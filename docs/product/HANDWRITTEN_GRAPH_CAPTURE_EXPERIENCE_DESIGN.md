# Handwritten Graph Capture Experience Design

**Status:** Research-gated proposal for Product Owner, Learning Quality,
accessibility, security, privacy, and technical review
**Related Tasks:** `UX-008`, `TASK-0011`
**Owner:** Product Owner with Learning Quality Owner and Technical Owner
**Last Updated:** 2026-06-15

## 1. Purpose

This document defines the proposed learner experience for completing a graph on
paper, handing capture to a phone by QR code or fallback link, checking image
quality, retaking or submitting, following cross-device status, using an
accessible alternative, and understanding how failed captures are saved for
study without human scoring in the learner flow.

This is a research UX. It does not approve production upload, storage, visual
extraction, automated graph grading, or learner-facing graph scores.

## 2. Research Boundary

UX-008 may be rendered with simulated fixtures to evaluate comprehension and
interaction design. Before any working capture prototype or production use:

- `TASK-0011` research gates remain controlling;
- upload security, privacy, retention, consent, and accessibility require
  review;
- graph-quality and feature-extraction performance require held-out evidence;
- automated output remains hidden during shadow operation;
- unsupported or unreadable captures may be retained for research study, but
  the learner flow does not offer human scoring.

The design must distinguish capture acceptance from graph correctness.

## 3. Experience Principles

1. Keep graph construction authentic and paper-first.
2. Make cross-device handoff optional, short-lived, and understandable.
3. Explain camera permission before requesting it.
4. Help the learner capture all point-bearing evidence.
5. Preserve the raw image and distinguish derived previews.
6. Detect capture defects before grading whenever feasible.
7. Say `Retake` only when recapture can plausibly fix the problem.
8. Separate capture quality, feature observation, and scoring.
9. Provide a non-QR and non-camera path.
10. Never present low-confidence visual interpretation as an authoritative
    grade.

## 4. End-to-End Flow

```text
Primary-device graph question
  -> Choose paper response
  -> Show QR code and fallback options
  -> Pair phone with one submission slot
  -> Explain and request camera permission
  -> Capture graph
  -> Review, rotate, crop, retake, or use photo
  -> Run simulated capture-quality check
       -> Retake recommended
       -> Accepted for review
       -> Cannot determine; save for study
  -> Explicitly submit
  -> Sync status to primary device
  -> Continue, wait, or leave safely
```

## 5. Primary-Device Preparation

Before handoff, show:

- question and approved paper instructions;
- what must appear in the image;
- one graph on one page for the research scope;
- `Use my phone`;
- `Upload from this device`;
- `I cannot use a camera or QR code`;
- `Move on`.

The checklist is item-specific and may include:

- entire graph;
- x- and y-axes;
- labels and units;
- scale and tick marks;
- all plotted data;
- error bars;
- line, curve, or bars;
- legend or title only when required;
- graph-derived annotation.

Do not reveal hidden scoring criteria beyond what the student prompt already
requires.

## 6. QR and Fallback Handoff

The QR state shows:

- short explanation;
- countdown or expiration time without exposing token value;
- submission-slot label;
- `Open on this device` fallback link;
- short manual code when approved;
- refresh action after expiration;
- cancel pairing;
- paired-device status.

The token contains no learner-readable personal information, is single-use,
short-lived, and cannot authorize access to other records.

Expiration does not erase the paper response or primary-device attempt.

## 7. Phone Landing and Permission

The phone confirms:

- Cramapple;
- AP Biology graph submission;
- bounded question or slot reference;
- paired status;
- privacy guidance;
- camera purpose;
- alternatives.

Before the browser permission prompt:

> Cramapple needs camera access to photograph this graph. You can review or
> retake the image before submitting.

Actions:

- `Continue to camera`
- `Choose an existing photo`
- `Use another method`
- `Cancel`

If permission is denied, explain how to retry without trapping the learner.

## 8. Capture Guidance

Camera guidance should be brief and visual:

- place the paper on a flat, contrasting surface;
- use even light and avoid shadows or glare;
- include all page edges or the complete graph region;
- hold the phone parallel to the page;
- keep axes, labels, units, and annotations readable;
- use the rear camera where available.

Use an overlay frame only as guidance. It must not imply that content outside
the overlay is automatically discarded.

Allow:

- take photo;
- flash guidance where supported;
- cancel;
- choose existing photo;
- accessibility alternative.

Do not rely on the HTML `capture` attribute as the only camera path.

## 9. Review and Edit

After capture, show the full image and controls:

- zoom;
- rotate in 90-degree steps;
- crop with reset;
- retake;
- remove;
- use this photo.

The raw capture remains immutable. Rotation and crop create a derived preview
and never overwrite the original.

Crop guidance warns against removing:

- axis labels;
- units;
- error bars;
- plotted points;
- annotations;
- title or legend when required.

Provide non-drag crop controls or a no-crop submission path.

## 10. Capture-Quality Results

Quality checks consider:

- cutoff point-bearing evidence;
- blur;
- glare;
- severe shadow;
- resolution;
- rotation;
- perspective distortion;
- unreadable labels or marks;
- unsupported multi-page response.

Result states:

### 10.1 Looks Ready

> The graph is clear enough to send for review.

This means capture quality is acceptable. It does not mean the graph is
correct.

### 10.2 Retake Recommended

Name the fixable issue and show it without claiming to identify every defect.

Examples:

- `The x-axis label is cut off.`
- `Some plotted points are blurry.`
- `Glare covers the upper-right part of the graph.`

Actions:

- `Retake`
- `Review image`
- `Use another method`

Continuing despite a retake warning is a research-policy decision and should
not be included unless approved.

### 10.3 Cannot Determine

Use when the system cannot safely decide image quality:

> We cannot confirm that every required part is readable. This capture needs
> another submission method or may be saved for study.

Do not grade automatically.

## 11. Explicit Submission

Before upload simulation, show:

- selected image;
- crop and rotation status;
- item and submission slot;
- privacy reminder;
- statement that the image is learner work and contains no unnecessary
  personal information;
- `Submit graph`;
- `Go back`.

Submission is explicit. Taking a picture does not transmit it.

Production upload would require file-signature validation, malware controls,
EXIF handling, size and dimension limits, signed storage, retention, deletion,
and audit. The Lovable brief simulates this state only.

## 12. Cross-Device Status

Primary device states:

```text
waiting_for_phone
phone_connected
photo_captured
quality_checking
retake_needed
submitted
capture_accepted
saved_for_study
needs_another_method
expired
cancelled
failed
```

The primary device may poll or receive updates in production, but the design
does not prescribe transport.

Let the learner:

- continue waiting;
- refresh status;
- restart handoff;
- upload on the primary device;
- leave safely and return;
- move on when pedagogically allowed.

Do not require both devices to remain open after submission.

## 13. Study-Only Failure States

The capture may be retained for study because:

- quality cannot be determined;
- representation is unsupported;
- feature extraction abstains;
- automated passes disagree;
- the learner disputes the result.

Learner-facing language:

- `Saved for study`
- `Needs another method`
- `More information needed`
- `Try again`

Do not offer human scoring in the learner flow. Research fixtures may label
study-only states as simulated.

## 14. Accessible Alternatives

Provide:

- direct file upload from the primary device;
- manual link or code instead of QR;
- keyboard-operable photo review;
- non-drag rotation and crop;
- ability to submit without crop;
- accessible digital table or coordinate-entry alternative when it preserves
  the assessed construct;
- supported accommodation path where camera use is impossible.

An alternative must not silently reduce the assessed operation. If equivalent
access is unavailable, disclose the limitation and route to approved support.

## 15. Errors and Recovery

Handle:

- QR expired;
- wrong or already-used token;
- network loss before or during submission;
- camera unavailable;
- permission denied;
- unsupported file;
- image too large or unreadable;
- phone closed after capture;
- primary device closed;
- duplicate submit;
- session conflict.

Preserve recoverable work. Duplicate submission does not create multiple
attempts. Error copy names what is saved and what action is safe.

## 16. Privacy and Trust

- Prompt learners to remove names, faces, school information, and unrelated
  surroundings.
- Do not claim perfect personal-information detection.
- Strip or govern metadata according to approved policy.
- Keep learner uploads isolated from canonical content and model training unless
  separately approved.
- Show retention and deletion language only after counsel approval.
- Do not use graph images for public sharing.

## 17. Lovable Scope

The Lovable render should demonstrate, with no actual upload:

- primary-device paper instructions;
- QR and fallback handoff;
- paired and expired states;
- phone permission explanation;
- camera framing screen;
- captured-image review, rotate, crop, and retake;
- clear, retake, and cannot-determine quality results;
- explicit simulated submission;
- cross-device status;
- accessible alternatives;
- human-review-required and review-complete states;
- recovery from permission, network, and session failures.

The render must say `Research UX` and `No file is uploaded`.

## 18. Research Questions

- Do learners understand why a second device is useful?
- Is QR faster or more reliable than direct primary-device upload?
- Which guidance reduces cutoff without increasing burden?
- Are quality-result messages accurate and actionable?
- How many retakes are tolerable in a cram session?
- Which accessible alternatives preserve the graphing construct?
- Do learners distinguish capture accepted from graph correct?
- What state and time language is truthful during shadow study?
