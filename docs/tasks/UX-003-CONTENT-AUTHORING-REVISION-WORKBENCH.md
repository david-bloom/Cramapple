# UX-003 - Content Authoring and Revision Workbench

**Task ID:** UX-003
**Title:** Content Authoring and Revision Workbench
**Owner:** Product Owner with Learning Quality Owner
**Product Owner:** David Bloom
**Status:** In Progress
**Priority:** High
**Created Date:** 2026-06-15
**Approved Date:** 2026-06-15 for design and prototype work

## Product Goal

Design the author-facing workspace that creates complete question packages and
receives items recycled by UX-002 for modification, versioning, and independent
reassessment.

## Technical Scope

- Define assigned-work queue acknowledgement and task states.
- Define MCQ and FRQ package authoring for questions, answers, rubrics, hints,
  explanations, sources, rights, and accessibility.
- Define governed document import and field mapping.
- Define anchored reviewer-comment response and resolution evidence.
- Define immutable version comparison and impact warnings.
- Define provenance, originality, asset, tool, and rights capture.
- Define preflight, resubmission, and return to two-tutor reassessment.
- Link qualified users to the UX-002 review carousel while preventing
  self-review.
- Produce a frontend-only clickable prototype and Lovable render brief.

## Out of Scope

- Production uploads, extraction, malware scanning, storage, or model calls.
- Physical database, API, authorization, audit, or notification design.
- Final rights, compensation, contracting, retention, or reviewer-identity
  policy.
- Reviewer scoring controls already owned by UX-002.
- Production release, publication, exam-pack activation, or payment.
- Use of official, secure, credentialed, or otherwise restricted content.

## Routes / Components / Systems Affected

- Author task queue.
- Package editor and section navigator.
- Document import and mapping.
- Reviewer comment drawer.
- Version history and comparison.
- Provenance and rights panel.
- Preflight and immutable submission.
- UX-002 review-carousel entry.

## Data / Security / Integration Impact

Production implementation will handle confidential candidate content,
contracts, identity, qualifications, source records, rights evidence,
attachments, reviewer findings, immutable versions, and signed attestations.
Assignment, conflict, rights, version, and submission rules require server
enforcement.

## Acceptance Criteria

- [x] Assigned work can be acknowledged, opened, clarified, declined, or
  conflict-reported.
- [x] MCQ and FRQ complete-package authoring requirements are defined.
- [x] Questions, answers, rubrics, hints, and explanations have explicit
  editing surfaces.
- [x] Document import preserves the original attachment and requires rights
  confirmation and field mapping.
- [x] Reviewer comments remain immutable and receive author responses.
- [x] Immutable versions can be compared at package and field level.
- [x] Provenance, tool, asset, originality, and rights states are explicit.
- [x] Recycled items create new versions and return to required reassessment.
- [x] UX-002 review access is linked without permitting self-review.
- [x] Clickable prototype is produced and verified.
- [x] Lovable-ready handoff is produced.
- [ ] Author, Learning Quality, accessibility, security, privacy, and rights
  review is completed.
- [ ] Product Owner approves, revises, or rejects the final UX.

## QA Plan

- Manual QA: Walk new assignment, recycled MCQ, FRQ, import, comments, version
  comparison, rights blocker, preflight, resubmission, and review-switch paths.
- Automated tests: Parse prototype JavaScript, verify required state labels,
  and run `git diff --check`.
- Regression areas: Immutable history, self-review exclusion, complete MCQ
  package integrity, comment preservation, and rights gating.
- Failure cases: Unacknowledged task, incomplete package, missing source,
  unresolved blocking comment, conflicting answer key, failed import, stale
  version, and missing attestation.
- Security/data/integration checks: Confirm the prototype makes no network
  writes, uploads no documents, and contains no secrets or protected content.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate for implementation and production use
**Decision:** Design and prototype work approved; implementation pending

## Implementation Notes

Primary records:

- `docs/product/CONTENT_AUTHORING_AND_REVISION_WORKBENCH_DESIGN.md`
- `prototypes/ux-003/index.html`
- `prompts/LOVABLE_UX003_CONTENT_AUTHORING_WORKBENCH.md`

UX-002 remains the scoring and disposition surface. UX-004 is the
student-provided question intake.

## QA Review

Browser verification completed on 2026-06-15:

- Verified new-assignment acknowledgement opens an original short-FRQ package
  with three editable rubric criteria and no inherited revision comments.
- Verified recycled MCQ question, answer, hint, explanation, source, rights,
  accessibility, comment, check, and version-comparison surfaces.
- Verified simulated document import requires ownership and
  restricted-material confirmations before field mapping.
- Verified resubmission requires a change summary and four attestations, then
  creates version 3 and returns it to two independent tutors.
- Verified UX-003 opens the existing UX-002 review carousel.
- Verified the self-review scenario blocks an artifact revised by the current
  author.
- Verified no browser console errors and no horizontal page overflow at 450
  CSS pixels.
- Author, Learning Quality, accessibility, security, privacy, rights, and
  Product Owner review remain pending.

## Done Decision

**Decision:** Pending
**Date:** Pending
