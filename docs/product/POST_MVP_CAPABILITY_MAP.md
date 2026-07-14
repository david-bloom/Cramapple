# Cramapple Post-MVP Capability Map

**Status:** Draft synthesis
**Purpose:** Define the major capability groups that come after the AP Biology MVP
**Primary sources:** `docs/product/CRAMAPPLE_VISION.md`, `docs/MASTER_TODO.md`, `docs/tasks/`, and subject launch briefs
**Last updated:** 2026-07-08

## 1. Why This Document Exists

The MVP is intentionally narrow: AP Biology, guided study, question practice,
criterion-level grading, student-provided question intake, and a private
activity record.

This document captures the next layer of product capability that is already
implied by the vision and backlog, but explicitly deferred from MVP. It is not
a launch commitment or an approval record. It is a synthesis of the likely
post-MVP product surface so product, curriculum, and engineering can discuss
the next phase with shared language.

## 2. Core Post-MVP Principles

1. Reuse one shared engine across subjects instead of building separate apps.
2. Add subject-specific capability only when a subject proves the need.
3. Keep every new surface governed by the same rights, validation, and review
   standards as the MVP.
4. Preserve student privacy and agency as the product grows.
5. Prefer staged expansion over broad feature sprawl.

## 3. Post-MVP Capability Groups

### 3.1 Multi-Subject Expansion

The clearest post-MVP step is expansion from one subject to a small cluster of
natural sciences and adjacent AP exams.

Current direction in the source docs points to:

- AP Statistics
- AP Chemistry
- AP Physics 1, AP Physics 2, AP Physics C: Mechanics, and AP Physics C:
  Electricity and Magnetism
- later natural-science or adjacent AP subjects once the shared engine proves
  reusable

What this adds:

- new `subject` rows and `exam_pack` versions;
- new subject taxonomies and content labels;
- subject-driven prompt composition;
- subject-specific verification profiles;
- subject-specific calibration and pilot batches;
- subject-aware routing in the frontend.

Why it belongs post-MVP:

- the vision already says Biology should not be burdened with abstractions for
  every future science;
- the backlog treats subject expansion as a gated sequence, not a single
  launch;
- Statistics, Chemistry, and Physics each need distinct verification logic.

### 3.2 Subject-Specific Verification

Different subjects will need different proof mechanisms beyond the Biology
baseline.

Examples already identified in the docs:

- AP Statistics: deterministic calculation checks and numeric criterion
  verification
- AP Chemistry: stoichiometry, notation, equation balancing, and
  unit-aware checks
- AP Physics: symbolic math, vectors, dimensions, and diagram-heavy
  reasoning

This capability group likely becomes a reusable verification framework that can
support multiple kinds of student evidence:

- typed numeric answers
- symbolic work
- notation-sensitive responses
- graph and table interpretation
- diagram-heavy responses
- mixed-representation responses

### 3.3 Content Operations at Scale

Once more than one subject exists, content creation and revision stop being a
single-subject workflow and become an operating system.

Likely post-MVP features include:

- authoring workbench for complete question packages;
- reviewer portal for independent tutor/AP Reader judgment;
- revision workflow for recycled or disputed content;
- immutable version history and provenance capture;
- rights and source tracking for authored and imported materials;
- calibration batches and gold-set maintenance;
- content retirement, replacement, and rollback.

This is the layer that turns content into a governed supply chain rather than a
collection of static question files.

### 3.4 Learning Experience Growth

The student experience already contains the seeds of several later capabilities.

Likely post-MVP additions:

- richer progress and recommendation history;
- clearer evidence timelines for skills and criteria;
- review queues for due, deferred, and recurring gaps;
- estimated-score ranges when validation supports them;
- learner overrides with outcome tracking;
- regrade and dispute handling;
- broader help modes for student-provided questions.

These features should deepen trust without turning the product into a generic
dashboard.

### 3.5 Student-Provided Question Intake

The BYOQ flow is already designed as a distinct pathway and is a strong
post-MVP capability because it extends Cramapple beyond authored content.

Later-stage additions may include:

- photo, screenshot, and document intake once upload policy is approved;
- better extraction and match confirmation;
- richer handling for missing diagrams, passages, or choices;
- subject expansion beyond the current enrolled subject;
- tighter rubric calibration before a question can be scored authoritatively.

This capability is valuable because it makes Cramapple useful for work that
originates outside the canonical library while keeping that material isolated
from the approved content system.

### 3.6 Parent and Secondary Buyer Surface

The vision and backlog treat parent access as a future paid entitlement, not an
MVP feature.

If developed, the likely post-MVP surface is a motivational progress tool, not
a surveillance product. The approved direction in the source docs suggests it
may eventually include:

- activity summary;
- topics covered;
- performance trends;
- recommended next actions;
- purchase and entitlement handling;
- consent, age-gating, notification, and privacy controls.

This capability is intentionally separated from the student experience because
it changes privacy, trust, and legal posture.

### 3.7 Pricing, Bundles, and Lifecycle

The business model is currently a one-time service hypothesis, but the docs
leave room for later testing around:

- subject bundles;
- access duration;
- refunds and discounts;
- parent add-ons;
- positioning and tagline tests;
- lifecycle and launch-announcement workflows;
- student and parent acquisition instrumentation.

This is a later commercial layer, not part of the initial classroom utility.

### 3.8 Platform Reliability and Economics

As usage grows, the shared engine needs more operational rigor.

Likely post-MVP capabilities:

- deterministic fallback recommendations;
- model routing and provider change control;
- cost limits and budget enforcement;
- latency targets for grading and recommendation generation;
- retries, dead-letter handling, and recovery behavior;
- preview, validation, and production separation;
- better observability and audit trails.

This work matters because the product promise depends on fast, dependable,
trustworthy feedback.

## 4. Suggested Expansion Order

The source docs imply a staged order rather than a single big release:

1. Expand to AP Statistics and AP Chemistry as the closest natural-science
   follow-ons.
2. Add AP Physics as the first representation-heavy subject family.
3. Generalize subject-specific verification and content tooling into reusable
   platform capabilities.
4. Introduce parent and lifecycle surfaces only after privacy and consent
   decisions are resolved.
5. Expand into adjacent subjects or bundles only after the subject engine and
   content governance are working well.

This is an inference from the current planning documents, not a finalized
commitment.

## 5. What Should Stay Out Of Scope For Now

- a full teacher-management product;
- a classroom LMS replacement;
- a broad social or community layer;
- unsupported official score guarantees;
- surveillance-style parent monitoring;
- subject expansion without subject-specific verification and calibration.

## 6. Open Decisions

These decisions are still unresolved in the source docs and should be settled
before any post-MVP build is treated as committed:

- which subject follows Biology first, if the current sequencing changes;
- what evidence threshold is required before showing estimated score ranges;
- how far parent access should go;
- whether bundles should be sold and when;
- what refund and access-duration policy should be used;
- how much subject-specific verification must be in platform code versus
  subject configuration;
- what launch gates are required before a subject is considered production
  ready.

## 7. Source Anchors

- `docs/product/CRAMAPPLE_VISION.md`
- `docs/MASTER_TODO.md`
- `docs/tasks/TASK-0013-AP-STATISTICS-LAUNCH.md`
- `docs/tasks/TASK-0014-AP-CHEMISTRY-LAUNCH.md`
- `docs/tasks/TASK-0015-AP-PHYSICS-LAUNCH.md`
- `docs/product/CONTENT_QUANTITY_AND_DISTRIBUTION.md`
- `docs/product/STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md`
- `docs/product/PROGRESS_REVIEW_RECOMMENDATIONS_DESIGN.md`
- `docs/product/QUESTION_AND_ANSWER_REVIEW_PORTAL_DESIGN.md`
- `docs/product/CONTENT_AUTHORING_AND_REVISION_WORKBENCH_DESIGN.md`
