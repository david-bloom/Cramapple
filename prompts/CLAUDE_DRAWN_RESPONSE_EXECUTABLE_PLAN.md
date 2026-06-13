# Claude Brief - Develop An Executable Drawn-Response Plan

## Role

Act as a research and architecture agent for Cramapple. Develop the next
planning package for paper-first drawn-response capture and grading.

Read first:

- `docs/research/DRAWN_RESPONSE_ARCHITECTURE_REVIEW.md`
- `docs/tasks/TASK-0011-HANDWRITTEN-GRAPH-CAPTURE.md`
- `docs/tasks/TASK-0010-GRADER-CONFIDENCE-AND-CALIBRATION.md`
- `docs/architecture/VISUAL_STIMULUS_AND_RENDERING_SYSTEM.md`
- `docs/architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md`
- `docs/teaching/TEACHING_AND_PEDAGOGY_DESIGN.md`
- `docs/team_charter/STANDING_APPROVAL_LANES.md`

GitHub documents are the source of truth. Do not treat your prior
`drawn-response-architecture.md` as approved.

## Objective

Produce a decision-grade plan that can be converted into bounded research and
prototype tasks for AP Biology quantitative graph construction.

Do not implement, select a production vendor, create physical database DDL,
deploy, use learner data, or authorize learner-facing automated grading.

## Scope

Primary:

- Paper-first AP Biology quantitative graphs.
- QR phone capture and direct-upload fallback.
- Capture-quality validation.
- Offline graph observation and criterion-grading experiments.
- Empirical confidence, abstention, and human escalation.
- Criterion feedback, independent retry, and learning-evidence integration.

Separate or deferred:

- Economics multi-curve graphs.
- Physics diagrams and circuits.
- Biological free-form labeled diagrams.
- General handwriting and equation grading.
- Tablet drawing canvas.
- Production schemas and deployment.

## Rights Boundary

Do not ingest, reproduce, paraphrase closely, or use official College Board
questions, scoring guides, response samples, images, or distinctive scenarios
as prompts, exemplars, evaluation cases, or generated content.

Use:

- Cramapple source-of-truth documents;
- official public exam-format and skill statements only at a high level;
- independently authored synthetic graph tasks;
- rights-cleared technical documentation;
- primary research papers; and
- abstract criterion requirements supplied by qualified human reviewers.

Flag any research step that requires counsel or a human abstraction firewall.

## Required Deliverables

Return one coherent package with these sections.

### 1. Supported-Response Taxonomy

Define:

- the exact AP Biology graph archetypes proposed for the first experiment;
- included visual features and criteria;
- excluded or unsupported response forms;
- graph-plus-writing boundaries; and
- the later path to diagrams and other AP subjects.

Limit the first experiment to three or fewer archetypes.

### 2. Graph-Rubric Primitive Contract

Propose vendor-neutral logical objects for:

- expected graph specification;
- criterion definition;
- raw capture;
- derived image;
- capture-quality result;
- visual observation;
- evidence region;
- criterion decision;
- disagreement;
- calibrated confidence and abstention;
- human adjudication; and
- feedback and retry evidence.

Use conceptual schemas or typed pseudocode, not physical SQL.

### 3. State Machines

Define separate state machines for:

- pairing and upload;
- capture quality and retake;
- observation and reconciliation;
- grading and abstention;
- human review and regrading; and
- learner feedback, dispute, and independent retry.

Include expiry, replay, timeout, duplicate, cancellation, and recovery behavior.

### 4. Security, Privacy, And Accessibility Threat Model

Cover:

- token theft and replay;
- unauthorized channel subscription;
- malformed or oversized images;
- metadata and personal information;
- public-object exposure;
- provider retention or training use;
- minor consent and deletion;
- handwriting and incidental identifiers;
- device and browser compatibility;
- inability to use a phone, camera, handwriting, or QR code; and
- construct-preserving alternatives.

Separate facts, recommendations, counsel questions, and Product Owner
decisions.

### 5. Capture Prototype Protocol

Specify:

- QR and direct-upload prototype flows;
- supported browser/device matrix;
- image-quality conditions to test;
- raw versus normalized image variants;
- usability tasks;
- measurements;
- participant and consent requirements;
- pass, revise, and stop criteria; and
- evidence the prototype must save.

Treat the HTML `capture` attribute as progressive enhancement, not a universal
camera guarantee.

### 6. Gold-Set And Bake-Off Protocol

Design an offline experiment satisfying Cramapple governance:

- at least 300 eligible held-out responses overall;
- at least 40 per supported archetype;
- dual-blind human scoring and lead adjudication;
- development, calibration, holdout, and challenge partitions;
- partitioning by underlying response before capture variants;
- difficult, partial, contradictory, ambiguous, and ungradeable cases;
- capture-condition and handwriting diversity; and
- hidden sentinel cases.

Compare:

1. direct multimodal criterion grading;
2. multimodal observation then separate grading;
3. deterministic geometry/OCR then separate grading; and
4. hybrid observation reconciliation.

Do not name a winner before results.

### 7. Metrics And Decision Rules

Use the thresholds in
`CONTENT_GOVERNANCE_AND_VALIDATION.md`. Add:

- capture-quality sensitivity and specificity;
- feature-observation precision and recall;
- exact criterion-vector agreement;
- coverage versus error after abstention;
- robustness by capture condition;
- localization error for proposed annotations;
- latency percentiles;
- cost per accepted result;
- cost per human-reviewed result;
- reviewer minutes per response; and
- independent retry improvement.

Explain how confidence will be calibrated from observed error. Do not use a
model's self-reported confidence as the release control.

### 8. Architecture Alternatives And Recommendation

Compare at least three logical architectures:

- model-forward;
- deterministic-extraction-forward; and
- hybrid.

For each, state:

- strengths;
- known failure modes;
- observability;
- vendor lock-in;
- privacy implications;
- cost drivers;
- human-review burden; and
- criteria or archetypes it may support.

Recommend the experiment sequence, not a production vendor.

### 9. Teaching And Learning Integration

Map the result into Cramapple's approved learning model:

- assessable target and representation facet;
- capture failure versus knowledge/representation failure;
- minimum repair;
- fresh independent retry;
- transfer task;
- delayed confirmation;
- learner override, Move On, and Park; and
- no mastery claim from one corrected response.

### 10. Executable Backlog

Propose bounded follow-on tasks with:

- task title and purpose;
- owner roles;
- inputs and dependencies;
- approved versus hard-gated work;
- acceptance criteria;
- QA evidence;
- risks;
- estimated external costs as ranges with assumptions; and
- explicit completion artifact.

At minimum separate:

- rights and expert criterion abstraction;
- capture prototype;
- graph corpus and gold-set creation;
- offline model/algorithm bake-off;
- accessibility study;
- shadow grader;
- owner decision packet; and
- production implementation, if later approved.

## Research Standards

- Use current primary sources.
- Cite factual claims next to the claim.
- Label inference and recommendation explicitly.
- Replace unsupported percentages, cost-per-image claims, and build-time claims
  with a measurement plan.
- Treat provider names and prices as dated candidates, not architecture.
- Record unresolved questions and the role authorized to answer each one.

## Required Final Recommendation Shape

End with:

1. Recommended immediate research scope.
2. Work that can proceed under standing approval.
3. Work requiring Product Owner approval.
4. Work requiring Learning Quality review.
5. Work requiring counsel or accessibility review.
6. Proposed stop conditions.
7. Exact next task to approve.

Do not call the plan executable unless every dependency, owner, artifact,
acceptance criterion, evaluation gate, and approval boundary is explicit.
