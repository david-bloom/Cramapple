# UX-004 - Student-Provided Question Intake

**Task ID:** UX-004
**Title:** Student-Provided Question Intake
**Owner:** Product Owner with Learning Quality Owner
**Product Owner:** David Bloom
**Status:** In Progress
**Priority:** High
**Created Date:** 2026-06-13
**Approved Date:** 2026-06-13 for design and prototype work

## Product Goal

Design a safe, understandable intake experience for students who type, paste,
photograph, or upload an outside question and request teaching, a hint, work
checking, or a solution walkthrough.

## Technical Scope

- Define capture, extraction confirmation, classification, clarification, mode
  selection, and review stages.
- Define personal-information, missing-context, low-confidence, unsupported
  subject, and active-assessment states.
- Preserve private use, anonymous improvement, canonical content, and public
  publication as separate states.
- Produce a frontend-only clickable prototype and Lovable render brief.

## Out of Scope

- Production uploads, OCR, malware scanning, storage, or model calls.
- Final copyright, consent, retention, deletion, provider, or academic-integrity
  policy.
- Physical database or API design.
- Public landing-page publication workflow.
- Production grading or authoritative scoring.

## Routes / Components / Systems Affected

- Student Home and Bring a Question.
- Check My Work entry.
- Question capture and upload.
- Extraction confirmation.
- Classification and clarification.
- Help-mode selection.
- Private learning-session entry.

## Data / Security / Integration Impact

Production implementation will handle potentially copyrighted source material
and restricted learner data, including names, handwriting, faces, school
information, answers, and uploaded files. Upload and processing must be
server-authorized, scanned, access-controlled, auditable, and governed by
approved retention and deletion rules.

## Acceptance Criteria

- [x] Type/paste, photo/screenshot, and document flows are specified.
- [x] Original input and learner-confirmed extraction are distinguished.
- [x] One-round relevance and completeness clarification is specified.
- [x] High, moderate, and low match behavior is specified.
- [x] Teach, Hint, Check My Work, and Solution modes are specified.
- [x] Personal-information and active-assessment states are specified without
  claiming final policy.
- [x] Private use, anonymous improvement, canonical content, and public
  publication are separated.
- [ ] Clickable prototype is produced and verified.
- [ ] Lovable-ready handoff is produced.
- [ ] Learning Quality, accessibility, security, privacy, rights, and
  academic-integrity review is completed.
- [ ] Product Owner approves, revises, or rejects the final UX.

## QA Plan

- Manual QA: Walk typed, photo, document, missing-context, personal-information,
  low-confidence, unsupported-subject, Check My Work, and active-assessment
  paths.
- Automated tests: Parse prototype JavaScript, verify required states, and run
  `git diff --check`.
- Regression areas: Answer leakage, fabricated context, unsupported scoring,
  canonical-content isolation, and public/private separation.
- Failure cases: Empty input, failed extraction, missing visual, missing answer,
  unclear subject, unsupported subject, and interrupted intake.
- Security/data/integration checks: Confirm prototype makes no network calls,
  uploads no files, and contains no secrets or protected content.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate for implementation and production use
**Decision:** Design and prototype work approved; implementation pending

## Implementation Notes

Primary records:

- `docs/product/STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md`
- `prototypes/ux-004/index.html`
- `prompts/LOVABLE_UX004_STUDENT_QUESTION_INTAKE.md`

## QA Review

Pending prototype completion.

## Done Decision

**Decision:** Pending
**Date:** Pending
