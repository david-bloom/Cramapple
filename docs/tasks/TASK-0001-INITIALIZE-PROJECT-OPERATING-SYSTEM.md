# TASK-0001 — Initialize Project Operating System and Canonical Vision

**Task ID:** TASK-0001
**Title:** Initialize Project Operating System and Canonical Vision
**Owner:** Main Conductor
**Product Owner:** David Bloom
**Status:** Ready for Owner Review
**Priority:** High
**Created Date:** 2026-06-09
**Approved Date:** 2026-06-09

## Product Goal

Establish a durable source of truth, explicit authority model, and reviewable canonical vision for Cramapple.

## Technical Scope

- Connect the local workspace to `david-bloom/Cramapple`.
- Install and customize `david-bloom/ai-project-operating-kit`.
- Store Cramapple Vision v0.2 in `docs/product/`.
- Record initial approval, decisions, and activity.
- Preserve existing speculative blueprint files.

## Out of Scope

- Product implementation.
- Technical architecture selection.
- Curriculum creation.
- Marketing execution.
- Deployment or live-service changes.

## Routes / Components / Systems Affected

- GitHub repository documentation only.

## Data / Security / Integration Impact

- No student data or production systems affected.
- No secrets, migrations, or deployments.

## Acceptance Criteria

- [x] Operating-kit documents are installed and contain no unresolved template placeholders.
- [x] David is recorded as Product Owner and final approver.
- [x] Strategy Advisor is defined as advisory with no independent approval authority.
- [x] Vision v0.2 is stored in `docs/product/` as Markdown and DOCX.
- [x] Initial approval, decision, and activity records are present.
- [x] Existing blueprint documents are preserved and identified as speculative.
- [x] DOCX renders cleanly.
- [ ] David reviews the pull request and records the Done decision.

## QA Plan

- Manual QA: Inspect source-of-truth structure and role language.
- Automated tests: Search for unresolved operating-kit placeholders; validate DOCX archive.
- Regression areas: Vision content and generated document formatting.
- Failure cases: Ambiguous approval authority or older blueprints appearing canonical.
- Security/data/integration checks: Confirm no live systems or secrets changed.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate for Done decision
**Decision:** Approved for execution through APPROVAL-0001

## Implementation Notes

Installed the operating kit, customized governance, added source-of-truth records, and updated the vision.

## QA Review

Documentation checks passed. The DOCX was rendered and visually inspected.

## Done Decision

**Decision:** Pending Product Owner review
**Date:** Pending
