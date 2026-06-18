# UX-005 - Content Operations, Adjudication, and Release

**Task ID:** UX-005
**Title:** Content Operations, Adjudication, and Release
**Owner:** Product Owner with Learning Quality Owner and Technical Owner
**Product Owner:** David Bloom
**Status:** In Progress
**Priority:** Critical
**Created Date:** 2026-06-15
**Approved Date:** 2026-06-15 for design documentation and Lovable brief

## Product Goal

Design the internal operating console that controls reviewer qualification,
entitlements, assignments, calibration, adjudication, release gates, immutable
manifests, rollback, and quality incidents.

## Technical Scope

- Define operations dashboard and exception queues.
- Define qualification, renewal, entitlement, suspension, and remediation UX.
- Define conflict-aware reviewer assignment and reassignment.
- Define calibration operations and drift findings.
- Define teaching and grading adjudication.
- Define release-candidate gate inspection and manifest comparison.
- Define publication, heightened monitoring, and rollback confirmations.
- Define incident triage, containment, correction, revalidation, and closure.
- Produce a Lovable-ready render brief without a prototype.

## Out of Scope

- Production database, authorization, audit, notification, or release code.
- Final adoption of proposed governance thresholds or qualification policy.
- UX-002 reviewer scoring, UX-003 author editing, or learner-facing grading.
- Protected holdout content in frontend fixtures.
- Real entitlement grants, publication, rollback, exports, or incident actions.

## Routes / Components / Systems Affected

- Content operations home.
- People, qualifications, and entitlements.
- Assignment and recusal operations.
- Calibration and remediation.
- Adjudication workbench.
- Release candidates and manifest comparison.
- Publication and rollback.
- Incident command and audit.

## Data / Security / Integration Impact

Production use would expose identity, qualifications, protected validation
evidence, assignments, immutable decisions, release manifests, incidents, and
privileged actions. Least privilege, separation of duties, reauthentication,
tamper-evident audit, server authority, and protected evidence isolation are
mandatory.

## Acceptance Criteria

- [x] Qualification and entitlement are separate UX concepts.
- [x] Suspension identifies dependent access and open-work consequences.
- [x] Assignment blocks mandatory conflicts and out-of-scope reviewers.
- [x] Calibration supports remediation without silently changing authority.
- [x] Adjudication preserves independent decisions and can reopen defects.
- [x] Release gates distinguish blocked, passed, awaiting, and not applicable.
- [x] Manifest comparison and atomic publication consequences are explicit.
- [x] Rollback preserves a prior approved manifest and incident evidence.
- [x] Incident states and cross-functional actions are specified.
- [x] Lovable-ready handoff is produced.
- [ ] Learning Quality, operations, accessibility, security, privacy, rights,
  and technical review is completed.
- [ ] Product Owner approves, revises, or rejects the final UX.

## QA Plan

- Document QA: Verify role boundaries, state transitions, required evidence,
  release classes, and incident behavior against governance.
- Lovable QA: Walk qualification, assignment, calibration, adjudication,
  release, rollback, and incident scenarios using fixtures.
- Regression areas: Self-approval, blind-review leakage, incomplete gates,
  partial activation, unauthorized rollback, and deleted history.
- Failure cases: Expired qualification, recusal, no eligible reviewer, rubric
  defect, checksum mismatch, expired rights, failed smoke test, and S0 incident.
- Security checks: Confirm fixtures contain no protected holdout, personal,
  secret, or production release data.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate for implementation and production use
**Decision:** Design documentation and Lovable brief approved; implementation
pending

## Implementation Notes

Primary records:

- `docs/product/CONTENT_OPERATIONS_ADJUDICATION_RELEASE_DESIGN.md`
- `prompts/LOVABLE_UX005_CONTENT_OPERATIONS_RELEASE.md`

No prototype is authorized by this task.

## QA Review

Pending expert and Product Owner review.

## Done Decision

**Decision:** Pending
**Date:** Pending

