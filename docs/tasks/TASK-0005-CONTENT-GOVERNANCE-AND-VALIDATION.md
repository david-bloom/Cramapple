# TASK-0005 — Content Governance and Validation Operating Procedure

**Task ID:** TASK-0005
**Title:** Content Governance and Validation Operating Procedure
**Owner:** Main Conductor
**Product Owner:** David Bloom
**Status:** In Progress
**Priority:** High
**Created Date:** 2026-06-12
**Approved Date:** Pending

## Product Goal

Define the complete operating procedure that makes Cramapple's versioned
content, independent teaching and grading validation, atomic exam-pack release,
monitoring, revalidation, retirement, rollback, and audit architecture
operationally precise.

## Technical Scope

- Define roles, separation of duties, and conflict rules.
- Define validator qualifications, renewal, calibration, and suspension.
- Define exact logical schemas for source, rights, artifact, provenance,
  dependency, review, validation, release, incident, revalidation, and audit
  records.
- Define source and rights review procedures.
- Define teaching and grading checklists, reviewer counts, and thresholds.
- Define atomic publication, monitoring, incident, retirement, and rollback
  procedures.
- Define source-refresh schedules and full-versus-partial revalidation rules.
- Define paid-tutor original-question authoring and author-validator separation.

## Out of Scope

- Physical database schema or migrations.
- Validator workbench implementation.
- Production model selection or tuning.
- Acquisition or reproduction of official or restricted materials.
- Legal conclusions or approval of a rights-use theory.
- Recruiting or contracting validators.
- Production launch or risk acceptance.

## Routes / Components / Systems Affected

- Canonical content repository.
- Rubric and scoring package repository.
- Source and provenance registry.
- Validator workbench and qualification service.
- Release and revalidation service.
- Exam pack resolver.
- Quality monitoring and audit services.

## Data / Security / Integration Impact

The proposed procedure introduces confidential validation records, reviewer
qualifications, rights decisions, immutable release manifests, protected
held-out sets, and append-only audit requirements. Implementation will require
separate security, privacy, retention, and authorization design.

## Acceptance Criteria

- [x] Roles and independence rules are explicit.
- [x] Validator qualifications and calibration rules are explicit.
- [x] Canonical logical record schemas and invariants are defined.
- [x] Teaching and grading review checklists are defined.
- [x] Reviewer counts and numeric release thresholds are defined.
- [x] Source and rights refresh schedules are defined.
- [x] Full-versus-partial revalidation rules are defined.
- [x] Atomic publication, monitoring, incident, retirement, rollback, and audit procedures are defined.
- [x] Paid-tutor original-question authoring replaces historical-question-seeded generation.
- [x] Both MCQs and FRQs are included with a ten-question subject/subtopic coverage target.
- [x] Controlled AI versioning is limited to Cramapple-owned or fully licensed proprietary packages.
- [x] AP Reader eligibility and diagnostic lifecycle rules are defined.
- [ ] AI-version holdout, production item sample thresholds, and permitted asset sources are defined.
- [ ] Learning Quality Owner reviews the paid-author workflow and proposed educational quality gates.
- [ ] Counsel reviews the proposed rights and retention boundaries.
- [ ] Product Owner approves, requests changes, or rejects the policy.

## QA Plan

- Manual QA: Cross-check against the vision, high-level architecture, component
  architecture, teaching design, and approved operating rules.
- Automated tests: Markdown structure, link, and terminology checks when
  documentation tooling exists.
- Regression areas: Product authority, teaching/grading separation, rights
  boundaries, learner privacy, and atomic release.
- Failure cases: Self-approval, partial publication, expired rights, exposed
  held-out cases, stale sources, and overwritten history.
- Security/data/integration checks: Deferred to implementation design.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate
**Decision:** Pending

## Implementation Notes

Created `docs/architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md` as a proposed
canonical operating policy. Numeric thresholds are initial operating standards,
not scientific claims, and cannot take effect until approved.

## QA Review

Documentation consistency review completed on 2026-06-12:

- Confirmed the policy remains proposed and does not record owner approval.
- Confirmed author, validator, adjudicator, and release duties are separated.
- Confirmed teaching and grading gates remain independent.
- Confirmed artifact payloads and review evidence are immutable.
- Confirmed first-launch teaching blockers and grading thresholds cannot be
  waived through ordinary risk acceptance.
- Confirmed AI versioning is limited to owned or fully licensed base packages,
  creates new unapproved artifacts, and remains blocked from production until a
  holdout policy is approved.
- `git diff --check` passed.

## Done Decision

**Decision:** Pending
**Date:** Pending
