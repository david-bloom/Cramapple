# Image Authoring and Hand-Drawn Capture Prototype QA

**Status:** Local synthetic-data research render; no Production or participant-data authorization
**Date:** 2026-08-03
**Authoring render:** `prototypes/ux-003/index.html`
**Learner render:** `prototypes/ux-008/index.html`

## Outcome

Cramapple now has an executable local UX slice for both sides of the image
workflow:

1. An author can acknowledge an image-based FRQ task, inspect one exact image
   candidate in learner context, see its checksum/content-version binding,
   record purpose/provenance/rights/accessibility state, remove it, restore it,
   and inspect submission blockers.
2. A learner can read a synthetic image-based graph question, select a
   paper-response path, simulate a bounded phone handoff, review a synthetic
   raw capture and derived crop/rotation preview, receive capture-quality
   states, explicitly confirm submission, and see capture acceptance kept
   separate from correctness.

The render is frontend-only. It does not generate a token, request camera
permission, read a file, upload an image, persist learner data, contact a
grader, or promise a human-review service.

## Authoring behavior

The UX-003 workbench now exposes a `Visual stimulus` package section for the
S009 v3 candidate. It records and presents:

- the exact asset SHA-256 and published content-version ID as machine-readable
  image attributes;
- actual PNG dimensions and a repository-resolving candidate path;
- question-stimulus role, model-analysis purpose, prompt dependency, source,
  rights state, answer-leakage state, and author note;
- short alt text, long-description content, symbol notes, reading order, and
  the still-open construct-equivalence/assistive-technology gates;
- the immutable rejected-v2 history and current candidate-v3 boundary; and
- candidate-submission language that explicitly does not approve or publish.

Removing the required visual now fails closed. The visual becomes a semantic
`role=alert` blocker, the exact source evidence remains preserved, the check
list changes to `Required visual is missing`, and `Review and submit` cannot
open the submission modal. Restoring the candidate re-enables candidate
submission while preserving all open human review gates.

## Learner capture behavior

UX-008 implements these simulated states:

- paper instructions;
- QR-ready, paired, expired, refreshed, and cancelled handoff;
- pre-permission purpose and privacy explanation;
- camera framing guidance;
- synthetic photo review;
- derived rotate/crop/reset preview with an immutable-raw reminder;
- `Looks ready`, fixable `Retake recommended`, and `Cannot determine` quality
  results;
- explicit submission confirmation;
- submitted/capture-accepted status; and
- direct-device, manual-code, no-crop, keyboard-control, and
  construct-preserving accessible alternatives.

The fixable cutoff state offers no confirm or submit route. `Looks ready` says
that image quality—not graph correctness—was checked. `Cannot determine`
withholds an automated score and identifies the human-review state as a
simulation.

Visible append-only events use only the canonical event enum in
`capture_session_event.schema.json`, including:

```text
SESSION_CREATED
PAIRING_ACCEPTED
RECOVERY_ISSUED
CAPTURE_RECORDED
REVIEW_OPENED
QUALITY_RECORDED
RETAKE_REQUESTED
CAPTURE_REMOVED
SUBMISSION_ACCEPTED
SESSION_CANCELLED
```

Scenario switching, crop/rotation preview, permission explanation, and
confirmation-checkbox changes are labeled preview-only UI actions and do not
pretend to append logical session events.

## Automated evidence

`scripts/test_image_workflow_prototypes.py` contains ten stdlib tests covering:

1. candidate PNG existence, dimensions, exact SHA-256, and content-version ID;
2. non-empty alt text and missing-image `role=alert` behavior;
3. purpose, provenance, rights, and answer-leakage fields;
4. absence of file-input, network, camera, or browser-storage APIs;
5. the persistent research/no-upload boundary;
6. required capture/recovery states and scenario controls;
7. disabled-until-confirmed explicit submission;
8. quality/correctness separation and fixable-retake blocking;
9. conformance of visible events to the capture-session schema enum; and
10. unique DOM IDs, native buttons, and accessible alternatives.

JavaScript syntax checks also pass for both standalone HTML prototypes.

## Browser evidence

The two pages were served locally and exercised in the Codex in-app browser.

Authoring checks:

- the image-based task opened directly into the visual-stimulus section;
- the exact candidate loaded with its accessible name and metadata;
- removing it produced `Blocking · image missing` and a semantic alert;
- the top submission action left the modal closed and announced `Restore or
  replace the required visual before submission`;
- restoring the image reopened the modal with the review-candidate boundary;
- no console errors or warnings were recorded.

Learner checks:

- the interactive path reached `SUBMISSION_ACCEPTED` only after pairing,
  capture, review, quality, and explicit checkbox confirmation;
- `Submit graph` had a disabled attribute before confirmation and none after;
- a 90-degree derived rotation and cropped preview retained the statement that
  the raw synthetic capture was unchanged;
- the fixable-cutoff scenario exposed only retake, review, or another method;
- no console errors or warnings were recorded.

Responsive checks used an effective 389 CSS-pixel viewport:

- UX-008 document and body scroll widths both measured 389 px;
- the active phone screen measured 332 px and no visible control crossed the
  viewport;
- UX-003 document and body scroll widths both measured 389 px;
- authoring controls outside the viewport were confined to the deliberately
  keyboard-scrollable task queue and package-tab strips; there was no
  page-level horizontal overflow.

These are technical browser checks, not independent assistive-technology or
content approval.

## Run locally

From the repository root:

```bash
python3 -m http.server 8765 --bind 127.0.0.1
```

Then open:

```text
http://127.0.0.1:8765/prototypes/ux-003/
http://127.0.0.1:8765/prototypes/ux-008/
```

Run the static contract suite with:

```bash
python3 scripts/test_image_workflow_prototypes.py
```

## Remaining gates

This checkpoint does not authorize the staff-only working capture prototype or
Production use. Those still require explicit Product Owner authorization plus
security, privacy, retention/deletion, consent, rights, accessibility,
malware/file-signature, Storage-policy, model-provider, held-out quality, and
human-review operations approval. The S009 Production object replacement also
retains its independent review, exact backup, rollback, delivery, and QA gates.
