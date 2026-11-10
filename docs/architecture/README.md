# docs/architecture — what is current and what is legacy

STATUS: CURRENT
DATE: 2026-11-09
REVIEW: full inventory of this folder, 2026-11-09. Statuses below are also bannered inside each file (annotate-in-place; nothing was moved or deleted).

**Start here for the current architecture:**
[`docs/product/ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md`](../product/ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md)
(DECISION-0075, ratified 2026-09-27) is the single decided-vs-open source. It wins over every file here. Live
truth for the backend is `supabase/migrations/` (baseline `20260731160000_schema_baseline.sql` + later) and
`supabase/functions/` (31 directories incl. `_shared`). None of the June–July 2026 plans below describe the
shipped system; most were written before the Lovable app/marketing split, the baseline squash, and the
Stripe/trial/review work.

## Current reference docs (still govern, some with stale sections)

| File | Status | Note |
| --- | --- | --- |
| `VISUAL_STIMULUS_AND_RENDERING_SYSTEM.md` | CURRENT (header says "Proposed") | Governing four-lane model; Lane A live in Production (APPROVAL-0153). |
| `CONTENT_GOVERNANCE_AND_VALIDATION.md` | PARTIALLY STALE | Human double-review paused (DECISION-0055); review functions frozen (TASK-0078). |
| `CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` | PARTIALLY STALE | Authoring workflow superseded by generate-select pipeline (TASK-0065, DECISION-0099). |
| `GRADING_MODEL_ASSESSMENT_PROTOCOL_2026_07_11.md` | PARTIALLY STALE | "Harness not built" is wrong; see `scripts/grading-model-assessment/`. |
| `GRADING_MODEL_ASSESSMENT_HARNESS_SCOPE_2026_07_11.md` | PARTIALLY STALE | Same; scope is v3. |
| `RUBRIC_AUDIT_AND_SAMPLING_POLICY.md` | PARTIALLY STALE | Still "Proposed"; no implementing job found. |
| `HIGH_LEVEL_SYSTEM_ARCHITECTURE.md` | PARTIALLY STALE | Principles fine; Vercel-era topology stale. |
| `SYSTEM_CONTEXT_AND_LOGICAL_COMPONENT_ARCHITECTURE.md` | PARTIALLY STALE | Same. |
| `PRODUCTION_PLUMBING_AND_CUTOVER_PLAN.md` | PARTIALLY STALE | Vercel principle stale; Stripe sections still cited by TASK-0023. |

## Legacy / historical (kept for history; do not use as the plan)

| File | Status | Superseded by |
| --- | --- | --- |
| `APP_SCHEMA_RECONCILIATION_2026_07_08.md` | HISTORICAL | Executed; schema baseline migration; DECISION-0075 D6/D16 |
| `BACKEND_CONSOLIDATION_MIGRATION_PLAN_2026_07_08.md` | HISTORICAL | Same (Vercel plan not how the app ships) |
| `BACKEND_CONSOLIDATION_QA_FINDINGS_2026_07_09.md` | HISTORICAL | Same |
| `PHASE1_CURATED_INTERFACE_NOTES.md` / `_QA_FINDINGS_2026_07_09.md` / `_VERIFY.sql` | HISTORICAL | Baseline migration (original migration file no longer exists) |
| `PRODUCTION_PLUMBING_EXECUTION_CHECKLIST.md` | HISTORICAL | TASK-0012 / executed cutover |
| `SUPABASE_EDGE_FUNCTIONS_DRAFT.md` | HISTORICAL | `supabase/functions/` |
| `SUPABASE_PRODUCTION_SCHEMA_AND_RLS_PLAN.md` | HISTORICAL | `supabase/migrations/`; DECISION-0128 |
| `TAXONOMY_LABELING_PLAN_V3_2026_08_04.md` | HISTORICAL | `product/CONTENT_TAXONOMY_RATIONALIZATION_PLAN_2026_09_26.md` |

## Gaps (no current architecture doc; listed, not invented)

- **Edge-function inventory** (30 functions): no current doc. The draft is historical; the directory is the only source.
- **Data model / RLS / environments** (Dev vs Prod, `app` vs `public` views): only migrations and DECISION-0128; no narrative doc.
- **Payments, entitlements and trial** architecture: spread across TASK-0023, DECISION-0135 and `docs/product/FREE_TRIAL_NO_CARD_*`.
- **Grading engines**: `docs/GRADING_PROGRAM.md` and `docs/GRADING_ENGINES_TO_PRODUCTION_HANDOFF.md` (outside this folder).
- **Deploy topology** (two Lovable projects, Cloudflare, Supabase CLI linked to Dev): only in the one-pager D6 and memory notes.

Writing any of these as a current doc needs David's go-ahead on scope; this review does not decide it.
