# TASK-0004 - Component Architecture and Teaching Design

**Task ID:** TASK-0004
**Title:** Component Architecture and Teaching Design
**Owner:** Main Conductor
**Product Owner:** David Bloom
**Status:** Ready for Owner Review
**Priority:** High
**Created Date:** 2026-06-10
**Approved Date:** 2026-06-10

## Product Goal

Refine the high-level architecture into explicit system-context and logical-component boundaries, and define a research-informed teaching system optimized for the ten-day AP Biology preparation window.

## Technical Scope

- Define actors, external systems, trust zones, logical components, ownership, information flows, and managed-service placement.
- Establish a versioned Exam Specification Registry for official College Board facts.
- Separate official facts from Cramapple-derived planning values.
- Define the pedagogical contract, ten-day learning model, diagnostics, intervention patterns, review scheduling, interleaving, metacognitive calibration, and progress evidence.
- Define weakness, improvability, and exam value as separate recommendation inputs.
- Record the current AP Biology section, point, unit, practice, and FRQ distributions.
- Define teaching validation and evaluation requirements.
- Define a unified ordinary-learning and stuck-escalation state model.
- Define evidence-weighted escalation, discriminating probes, Move On, Park, and schedule-aware return.
- Define anonymous student-response use for Cramapple improvement separately from public publication.
- Create canonical Markdown and DOCX documents.

## Out of Scope

- Implementing services, schemas, prompts, or interfaces.
- Final grading and calibration design.
- Final score-prediction model.
- Legal determination of material-use rights.
- Final tutor-approved pedagogy.

## Acceptance Criteria

- [x] System context and trust boundaries are documented.
- [x] Logical components and ownership are documented.
- [x] Official exam facts have a versioned source-of-truth component.
- [x] Official and derived values are clearly distinguished.
- [x] Teaching and grading responsibilities remain separate.
- [x] Ten-day pedagogy and learning loop are defined.
- [x] Diagnostic sequence and failure taxonomy are defined.
- [x] Weakness and improvability are treated separately.
- [x] Next-best-action factors and explanation requirements are defined.
- [x] AP Biology section and point distributions are documented.
- [x] FRQ criterion and task-specific pedagogy is defined.
- [x] Validator review and release gates are defined.
- [x] Unified learning and stuck-state escalation are defined.
- [x] Sideways, Apart, and Down routing uses direct evidence where feasible.
- [x] Immediate transfer and delayed confirmation are separate outcomes.
- [x] Schedule-aware Park and Move On are defined.
- [x] Anonymous improvement use and publication gates are separated.
- [x] Canonical DOCX files are generated and visually reviewed.
- [ ] David reviews the pull request and records the Done decision.
- [ ] AP Biology tutors review the pedagogy before implementation or launch.

## QA Plan

- Verify AP Biology facts against current College Board primary sources.
- Confirm unit ranges are labeled as MCQ-section weights.
- Confirm derived point values are labeled as Cramapple planning approximations.
- Review architecture consistency with the approved high-level design.
- Render and visually inspect every DOCX page.
- Validate DOCX archives and Git whitespace.

## Approval State

**Approval Required:** Yes
**Approval Type:** Product-scope Hard Gate; Done Hard Gate
**Decision:** Approved for documentation execution through APPROVAL-0004

## QA Review

- Verified the AP Biology exam format, raw-point structure, unit ranges, science-practice ranges, FRQ structure, and public-material availability against current College Board primary sources.
- Confirmed that unit ranges are labeled as multiple-choice-section weights and that Cramapple-derived point values are labeled as planning approximations.
- Reviewed the system-context and logical-component design against the approved high-level architecture.
- Rendered and visually inspected all pages of the five current architecture and teaching DOCX files: 23 high-level architecture pages, 21 system-context pages, 26 teaching-design pages, 30 learning-system pages, and 11 stuck-protocol pages.
- Corrected ordered-list continuation, table-row pagination, and large-diagram page flow in the shared document renderer.
- Validated all DOCX archives, Python renderer syntax, and Git whitespace.

**QA Result:** Passed for Product Owner review.

## Done Decision

**Decision:** Pending Product Owner review
**Date:** Pending
