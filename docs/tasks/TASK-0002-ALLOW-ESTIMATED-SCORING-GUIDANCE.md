# TASK-0002 — Allow Estimated AP Scoring Guidance

**Task ID:** TASK-0002
**Title:** Allow Estimated AP Scoring Guidance
**Owner:** Main Conductor
**Product Owner:** David Bloom
**Status:** Ready for Owner Review
**Priority:** High
**Created Date:** 2026-06-09
**Approved Date:** 2026-06-09

## Product Goal

Allow Cramapple to provide useful, qualified estimates of a student's likely AP score range and explain what improvement is most likely to move the student forward.

## Technical Scope

- Revise the canonical vision to permit estimated AP score ranges and readiness estimates.
- Require sufficient evidence, confidence language, evidence-gap disclosure, and non-official labeling.
- Require estimates to connect to concrete knowledge, skill, rubric, and practice recommendations.
- Add expert-scored calibration and later observed outcomes to the quality-measurement plan.
- Regenerate the canonical vision DOCX.

## Out of Scope

- Implementing an estimation algorithm.
- Selecting model providers or models.
- Defining the final evidence threshold or calibration metric.
- Building content, grading, analytics, or user-interface features.
- Making official score predictions or guaranteeing score improvement.

## Routes / Components / Systems Affected

- Canonical product vision.
- Product approval, decision, task, and activity records.
- Generated vision DOCX.

## Data / Security / Integration Impact

- Documentation and planning only.
- No student data, production systems, integrations, deployments, or model providers are affected.

## Acceptance Criteria

- [x] Vision permits estimated score ranges without presenting them as official or guaranteed outcomes.
- [x] Vision requires sufficient evidence, confidence language, assumptions, and coverage-gap disclosure.
- [x] Vision connects estimated scoring to concrete recommendations for reaching the next range.
- [x] Vision adds expert-scored calibration to the first-year evidence plan.
- [x] Approval and product decision are recorded.
- [x] Vision DOCX is regenerated and visually reviewed.
- [ ] David reviews the pull request and records the Done decision.

## QA Plan

- Manual QA: Review estimated-scoring language for clarity and consistency.
- Automated tests: Search for contradictory score-prediction language and validate the DOCX archive.
- Regression areas: Product claims, MVP exclusions, evidence plan, risk language, and open questions.
- Failure cases: Estimates appear official, guaranteed, falsely precise, or derived from one response.
- Security/data/integration checks: Confirm the change remains documentation-only.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate for product scope; Hard Gate for Done decision
**Decision:** Approved for documentation execution through APPROVAL-0002

## Implementation Notes

Revised the vision to distinguish response-level rubric scoring from evidence-based estimated AP score ranges. Added required confidence, calibration, and improvement-guidance principles.

## QA Review

Vision Markdown and DOCX were reviewed for consistency. The DOCX archive validated successfully, and all 13 rendered pages were visually inspected with no clipping, overlap, or pagination defects.

## Done Decision

**Decision:** Pending Product Owner review
**Date:** Pending
