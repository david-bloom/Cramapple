# QA — Phase 1 Curated Interface Migration (live-schema validation)

**Reviewer:** Claude, 2026-07-09. **Validated against the live Production schema
(`pcntajvbdfqhbeewmdry`) via Supabase MCP** — the step Codex could not run.
**Target reviewed:** `supabase/migrations/202607090001_curated_public_interface.sql`
+ `PHASE1_CURATED_INTERFACE_NOTES.md` + `PHASE1_CURATED_INTERFACE_VERIFY.sql`.

> **STATUS UPDATE — 2026-07-09, post-remediation re-QA: PASS.** Codex's remediation
> fixed B1–B5 and the security-model concern is resolved against live Production.
> The original FAIL below is retained as the record of round 1. See
> **[Re-QA (round 2) — PASS](#re-qa-round-2--pass-2026-07-09)** at the bottom.

## Verdict (round 1): **FAIL — do not apply as-is.** 5 column-reference bugs will abort the migration.

Every view is created in one `begin;…commit;` block, so any single bad column
reference rolls back the **entire** migration — nothing applies. All five below
were confirmed against `information_schema.columns` on Production.

### Blocking (migration will error on apply)

| # | View (line) | References | Actual columns in `app.*` | Fix |
|---|---|---|---|---|
| **B1** | `public.content_item_versions` (:211) | `civ.canonical_answer` | `canonical_answer_1`, `canonical_answer_2` (no `canonical_answer`) | expose `canonical_answer_1, canonical_answer_2`; update the frontend contract accordingly |
| **B2** | `public.grading_results` (:530–532) | `gr.feedback_preview`, `gr.action_hint`, `gr.repair_hint` | **none of the three exist** in Production `app.grading_results` | see cross-migration note below — drop them, or apply the Phase A column migrations to `app.grading_results` first |
| **B3** | `public.content_review_assignments` (:555) | `cra.id` | PK is `content_review_assignment_id` (no `id`) | `cra.content_review_assignment_id` (alias `as id` if the contract wants `id`) |
| **B4** | `public.content_review_decisions` (:595–596, join :629–630) | `crd.id`, `crd.assignment_id` | `content_review_decision_id`, `content_review_assignment_id` | rename both; join on `cra.content_review_assignment_id = crd.content_review_assignment_id` |
| **B5** | `public.content_item_labels` (:316) | `cil.created_at` | table has only `content_item_id, content_label_id` | drop `cil.created_at` |

### The delta report is factually wrong on B1

`PHASE1_CURATED_INTERFACE_NOTES.md` §Delta #1 asserts: *"the actual repo schema
uses a single `app.content_item_versions.canonical_answer`."* **It does not** —
the live schema has `canonical_answer_1` and `canonical_answer_2` and no
`canonical_answer`. This is exactly the assumption that a live read (which the
notes say could not be run) would have caught. Correct the delta report too.

### Cross-migration dependency (B2)

`feedback_preview` / `action_hint` / `repair_hint` were to be added by the Phase A
migrations `202607080007/0008/0009`. Those files are committed but **not applied
to Production** (columns absent), and it must be confirmed they target
`app.grading_results` (not a `public` table). This curated migration therefore
has an **undeclared dependency**: it cannot succeed until those columns exist.
Declare the ordering, or drop the three fields from the view for now.

## Design concern to verify before this interface actually serves the app

The curated entity views use `security_invoker = true`. That means an
`authenticated` user querying, say, `public.attempts` runs the query **as
themselves** against `app.*` — so they need `USAGE` on schema `app` + `SELECT` on
the underlying app tables + must pass those tables' RLS. Granting `SELECT` on the
public *view* does **not** grant that underlying access. If `authenticated` has no
grants/RLS on `app.*` (the likely state, since keeping `app` private was the whole
point), these views return permission errors or zero rows — defeating their
purpose. The dashboard views avoid this (no `security_invoker` → definer) but then
bypass `app` RLS, relying on their `auth.uid()` role-EXISTS gate.

**Action:** run the verification's row-count checks **as the `authenticated`
role** (not service/admin) on Dev to confirm the security_invoker views return
data. If they don't, the entity views likely need `security_invoker = false`
(definer) plus in-view row filters (e.g. `user_id = auth.uid()` on learner-owned
views), or explicit `app.*` grants/RLS for `authenticated`.

## What is correct (verified)

- **Write-path RPC signatures in the notes match the live schema exactly:**
  `submit_response(uuid,uuid,uuid,text,text,text)`,
  `compose_learning_runtime_context(uuid)`,
  `reserve_model_usage(text,text,text,numeric,numeric)`,
  `complete_model_usage(text,text,text,numeric,integer,integer)`;
  `apply_student_memory_event()` correctly noted as a trigger helper.
- `app.config` (KV + `is_public` + RLS + `set_updated_at` trigger + public
  filtered read view) is well-formed; `app.set_updated_at()` exists.
- Grants are **authenticated-only, no anon** — matches DECISION-0035.
- DECISION-0035 honored: `content_review_*` chosen; `review_blind_groups` not
  created (uses `blind_group_id`); `app.config` added; 6 dashboards rebuilt.
- All other view columns check out against live schema (profiles, subjects,
  exam_packs, exam_pack_versions, progress_snapshots, content_items,
  content_labels, mcq_choices, frq_criteria, learning_sessions, attempts,
  response_versions, attempt_criterion_results).

## Recommended remediation

1. Fix B1–B5 (targeted column corrections above) + correct delta-report #1.
2. Resolve B2's dependency (apply Phase A grading_results columns first, or drop
   the three fields).
3. Re-run the verification SQL **as `authenticated`** on Dev (or a branch) to
   settle the security_invoker question before applying anywhere.
4. Then apply on Dev, run VERIFY.sql, and only then plan Production.

---

## Re-QA (round 2) — PASS (2026-07-09)

**Reviewer:** Claude, 2026-07-09, re-validated **directly against the apply
target — live Production `pcntajvbdfqhbeewmdry`** via Supabase MCP (the same
method that caught round 1). Every column referenced by every view was
cross-checked against `information_schema.columns`; grants, RLS, schema USAGE, the
trigger dependency, and public-name collisions were all checked.

### Blockers B1–B5 — all fixed (verified against live columns)

| # | Fix confirmed in the migration | Live-schema check |
|---|---|---|
| B1 | `content_item_versions` now selects `canonical_answer_1, canonical_answer_2` | both columns exist; no `canonical_answer` — correct |
| B2 | `grading_results` no longer selects `feedback_preview/action_hint/repair_hint`; selects `criterion_results, highest_value_gap, predicted_*, prediction_outcome, confidence, uncertainty_reason` (+ `latency_ms, estimated_cost_usd` in the quality dashboard) | all referenced columns exist in prod `app.grading_results` — the cross-migration dependency is dissolved by dropping the absent fields |
| B3 | `content_review_assignments` uses `content_review_assignment_id` | PK matches |
| B4 | `content_review_decisions` uses `content_review_decision_id`, joins `cra.content_review_assignment_id = crd.content_review_assignment_id` | matches |
| B5 | `content_item_labels` selects only `content_item_id, content_label_id` (+ joined label fields) | table has exactly those two columns — correct |

**No new missing-column references introduced.** All ~20 views were checked
column-by-column across all 18 base+join tables — every reference resolves.

### Security-model concern (round 1) — resolved, NOT the feared state

Round 1 assumed `authenticated` likely had no `app.*` access (making
`security_invoker` views error/empty). Live Production shows the opposite:

- `has_schema_privilege('authenticated','app','USAGE')` = **true**
  (`anon` = **false**, correct for sign-in-only).
- `authenticated` holds **SELECT** on all 18 base+join tables the views read.
- RLS is **enabled** on all of them, each with ≥1 `authenticated`/`public` policy.

So the `security_invoker` entity views have schema USAGE + table SELECT + a
permitting RLS policy on every table — they will neither permission-error nor be
structurally empty. Row *visibility* per user still follows each table's RLS
predicate (correct/intended); a true signed-in end-to-end check belongs in Phase 2
(MCP runs as a privileged role and can't fully emulate a JWT session).

### Other apply-blockers checked

- `app.set_updated_at()` **exists** → the `app.config` trigger is safe.
- **No name collisions**: none of the 25 objects created exist in `public` today
  (the 5 vestigial `public` tables don't overlap), so `create or replace view`
  won't hit a table/view conflict.

### Verdict: safe to apply to Production.

Because verification was run against the **apply target itself** (Production), a
Dev pre-apply is optional belt-and-suspenders, not a gate — and note Dev
(`wmgjsdkphcyhngaffbqf`) may hold a different `app` schema state, so a Dev failure
wouldn't necessarily reflect Production. Recommended: Product Owner applies to
Production (elevated access), then runs `PHASE1_CURATED_INTERFACE_VERIFY.sql`.
