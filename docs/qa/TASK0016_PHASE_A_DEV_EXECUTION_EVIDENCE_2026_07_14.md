# TASK-0016 Phase A — Dev Execution Evidence

**Date:** 2026-07-14
**Task:** TASK-0016, Phase A (router + Engine 1 + Engine 3 typed + shadow pipeline)
**Approval:** APPROVAL-0037 (David Bloom, in-session) — "I approve dev execution of
phase A"; scope confirmed: **full Phase A incl. review pipeline**.
**Target:** `wmgjsdkphcyhngaffbqf` = **Cramapple - Development** (verified via
`list_projects`). Production (`pcntajvbdfqhbeewmdry`) untouched.
**Executed by:** Claude, via Supabase MCP (migrations) + Supabase CLI (function
deploys, `--project-ref wmgjsdkphcyhngaffbqf`).

## Preflight findings (read-only)

1. **Migration history diverged / partly managed outside this repo.** Dev has
   `add_rubric_routing_columns` + `backfill_rubric_routing_metadata` applied under
   versions `20260711033925/033934`, which **do not exist in the repo** (repo
   carries them as `202607080005/0006`). `content_item_versions.rubric_type` /
   `evaluator_strategy` were present as a result. **Consequence:** `supabase db
   push` is unsafe; migrations were applied **individually via MCP
   `apply_migration`** instead.
2. **Grading-core gap:** exactly 5 missing `grading_results` columns
   (`feedback_preview`, `action_hint`, `repair_hint`, `deterministic_verifier_version`,
   `boundary_contract_version`); all other 19 written columns present.
3. **Review-pipeline gap:** all `content_review_*` tables already existed;
   `profiles.review_queue_scope` missing; `artifact_label_assignments` and
   `content_review_assignment_labels` had **RLS enabled with 0 policies** (silently
   blocking API access).
4. **No published AP Statistics FRQ content on Dev** (0 HDG, 0 SFRQ) — so the HDG
   spatial-remediation migration's content guard would abort.

## Migrations applied (7, all additive / idempotent)

Applied via `apply_migration` (recorded under fresh `task0016_phase_a_*` names —
see divergence note):

| Repo migration | What it added |
|---|---|
| `202607080007` | `grading_results.feedback_preview` |
| `202607080008` | `grading_results.action_hint` |
| `202607080009` | `grading_results.repair_hint` |
| `202607080010` | `grading_results.deterministic_verifier_version`, `boundary_contract_version` |
| `202607080001` | `review_decisions.difficulty_label`, `content_items.content_key`, de-recursive owner-scoped RLS on legacy `review_decisions` |
| `202607080002` | `profiles.review_queue_scope` + CHECK (**CHECK wrapped in an existence guard** — the repo version lacks `IF NOT EXISTS` and would trap a future re-apply on this diverged history) |
| `20260710032203` | RLS policies (4 each) on `artifact_label_assignments` and `content_review_assignment_labels` |

**Post-migration verification (SQL):** 5 grading columns present;
`review_queue_scope` + constraint present; `artifact_label_assignments` 0→4
policies; `content_review_assignment_labels` 0→4 policies.

**Security advisors after DDL:** only pre-existing WARN-level items
(`function_search_path_mutable` on legacy functions, `handle_new_user` definer
exposure, leaked-password protection disabled). **No new findings from this work;
the RLS-zero-policy issues on the label tables were resolved.**

## Deferred (not applied)

- `202607120001` HDG spatial remediation — **content guard would abort** (0
  published HDG items on Dev); not required for router function.
- `202607080003` backfill queue scope (data) and `202607080004` **promote
  dbloom01 → admin (a role/privilege change)** — deferred; not required for the
  pipeline to function (column default = `my_queue`). Available on request.
- Non-Phase-A: `202607090001/090002` (curated interface), `202607130001` (atomic
  publication), TASK-0017 H1–H5.

## Functions deployed (6, via CLI, shared deps auto-bundled)

`evaluate-attempt` (v7→v8, updated) and newly created: `attempt-response`,
`assign-for-review`, `review-queue`, `review-decision`, `reviewer-invite` — all
`ACTIVE`. Duplicate `" 2"/" 3"` dirs were not deployed (explicit names).

**Secrets present on Dev:** `OPENAI_API_KEY`, `OPENAI_MODEL`, prompt/version/caps,
`ALLOWED_ORIGINS`, Supabase keys — runtime grading has its credentials.

## Boundary verification (smoke)

- `POST /evaluate-attempt` with invalid JWT → **401** (reachable; unauthenticated
  access blocked).
- `GET /review-queue` with invalid JWT → **401** (new GET route live and gated).
- `OPTIONS /evaluate-attempt` (CORS preflight) → **200** (the `cors.ts` GET
  addition works).

## Remaining verification (NOT done — needs setup)

Full end-to-end shadow-grading proof — router dispatch per route
(mcq/discrete_text/structured_formula/spatial/holistic/unknown),
deterministic-before-LLM (no grader call for keyed criteria), v2 sanitizer
grounding (`integrity_issues`), auth-attribution of telemetry, and the shadow
review round-trip — requires **seeded AP Statistics content + a test student JWT +
a real attempt row** on Dev, which does not currently exist. This is the packet's
"Dev evidence run" and is the next step.

## Migration-history divergence — recommended follow-up

Dev's migration history no longer maps cleanly to the repo (rubric-routing under
foreign ids; the 7 above recorded under `task0016_phase_a_*` names, not their repo
`2026070800x` versions). A future `supabase db push` from the repo will see the
repo copies as unapplied. All are idempotent **except** the `202607080002` CHECK
(mitigated here by the guard). **Recommend a separate migration-history
reconciliation task** to align Dev's `schema_migrations` with the repo (and to
determine what process — Lovable branch merges? — introduced the Jul-11 ids).

## Disposition

Phase A **deployed and boundary-verified on Dev**; Production untouched.
Blocked-next on the seeded end-to-end Dev evidence run.
