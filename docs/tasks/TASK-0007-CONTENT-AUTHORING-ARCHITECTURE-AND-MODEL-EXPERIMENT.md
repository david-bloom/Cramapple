# TASK-0007 — Content Authoring Architecture and Model Experiment

**Task ID:** TASK-0007
**Title:** Content Authoring Architecture and Model Experiment
**Owner:** Main Conductor / Learning Quality Owner
**Product Owner:** David Bloom
**Status:** In Progress
**Priority:** High
**Created Date:** 2026-06-13
**Approved Date:** 2026-06-13 for design direction; execution pending

## Product Goal

Define a rights-safe, versioned MCQ and FRQ authoring architecture and test
whether alternative AI-led authoring models can outperform the paid-tutor-first
baseline without reducing quality, originality, diversity, or accountability.

## Technical Scope

- Reject and exclude the prohibited official-derived candidate.
- Define failure-card handling for consequential rejected content.
- Define immutable prompt composition and multi-subject logical boundaries.
- Define complete MCQ and FRQ candidate-package contracts.
- Separate authored test cases from independent calibration evidence.
- Define a blinded, controlled comparison of three authoring models.
- Preserve the tutor-first production baseline during the experiment.

## Out of Scope

- Importing the stale ZIP patches.
- Retaining rejected candidate questions as anti-examples.
- Physical Supabase or Postgres DDL.
- Production approval of an AI-led authoring model.
- Use of official questions, scoring material, or secure content.
- Spending, contracting, or recruiting beyond separately approved authority.

## Routes / Components / Systems Affected

- Content authoring and provenance workflow.
- Prompt build and model configuration registry.
- Tutor authoring and independent validation.
- MCQ and FRQ package schemas.
- Failure-card and regression-test suites.
- Content coverage and production reporting.

## Data / Security / Integration Impact

The experiment requires arm blinding, immutable provenance, restricted holdout
access, model-input logging, source and rights preflight, and complete exclusion
of contaminated source material.

## Acceptance Criteria

- [x] Prohibited official-derived candidate rejected and excluded from the
  repository.
- [x] Anti-example retention policy defined as abstract failure cards.
- [x] Prompt build manifest and multi-subject logical model defined.
- [x] MCQ and FRQ complete-package contracts defined.
- [x] Authored examples separated from independent grading gold evidence.
- [x] Three-arm validation experiment defined with controls and decision rules.
- [x] Tutor-first production baseline preserved.
- [x] MCQ and FRQ authoring may proceed simultaneously through coordinated
  workstreams.
- [x] Reviewed FRQs remain unapproved candidates subject to edit or rejection.
- [ ] Learning Quality Owner reviews the architecture and experiment.
- [ ] Counsel reviews the experiment's source, rights, and author agreements.
- [ ] Experiment briefs, assignments, blinding, and data-capture plan are frozen.
- [ ] Product Owner approves experiment execution costs and participants.
- [ ] Pilot is run, analyzed, and adjudicated.
- [ ] Product Owner decides whether to stop, revise, replicate, or propose a
  production-policy change.

## QA Plan

- Manual QA: Cross-check against approved decisions, governance, content
  quantity, pedagogy, visual architecture, and current AP Biology structure.
- Automated tests: Search for prohibited artifact identifiers and derivative
  provenance; validate future structured packages against versioned schemas.
- Regression areas: Human abstraction firewall, author-validator separation,
  held-out-set independence, immutable approvals, and atomic release.
- Failure cases: Contaminated prompt input, arm disclosure, validator
  self-approval, hidden revision labor, generated samples treated as gold, and
  experimental content entering production.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate for experiment execution and any production change
**Decision:** Design and validation-only test direction approved; execution
budget and production use pending

## Implementation Notes

The reviewed ZIP patches are not applied because they target a stale branch and
conflict with current governance. Useful ideas were rewritten into:

- `docs/architecture/CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md`
- `docs/product/CONTENT_AUTHORING_MODEL_EXPERIMENT.md`

## QA Review

Initial architecture review completed on 2026-06-13.

## Done Decision

**Decision:** Pending
**Date:** Pending
