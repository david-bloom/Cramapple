# App ↔ Repo Schema Reconciliation (Option A) — 2026-07-08

**Decision:** Option A — adapt the Lovable app to the repo's authoritative `app`
schema in Supabase Production (`pcntajvbdfqhbeewmdry`), rather than rebuild the
app's `public` schema in Production.
**Owner:** David Bloom (Product Owner) with Lovable (frontend) + Codex (backend)
**Basis:** live inventory + column pull from `pcntajvbdfqhbeewmdry`, 2026-07-08.
**Related:** [[project_supabase_prod_dev]], `SUPABASE_PRODUCTION_SCHEMA_AND_RLS_PLAN.md`.

## The situation in one paragraph

The live Lovable app queries ~26 tables in the **`public`** schema of its own
Lovable-Cloud database (`tazjfzphsevtgervlyit`). Production
(`pcntajvbdfqhbeewmdry`) instead holds the repo's real system as ~60 tables in an
**`app`** schema (+ 5 vestigial legacy `public` tables, 5 auth users, the repo's
8 edge functions). The two schemas were built independently and diverged. Option
A points the app at the `app` schema.

## The key sub-decision: how the app reaches `app.*`

PostgREST (the Supabase REST/JS API) exposes **only `public`** by default, and the
`app` schema contains sensitive ops tables (`author_commissions`, `rights_records`,
`audit_events`, `daily_budgets`, `model_usage_ledger`, validation/*). Two ways to
give the app access:

- **A1 — expose the whole `app` schema** to the API (`Settings → API → Exposed
  schemas` + grants) and call `supabase.schema('app').from(...)`. Simple, but puts
  all 60 tables (incl. ops/finance/audit) behind RLS on the public API — a large
  attack surface.
- **A2 — curated `public` interface (RECOMMENDED)**: expose only what the student/
  reviewer app needs, via `public` **views** (reads) + **RPCs** (writes) over the
  `app` tables, keeping ops tables private. This is the shape the `app` schema was
  already designed for — it ships SECURITY DEFINER RPCs as entry points:
  `submit_response`, `apply_student_memory_event`, `compose_learning_runtime_context`,
  `reserve_model_usage`, `complete_model_usage`. The app should call those via
  `supabase.rpc(...)` and read via curated views, instead of doing direct table CRUD.

**Recommendation: A2.** Smaller surface, reuses the repo's intended RPC design,
and minimizes leaking the ops schema. The rest of this doc assumes A2.

## Structural gotchas the frontend must absorb

- **Non-`id` primary keys:** `app.profiles.user_id` (no `id`),
  `app.review_assignments.assignment_id`, `app.review_decisions.review_decision_id`,
  `app.content_review_assignments.content_review_assignment_id`,
  `app.content_review_decisions.content_review_decision_id`. The app's generated
  types + `.eq('id', …)` filters must be updated.
- **Roles are on `profiles`, not a `user_roles` table:** `app.profiles.role` (+
  `review_queue_scope`). The app's `has_role()` / `user_roles` reads must map to
  `profiles.role`.
- **Grading is RPC + jsonb, not flat rows:** `app.grading_results` carries
  `criterion_results jsonb`, `highest_value_gap jsonb`, prediction + token/cost
  fields, keyed by `request_id`/`request_hash` and `response_version_id`. The
  simple `attempt_feedback` table the app expects is instead
  `app.attempt_criterion_results` (per-criterion rows).

## Object mapping (app-expected `public.X` → repo `app.Y`)

| App expects (`public`) | Repo target (`app`) | Status | Notes |
|---|---|---|---|
| `content_items` | `content_items` | **repoint** | cols: `content_key, item_type, frq_form, exam_pack_version_id, title, status` |
| `content_item_versions` | `content_item_versions` | **repoint** | rich: `stem, prompt_json, status, canonical_answer_1/2, review_status, published_at` |
| `mcq_items` | `mcq_choices` (+ item in `content_items`) | **remap** | choices live in `mcq_choices(choice_key, choice_text, is_correct, rationale)` |
| `rubrics` / `rubric_versions` | `frq_criteria` | **remap** | `criterion_key, learner_facing_text, points_possible, accepted_variants jsonb` |
| `attempts` | `attempts` | **repoint** | renamed cols: `learning_session_id, exam_pack_version_id, content_item_version_id, attempt_mode, assistance_state, result_state, result_summary` |
| `attempt_feedback` | `attempt_criterion_results` | **remap** | `criterion_key, status, points_awarded, evidence_quote, decision_explanation, minimum_fix, evaluator_version` |
| `attempt_revisions` | `response_versions` | **remap** | `response_parts jsonb, version_number, is_submitted, parent_response_version_id` |
| `grading_results` | `grading_results` | **repoint (reshape)** | jsonb-heavy; see gotcha above |
| `sessions` | `learning_sessions` | **remap** | `entry_path, session_mode, available_minutes, status` |
| `profiles` | `profiles` | **repoint** | PK `user_id`; has `role`, `review_queue_scope` |
| `user_roles` | `profiles.role` | **fold in** | no separate table; rework `has_role` |
| `prompts` / `prompt_versions` | `prompt_versions` | **remap** | versions only (`operation, version, status, prompt_hash`) |
| `model_usage_ledger` | `model_usage_ledger` | **repoint** | + RPCs `reserve_model_usage` / `complete_model_usage` |
| `review_assignments` | `content_review_assignments` **or** `review_assignments` | **repoint — DISAMBIGUATE** | two review workflows exist: content-version review (`content_review_*`) vs artifact review (`review_*`). Pick the one the app's reviewer UI targets. |
| `review_decisions` | `content_review_decisions` **or** `review_decisions` | **repoint — DISAMBIGUATE** | same fork; `content_review_decisions` has `tutor_score, concern_codes, canonical_decision, reader_decision` |
| `topics` | `subjects` (+ `content_labels`) | **remap** | subject taxonomy in `subjects(subject_key, display_name)`, finer labels in `content_labels` |
| `exam_specs` | `exam_packs` / `exam_pack_versions` | **remap** | legacy `public.exam_specs` also exists but is vestigial |
| `frq_packages` | `frq_criteria` (+ `frq_synthetic_responses`) | **remap** | |

### Gaps — RESOLVED 2026-07-09 (DECISION-0035)

| App table | Disposition |
|---|---|
| `anonymous_sessions` | **DROP** — sign-in required on prod (no anon practice). |
| `capture_sessions` | **DROP for now** — re-add when the TASK-0011 capture path lands. |
| `config` | **ADD `app.config`** (small KV table, exposed via a curated read view). |
| `idempotency_keys` | **DROP** — use `grading_results.request_id/request_hash` + `model_usage_ledger`. |
| `predictions` | **DROP** — fields embedded in `grading_results` (`predicted_label`, `predicted_point_gain`). |
| `review_blind_groups` | **ADAPT to column** — use the `blind_group_id` column on assignments/decisions; no group table. |
| `dashboard_*_v1` (6 views) | **REBUILD** as `public` views over `app`. |

**Review-workflow disambiguation → resolved to `content_review_*`** (content-version
review). The two "DISAMBIGUATE" rows in the mapping table above resolve to
`app.content_review_assignments` / `app.content_review_decisions`.

## Work plan (Option A / A2)

1. **Backend (Codex):** build the curated `public` interface over `app` — views
   for the read paths + confirm the RPC set the app needs (`submit_response`,
   memory, model-usage). Grant `select` on views / `execute` on RPCs to
   `authenticated` (and `anon` only where anonymous practice is intended). Do NOT
   expose the ops tables. Rebuild the 6 `dashboard_*_v1` views over `app`.
2. **Decisions (David + LQ):** resolve the two review-workflow disambiguations and
   each gap-table add/drop above.
3. **Frontend (Lovable):** repoint queries to the curated views/RPCs; regenerate
   `types.ts` against `pcntajvbdfqhbeewmdry`; update non-`id` PK filters; map
   `user_roles`→`profiles.role`; swap Google OAuth to native Supabase provider
   (from Lovable's own plan §1); switch `.env`/`config.toml` to Production.
4. **Auth:** 5 users currently in prod; the app's real users are on the
   Lovable-Cloud project and will NOT carry over — decide migrate vs fresh.
5. **Cutover order:** backend interface + decisions FIRST, then frontend repoint,
   then env switch, then the Vercel repo/env fix — with Lovable Cloud left enabled
   as rollback until verified.

## What to tell Lovable now

Its plan §3 "gap migration" premise is wrong: the target runs a different schema
(`app.*`) with an RPC/view design. Hold the `.env`/`config.toml`/OAuth changes.
The frontend work is a **repoint to a curated `public` interface over `app`**
(views + `supabase.rpc(...)`), not a table-for-table switch — driven by this
mapping once the backend interface exists and the disambiguations/gaps are decided.
