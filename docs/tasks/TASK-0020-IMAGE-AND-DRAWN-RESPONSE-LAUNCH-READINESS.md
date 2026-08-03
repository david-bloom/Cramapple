# TASK-0020 — Image and Drawn-Response Launch Readiness

**Task ID:** TASK-0020
**Title:** Assess Launch Readiness for Prompt Visuals and Hand-Drawn Responses
**Owner:** Main Conductor / Technical Assessment Owner
**Product Owner:** David Bloom
**Tier:** Standard
**Status:** In Progress
**Priority:** Critical
**Created Date:** 2026-08-03
**Approved Date:** 2026-08-03
**Branch:** `codex/image-workflows-readiness`
**PR:** Pending

## Product Goal

Determine whether Cramapple's launch-critical slice can reliably serve required question visuals, accept and preserve hand-drawn student responses, make them available for review, and support grading and repair under approved quality, privacy, accessibility, and operational controls.

## Technical Scope

- Run a cheap read-only cross-course scan for prompt-visual and learner-drawn-response candidates.
- Deep-classify the Product Owner-selected launch slice, preserving overlaps between displayed visuals and drawn responses.
- Audit prompt-visual authoring, rights, QA, accessibility, exact-version delivery, rendering, and failure behavior.
- Audit response capture routes by supported device class, binding, preservation, review, later student access, and hard-gate dependencies.
- Audit manual and automated grading/repair evidence, corpus adequacy, abstention, reviewer capacity, and revalidation triggers.
- Produce separate launch verdicts and next-approval remediation handoffs for Programs A, B, and C.

## Out of Scope

- Database migrations, API or frontend implementation, deployment, configuration, or secrets.
- Real learner/minor uploads or mutations to Production data.
- Retention, consent, vendor, or model-selection decisions.
- Operationalizing a manual-review queue or assigning reviewers.
- Automated learner-facing grading, task closure, risk acceptance, or launch approval.
- Merging or adopting the quarantined design sketch.

## Routes / Components / Systems Affected

- Read-only Production content, attempts, responses, storage metadata, and deployed-function evidence.
- Content authoring and reviewer workflows.
- Student question-delivery routes.
- Hand-drawn capture and response-review designs/prototypes.
- Grading and repair research records.
- No live system will be modified.

## Data / Security / Integration Impact

The assessment may inspect metadata about content and system configuration using read-only queries. It must not retrieve or expose learner handwriting, private signed URLs, secrets, or unnecessary personal data. Any later learner-image implementation remains a separate privacy/security hard gate.

## Acceptance Criteria

- [ ] Approval, evidence labels, ownership, and quarantine state are durably recorded.
- [x] A cheap cross-course candidate scan identifies systemic prompt-visual and drawn-response exposure.
- [ ] The launch-critical slice and minimum viable content volume are locked before delivery readiness Step 2.
- [ ] Candidate items are manually classified with intersections preserved and ambiguity reviewed.
- [ ] Prompt-visual readiness is audited from asset/source through student display and failure behavior.
- [ ] Hand-drawn capture, preservation, authorized review, later access, and supported-device routes are audited.
- [ ] Grading and repair readiness separates capture, grading, review/dispute, abstention, feedback, and transfer evidence.
- [ ] Reviewer capacity, hard gates, scope viability, and revalidation triggers are assessed.
- [ ] Separate Program A/B/C launch verdicts and proportional next-approval remediation handoffs are produced.
- [ ] A fresh independent reviewer receives the evidence packet at `Ready for Review`.

## QA Plan

- Manual QA: reconcile live, deployed, repository, prototype, proposed, and not-verified evidence; manually review ambiguous candidates and a sample of clear candidates.
- Automated tests: deterministic inventory/reconciliation scripts, count invariants, duplicate/intersection checks, and `git diff --check` for project records.
- Regression areas: missing-context false positives, answer-image versus prompt-image conflation, inaccessible alternates, unsupported device classes, and aggregate grading metrics masking weak cells.
- Failure cases: missing asset, private path without learner delivery, unanswerable item served, capture without response binding, accepted capture mistaken for gradable/correct work, unavailable reviewer capacity, and scope narrowing below viable volume.
- Security/data/integration checks: read-only Production queries, minimal selected fields, no learner-image retrieval, no signed URL disclosure, and no mutations.

## Implementation Summary

The read-only cheap cross-course scan is complete. It found 111 published prompt-visual candidates, 38 published drawn-response candidates, and 36 published possible missing-visual/context candidates across 288 published latest-version item pairs. The evidence supports a bounded dual-slice recommendation: 48 published AP Statistics targeted-drill FRQs plus 41 published AP Biology FRQs.

## Test Results

- Production aggregate scan executed with SELECT-only SQL.
- Reproducible query artifact: `scripts/image_readiness/cross_course_scan.sql`.
- Aggregate and per-course counts reconciled to 1,412 latest items and 288 published latest-version pairs.
- Storage metadata check found all 10 latest image-path references present in private `content-assets`; `learner-uploads` has zero objects.

## Risks / Issues

- Launch slice, minimum viable item volume, and precise essential-image failure behavior require Product Owner/Learning Quality decisions before Step 2. The scan recommends an 89-item AP Statistics + AP Biology dual slice.
- The preparer cannot perform the final independent QA.
- The unapproved code sketch is quarantined on `codex/image-workflows-design-sketch` at `a34a078` and must remain inert.

## Approval State

**Approval Required:** Yes
**Approval Type:** Product Owner approval for Standard-tier assessment; later implementation and launch hard gates remain separate
**Decision:** Approved under `APPROVAL-0041`

## Implementation Notes

Governing plan:

- `docs/research/IMAGE_AND_DRAWN_RESPONSE_LAUNCH_GATING_ASSESSMENT_PLAN_V5_2026_08_03.md`

The cross-course scan may begin before the launch slice is selected. Deep Step 2 work may not begin until the launch slice and minimum viable content volume are locked.

## QA Result

**QA Verdict:** Pending. A genuinely fresh independent context is required.

## Done Decision

**Decision:** Pending
**Date:** Pending
