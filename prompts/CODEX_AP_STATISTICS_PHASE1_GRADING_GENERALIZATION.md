# Codex Execution Prompt — TASK-0013 Phase 1: Grading Prompt Generalization

**Cleared to execute.** TASK-0013 was approved by David Bloom on 2026-06-30
(`DECISION-0031`, `APPROVAL-0024`). This prompt is ready to hand to Codex.

## Context

Cramapple's grading edge functions are currently hardcoded to AP Biology:

- `supabase/functions/grade-frq/index.ts:337` — grader persona string "You
  are Cramapple's criterion-based AP Biology grader."
- `supabase/functions/evaluate-attempt/index.ts:896` — `examName: 'AP
  Biology'`
- `supabase/functions/evaluate-attempt/index.ts:1104` — "You are a production
  AP Biology criterion-based grader."

The schema already supports multiple subjects: `app.subjects` exists
(`supabase/migrations/202606230002_subjects_normalization.sql`), and the
target design for prompt composition is the prompt-build manifest described in
`docs/architecture/CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §5 — a
structured manifest (subject, exam_pack, taxonomy_scheme, task_archetype,
etc.) that compiles to a provider-specific prompt with a recorded hash, not ad
hoc string concatenation.

## Goal

Make grading prompt composition subject-driven instead of hardcoded, with
zero behavior change for AP Biology.

## Scope

1. Read the current `grade-frq` and `evaluate-attempt` prompt-assembly code
   end to end before changing anything — confirm there are no other
   AP-Biology-specific literals beyond the three cited above (grep is a
   starting point, not proof of completeness).
2. Introduce (or extend, if a partial version already exists) a manifest-style
   construct that resolves `subject_id` → subject display name and any
   subject-specific grader framing, and pulls that into the prompt instead of
   a literal string.
3. Keep the change minimal and additive — this is a refactor of how the
   existing AP Biology prompt is composed, not a redesign of the grading
   logic itself. Do not build subject-specific verification techniques in
   this phase (that's TASK-0013 Phase 3).
4. Do not touch `app.subjects` data, exam_pack, or taxonomy_scheme rows in
   this phase — Phase 1 is prompt composition only. No new subject row should
   exist yet; AP Biology should be the only resolvable subject after this
   change.
5. Add or update unit/integration tests proving:
   - AP Biology grading prompt output is byte-for-byte (or semantically)
     identical before and after the refactor, OR any intentional difference
     is called out explicitly with reasoning.
   - The subject-resolution path fails loudly (not silently defaults to
     Biology) if `subject_id` is missing or unresolvable.

## Out of Scope

- Any AP Statistics-specific content, taxonomy, or verification work.
- Schema migrations beyond what's strictly needed to read `subject_id` if it
  isn't already threaded through the grading call path (check first — it may
  already be available via `content_item_versions` / `exam_pack_version_id`
  joins before assuming a new column is needed).
- Frontend changes.

## Required Evidence on Completion

- Diff showing the hardcoded literals replaced with manifest-driven
  resolution.
- Test output showing AP Biology grading regression-clean.
- A short note on where the next phase (Phase 2: instantiating an AP
  Statistics subject row) would plug in, given how this phase wired things.

## Do Not Touch

- Production environment, secrets, or deployment config.
- `app.subjects` table contents.
- Any file under `docs/seo/`, `docs/legal/`, or `docs/product/` (out of this
  task's scope).

## Next Expected Output

A PR against `main`, branch-prefixed `codex/...` per
`docs/team_charter/AI_COLLABORATION_RULES.md` branch convention, with the task
doc reference (`TASK-0013`) in the PR description, ready for QA Agent review
per the auto-triggered QA step in `AGENT_OPERATING_MODEL.md`.
