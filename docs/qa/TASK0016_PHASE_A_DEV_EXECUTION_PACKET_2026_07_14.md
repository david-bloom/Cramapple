# TASK-0016 Phase A — Dev Execution and Evidence Packet

**Date:** 2026-07-14
**Task:** TASK-0016 — Multi-Rubric Grading & Feedback Engine Rollout, Phase A
**Scope:** Evaluator-strategy router + Engine 1 (deterministic-before-LLM) +
Engine 3 typed symbolic/ECF dispatch + shadow-review pipeline.
**Prepared by:** Claude (session 2026-07-14). Repository/packet only.
**Branch:** `codex/task0016-phase-c-content-publish-approval-packet`
**Base commit:** `9b639d3` (9-commit worktree reconciliation; suite 95/95 green,
`deno check` clean on all in-scope functions).

## Approval boundary

**This packet authorizes nothing.** No migration or edge function has been
applied to Dev or Production. Per DECISION-0040 and standing governance:

- No Dev application without a **separate Dev execution approval ID** (not
  issued here).
- No Production migration, deployment, config change, or publication.
- Applying to Dev is **verification**, not authorization — the P0/functional
  smoke tests below must re-run green in the Dev evidence bundle.

Nothing in this packet touches the fail-closed publish path: Phase A grades in
**shadow mode only** (100% human review, non-authoritative). No learner-facing
automated score is produced or published.

## Approved-artifact candidates

### Edge functions (deploy canonical names only)

| Function | Change | Role in Phase A |
|---|---|---|
| `evaluate-attempt` | router-wired; v2 sanitizer; deterministic prefilter; repair plan | Engine 1 + dispatch |
| `attempt-response` | new | response capture surface |
| `assign-for-review` | updated | shadow-review assignment |
| `review-queue` | updated (GET) | reviewer queue read |
| `review-decision` | updated | reviewer decision recording |
| `reviewer-invite` | updated | reviewer onboarding |

Shared modules bundled with the above: `grading-router`, `grading-contract`,
`grading-repair`, `grading-feedback`, `grading-perception`, `statistics-verifier`,
`verification-profiles`, `evaluate-attempt-response`, `student-memory`,
`learning-context`, `auth`, `cors`.

> **Preflight exclusion — duplicate function directories.** The repo contains
> stray `" 2"/" 3"` copies (`evaluate-attempt 2/3`, `admin-content 2/3`,
> `session-event 2/3`, `storage-sign-url 2/3`). These are not deploy targets and
> must be excluded from any `supabase functions deploy`. Recommend deleting them
> in a separate hygiene commit before execution so a glob deploy can't pick them
> up. **Flagged, not fixed in this packet.**

### Migrations (pending on this branch — reconcile against Dev before applying)

| File | Purpose |
|---|---|
| `202607090001_curated_public_interface.sql` | app.config KV + read-only public interface over `app` |
| `202607090002_curated_public_interface_revoke_anon.sql` | revoke anon from curated interface (sign-in-only) |
| `20260710032203_restore_label_assignment_rls_policies.sql` | restore RLS policies on label-assignment tables (advisor finding) |
| `202607120001_ap_statistics_hdg_spatial_shadow_remediation.sql` | make 40 HDG FRQs route spatial→human_shadow consistently (typed cols + prompt_json) |

Prerequisite grading/routing column migrations (`202607080005`–`202607080010`:
rubric routing columns + backfill, feedback_preview, action_hint, repair_hint,
deterministic_verifier_pins) are already committed on the branch — **confirm they
are present in Dev during preflight**; the router and grading-result writes
depend on them.

> ⚠️ **Migration-ordering hazard (must resolve in preflight).** The four pending
> migrations are timestamped **Jul 9–12**, but already-committed migrations run
> through **Jul 13** (`202607130001_atomic_content_publication`,
> `20260713172806`/`20260713172817` TASK-0017 H1–H5). If Dev has already applied
> any Jul-13 migration, the Supabase CLI will see the earlier-timestamped files
> as out-of-order/unapplied. Read Dev's `supabase_migrations.schema_migrations`
> first (preflight) and choose one: (a) Dev has none of Jul-13 → apply all in
> timestamp order, clean; (b) Dev already has Jul-13 → apply the four out-of-order
> migrations explicitly and record the deviation, or renumber. Do not blind-run
> `db push`.

## Preflight — read-only (no writes)

1. **Migration state.** `SELECT version FROM supabase_migrations.schema_migrations
   ORDER BY version;` on Dev. Compute the exact pending set vs. the branch. Resolve
   the ordering hazard above.
2. **`app` not Data-API-exposed.** Hosted PostgREST exposed-schema check — confirm
   `app` is NOT in the exposed schemas (the standing required Dev preflight). The
   curated public interface migration is the intended read surface; `app` itself
   must stay private.
3. **RPC privilege baseline.** Confirm anon/authenticated cannot execute the
   grading/usage RPCs; service-role only.
4. **Rubric columns present.** Confirm `content_items`/version rows expose
   `rubric_type` / `evaluator_strategy` and grading_results has the
   feedback_preview/action_hint/repair_hint/deterministic-pin columns.
5. **Secrets.** Confirm the grader gateway credential + `ALLOWED_ORIGINS` are set
   in the Dev function environment (the auth fix depends on a real bearer token
   round-trip; CORS now allows GET).

## Required execution order

1. Apply pending migrations (in the order resolved by preflight step 1).
2. Deploy the six edge functions (canonical names only; exclude `" 2"/" 3"`).
3. Run the post-deploy verification below.
4. Capture the evidence bundle.

## Post-deploy verification (Dev, shadow-mode)

- **Router dispatch.** One item per route: `mcq`→`mcq_rule`,
  `discrete_text`→`llm_text`, `structured_formula`→`symbolic_ecf`,
  `spatial`/`holistic`/missing→`shadow_review`. Assert the returned
  `evaluator_strategy`/`target` and that spatial/holistic/unknown are **held**,
  not auto-graded.
- **Engine 1 deterministic-before-LLM.** A keyed AP Statistics numeric item where
  the deterministic verifier owns the criterion returns without an LLM call
  (verify no grader-usage ledger row / zero grader cost for that criterion).
- **v2 sanitizer grounding.** A response whose model "evidence_quote" is not
  present in the submitted text lands `evidence_not_found` in `integrity_issues`
  and the criterion falls to `unable_to_determine` (no unfounded credit).
- **Auth attribution (the fixed bug).** A graded attempt records telemetry under
  the authenticated user id derived from the bearer token — not an empty/anon
  session.
- **Shadow-review round-trip.** Graded-in-shadow item appears in `review-queue`
  (GET), a reviewer decision via `review-decision` records, and no
  learner-facing authoritative score is emitted.
- **Regression.** AP Biology / AP Statistics existing text grading unchanged
  where it was already correct.
- **Latency/cost capture (measure-and-report).** Record end-to-end p50/p90/p99
  segmented per engine/modality and per-stage breakdown for the smoke set — first
  observed distribution, not yet a gate.

## Rollback decision tree

- **Migration fails before commit** → transaction aborts; no state change; fix and
  re-run. `curated_public_interface` and the RLS restore are the risk items —
  verify they are transactional.
- **Migration succeeds, functions not yet deployed** → safe to pause; new columns
  are additive and unused until the functions ship.
- **Function deploy or smoke fails** → redeploy the previous function bundle
  (functions are stateless; last-known-good is the pre-Phase-A deployment). No
  data migration needed to roll functions back.
- **Defect surfaces after deploy** → because Phase A is shadow-only, no learner
  saw an authoritative score; disable the new route by reverting the function
  bundle; data written is review/telemetry only.
- **Schema rollback** → the four migrations are additive (interface/table/RLS/
  projection); down-path is drop-interface / restore-prior-policy. Author explicit
  down migrations before Production; Dev may be reset from the disposable baseline.

## Required evidence bundle after authorized Dev execution

- `schema_migrations` before/after diff.
- Preflight outputs (exposed-schema check, RPC privilege check, column presence).
- Router dispatch transcript (one per route).
- Deterministic-before-LLM proof (no-grader-call ledger evidence).
- Sanitizer grounding transcript (`integrity_issues`).
- Auth-attribution proof (telemetry user id = token subject).
- Shadow round-trip transcript.
- Latency/cost table (p50/p90/p99 per engine/modality + per-stage).
- P0 SQL regression re-run green against the Dev-applied schema.

## Current disposition

**Repository-ready; unapplied.** Suite 95/95 green, `deno check` clean, worktree
reconciled into 9 workstream commits. **Blocked on:** (1) Product Owner Dev
execution approval ID; (2) preflight migration-ordering resolution; (3) duplicate
function-dir hygiene. Production remains a separate, later gate.
