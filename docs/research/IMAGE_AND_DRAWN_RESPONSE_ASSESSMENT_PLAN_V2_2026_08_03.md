# Image Questions and Drawn Responses — Assessment Plan V2

**Status:** Draft for independent review
**Date:** 2026-08-03
**Product Owner:** David Bloom
**Purpose:** Read-only assessment plan; not implementation approval

## 1. Objective

Answer three practical questions for the next launch-critical course or exam:

1. How many current questions require a visual as part of the question?
2. Can Cramapple reliably create, approve, and display those visuals to students?
3. What is the actual readiness of student-drawn response capture, grading, repair feedback, storage, and later review?

The assessment should support a near-term product decision. It should not attempt to redesign every visual capability before that decision can be made.

## 2. Simplicity rules

Apply Occam's razor throughout:

- Start with the smallest launch-critical content slice.
- Inspect published and potentially servable content before drafts or future inventory.
- Prefer direct evidence over proposed architecture.
- Add a control, schema, service, or workflow only when a demonstrated requirement justifies it.
- Do not build a universal image artifact model in advance.
- Do not assume QR is necessary when capture on the current device may work.
- Do not assume automated grading is necessary for useful paper capture.
- Do not use a large aggregate sample to conceal weak coverage of important cases.
- Stop once the evidence is sufficient for the pending decision.

## 3. Three separate programs

Assess these as separate programs. They may later share narrow infrastructure, but they do not share one approval or readiness verdict.

### Program A — Question visual delivery

Cramapple-authored, generated-from-structured-data, or licensed visuals displayed as part of a question.

Primary concerns:

- content correctness;
- rights and provenance;
- accessibility and construct preservation;
- release approval;
- exact-version delivery;
- responsive rendering;
- missing-visual behavior.

### Program B — Student response-image capture

Learner-created photographs or uploads bound to an attempt and response.

Primary concerns:

- identity and cross-device authorization;
- upload safety;
- response binding and provenance;
- privacy, consent, retention, and deletion;
- capture quality;
- later student and reviewer access.

### Program C — Image-based grading and repair

Image perception, criterion judgment, abstention, human escalation, and feedback.

Primary concerns:

- held-out evaluation evidence;
- severe grading errors;
- supported and unsupported response types;
- calibrated abstention;
- human review;
- grounded repair feedback;
- independent transfer.

Shared infrastructure should be limited initially to requirements that are clearly common, such as private storage, immutable identifiers, checksums, short-lived access, and audit records. Even these should not force the programs into one record type or lifecycle.

## 4. Required framing decisions

Before the assessment begins, record answers to three questions:

1. What is the first launch-critical content slice?
   - AP Biology, AP Statistics, another course, or a specifically named subset.
2. What is the first desired drawn-response outcome?
   - capture only;
   - capture with human/manual review;
   - automated grading in hidden shadow mode;
   - learner-facing automated repair.
3. What should happen when an essential question visual cannot load?
   - remove the item before selection;
   - skip and replace it during a session;
   - offer an already approved equivalent;
   - retry delivery;
   - another explicitly approved behavior.

A warning without the visual is not an acceptable default when the visual is required to answer. A prose or table alternate is not assumed equivalent when it changes the assessed construct.

If these decisions are not yet available, the assessment may collect the inventory needed to make them, but it should not design implementation around an assumed answer.

## 5. Evidence labels

Every finding must use one of these labels:

- **Live verified** — confirmed read-only in the current Production system.
- **Deployed verified** — exercised in the relevant deployed environment.
- **Repository only** — present in committed code but not confirmed deployed.
- **Prototype/research only** — useful evidence but not a production capability.
- **Proposed** — design or protocol not yet approved or exercised.
- **Not verified** — evidence was unavailable or contradictory.

These labels prevent a prototype, schema field, storage bucket, or successful synthetic experiment from being reported as an end-to-end capability.

## 6. Step 1 — Launch-critical visual inventory

### Scope

Start with current published and potentially servable questions in the chosen launch slice. Expand to pipeline content only if the launch decision requires it.

### Method

1. Produce a read-only inventory containing only the fields needed to identify visual dependence and delivery readiness.
2. Mechanically flag candidates using:
   - stored visual paths or structured visual specifications;
   - stems or stimuli that reference a figure, image, chart, graph, diagram, display, table, or earlier context;
   - existing missing-visual flags;
   - known learner-drawn-response markers.
3. Manually classify only the candidates, not every question.
4. Independently review ambiguous cases and a small sample of apparently clear cases.

### Classification

Assign one primary class:

1. **Requires displayed visual perception** — the learner must inspect a displayed image, diagram, chart, or visual model.
2. **Requires structured data rendering** — the required table or chart can be rendered from governed structured data rather than stored as a raster image.
3. **Requires student construction** — the question does not require an image to be shown, but the answer must be drawn.
4. **References missing prior context** — the missing dependency may be an earlier subpart, shared passage, stimulus package, or external figure.
5. **Decorative or incidental media** — failure should not prevent answering.
6. **Accessible alternate may change construct** — an alternate exists, but equivalence cannot be assumed.
7. **Ambiguous** — evidence is insufficient for a reliable classification.

### Required output

Report three headline counts:

1. Questions requiring an essential displayed visual.
2. Essential displayed visuals that are missing, broken, or delivery-unverified.
3. Questions requiring a learner-drawn response.

Supporting tables should show course, item type, publication/serving state, classification, and the reason for any readiness failure. Do not lead with a count of non-null image paths.

## 7. Step 2 — Question visual delivery readiness

Assess Program A only for essential visuals in the launch-critical slice.

For each candidate, verify the shortest evidence chain that can establish readiness:

1. The required asset or structured specification exists.
2. It belongs to the exact approved question version.
3. Source, rights, and authoring status are recorded sufficiently for the intended use.
4. Subject/scientific and grading review cover the visual's effect on the question and answer.
5. Accessibility review addresses alt text, long description, structured data, or a separately approved alternate.
6. Answer-leakage and construct-equivalence risks are resolved.
7. The student delivery path can retrieve the exact visual without exposing private paths or reviewer-only content.
8. The visual renders legibly at the supported desktop and mobile sizes and required zoom/reflow conditions.
9. The approved failure behavior occurs when delivery fails.

Do not require every future visual-governance feature to answer launch readiness. Record broader architecture gaps separately from immediate blockers.

### Failure policy

Define the product behavior by visual class before implementation:

| Visual class | Simplest safe failure behavior |
| --- | --- |
| Essential visual perception | Do not serve, or replace with an independently approved equivalent item |
| Structured data rendering | Retry; use an approved semantic representation only if it preserves the task |
| Incidental media | Continue without media only if prior review confirms no effect on meaning or difficulty |
| Accessible alternate changes construct | Deliver as separately identified evidence; do not silently treat it as equivalent |
| Missing prior context | Remove from serving until the package relationship is repaired |

The Product Owner and Learning Quality owner must approve any behavior that changes which question or representation the learner receives.

## 8. Step 3 — Student response-image capture readiness

Assess Program B independently from grading.

### Baseline and comparator

Use the simplest baseline:

1. **Baseline:** capture or upload on the device currently answering the question.
2. **Comparator:** QR/fallback handoff to a phone when a second device materially improves completion or image quality.

QR should be adopted only if measured benefits justify token lifecycle, cross-device synchronization, recovery states, and support burden.

### Capability matrix

Classify each capability as designed only, repository only, deployed, exercised, independently QA'd, or not found:

- question and paper instructions;
- current-device camera/gallery upload;
- QR and fallback handoff;
- short-lived, single-use, purpose-bound authorization;
- exact learner, attempt, question version, and response binding;
- camera permission and accessible alternative;
- framing, review, rotate, retake, and explicit submit;
- file signature, decode, size, dimension, and metadata handling;
- blur, glare, cutoff, perspective, and resolution checks;
- immutable original and traceable derived versions;
- retry, idempotency, expiry, and cross-device recovery;
- later authorized student/reviewer retrieval;
- retention, deletion, dispute, and regrade behavior.

Use consented test artifacts only. Real learner or minor data remains separately gated.

### Separate state dimensions

Capture acceptance and grading eligibility must never be one status.

Minimum conceptual states:

```text
capture_state = accepted | retake_required | indeterminate
grading_state = automated_eligible | human_review_only | unsupported | pending
```

Examples:

- A clean image may be accepted but unsupported for automated grading.
- A visually imperfect image may still be usable for human review.
- “Image received” must not imply “answer graded” or “answer correct.”

This is a requirements distinction, not approval of a physical schema.

### Minimal attachment requirements

Only if learner-drawn items are in the launch slice, draft a requirements-level attachment contract covering:

- exact attempt and response-version binding;
- immutable original evidence;
- derivative lineage;
- capture state;
- grading state;
- authorized retrieval;
- audit and idempotency;
- unresolved retention/deletion policy references.

Do not implement or choose a permanent artifact model during this assessment.

## 9. Step 4 — Grading and repair readiness

Assess Program C only for the first explicitly supported response type. Do not generalize from graphs to diagrams, equations, or all handwriting.

### Separate evaluations

Evaluate independently:

1. capture-quality classification;
2. visual observation or extraction;
3. rubric criterion judgment;
4. confidence and abstention;
5. human escalation;
6. repair-feedback quality;
7. independent learner transfer.

A pass in one layer does not imply a pass in the next.

### Corpus adequacy

Treat the existing 300-response DR-1 target as a proposed starting point, not proof of sufficiency.

Before using aggregate results, verify meaningful coverage of:

- each supported graph archetype and criterion;
- multiple independently authored items and datasets;
- full-credit, partial-credit, ambiguous, contradictory, and severe-error cases;
- handwriting and mark variation;
- device, lighting, framing, perspective, blur, glare, and occlusion conditions;
- unsupported and out-of-distribution examples.

Keep all photographs of the same underlying response in one partition. Choose the smallest sample that supports the required per-archetype and per-criterion claims; expand it when confidence intervals, rare failures, or uncovered conditions require more evidence.

### Release claims

- Manual grading mechanics do not establish automated accuracy.
- Synthetic images do not establish performance on real handwriting.
- Expert drawings do not establish performance on typical student errors.
- No automated-grading claim should be made below a locked held-out evaluation with zero severe errors and acceptable per-criterion performance.
- Learner-facing automated output should remain blocked until shadow operation and required human review pass.

### Repair parity

Compare image-based repair with written-answer repair using evidence, not presentation quality:

- references the learner's actual response evidence;
- identifies the correct minimum fix;
- does not leak unrelated criteria;
- distinguishes capture defects from content defects;
- is understood by the learner;
- improves performance on a fresh, structurally equivalent task.

Human/manual review may be a valid first product mode if its privacy, turnaround, cost, and operational expectations are acceptable. Automated grading is not a prerequisite for assessing that option.

## 10. Step 5 — Decision outputs

Produce three separate verdicts:

### A. Question visual delivery

- Ready for the launch slice.
- Ready after named blocker remediation.
- Not ready; affected items must not be served.

### B. Student response-image capture

- No current product need in the launch slice.
- Prototype current-device capture only.
- Prototype current-device capture plus QR comparator.
- Not ready for a working prototype because privacy/security/product decisions are missing.

### C. Image grading and repair

- Manual review only.
- Automated shadow research only.
- Bounded learner-facing capability for named criteria and archetypes.
- Not ready; continue or stop research.

Each verdict must state its evidence class, unsupported cases, owner decisions, and stop conditions. One program's readiness must not promote another.

## 11. Independent review

Before any implementation task is approved, use a fresh reviewer to challenge:

- launch-slice selection;
- inventory completeness and misclassification;
- live/deployed/repository/prototype conflation;
- missing-context cases incorrectly treated as image-authoring needs;
- silent construct changes through alternates;
- unsafe or confusing failure behavior;
- QR complexity without measured benefit;
- capture acceptance conflated with grading eligibility;
- corpus leakage, inadequate stratification, and aggregate-metric masking;
- unsupported grading or feedback claims;
- privacy, consent, retention, accessibility, human-review load, and operational cost.

## 12. Quarantine of prior implementation work

The existing `codex/image-workflows-readiness` code and prototype work must remain quarantined:

- do not merge, deploy, or treat it as baseline architecture;
- preserve it as a design sketch;
- mine it for tests, edge cases, and API ergonomics only after requirements are approved;
- compare any later approved design against it in a fresh review;
- decide separately whether to revise, split, preserve, or discard it.

Existing code does not create a reason to adopt its architecture.

## 13. Explicitly out of scope

This assessment does not authorize:

- database migrations;
- endpoint or frontend implementation;
- production deployment or configuration;
- real learner/minor uploads;
- retention or consent policy decisions;
- vendor/model selection;
- a universal image artifact model;
- automated learner-facing grading;
- task closure or launch approval.

## 14. Questions for the next reviewer

1. Is the launch-critical slice the right organizing principle, or could it hide a cross-course systemic blocker?
2. Are the three programs sufficiently independent, and which infrastructure truly needs to be shared?
3. Is the inventory taxonomy mutually exclusive and complete enough for reliable counts?
4. Are the proposed failure behaviors safe, simple, and educationally honest?
5. Does current-device capture provide the right baseline against which to test QR?
6. Are the capture and grading state dimensions sufficient without prematurely specifying a schema?
7. How should corpus size and stratification be determined for the first supported response type?
8. What evidence should be required before manual-review-first paper capture is offered?
9. Which part of this plan remains unnecessarily complex?
10. What is the smallest assessment that would still support a responsible next decision?
