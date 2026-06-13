# TASK-0011 — Handwritten Graph Capture

**Task ID:** TASK-0011
**Title:** Research QR-Linked Camera Capture for Handwritten Graph Review
**Owner:** Product / Technical Owner / Learning Quality Owner
**Product Owner:** David Bloom
**Status:** Research
**Priority:** Medium
**Created Date:** 2026-06-13
**Approved Date:** Pending

## Product Goal

Preserve authentic paper graph construction while allowing Cramapple to receive,
review, grade, and discuss a student's handwritten graph without building a
complex digital drawing tool.

## Proposed Flow

1. The question appears on the learner's primary device with printable or
   paper-first graph instructions.
2. Cramapple displays a short-lived, single-use QR code and fallback link bound
   to the learner, session, question version, and submission slot.
3. The learner opens the secure capture page on a phone.
4. The phone requests camera permission and prefers the rear camera.
5. Framing guidance helps capture the entire graph, axes, labels, units, scale,
   plotted data, legend, and title where applicable.
6. The learner reviews, crops, rotates, retakes, and explicitly submits.
7. Automated quality checks detect blur, glare, cutoff edges, perspective
   distortion, and unreadable resolution.
8. The original image and a normalized derivative are stored with immutable
   submission provenance.
9. Vision-assisted extraction proposes graph features and confidence.
10. The grading workflow applies criterion-level checks and escalates uncertain
    or incomplete cases to human review.

## Research Questions

- Is QR handoff materially easier than taking the photograph on the primary
  device?
- Can image-quality checks reliably prevent ungradeable submissions?
- Which graph criteria can be extracted deterministically or with acceptable
  vision-model reliability?
- What confidence threshold requires a retake or human review?
- How should multi-page or graph-plus-written-explanation submissions work?
- What accommodations are needed for learners who cannot handwrite, use a
  camera, or scan a QR code?
- What retention, deletion, consent, EXIF stripping, malware scanning, and
  personal-information controls apply?
- Does the capture flow improve authenticity enough to justify its operational
  and privacy cost?

## Constraints

- Use HTTPS and explicit camera permission.
- QR tokens contain no learner-readable personal information, expire quickly,
  are single-use, and cannot authorize access to other learner records.
- Validate file type, signature, size, dimensions, and decoding; store uploads
  outside public web paths with signed access.
- Preserve the original submission for audit; derived crops or enhancements
  never overwrite it.
- Do not treat low-confidence visual extraction as an authoritative grade.
- Keep uploaded learner work isolated from canonical content and model-training
  use unless separately consented and approved.
- Provide a non-QR fallback and an accessible alternative.

## Out of Scope

- Building a general digital drawing application.
- Automatic production grading before a held-out graph-image evaluation passes.
- Public sharing of handwritten work.

## Acceptance Criteria

- [ ] Low-fidelity QR and camera-capture prototype completed.
- [ ] Cross-device session binding and expiry tested.
- [ ] Image-quality and retake flow tested with representative phones.
- [ ] Graph feature extraction evaluated against human labels.
- [ ] Privacy, upload security, retention, and accessibility review completed.
- [ ] Tutor and student usability study completed.
- [ ] Product Owner decides whether to proceed, revise, or stop.

## Architecture Review

Claude's initial drawn-response proposal was reviewed on 2026-06-13. The review
retains paper-first QR capture and direct upload as promising prototype flows,
but rejects production vendor selection, single-pass learner-facing grading,
official-question reuse, self-reported confidence, generic mastery counters,
and unvalidated image annotations.

The proposed next research package narrows the first capability to AP Biology
quantitative graph construction and requires a capture prototype, adjudicated
gold set, offline architecture bake-off, calibrated abstention, and shadow
operation before any production recommendation.

Review and follow-up brief:

- `docs/research/DRAWN_RESPONSE_ARCHITECTURE_REVIEW.md`
- `prompts/CLAUDE_DRAWN_RESPONSE_EXECUTABLE_PLAN.md`

## Initial Expert Capture Pilot

David directed preparation for Orly Bloom to complete proposed handwritten
questions and submit phone photographs. Claude's historical-reference library
was reviewed as a useful taxonomy input but is not eligible as the formal pilot
or as a gold-set seed.

The initial expert batch must use three or fewer newly authored, rights-clean
quantitative graph prompts. Orly's responses are expert development cases for
prompt clarity, capture quality, and pipeline debugging. They are not
independent learner gold labels or evidence of grading accuracy.

Pilot protocol and Claude revision brief:

- `docs/research/ORLY_DRAWN_RESPONSE_PILOT_PROTOCOL.md`
- `prompts/CLAUDE_REVISE_DRAWN_RESPONSE_PILOT_SET.md`

## Approval State

**Approval Required:** Yes
**Approval Type:** Research prototype approval; separate production hard gate
**Decision:** Pending

## References

- [MDN: `getUserMedia()`](https://developer.mozilla.org/en-US/docs/Web/API/MediaDevices/getUserMedia)
- [W3C: HTML Media Capture](https://www.w3.org/TR/html-media-capture/)
- [OWASP: File Upload Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/File_Upload_Cheat_Sheet.html)

## Done Decision

**Decision:** Pending
**Date:** Pending
