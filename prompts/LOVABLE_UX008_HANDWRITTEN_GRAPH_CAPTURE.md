# Lovable Build Brief - UX-008 Handwritten Graph Capture

Build a polished, responsive, frontend-only research render for Cramapple's
paper-first handwritten graph capture experience.

Do not access a camera, generate a QR token, read or upload files, store images,
run image analysis, connect a grader, or claim human-review availability. Use
simulated original fixtures only.

Display a persistent label:

```text
Research UX · No file is uploaded
```

## Product Boundary

- The learner constructs the graph on paper.
- UX-008 captures and routes the image.
- Capture quality is not graph correctness.
- Automated feature extraction and grading remain research-gated.
- Human review is shown only as a simulated state.
- `TASK-0011` controls any later prototype or production gate.

## Visual Direction

- Clear, reassuring, and task-focused.
- Primary device feels like the Cramapple study interface.
- Phone view feels lightweight and trustworthy.
- Warm neutral background, deep green actions, white image-review cards.
- Use amber for fixable quality warnings and red only for blockers.
- Avoid novelty-camera styling, social-photo metaphors, or grading celebration.

## Suggested Routes

```text
/prototype/graph-response
/prototype/graph-response/handoff
/prototype/capture/:slotId
/prototype/capture/:slotId/review
/prototype/graph-response/status
/prototype/graph-response/accessible-alternative
```

## Scenario Controls

Allow switching among:

- Paper instructions
- QR ready
- Phone connected
- QR expired
- Permission explanation
- Camera framing
- Photo review
- Looks ready
- Retake: cutoff
- Retake: blur
- Retake: glare
- Cannot determine
- Submitted
- Human review required
- Review complete
- Accessible alternative
- Network failure

## Primary-Device Graph Screen

Show:

- original placeholder quantitative graph question;
- paper-first instructions;
- item-specific visible checklist;
- Use my phone;
- Upload from this device;
- I cannot use a camera or QR code;
- Move on.

Checklist may include full graph, axes, labels, units, scale, plotted values,
error bars, and required estimate annotation. Do not reveal hidden rubric
criteria.

## QR Handoff

Create a fake QR block with:

- short explanation;
- expiration countdown;
- submission-slot label;
- fallback link;
- optional manual code;
- Refresh code;
- Cancel;
- waiting and phone-connected status.

Do not encode or display personal information. Explain that the real token
would be single-use and short-lived.

Expired state preserves the learner's primary-device attempt and offers a new
code or another method.

## Phone Landing

Confirm:

- Cramapple;
- AP Biology graph submission;
- bounded slot reference;
- paired status;
- privacy guidance;
- camera purpose.

Before simulated permission:

> Cramapple needs camera access to photograph this graph. You can review or
> retake the image before submitting.

Actions:

- Continue to camera
- Choose an existing photo
- Use another method
- Cancel

Create permission-denied recovery.

## Camera Framing

Simulate a camera viewport with:

- paper outline guide;
- hints for flat surface, even light, no glare, parallel phone, full graph;
- reminders to include axes, labels, units, plotted data, and annotations;
- Take photo;
- Choose photo;
- Cancel.

Do not imply that the overlay automatically crops or validates the graph.

## Photo Review

Use an original fake graph image placeholder.

Controls:

- Zoom
- Rotate left
- Rotate right
- Crop
- Reset crop
- Retake
- Remove
- Use this photo

Provide keyboard and button alternatives to drag cropping. Explain that the raw
capture remains unchanged and crop or rotation creates a preview.

Warn before cropping point-bearing evidence.

## Quality Results

### Looks Ready

> The graph is clear enough to send for review.

Add:

> This checks image quality, not whether the graph is correct.

### Retake Recommended

Create separate states:

- x-axis label cut off;
- plotted points blurry;
- glare covers required marks.

Actions:

- Retake
- Review image
- Use another method

Do not include `Continue anyway`.

### Cannot Determine

> We cannot confirm that every required part is readable. This capture needs
> simulated human review or another submission method.

Do not show an automated score.

## Explicit Submission

Before simulated submission show:

- chosen image preview;
- rotation and crop summary;
- item and slot;
- privacy reminder;
- confirmation that unnecessary personal information is absent;
- Submit graph;
- Go back.

Taking the picture must not equal submission.

## Cross-Device Status

Primary-device states:

- Waiting for phone
- Phone connected
- Photo captured
- Checking image quality
- Retake needed
- Submitted
- Capture accepted
- Simulated human review required
- Review pending
- Review complete
- Expired
- Cancelled
- Failed

Actions:

- Refresh status
- Restart handoff
- Upload on this device
- Leave and return
- Move on

Do not require both devices to stay open.

## Accessible Alternative

Show:

- direct file selection on the primary device;
- manual link or code;
- no-crop submission;
- keyboard image controls;
- accessible coordinate or table entry only when it preserves the construct;
- request approved accommodation or review.

Explain when an equivalent method is not yet supported. Do not silently replace
graph construction with an easier task.

## Error Recovery

Create:

- expired or already-used code;
- camera unavailable;
- permission denied;
- unsupported file;
- image too large;
- network loss before submission;
- duplicate submit;
- session conflict.

Every error says what is saved and which next action is safe.

## Required Scenarios

- QR and fallback handoff.
- Expired pairing.
- Permission explanation and denial recovery.
- Camera framing.
- Image review and non-drag crop controls.
- Looks ready.
- Cutoff, blur, and glare retakes.
- Cannot determine and simulated review.
- Explicit submission.
- Cross-device completion.
- Accessible alternative.
- Network and duplicate-submit recovery.

## Accessibility, Privacy, and Safety

- Full keyboard operation and visible focus.
- No drag-only crop.
- No color-only quality result.
- Reflow at 390 CSS pixels.
- Explain camera permission before requesting it.
- No real QR, camera, file, upload, metadata, learner data, or grading.
- No public sharing.
- Do not claim perfect personal-information detection.
- Label every review, quality check, and submission as simulated research UX.

