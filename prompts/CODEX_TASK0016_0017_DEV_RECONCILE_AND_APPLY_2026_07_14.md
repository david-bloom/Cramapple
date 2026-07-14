# Codex Task — Dev Migration Reconciliation + TASK-0017/Publication Apply + Seeded Grading Evidence Run

**Date:** 2026-07-14
**Owner:** Codex (backend), reporting to David Bloom (Product Owner / approver)
**Environment:** **Development only** (`wmgjsdkphcyhngaffbqf`). **No Production
(`pcntajvbdfqhbeewmdry`) change of any kind.**
**Approvals in force:** APPROVAL-0037 (Phase A Dev exec); David authorized this
TASK-0017/publication Dev execution 2026-07-14 (record it as APPROVAL-0038 on
completion). DECISION-0041 (TASK-0010 calibration gates any publish).

## Why this task exists

TASK-0016 Phase A was deployed to Dev on 2026-07-14 (7 additive migrations + 6
edge functions, shadow mode; boundary-verified). Preflight for the follow-on
TASK-0017 / publication migrations found **Dev's migration history has diverged
from the repo and is partly managed outside it**, which blocks a clean `db push`.
The publication + harness migrations are ~2,800 lines of security-critical SQL
(the fail-closed publish RPC that enforces DECISION-0041), so they must be applied
**file-faithfully**, not hand-transcribed. This task reconciles the history and
lands the batch with evidence.

## Confirmed Dev state (from 2026-07-14 preflight)

- Dev `schema_migrations` runs to `202607071200`, then **`20260711033925`
  (add_rubric_routing_columns)** and **`20260711033934`
  (backfill_rubric_routing_metadata)** — version ids that **do not exist in the
  repo** (repo carries the same two migrations as `202607080005/0006`). Source of
  these Jul-11 ids is unknown (Lovable branch merge? manual apply?) — **determine
  it.**
- Phase A then applied 7 migrations via MCP under **`task0016_phase_a_*`** names
  (fresh Jul-14 versions, not the repo `2026070800x` ids): the 5
  `grading_results` columns, `profiles.review_queue_scope` (CHECK guarded),
  `review_schema_stabilization`, and `restore_label_assignment_rls_policies`.
- **Not applied / deferred:** `202607080003` (queue backfill), `202607080004`
  (dbloom01→admin, a privilege change), `202607120001` (HDG — content guard
  aborts; Dev has 0 published AP Stats FRQs), and the whole
  TASK-0017/publication batch below.
- Dependency preflight for the batch **passed**: every table the P0 functions and
  H1/H2 reference already exists on Dev; `pgcrypto` is in `extensions`,
  relocatable, `extensions.digest` available (P0 preamble will not raise).

## Workstream 1 — Migration-history reconciliation (the unlock)

**Goal:** make Dev's `supabase_migrations.schema_migrations` a faithful
description of the repo so `supabase db push` works safely, without re-running or
breaking already-applied schema.

- Investigate and document the source of the `20260711033925/033934` ids (was Dev
  provisioned/updated by Lovable Cloud or a manual apply?). This determines
  whether a second writer will keep re-diverging Dev.
- Produce a reconciliation plan + script that aligns recorded versions to the repo
  file versions for migrations whose **effects already exist** (rubric routing,
  the 7 `task0016_phase_a_*`), by rewriting/inserting the correct
  `schema_migrations` rows — **not** by re-applying DDL. Verify actual schema
  state (columns/policies/constraints) matches before recording each as applied.
- Guard the known trap: repo `202607080002` adds
  `profiles_review_queue_scope_check` **without** `IF NOT EXISTS`; Phase A applied
  a guarded version. Ensure the reconciled history won't re-run the unguarded
  form (or harden the repo file).
- Output: a dry-run diff of `db push` after reconciliation showing **zero
  unexpected pending migrations** except the intended batch below.

## Workstream 2 — Apply the TASK-0017 / publication batch (with evidence)

Apply these exact repo files **in order** (file-faithful; the fail-closed publish
RPC must not be altered in transit):

1. `202607090001_curated_public_interface`
2. `202607090002_curated_public_interface_revoke_anon`
3. `202607130001_atomic_content_publication` — **P0 fail-closed publish RPC**
4. `20260713172806_task0017_h1_h2_subject_harness_persistence`
5. `20260713172817_task0017_h3_h5_validation_and_exceptions`

**Do NOT apply** `202607120001` (HDG — aborts on 0 published FRQs),
`202607080003/004` (data + privilege change; `004` is David's call to run).

Preflight notes already verified: dependencies present; no migration-time content
guards except HDG (excluded); the `content_items`/`subjects` inserts inside
`20260713172817` are **function bodies** (runtime), not seed data — only
`platform_capabilities` / `deterministic_check_types` / `validation_suite_types`
are top-level reference seeds.

**Two acceptable apply mechanisms** (pick one; if Claude has already applied via
`scripts/dev-migration-apply/apply.sh` this session, verify + record instead):
- After Workstream 1, `supabase db push` (now safe).
- Or `psql` on the exact files via `scripts/dev-migration-apply/apply.sh` (records
  versions; refuses non-Dev via the `task0016_phase_a_*` interlock).

**Evidence bundle (required):**
- `scripts/dev-migration-apply/verify.sql` output (P0 functions present +
  service_role-only execute; H1/H2/H3–H5 tables; curated interface; recorded
  versions).
- The **P0 SQL regression battery** (`TASK0017_P0_*`) re-run green against the
  Dev-applied schema.
- **`app`-not-Data-API-exposed** REST probe (`app` schema unreachable via
  PostgREST) — the standing Dev preflight.
- `get_advisors(security)` after DDL: no new ERROR-level findings.

## Workstream 3 — Seeded end-to-end grading evidence run (Phase A proof)

Prove Phase A grades correctly in Dev **shadow mode** (still non-authoritative):
- Seed one AP Statistics test item per `rubric_type` (`mcq`, `discrete_text`,
  `structured_formula`, `spatial`, `holistic`) + a keyed numeric item for the
  deterministic path. (Dev currently has **0 published AP Stats FRQ content**.)
- **Test student:** David to provide a throwaway Dev student account / JWT (Claude
  cannot create accounts; Codex should also not self-provision auth users without
  David's explicit go).
- Drive `evaluate-attempt` for every route and capture the evidence bundle:
  router dispatch per route (spatial/holistic/unknown **held**, not auto-graded);
  deterministic-before-LLM (no grader-usage ledger row / zero grader cost for a
  keyed criterion); v2 sanitizer grounding (`integrity_issues` incl.
  `evidence_not_found`); **auth attribution** (telemetry user id = token subject —
  the fixed bug); shadow round-trip through `review-queue`/`review-decision`;
  latency p50/p90/p99 + cost per engine/modality.

## Related follow-on (grading plan) — not required here, note for sequencing

- **Calibration candidate-capture adapter** (TASK-0010, DECISION-0041 critical
  path): build the provider-dispatch adapter that runs the production grader
  against the AP Statistics gold-set responses to produce the
  `candidate-results.json` that
  `scripts/grading-model-assessment/calibrate-ap-statistics.ts` scores. This is
  the missing half that makes the launch-bar measurement real once **human
  dual-blind adjudicated gold** replaces the provisional labels.

## Guardrails

- **Dev only.** No Production migration, deploy, config, or publication.
- Verify actual schema by query before trusting the migration list (history is
  diverged).
- Nothing here publishes content; publication remains fail-closed and, per
  DECISION-0041, gated on a passed TASK-0010 calibration run. `QA-pass ≠ launch
  approval`.
- Return completed work + evidence for Hard-Gate review; record APPROVAL-0038 and
  an ACTIVITY_LOG entry.

## References

- `docs/qa/TASK0016_PHASE_A_DEV_EXECUTION_EVIDENCE_2026_07_14.md`
- `docs/qa/TASK0016_PHASE_A_DEV_EXECUTION_PACKET_2026_07_14.md`
- `scripts/dev-migration-apply/` (applier + verify + README)
- `docs/activity_log/DECISIONS_LOG.md` (DECISION-0039, 0041),
  `docs/activity_log/APPROVALS_LOG.md` (APPROVAL-0037)
- Memory: Dev migration divergence — do not `db push` until reconciled.
