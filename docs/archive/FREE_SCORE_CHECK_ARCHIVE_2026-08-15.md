# Free Score Check — archived backend code (2026-08-15)

The activation-limited Free Score Check offer was retired from `main` on
2026-08-15 in favor of a 7-day full-access trial (TASK-0026), because the
early-school-year timing it was designed around ("student with ~10 days
before an exam") no longer applied. The product owner wants to revive this
offer later, once exam season creates real urgency again — this branch exists
so that revival isn't a from-scratch rebuild.

**This branch is not merged into `main` and should not be, until a fresh
design review confirms the offer still matches the schema at revival time.**
`main`'s `app.authorize_grading_access` no longer has the FSC fallback branch
these files depend on (`20260815140000_retire_free_score_check.sql` removed
it), so these files will not work as-is against current `main` — treat this
as reference material for a rebuild, not a drop-in restore.

## What's here

- `supabase/functions/free-score-check/index.ts` — the Edge Function (4
  operations: start/status/record_grading_result/report). Also fully
  recoverable from `main`'s git history (it was a tracked file; only the
  working-tree copy was removed) via:
  `git log --all --diff-filter=D -- supabase/functions/free-score-check/index.ts`
- `supabase/functions/_shared/free-score-check-contract.ts` — shared helpers
  (touch sanitization, UUID/string coercion, grading-result normalization,
  error-code parsing). This one was **never committed anywhere** — it only
  existed as uncommitted local work — so this file is the only copy.
- `supabase/migrations/20260813174828_free_score_check_visual_gate.sql` — the
  in-progress "subject-agnostic" rewrite of `start_free_score_check` (adds an
  optional `p_subject_key` param and a per-subject config map). **This
  migration was never applied to Dev or Production** — production ran the
  original 5-argument `start_free_score_check` from
  `20260731160200_free_score_check_growth_funnel.sql` the whole time. Also
  never committed — this file is the only copy.

## What's NOT recoverable

The following existed only as uncommitted, untracked local files and were
deleted before their full contents were read into any record — they cannot be
reconstructed exactly:

- 14 launch-gate scripts under `scripts/free-score-check-*` and
  `scripts/verify-free-score-check-*` (candidate selection, visual
  classification worklist, enable/disable config templates, production
  preflight/readiness SQL, local verification runners).
- `supabase/tests/free_score_check_growth_funnel.integration.sql` (the
  rollback-scoped SQL integration test).
- `supabase/functions/_shared/free-score-check-contract_test.ts` — only the
  first 40 lines were read before deletion; treat as **partially** lost. What
  was seen: unit tests for `sanitizeTouch` (bounded attribution fields, length
  truncation, array/non-string rejection) and `asString`/`asUuid` trimming
  and validation. The rest of the file's content (it covered UUID validation,
  grading-result normalization, and points-gained calculation per the
  exported surface) was not captured.

`docs/tasks/TASK-0024-FREE-SCORE-CHECK-LAUNCH-READINESS.md` on `main` (marked
superseded, not deleted) documents what each of the unrecoverable scripts was
*for*, even though it doesn't have their code — read that first when
rebuilding.

## What's untouched and still the real source of truth

The **original** `app.free_score_checks` table and the **original**
`app.start_free_score_check` / `app.record_free_score_grade` RPC definitions
(pre-visual-gate, AP-Biology-only, 5-argument signature) were never deleted —
they're still in `supabase/migrations/20260731160200_free_score_check_growth_funnel.sql`
on `main`, committed and intact. A revival can start from that baseline
without needing anything from this archive branch at all, if the
subject-agnostic + visual-gate work isn't wanted back.

## Revival checklist (when the time comes)

1. Confirm what launch subjects/content exist by then — the original design
   was AP-Biology-only; decide fresh whether to revive as single-subject or
   pick up the subject-agnostic direction from this branch's migration.
2. Rebuild `app.authorize_grading_access`'s FSC fallback branch (removed by
   `20260815140000_retire_free_score_check.sql` on main) — or design a
   cleaner integration with whatever entitlement model exists at that time
   (the trial/paid/beta model may have evolved).
3. Rebuild the 14 launch-gate scripts and the integration test from scratch,
   using TASK-0024 as the spec.
4. Re-run the full launch-gate sequence documented in TASK-0024 before
   enabling in production.
