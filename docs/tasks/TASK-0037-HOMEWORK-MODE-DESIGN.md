# TASK-0037 — Homework Mode Design

**Task ID:** TASK-0037
**Title:** Homework Mode — intake, guardrails, and mission-alignment design
**Owner:** Claude (design), Product Owner (decisions)
**Product Owner:** David Bloom
**Tier:** Hard-Gate
**Status:** In Progress (design phase; nothing built)
**Priority:** High
**Created Date:** 2026-08-28
**Approved Date:** Pending

## Product Goal

Design a student-facing capability where a student brings an outside question
(free text, a photographed question, or an uploaded worksheet) and asks
Cramapple for help, and Cramapple teaches the underlying skill without doing
the problem for them — consistent with Cramapple's mission (help students earn
the most points from the time they have) and with the existing no-general-LLM-
generation law (INV-3 / CM-D14, extended to this feature as CM-D20).

## Technical Scope

- Define the intake sequencing across three entry points (free-text + bounded
  interview; photo of a specific question; uploaded worksheet) and the shared
  pipeline they converge on (classify → coverage-check → teach on a parallel
  vetted item → cold prove-it → gated Check My Work).
- Define the two-gate content model: classification (broad, low-risk) versus
  vetted-content coverage (narrow, the real constraint) — and the honest
  degrade when coverage is missing.
- Define anti-gaming guardrails at both surfaces where a student could bypass
  the "teach, don't answer" rule: the intake/classification step (verbatim
  paste + closed-form confirmation) and the Check-My-Work unlock gate (correct-
  not-just-attempted; guard against blind-guessing; self-explanation as a
  candidate requirement).
- Formalize the mission-alignment principle governing all response content
  (CM-D20 in `COURSE_MODE_LEARNING_MODEL.md`) and thread its consequences
  through every component (explainer content, practice-item generation,
  Check-My-Work feedback, interview language).
- Reuse existing machinery wherever the design already exists rather than
  re-specifying it: UX-004's intake/help-mode design, the Course Mode
  learn-first entry (§11.2 of the UX integration spec), the homework-image
  classification experiment, and the `LEARNING_SYSTEM_STUCK.md` evidence/
  escalation model.

## Out of Scope (this task; deferred to follow-on work)

- Any implementation — backend edge functions, database schema, or frontend
  UI. This task is design-only.
- Photo-of-a-question and worksheet-upload detailed design (sequenced after
  text-interview; photo has a design basis in §11.3 of the UX integration spec
  and the feasibility experiment, worksheet decomposition has none yet).
- The adversarial red-team guardrail evaluation itself (named as a required
  gate before build, not run here).
- Final resolution of the OPEN items recorded in the design doc (two-tier
  coverage degrade using existing topic explainers; exact Check-My-Work unlock
  thresholds; conversational academic-integrity mechanism).
- Any change to Course Mode's existing content, generator, or serving
  pipeline. Homework Mode is designed to be a new serving surface over that
  same pipeline, not a fork of it.

## Routes / Components / Systems Affected (future implementation, not this task)

- A new intake surface (front-end, `exam-buddy-wireframe`, outside this repo's
  session scope).
- A new interview-turn / classification edge function and a coverage lookup
  against `taxonomy_cells` / `content_item_cells`.
- The existing learn-first `/session` entry (§11.2), reused unmodified as the
  teaching surface.
- A new `entry_path` value for session-event analytics (e.g.
  `homework_interview`).

## Data / Security / Integration Impact

- None yet (design only). Flagged for the implementation task: a pasted
  homework question is student-submitted external content and should follow
  the same personal-information-warning and non-retention posture already
  specified for photo intake in §11.3 (read, classify, discard — do not
  persist the verbatim text beyond the session unless a retention need is
  separately approved).
- Academic-integrity handling (active quiz/test vs. homework) carries forward
  from UX-004 §8 as a conservative default, pending the OPEN conversational-
  mechanism decision.

## Acceptance Criteria

- [x] Three intake modes are identified and sequenced with a stated rationale.
- [x] The unified classify → coverage → teach → prove-it pipeline is specified
      and grounded in already-built Course Mode machinery.
- [x] The mission-alignment principle is stated precisely and codified as a
      decision (CM-D20) in `COURSE_MODE_LEARNING_MODEL.md`, not left only in
      chat.
- [x] Anti-gaming guardrails are specified for both the intake/classification
      surface and the Check-My-Work unlock surface, each tied to a concrete
      mechanism (verbatim paste + closed-form confirm; correct-not-attempted +
      provisional/confirmed threshold).
- [x] The evidence base for "teach, don't answer" is captured with real
      citations, not asserted from memory.
- [ ] The OPEN items (two-tier coverage degrade; Check-My-Work unlock
      thresholds; conversational academic-integrity mechanism) are resolved by
      the Product Owner.
- [ ] A backend contract at the detail level of
      `COURSE_MODE_SESSION_ASSEMBLY_AND_ENTRY_FLOW_SPEC.md` is written.
- [ ] The adversarial red-team guardrail pass is scheduled as a named
      pre-launch gate.
- [ ] Product Owner approves, revises, or rejects the design before any
      implementation task is opened against it.

## QA Plan

Not applicable at this stage (design-only, Hard-Gate tier awaits a build task).
Once implementation begins, the adversarial red-team pass (§6 of the design
doc) is the primary QA requirement and should be treated as a hard gate
equivalent to D8/CM-D19 for content.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate (academic-integrity and answer-leakage risk;
follows this repo's standing practice for guardrail-bearing student-facing
features).
**Decision:** Pending — design captured, OPEN items and full sign-off still
needed before an implementation task can open.

## Implementation Notes

Primary record: `docs/teaching/HOMEWORK_MODE_DESIGN_2026_08_28.md` (the full
design discussion, decisions, and OPEN items). Companion decision:
`COURSE_MODE_LEARNING_MODEL.md` §7 (CM-D20). Prior art superseded/extended:
`docs/product/STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md` (UX-004),
`docs/teaching/COURSE_MODE_STUDENT_UX_INTEGRATION_SPEC.md` §11.2–§11.3,
`docs/research/HOMEWORK_IMAGE_CLASSIFICATION_EXPERIMENT_2026_08_25.md`.

## QA Review

Not applicable (design-only task; no code to review).

## Done Decision

**Decision:** Pending
**Date:** Pending
