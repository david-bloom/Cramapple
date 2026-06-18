# TASK-0006 — Visual Stimulus and Rendering System

**Task ID:** TASK-0006
**Title:** Visual Stimulus and Rendering System
**Owner:** Main Conductor / Technical Owner
**Product Owner:** David Bloom
**Status:** Ready for Owner Review
**Priority:** High
**Created Date:** 2026-06-12
**Approved Date:** Pending

## Product Goal

Define how Cramapple authors, renders, validates, delivers, and revalidates
tables, charts, graphs, diagrams, models, experimental setups, and
learner-created graphs without compromising scientific meaning, accessibility,
rights, or the assessed skill.

## Technical Scope

- Assess the proposed structured-data, prose-fallback, and image-generation
  approaches.
- Define a logical visual-artifact and dataset contract.
- Define deterministic-rendering and governed-diagram lanes.
- Define accessibility-equivalence and answer-leakage rules.
- Define source, rights, validation, change, and revalidation requirements.
- Separate displayed stimuli from learner-created graphing.
- Define V1 prototype scope and renderer-selection criteria.

## Out of Scope

- Physical Supabase or Postgres schema.
- Production renderer selection or implementation.
- Free-form generative scientific images in production.
- Final legal conclusion about ADA applicability.
- Final graphing-workspace UX.
- Applying official question text or protected visual assets.

## Routes / Components / Systems Affected

- Content authoring and validator workbench.
- Canonical content and asset repository.
- Question delivery and accessibility surfaces.
- Student graphing workspace.
- Teaching and grading validation.
- Release, revalidation, and rollback services.

## Data / Security / Integration Impact

Visual specifications, datasets, accessible representations, renderer profiles,
and derived outputs require immutable identities, provenance, rights, checksums,
dependency edges, safe parsing, payload limits, and version-specific approval.
Untrusted HTML, scripts, arbitrary URLs, and free-form SVG are prohibited.

## Acceptance Criteria

- [x] Initial A/B/C proposal assessed for strengths and weaknesses.
- [x] Recommended four-lane model documented.
- [x] Construct-preservation and answer-leakage rules defined.
- [x] Logical artifact contracts proposed without physical DDL.
- [x] Source, rights, validation, and revalidation rules proposed.
- [x] Visual reviewer qualifications and counts proposed.
- [x] Learner-created graphing separated from displayed stimuli.
- [x] Paper-first, camera-capture graphing direction recorded as `TASK-0011`.
- [x] Interim logical stimulus-package contract defined without physical DDL.
- [x] V1 prototype scope and renderer-selection process proposed.
- [ ] Product Owner decides the five open direction questions.
- [ ] Learning Quality Owner reviews construct equivalence and V1 scope.
- [ ] Accessibility specialist reviews the proposed equivalence policy.
- [ ] Counsel confirms applicable legal accessibility requirements.
- [ ] Representation audit of the 964-item content plan is complete.

## QA Plan

- Manual QA: Cross-check against governance, teaching, content quantity, and
  logical architecture documents.
- Automated tests: `git diff --check`; Markdown link and structure checks when
  tooling exists.
- Regression areas: Cold-mode answer leakage, representation evidence,
  immutable artifacts, rights, physical-schema deferral, and independent gates.
- Failure cases: Missing visual, inaccessible task, misleading scale, invalid
  data, renderer mismatch, silent prose fallback, and untrusted SVG.
- Security/data/integration checks: Safe structured parsing and renderer
  isolation remain implementation requirements.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate
**Decision:** Pending

## Implementation Notes

The architecture is proposed in
`docs/architecture/VISUAL_STIMULUS_AND_RENDERING_SYSTEM.md`. It does not approve
a renderer, implementation, or physical database schema.

## QA Review

Initial architecture consistency review completed on 2026-06-12.

## Done Decision

**Decision:** Pending
**Date:** Pending
