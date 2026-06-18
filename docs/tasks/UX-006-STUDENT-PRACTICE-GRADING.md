# UX-006 - Student Practice and Grading

**Task ID:** UX-006
**Title:** Student Practice and Grading
**Owner:** Product Owner with Learning Quality Owner and Grading Lead
**Product Owner:** David Bloom
**Status:** In Progress
**Priority:** Critical
**Created Date:** 2026-06-15
**Approved Date:** 2026-06-15 for design documentation and Lovable brief

## Product Goal

Design the detailed learner experience for MCQ, FRQ, quantitative, and
data-analysis attempts; criterion feedback; uncertainty; repair; disputes;
human-review states; and immutable regrading.

## Technical Scope

- Extend the UX-001 learning frame into detailed response controls.
- Define independent, coached, and exam-practice attempt conditions.
- Define MCQ, FRQ, quantitative, and data-analysis interactions.
- Define criterion-level grading and evidence-grounded feedback.
- Define high-confidence, qualified, low-confidence, content-uncertain, and
  technical-failure states.
- Define repair, fresh retry, dispute, escalation, and regrade behavior.
- Define evidence consequences and accessibility requirements.
- Produce a Lovable-ready render brief without a prototype.

## Out of Scope

- Production grading implementation or learner-facing release approval.
- Calibration thresholds and operational gates owned by `TASK-0010`.
- Internal adjudication and release controls owned by UX-005.
- Student-provided question intake owned by UX-004.
- Handwritten graph capture owned by UX-008.
- Official AP score prediction or guaranteed improvement claims.

## Routes / Components / Systems Affected

- Practice session frame.
- MCQ and FRQ response controls.
- Quantitative workspace.
- Submission and grading states.
- Criterion feedback.
- Repair and retry.
- Dispute and recheck.
- Review status and regrade comparison.

## Data / Security / Integration Impact

Production use handles immutable learner responses, assistance level, timing,
confidence, grader and rubric versions, criterion decisions, disputes, reviewer
access, and corrected outcomes. Idempotent submission, least privilege,
retention, audit, and evidence-rebuild behavior require server enforcement.

## Acceptance Criteria

- [x] MCQ, FRQ, quantitative, and data-analysis attempt controls are specified.
- [x] Cold, coached, and exam-practice consequences are explicit.
- [x] Criterion feedback cites learner evidence and applicable rules.
- [x] Low-confidence totals are withheld or appropriately qualified.
- [x] Content uncertainty cannot count against learner progress.
- [x] Technical retries do not create duplicate attempts.
- [x] Repair preserves the immutable original response.
- [x] Disputes are criterion-specific.
- [x] Regrades append a new result and show downstream consequences.
- [x] Human-review language depends on operational availability.
- [x] Lovable-ready handoff is produced.
- [ ] Learning Quality, grading, accessibility, security, privacy, and
  academic-integrity review is completed.
- [ ] Product Owner approves, revises, or rejects the final UX.

## QA Plan

- Document QA: Verify learning-state, confidence, evidence, and immutable-grade
  rules against UX-001, `TASK-0010`, and the learning system.
- Lovable QA: Walk MCQ, FRQ, quantitative, uncertainty, dispute, and regrade
  scenarios using fixtures.
- Regression areas: Answer leakage, pseudo-precise low-confidence scores,
  coached work counted as cold, duplicate submission, overwritten grades, and
  unsupported human-review promises.
- Failure cases: Empty part, lost connection, conflicting graders, ambiguous
  response, defective rubric, unsupported representation, and stale regrade.
- Security checks: Use original placeholder content and no real learner data.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate for implementation and learner-facing grading
**Decision:** Design documentation and Lovable brief approved; implementation
and grading release pending

## Implementation Notes

Primary records:

- `docs/product/STUDENT_PRACTICE_AND_GRADING_DESIGN.md`
- `prompts/LOVABLE_UX006_STUDENT_PRACTICE_GRADING.md`

No prototype is authorized by this task.

## QA Review

Pending expert and Product Owner review.

## Done Decision

**Decision:** Pending
**Date:** Pending

