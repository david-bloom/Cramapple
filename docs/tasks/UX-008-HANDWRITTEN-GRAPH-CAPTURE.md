# UX-008 - Handwritten Graph Capture

**Task ID:** UX-008
**Title:** Handwritten Graph Capture
**Owner:** Product Owner with Learning Quality Owner and Technical Owner
**Product Owner:** David Bloom
**Status:** Research
**Priority:** Medium
**Created Date:** 2026-06-15
**Approved Date:** 2026-06-15 for design documentation and Lovable brief

## Product Goal

Design the research-gated learner experience for paper graph response, QR or
fallback phone handoff, camera capture, image review, quality checks, retakes,
cross-device status, accessible alternatives, and human-review states.

## Technical Scope

- Define primary-device paper-response preparation.
- Define short-lived QR, fallback link, and manual handoff states.
- Define phone landing and camera-permission explanation.
- Define framing guidance and captured-image review.
- Define rotate, crop, reset, retake, remove, and no-crop alternatives.
- Define capture-quality results and safe abstention.
- Define explicit submission and cross-device status.
- Define accessible alternatives and error recovery.
- Define human-review states without implying production availability.
- Produce a Lovable-ready research render brief without a prototype.

## Out of Scope

- Working camera, QR, upload, storage, extraction, or grading prototype.
- Production visual model or provider selection.
- Learner-facing automated graph grades.
- General digital drawing tool.
- Diagrams, multi-page responses, or public sharing.
- Final privacy, retention, consent, metadata, or upload-security policy.

## Routes / Components / Systems Affected

- Graph question on primary learning device.
- QR and fallback handoff.
- Phone capture landing.
- Camera permission and framing.
- Image review and quality result.
- Submission status on both devices.
- Accessible alternative.
- Human-review status.

## Data / Security / Integration Impact

A future implementation would process learner handwriting and images,
short-lived pairing authorization, device metadata, immutable raw captures,
derived images, capture-quality results, and review outcomes. Upload validation,
malware controls, EXIF policy, signed access, retention, deletion, audit,
idempotency, and consent require approval before implementation.

## Acceptance Criteria

- [x] Primary-device and phone responsibilities are explicit.
- [x] QR, fallback link, expiration, and restart states are defined.
- [x] Camera permission is explained before the browser prompt.
- [x] Framing guidance covers all point-bearing graph evidence.
- [x] Raw capture and derived crop or rotation are distinguished.
- [x] Capture accepted is distinguished from graph correct.
- [x] Retake and cannot-determine states avoid unsupported grading.
- [x] Explicit submission and cross-device recovery are defined.
- [x] Non-QR, non-camera, non-drag, and equivalent-access alternatives are
  specified.
- [x] Human-review language depends on operational availability.
- [x] Lovable-ready research handoff is produced.
- [ ] `TASK-0011` research, security, privacy, accessibility, and evidence gates
  are completed.
- [ ] Product Owner approves a later working prototype, revises, or stops.

## QA Plan

- Document QA: Verify capture, quality, abstention, privacy, and graph-research
  boundaries against `TASK-0011` and its phase-1 specification.
- Lovable QA: Walk QR, permission, capture, crop, retake, quality, submit,
  expiry, fallback, accessibility, and review-status scenarios.
- Regression areas: Capture accepted shown as correct, automatic grading,
  hidden upload, raw-image overwrite, inaccessible crop, and token overreach.
- Failure cases: Expired token, denied camera, blur, glare, cutoff, network
  loss, duplicate submit, unsupported file, and no equivalent capture method.
- Safety checks: Confirm Lovable performs no file access or upload.

## Approval State

**Approval Required:** Yes
**Approval Type:** Research design approval; separate working-prototype and
production hard gates
**Decision:** Design documentation and Lovable brief approved; no prototype or
implementation approved

## Implementation Notes

Primary records:

- `docs/product/HANDWRITTEN_GRAPH_CAPTURE_EXPERIENCE_DESIGN.md`
- `prompts/LOVABLE_UX008_HANDWRITTEN_GRAPH_CAPTURE.md`
- `docs/tasks/TASK-0011-HANDWRITTEN-GRAPH-CAPTURE.md`

No prototype is authorized by this task.

## QA Review

Pending research, expert, and Product Owner review.

## Done Decision

**Decision:** Pending
**Date:** Pending

