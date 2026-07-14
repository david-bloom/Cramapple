# Codex — Subject-Onboarding Harness (TASK-0017 execution brief)

**Prepared:** 2026-07-13 · **v2** (rewritten after Codex's own G1-style review; scope now lives in the task doc)
**Authoritative scope:** `docs/tasks/TASK-0017-SUBJECT-ONBOARDING-HARNESS.md` — read it first; this brief is the execution pointer, not a second source of truth.
**Decision:** `DECISION-0037`. Related: `DECISION-0036` (content authoring), `DECISION-0034` (verification profile), `AP_STATISTICS_2027_CONTENT_REBUILD_ORCHESTRATION.md` (first consumer).

Your 2026-07-13 review is accepted in full. This brief reflects it and David's four decisions.

## What changed from v1 (your review, incorporated)

- **H5 → P0.** The publication-trust ordering defect is the **first** work item, not a later enhancement. Verified: `admin-content/index.ts` `changeArtifactState` flips `content_items`/`content_item_versions` to `published` (≈ lines 638–660) **before** requiring the manifest (≈ 663–668) or running `enforceGatePolicy` (≈ 707–714), non-atomically. Fix per TASK-0017 "P0" (server-resolved eligibility, atomic apply, rollback, reviewed-version==activated-version proof, regression test).
- **Added H0 SubjectPackage contract** as the Claude↔Codex interface. Claude supplies packages; never executable verifier code or migration SQL.
- **Annual-revision support** (`create-subject` and `create-exam-pack-version`), real taxonomy versioning (H2), versioned item-package schema over enums (H1), declarative-checks + reviewed-plugins (H3), real qualification policy / no fail-open (H4), capability preflight, machine-readable calibration status, plan/apply CLI with explicit env + Production approval-ID gate, golden fixtures.

## David's decisions (2026-07-13)

1. **P0 first → H1 vertical slice → rest** under design approval.
2. **Gate waivability:** content-clearance waivable by PO with a recorded exception; **grading/calibration, rights, security/privacy never waivable.**
3. **AP Chem (TASK-0014) / Physics (TASK-0015):** adopt the harness once ready; **no new bespoke scaffolding** for them meanwhile.
4. **Canonical school-year id = academic-year form (`YYYY-YY`) derived from `official_exam_date`.** A legacy `2026` row with a May 2026 exam becomes `2025-26`; a May 2027 exam becomes `2026-27`. Do not blanket-map `2026`.
5. **Canonical question-version record (v1) = `content_item_versions.id`** — do not create a second parallel record.

## Deliverable sequence

Follow the TASK-0017 "Delivery Sequence" exactly. In short: **(1)** implement and review the already authorized P0 repository repair without applying it to an environment; **(2)** produce the H0/H1 design packet for Product Owner approval; **(3)** obtain separate Dev migration approval; **(4)** prove the H1 AP Stats Q1–Q4 round-trip before DB staging; then continue H2–H5. AP Stats 2027 tests annual revision, AP Chemistry tests reconciliation of an existing bespoke subject, and a transaction-rolled-back fixture tests true `create-subject` behavior.

## Hard guardrails

- **Design approval before any Dev migration.** Dev migrations separately approved. Production is a distinct Hard-Gate review (migration + rollback + evidence packet).
- **Dev first** (`wmgjsdkphcyhngaffbqf`); **no Production schema changes** without explicit David approval + recorded approval ID. Never infer the target from the currently linked project.
- **No auto-publish**; nothing sets `status='published'` or asserts human approval outside the repaired, gated publish path.
- **Config never executes arbitrary code** (declarative checks + reviewed plugins only).
- **Backward compatible:** AP Biology + current AP Statistics must reproduce normalized semantic golden snapshots (excluding generated UUIDs, timestamps, and audit fields), with stable hashes for canonical config/payload content, or have an approved migration explanation.
- **People stay out of reusable subject configs.**

## Report back

The design proposal (item 1) plus: the canonical-record and taxonomy-versioning approach, the Dev→Prod migration/rollback plan, and any schema decisions needing David's sign-off before Production. Flag anything in TASK-0017 you'd revise.
