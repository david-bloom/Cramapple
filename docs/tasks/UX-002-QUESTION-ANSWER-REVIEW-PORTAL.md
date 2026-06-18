# UX-002 - Question and Answer Review Portal

**Task ID:** UX-002
**Title:** Question and Answer Review Portal
**Owner:** Product Owner with Learning Quality Owner
**Product Owner:** David Bloom
**Status:** In Progress
**Priority:** High
**Created Date:** 2026-06-13
**Approved Date:** 2026-06-13 for design and prototype work

## Product Goal

Design a reviewer portal in which logged-in tutors and AP Readers evaluate
question candidates and MCQ answer options through an independent, auditable
carousel workflow.

## Technical Scope

- Define tutor and AP Reader scoring semantics and state transitions.
- Define question-first and answer-second review gates.
- Define exact difficulty agreement and discussion behavior.
- Define reviewer queue, carousel, review panel, outcome, recusal, and
  responsive interactions.
- Produce a frontend-only clickable prototype.
- Produce a Lovable-ready render brief.

## Out of Scope

- Production authentication, authorization, database, APIs, or audit storage.
- Physical Supabase or Postgres schema.
- Reviewer recruiting, qualification, contracting, or compensation.
- Production release or exam-pack publication.
- Replacing source, rights, teaching, grading, accessibility, or release gates.
- Use of official or unapproved question content.

## Routes / Components / Systems Affected

- Reviewer queue and dashboard.
- Tutor question and answer review carousel.
- AP Reader question and answer review carousel.
- Difficulty discussion queue.
- Review assignment, comparison, versioning, and candidate disposition.
- Recycled-item handoff to the UX-003 authoring and revision workbench.

## Data / Security / Integration Impact

Production implementation will handle confidential candidate content,
reviewer identity and qualifications, blinded assignments, immutable decisions,
version history, conflict attestations, and audit events. Server enforcement is
required; the browser cannot be authoritative for review or release state.

## Acceptance Criteria

- [x] Individual tutor and aggregate score meanings are explicit.
- [x] Question and answer state transitions are documented.
- [x] Difficulty confirmation requires exact three-reviewer agreement.
- [x] Any excluded answer blocks the current four-option MCQ package.
- [x] Submitted decisions and edits preserve immutable versions.
- [x] Candidate approval is distinguished from production release.
- [x] Revision and edit-and-recycle outcomes have an explicit UX-003
  destination.
- [x] Clickable carousel prototype is produced.
- [x] Lovable-ready handoff is produced.
- [ ] Tutor, AP Reader, Learning Quality, accessibility, and security review is
  completed.
- [ ] Product Owner approves, revises, or rejects the final UX.

## QA Plan

- Manual QA: Walk all tutor aggregate and AP Reader branches for questions and
  answers.
- Automated tests: Parse prototype JavaScript, verify required state labels,
  and run `git diff --check`.
- Regression areas: Reviewer independence, immutable decisions, whole-package
  MCQ validity, and downstream release boundaries.
- Failure cases: Missing score, missing difficulty, missing rationale,
  attempted navigation with unsaved work, recusal, and stale assignment.
- Security/data/integration checks: Confirm frontend-only prototype contains no
  credentials, network writes, or protected content.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate for implementation and production use
**Decision:** Design and prototype work approved; implementation pending

## Implementation Notes

Primary records:

- `docs/product/QUESTION_AND_ANSWER_REVIEW_PORTAL_DESIGN.md`
- `prototypes/ux-002/index.html`
- `prompts/LOVABLE_UX002_REVIEW_PORTAL.md`

## QA Review

Browser verification completed on 2026-06-13:

- Verified missing-score, missing-difficulty, and missing-rationale validation.
- Verified tutor Maybe disposition language for aggregate 3 and higher.
- Verified AP Reader answer exclusion blocks the current MCQ package.
- Verified AP Reader edit-and-recycle creates a new answer/package version.
- Verified answer carousel navigation between the proposed correct answer and
  distractors.
- Verified difficulty discussion requires a resolution and rationale and
  preserves prior labels.
- Verified keyboard score selection semantics and visible focus.
- Verified no horizontal overflow at 390 and 1280 CSS pixels.
- Verified no browser console errors.
- Tutor, AP Reader, Learning Quality, accessibility, and security review remain
  pending.

## Done Decision

**Decision:** Pending
**Date:** Pending
