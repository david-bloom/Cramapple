# Codex Execution Prompt — Backend Consolidation Phase 1: Curated `public` Interface over `app` (Option A/A2)

**Status:** Cleared to build (Phase 0 resolved — `DECISION-0035`, 2026-07-09).
This is a **backend-only** task: create a curated `public` read/write interface
over the existing `app` schema in Supabase **Production** (`pcntajvbdfqhbeewmdry`).
No frontend changes, no `.env`/`config.toml`/OAuth changes, no Vercel changes —
those are Phase 2/3 and must NOT be touched here.

**Hard constraint:** the schema apply to Production requires the Product Owner's
elevated access (Supabase dashboard or a CLI relinked to Production). Codex
**authors the migration + verification**; David applies it. Do not attempt to
apply to Production with the repo's current CLI link (it points at **Development**
`wmgjsdkphcyhngaffbqf` — see §6).

## Read first (do not skip — these are the spec)

1. `docs/architecture/BACKEND_CONSOLIDATION_MIGRATION_PLAN_2026_07_08.md` — the
   entry point: the fork, Option A/A2, phased plan, reference data (project refs,
   keys, edge functions, buckets).
2. `docs/architecture/APP_SCHEMA_RECONCILIATION_2026_07_08.md` — the object+column
   mapping table (app-expected `public.X` → repo `app.Y`), the structural gotchas,
   and the **resolved** gap-table dispositions.
3. `docs/activity_log/DECISIONS_LOG.md#DECISION-0035` — the binding Phase 0
   decisions this task implements.

## Ground truth first — VERIFY, do not trust the mapping blindly

The mapping doc was built from a live inventory on 2026-07-08 but is a **planning
artifact**, not a schema dump. Before writing any DDL, re-establish ground truth
(read-only) against `pcntajvbdfqhbeewmdry`:

- `list_tables` for schemas `app` and `public`; confirm every `app.*` table this
  spec references exists and pull its **actual column names + types + PK**.
- Confirm the SECURITY DEFINER RPCs already ship: `submit_response`,
  `apply_student_memory_event`, `compose_learning_runtime_context`,
  `reserve_model_usage`, `complete_model_usage` — capture their exact signatures
  (arg names/types, return type).
- If any referenced object/column does not exist or is named differently, **stop
  and report the delta** in the deliverable; do not guess or silently rename.

## Scope — build these, nothing else

### A. `public` read views over `app` (grant SELECT to `authenticated`)

One view per app read path below. Views are **`security_invoker = true`** (Postgres
15+/Supabase) so the caller's RLS on the underlying `app` tables is enforced —
these views must NOT become an RLS bypass. Expose only the columns the student/
reviewer app needs; do not `SELECT *` ops/finance/audit columns.

| `public` view | Over `app` table(s) | Notes |
|---|---|---|
| `content_items` | `app.content_items` | `content_key, item_type, frq_form, exam_pack_version_id, title, status` |
| `content_item_versions` | `app.content_item_versions` | `stem, prompt_json, status, canonical_answer_1/2, review_status, published_at` |
| `mcq_choices` | `app.mcq_choices` | `choice_key, choice_text, is_correct, rationale` (+ item join) |
| `frq_criteria` | `app.frq_criteria` | `criterion_key, learner_facing_text, points_possible, accepted_variants` |
| `attempts` | `app.attempts` | `learning_session_id, exam_pack_version_id, content_item_version_id, attempt_mode, assistance_state, result_state, result_summary` |
| `attempt_criterion_results` | `app.attempt_criterion_results` | `criterion_key, status, points_awarded, evidence_quote, decision_explanation, minimum_fix, evaluator_version` |
| `response_versions` | `app.response_versions` | `response_parts, version_number, is_submitted, parent_response_version_id` |
| `grading_results` | `app.grading_results` | reshape jsonb-heavy row; expose only learner-safe fields (NOT token/cost/budget internals) |
| `learning_sessions` | `app.learning_sessions` | `entry_path, session_mode, available_minutes, status` |
| `profiles` | `app.profiles` | PK `user_id`; expose `role`, `review_queue_scope` |
| `prompt_versions` | `app.prompt_versions` | `operation, version, status, prompt_hash` — reviewer/admin surface only |
| `subjects` | `app.subjects` (+ `content_labels`) | taxonomy: `subject_key, display_name` |
| `exam_packs` / `exam_pack_versions` | same | replaces app-expected `exam_specs` |
| `content_review_assignments` | `app.content_review_assignments` | **review workflow = `content_review_*`** per DECISION-0035 |
| `content_review_decisions` | `app.content_review_decisions` | `tutor_score, concern_codes, canonical_decision, reader_decision` |

- **Roles:** there is no `user_roles` table — role lives on `app.profiles.role`.
  Provide a `public.current_user_role()` helper (or expose `role` via the
  `profiles` view) so the app can drop its `has_role()`/`user_roles` reads.
- **Do NOT** create views over ops/finance/audit tables: `author_commissions`,
  `rights_records`, `audit_events`, `daily_budgets`, `model_usage_ledger`,
  `validation/*`. These stay private.

### B. Write paths — RPCs only (grant EXECUTE to `authenticated`)

Do not expose base tables for writes. Confirm the existing RPCs cover the app's
write needs and are callable via PostgREST (`public` schema or exposed):
`submit_response` (attempt submit → grading), `apply_student_memory_event`,
`compose_learning_runtime_context`, `reserve_model_usage`,
`complete_model_usage`. If the reviewer UI needs to record a decision, add/confirm
a thin RPC over `content_review_decisions` (do not let the app write that table
directly). Report any write path with no RPC coverage.

### C. `app.config` (new — per DECISION-0035)

Create a small KV table `app.config (key text primary key, value jsonb not null,
updated_at timestamptz default now())`. Expose a **read-only** `public.config`
view (SELECT to `authenticated`). Writes are admin/ops only — no `authenticated`
write grant.

### D. Rebuild the 6 `dashboard_*_v1` views

None exist in Production. Rebuild them as `public` views over `app` (or as RPCs if
they aggregate). **Canonical names (pinned — the Lovable frontend briefs
`LOVABLE_UX002_REVIEW_PORTAL.md` and `LOVABLE_TUTOR_READER_SUPABASE_EXECUTION.md`
already read these exact names, so build these, not renamed variants):**
`dashboard_overview_v1`, `dashboard_subjects_v1`, `dashboard_pipeline_v1`,
`dashboard_engagement_v1`, `dashboard_quality_v1`, `dashboard_attention_v1`. If a
required shape isn't recoverable from the app repo (`cramapple-beta`), report it as
ambiguous rather than inventing the aggregation — but keep the name.

### E. Gap tables — implement the DECISION-0035 dispositions

- **Drop/omit** (do NOT create in `app`): `anonymous_sessions`, `capture_sessions`,
  `idempotency_keys`, `predictions`.
- **Adapt to column:** no `review_blind_groups` table — the app uses the
  `blind_group_id` column already on assignments/decisions. Ensure it's exposed on
  the relevant curated view.

## Security requirements (non-negotiable)

1. `security_invoker = true` on every read view (no RLS bypass).
2. **No `anon` grants anywhere** — sign-in required (DECISION-0035). Grants go to
   `authenticated` only. (Revisit only if anon practice is ever re-approved.)
3. Ops/finance/audit tables remain unexposed — not via view, not via
   `Exposed schemas`. Do NOT add `app` to PostgREST exposed schemas (that's the
   rejected A1 path).
4. Confirm RLS is enabled + policied on every underlying `app` table a view reads;
   if any is missing RLS, flag it — do not paper over it with a definer view.

## Deliverables

1. A single idempotent migration under `supabase/migrations/` (timestamped,
   Production-targeted), containing the views, `app.config`, RPC grants, and
   dashboard views. Re-runnable (`create or replace view`, `if not exists`).
2. A short `docs/architecture/PHASE1_CURATED_INTERFACE_NOTES.md`: the exact
   view→table column mapping as built, the RPC signatures confirmed, and a
   **delta report** of anything in the mapping doc that didn't match live schema.
3. A verification script/queries (read-only) proving each view returns rows and
   each grant is correct — runnable against Production after apply.

## Acceptance criteria

- Every view/RPC/grant above exists (or is explicitly reported as blocked with the
  reason). No ops/finance/audit table is reachable via the public API.
- `security_invoker = true` verified on all read views; zero `anon` grants.
- The migration applies cleanly to a scratch/Dev copy first, then is handed to
  David for the Production apply. It does NOT self-apply to Production.
- Delta report lists every mismatch between the mapping doc and live schema.

## §6 — CLI linkage gotcha (read before any `supabase` command)

The repo's Supabase CLI is linked to **Development** (`wmgjsdkphcyhngaffbqf`,
`supabase/.temp/linked-project.json`). `supabase db push` / `functions deploy`
from here hit **Dev** unless relinked:
`supabase link --project-ref pcntajvbdfqhbeewmdry`. Test the migration against Dev
(or a branch), but the **Production apply is David's** (elevated access). Leave the
CLI linked to Dev when done unless David says otherwise.

## Out of scope (do NOT do here)

- Any frontend / `cramapple-beta` change, `types.ts` regen, OAuth swap — Phase 2.
- Any `.env`, `config.toml`, or Vercel change — Phase 2/3.
- Auth-user migration — DECISION-0035 says start fresh; nothing to migrate.
- Disabling Lovable Cloud — stays enabled as rollback until Phase 4 verification.
