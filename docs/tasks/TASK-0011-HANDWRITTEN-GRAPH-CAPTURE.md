# TASK-0011 — Handwritten Graph Capture

**Task ID:** TASK-0011
**Title:** Research QR-Linked Camera Capture for Handwritten Graph Review
**Owner:** Product / Technical Owner / Learning Quality Owner
**Phase D Execution Owner:** Claude (assigned 2026-07-27)
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

## Phase-1 Execution Specification

The initial phase-1 specification defines six newly authored graph items across
three bounded archetypes, criterion labels, the dual-human labeling protocol,
abstention rules, and the locked offline evaluation plan. The historical AP
Biology reference library is used only as taxonomy and failure-mode input; its
identifiable official-question material is excluded from prompts, exemplars,
model inputs, and evaluation cases.

- `docs/research/TASK-0011_PHASE_1_EXECUTION_SPEC.md`

## Phase-1 Labeling And Evaluation Tooling

Internal specification work permitted by the phase-1 spec's section 10
("item briefs, synthetic-data generators, rubric drafts, label schemas,
annotation instructions, and offline evaluation harness design"). No
participant labeling, item content, or real corpus data is included. Label
schemas, the annotation handbook, partition-manifest checks, and the
offline evaluation harness (sections 4-8 of the phase-1 spec) are built and
validated against synthetic fixtures only.

- `scripts/drawn_response/schemas/` — observation, criterion-decision,
  capture-image, capture-quality, partition-manifest, and method-run-log record
  schemas. The capture-image record closes the previous raw/derived-image
  provenance gap without selecting a production database or storage provider.
- `scripts/drawn_response/validate_records.py` — structural validation CLI
- `scripts/drawn_response/check_partition_manifest.py` — section 8.1
  partition-count and governance-coverage checks
- `scripts/drawn_response/evaluate_offline.py` /
  `scripts/drawn_response/report_offline_eval.py` — section 8.3-8.5 offline
  metrics, decision gates, and outcome classification
- `docs/research/DRAWN_RESPONSE_ANNOTATION_HANDBOOK.md` — versioned human-
  labeler procedure
- `docs/research/TASK-0011_OFFLINE_EVALUATION_HARNESS_DESIGN.md` — harness
  design doc, including every metric-definition choice the spec names but
  doesn't formula (flagged as harness convention pending Learning Quality
  confirmation)

Two experiment protocols build on this tooling, structured after
`docs/research/GRADER_SPEED_SUBTASK_PROTOCOL.md`:

- `docs/research/DRAWN_RESPONSE_RUBRIC_MATCH_PROTOCOL.md` (DR-1) —
  operationalizes the phase-1 spec's section 8 offline bake-off as a
  runnable experiment with corpus-state read tiers. Blocked on at least
  one item passing the section 3.2 authoring/preflight gate.
- `docs/research/DRAWN_RESPONSE_FEEDBACK_USEFULNESS_PROTOCOL.md` (DR-2) —
  a new tiered protocol testing whether criterion feedback is grounded,
  actionable, and produces independent transfer, since rubric-match
  accuracy alone does not establish useful feedback. Tier 1 (expert
  review) has no participant gate; Tier 2 (bounded pilot) needs Product
  Owner approval; Tier 3 (real-student shadow) needs Hard Gate approval
  and is designed but not authorized.

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

Claude returned the proposed three-prompt `v0.1-ai-draft` on 2026-06-13.
Preflight found that Prompt 2 and Prompt 3 were not reproducible from their
stated synthetic-data methods, the rights section cited a nonexistent
originality approval, and several uncertainty and graphical-estimate criteria
would confound the capture pilot.

The package is not ready for Orly. Required review and remediation:

- `docs/research/DRAWN_RESPONSE_PILOT_V0_REVIEW.md`
- `prompts/CLAUDE_REMEDIATE_DRAWN_RESPONSE_PILOT_V0.md`

## Progress Notes

### 2026-06-30 — Corpus realism fix (v0.2) and four-finding spot-check

Spot-checked the hand-drawn generation artifacts against four defect modes from
prior corpus/reference-image work: (a) pen-type legibility-vs-precision
tradeoff, (b) "carrying capacity" in student text, (c) synthetic data that is
not real noise, (d) paired good/bad reference images isolating one criterion
violation.

Results vs the 2026-06-29 v0.1 corpus: (b) clean; (a) only logged after the
fact, not controlled; (c) failing (no replicates, uniform x-grids, 5 recycled
shapes); (d) absent — no single-violation negatives exist in-repo.

Acted on (c): `scripts/generate_hand_drawn_graph_corpus.py` rewritten to a
seeded, reproducible v0.2 generator (replicate-derived SEM, off-model scatter,
non-uniform clean x-grids, round-ish displayed values, RNG-varied shapes). New
package: `docs/research/hand_drawn_graph_corpus_2026_06_30/` (prefix
`HDG-2026-P2-*`). v0.1 left untouched and still bound to the pages already drawn.
Verified bit-for-bit reproducible; audit metrics restored (uniform x-grids
4/100, fake SEM 0/100, distinct categorical shapes 50/50). See the 2026-06-30
activity-log entry for full detail.

Still open: pen-type control (a); single-violation negatives (d); v0.2
trace-set renders; adjudicated dual-human gold; external-provider data-transfer
approval. Each gates any learner-facing automated graph score.

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
