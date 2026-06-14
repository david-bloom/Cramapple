# Cramapple Master Backlog

**Status:** Active backlog index
**Owner:** Main Conductor
**Product Owner:** David Bloom
**Last Updated:** 2026-06-13

## 1. Purpose

This is the canonical index of Cramapple's open work. It consolidates active
tasks, required follow-on designs, launch gates, research questions, deferred
features, and unresolved product decisions.

This backlog does not approve execution. Approved decisions, approval records,
and task files retain the authority order defined in `docs/README.md`.

When a backlog item moves into execution:

1. create or update its `TASK-XXXX` file;
2. define scope, owner, acceptance criteria, QA, and exclusions;
3. obtain the required approval;
4. link the task from this backlog;
5. update both records when status changes.

## 2. Status and Priority

### Status

| Status | Meaning |
| --- | --- |
| Ready for Owner Review | Work is prepared and awaits Product Owner action |
| Expert Review Required | A qualified functional or legal reviewer must act |
| Proposed | Identified work without approved execution scope |
| Research | Evidence is required before a product rule can be adopted |
| Deferred | Intentionally outside the current release horizon |
| Done | Acceptance and required Done decisions are recorded |

### Priority

| Priority | Meaning |
| --- | --- |
| P0 | Required to protect users, rights, data, or release integrity |
| P1 | Required before AP Biology production launch |
| P2 | Important for beta quality, operating readiness, or commercial readiness |
| P3 | Later optimization or expansion |

## 3. Immediate Action Queue

These are the next actions already supported by existing source-of-truth
records.

| ID | Priority | Action | Owner | Status | Required outcome |
| --- | --- | --- | --- | --- | --- |
| NOW-001 | P1 | Review and close the project operating-system task | David Bloom | Done | Completed through `APPROVAL-0007` |
| NOW-002 | P1 | Review and close the high-level architecture task | David Bloom | Done | Completed through `APPROVAL-0008` |
| NOW-003 | P1 | Review the component architecture and teaching design | David Bloom | Done | Current documentation approved through `APPROVAL-0009`; tutor gate remains |
| NOW-004 | P1 | Perform AP Biology tutor review of the pedagogy | Orly Bloom / qualified AP Biology tutors | Expert Review Required | Record findings, required remediation, and launch recommendation for `TASK-0004` |
| NOW-005 | P0 | Review the proposed content-governance educational gates | Orly Bloom / Learning Quality Owner | In Progress | Review paid-author qualifications and workflow, validator qualifications, reviewer counts, and teaching/grading thresholds |
| NOW-006 | P0 | Review content-governance rights and retention boundaries | Counsel | Expert Review Required | Approve or revise rights, official-material, retention, and public-use controls |
| NOW-007 | P1 | Decide the content-governance policy | David Bloom | Ready for Owner Review | Approve, request changes, or reject `TASK-0005` after expert and counsel review |
| NOW-008 | P1 | Decide the visual-stimulus architecture direction | David Bloom | Ready for Owner Review | Decide the four-lane model, fail-closed rule, V1 visual types, synthetic-data rule, and graphing device floor in `TASK-0006` |
| NOW-009 | P1 | Review the authoring architecture and experiment protocol | Orly Bloom / Learning Quality Owner | Expert Review Required | Review failure cards, prompt composition, complete-package contracts, experiment arms, metrics, and decision thresholds in `TASK-0007` |
| NOW-010 | P0 | Review authoring experiment rights and contracts | Counsel | Expert Review Required | Confirm source isolation, contamination handling, releases, model-input rights, and retention rules before experiment execution |
| NOW-011 | P1 | Commission the proprietary replacement exemplar | Orly Bloom / Paid Tutor Author | Proposed | Execute `TASK-0008` from a blank brief after author and rights gates |
| NOW-012 | P1 | Reconcile conceptual schemas with governance | Technical Owner / Main Conductor | Proposed | Complete `TASK-0009` before any physical database design |
| NOW-013 | P0 | Establish grader confidence and calibration | Learning Quality Owner / Grading Lead | Proposed | Complete `TASK-0010` before learner-facing automated FRQ scores |
| NOW-014 | P2 | Prototype handwritten graph camera capture | Product / Technical Owner | Research | Test the QR-linked paper-first flow in `TASK-0011` |

## 4. Active Task Register

| Task | Title | Priority | Current status | Remaining gate |
| --- | --- | --- | --- | --- |
| `TASK-0001` | Initialize Project Operating System and Canonical Vision | High | Done | None |
| `TASK-0003` | High-Level System Architecture | High | Done | None |
| `TASK-0004` | Component Architecture and Teaching Design | High | In Progress | AP Biology tutor review |
| `TASK-0005` | Content Governance and Validation Operating Procedure | High | In Progress | Learning Quality Owner, counsel, and Product Owner decisions |
| `TASK-0006` | Visual Stimulus and Rendering System | High | Ready for Owner Review | Product Owner direction, expert reviews, and representation audit |
| `TASK-0007` | Content Authoring Architecture and Model Experiment | High | In Progress | Learning Quality, counsel, execution-budget, and pilot gates |
| `TASK-0008` | Proprietary Exemplar Replacement | High | Proposed | Author commission and full validation |
| `TASK-0009` | Schema and Governance Reconciliation | High | Proposed | Conceptual-model approval |
| `TASK-0010` | Grader Confidence and Calibration | Critical | Proposed | Learning Quality and Product Owner release gates |
| `TASK-0011` | Handwritten Graph Capture | Medium | Research | Prototype and feasibility decision |
| `UX-001` | Initial Product UX Decisions | High | In Progress | Learning, Marketing, accessibility, and Product Owner review |

## 5. P0 Legal, Privacy, and Trust Backlog

### GOV-001 - Official Materials and Rights Policy

**Status:** Proposed
**Owner:** Counsel with Source Steward and Learning Quality Owner
**Approval:** Product Owner hard gate

- [ ] Define permitted storage, transformation, model-input, learner-display,
  and public-display uses for official AP and College Board materials.
- [ ] Define written-permission and license requirements.
- [ ] Define student-upload copyright and reuse rules.
- [ ] Define trademark and attribution rules.
- [ ] Define takedown, dispute, and rights-expiration procedures.
- [ ] Convert the approved policy into operational rights-review guidance.
- [x] Exclude official historical questions and scoring materials from
  question-generation seeds, adaptation targets, and generative-model inputs.
- [ ] Define the narrow conditions under which authorized humans may review
  public official materials for abstract alignment.

### GOV-002 - Minor Privacy, Consent, and Data Rights

**Status:** Proposed
**Owner:** Counsel with Product Owner
**Approval:** Product Owner hard gate

- [ ] Define age gating, minor notice, consent, and parental-consent rules.
- [ ] Define purchaser and future parent-access rights.
- [ ] Define learner access, correction, export, deletion, and revocation.
- [ ] Define retention for responses, uploads, account records, validation
  examples, and audit evidence.
- [ ] Define handling of names, handwriting, faces, school information, and
  other personal information in uploads.
- [ ] Define anonymous or deidentified improvement-dataset requirements.
- [ ] Produce the privacy policy and required in-product notices.

### GOV-003 - Provider and Academic-Integrity Policy

**Status:** Proposed
**Owner:** Product Owner with counsel and technical owner
**Approval:** Product Owner hard gate

- [ ] Set acceptable model-provider retention, training, regional-processing,
  and minor-data terms.
- [ ] Define academic-integrity boundaries for teach, hint, check, and solve
  modes.
- [ ] Define when paste and typing signals may qualify evidence.
- [ ] Prohibit unsupported AI-detection claims.
- [ ] Decide whether a third-party detector, an internal signal, or no detector
  is appropriate after accuracy, privacy, and cost review.

## 6. P1 Required Designs Before Implementation

### DESIGN-001 - Grading and Calibration System

**Status:** Proposed
**Owner:** Learning Quality Owner with grading lead and technical owner
**Depends on:** `TASK-0004`, `TASK-0005`
**Execution record:** `TASK-0010`

- [ ] Define rubric-package contracts and criterion independence.
- [ ] Define deterministic and model-supported grading orchestration.
- [ ] Define confidence, abstention, escalation, and disputed-grade handling.
- [ ] Define human gold-set creation and held-out evaluation.
- [ ] Confirm launch metric thresholds through expert review and pilot evidence.
- [ ] Decide dual-pass policy for long and short FRQs.
- [ ] Define estimated-score boundaries and prohibit unsupported score claims.
- [ ] Define regrading and correction behavior.

### DESIGN-002 - Shared Data and Event Contracts

**Status:** Proposed
**Owner:** Technical owner
**Depends on:** Approved architecture and governance policy
**Reconciliation record:** `TASK-0009`

- [ ] Create the conceptual and physical data model.
- [ ] Define immutable version, provenance, dependency, review, validation,
  release, incident, and audit schemas.
- [ ] Define learner evidence and rebuildable projection schemas.
- [ ] Define API and event contracts with idempotency and versioning.
- [ ] Define RLS, indexes, migrations, retention hooks, and deletion behavior.
- [ ] Define exam-pack manifest resolution and atomic activation.
- [ ] Define compatibility and migration rules for historical learner evidence.

### DESIGN-003 - Security and Privacy Architecture

**Status:** Proposed
**Owner:** Security/technical owner with counsel
**Depends on:** GOV-002, DESIGN-002

- [ ] Complete threat modeling and data classification.
- [ ] Define authorization matrix and least-privilege validator access.
- [ ] Define service-role, secret, and environment boundaries.
- [ ] Define upload validation, malware controls, signed access, and retention.
- [ ] Define audit, incident response, deletion, and protected export.
- [ ] Define parent-entitlement security before any parent implementation.

### DESIGN-004 - Validator Workbench and Release Workflow

**Status:** Proposed
**Owner:** Learning Quality Owner with product and technical owners
**Depends on:** `TASK-0005`, DESIGN-002, DESIGN-003

- [ ] Design qualification, entitlement, assignment, recusal, and suspension.
- [ ] Design blind independent teaching and grading review.
- [ ] Design compact evidence packages and criterion-level comparison.
- [ ] Design adjudication and calibration workflows.
- [ ] Design held-out-set protections.
- [ ] Design release gates, manifest approval, rollback, and incident controls.
- [ ] Establish validator staffing, throughput, queue-age, and cost targets.

### DESIGN-005 - Deployment, Reliability, and Provider Boundaries

**Status:** Proposed
**Owner:** Technical owner
**Depends on:** DESIGN-002, DESIGN-003

- [ ] Decide Vercel route, Supabase Edge Function, database, and queued-worker
  responsibilities.
- [ ] Set latency targets for MCQ, FRQ, extraction, session resume, and
  recommendation generation.
- [ ] Define retries, dead-letter handling, idempotency, and recovery.
- [ ] Define deterministic fallback recommendations and provider-failure modes.
- [ ] Define model routing, model change control, observability, and cost limits.
- [ ] Define preview, validation, and production separation.

### DESIGN-006 - Marketing and Lifecycle Integration

**Status:** Proposed
**Owner:** Micah Bloom with product, counsel, and technical owners
**Depends on:** GOV-002, DESIGN-002

- [ ] Define the allowlisted event catalog.
- [ ] Define consent, attribution, hashing, and destination policies.
- [ ] Select analytics and lifecycle tools.
- [ ] Keep detailed learner evidence out of marketing systems.
- [ ] Define subject waitlist, launch-announcement, and reporting workflows.
- [ ] Define public educational-content publishing and identity-sweep workflow.

### DESIGN-007 - Visual Stimulus and Rendering System

**Status:** Ready for Owner Review
**Owner:** Technical owner with Learning Quality Owner
**Depends on:** `TASK-0005`, `TASK-0006`, CONTENT-001A

- [x] Assess structured rendering, prose fallback, and image-generation options.
- [x] Define the proposed four-lane visual architecture.
- [x] Define logical visual, dataset, accessibility, and renderer-profile
  contracts without physical DDL.
- [x] Define construct-preservation, answer-leakage, and fail-closed rules.
- [ ] Obtain Product Owner direction on the five open decisions.
- [ ] Audit the 964-item plan by visual kind and purpose.
- [ ] Prototype semantic tables, common quantitative charts, and a constrained
  phylogenetic tree.
- [ ] Validate screen-reader, keyboard, zoom, contrast, and mobile behavior.
- [ ] Define and validate learner-created graphing and scoring.
- [ ] Research QR-linked handwritten graph capture through `TASK-0011`.
- [ ] Select a renderer only after the bounded prototype and architecture gate.

## 7. P1 Product and Teaching Design Backlog

### LEARN-001 - Optional Calibration Diagnostic

**Status:** Proposed
**Owner:** Learning Quality Owner

- [ ] Determine the shortest diagnostic that produces useful ranking evidence.
- [ ] Define question composition, stopping rules, and confidence collection.
- [ ] Define cold-orientation and answer-leakage controls.
- [ ] Define how pasted or assisted responses affect evidence weight.
- [ ] Validate with AP Biology experts and students.

### LEARN-002 - Stable Improvement and Evidence Policy

**Status:** Research
**Owner:** Learning Quality Owner

- [ ] Determine required fresh independent attempts by skill and task type.
- [ ] Determine required transfer distance and delay.
- [ ] Define provisional success, stable improvement, and retention language.
- [ ] Define minimum sample and effect threshold before intervention history may
  bias future routing.
- [ ] Define evidence thresholds for readiness and improvement claims.

### LEARN-003 - Time, Fatigue, and Review Scheduling

**Status:** Research
**Owner:** Learning Quality Owner

- [ ] Set per-target time and intervention budgets by task, exam horizon, and
  learner intent.
- [ ] Validate Lock return intervals.
- [ ] Determine study policy when fewer than three days remain.
- [ ] Validate the final protected exam window.
- [ ] Define how fatigue and frustration affect recommendations without becoming
  hidden diagnoses.

### LEARN-004 - Stuck-State Calibration

**Status:** Research
**Owner:** Learning Quality Owner

- [ ] Calibrate the current entry threshold and evidence weights by skill.
- [ ] Validate assessable-skill equivalence with inter-rater exercises.
- [ ] Identify misconceptions with reliable discriminating probes.
- [ ] Define validator sampling for Park and repeated route failures.
- [ ] Define prerequisite, component, representation, and transfer relationships.

### LEARN-005 - Intervention and FRQ Calibration

**Status:** Research
**Owner:** Learning Quality Owner with grading lead

- [ ] Determine the number of Show fade steps by task complexity.
- [ ] Determine anchor-example count and selection by FRQ archetype.
- [ ] Decide how to prioritize simultaneous partial correctness across criteria.
- [ ] Determine which interventions require deterministic authored text.
- [ ] Identify AP Biology gaps most improvable within ten days.

### LEARN-006 - Recommendation and Progress Design

**Status:** Proposed
**Owner:** Product Owner with Learning Quality Owner

- [ ] Define the precise next-best-action algorithm.
- [ ] Define weakness, improvability, exam value, time cost, fatigue, and
  confidence inputs.
- [ ] Define recommendation explanations and learner override.
- [ ] Decide whether target score affects recommendations.
- [ ] Define progress reporting versus estimated-score projection.
- [ ] Define disputed-grade and low-confidence effects on learner state.

### CONTENT-001 - AP Biology Content Authoring and Coverage Plan

**Status:** In Progress
**Owner:** Orly Bloom / Learning Quality Owner

- [x] Adopt paid qualified tutors as the original-question authors.
- [x] Prohibit historical College Board questions from serving as seeds,
  adaptation targets, few-shot examples, or generative-model inputs.
- [ ] Define tutor author qualifications, writing exercise, compensation,
  revision terms, confidentiality, originality warranty, and IP assignment.
- [x] Define AP Reader eligibility as AP Biology Reading service in at least one
  of 2024, 2025, or 2026, plus the underlying validator qualification.
- [x] Require a simple counsel-approved IP and confidentiality release for paid
  authors, sellers, and AP Reader reviewers.
- [ ] Define versioned coverage briefs for questions, rubrics, lessons, hints,
  worked examples, probes, transfer items, and delayed variants.
- [x] Use all 60 official public AP Biology topics as the coverage taxonomy.
- [x] Set the planning target at ten approved MCQs and five approved short-FRQ
  prompts per topic, plus four long-FRQ stimulus packages and eight counted
  long-FRQ prompts per unit.
- [x] Define one inventory item as one MCQ or one independently delivered and
  answered FRQ prompt.
- [ ] Define priority modules, skills, archetypes, and misconception coverage.
- [ ] Recruit paid tutor authors and separate qualified validators.
- [ ] Create originality, similarity, source-disclosure, and rights preflight.
- [x] Permit controlled AI versioning only from Cramapple-owned or fully
  licensed proprietary packages with derivative and model-input rights.
- [x] Preserve paid-tutor authorship as the production baseline while testing
  AI-led base authoring in an isolated, validation-only experiment.
- [x] Reject the proposed official-derived candidate and prohibit it from
  prompts, exemplars, evaluation sets, and production content.
- [x] Retain consequential content lessons as abstract failure cards rather
  than complete rejected questions.
- [ ] Create a clean proprietary replacement exemplar through `TASK-0008`.
- [ ] Execute `TASK-0007` only after Learning Quality, counsel, participant,
  blinding, and budget gates pass.
- [ ] Define and approve the independent holdout set and passing thresholds for
  AI-created variants; variants cannot count toward production coverage before
  this gate passes.
- [ ] Create and validate the proprietary question-versioning skill only after
  rights, source, similarity, and holdout policies are approved.
- [ ] Define permitted sources for original graphs, datasets, experimental
  contexts, passages, and images.
- [ ] Complete `TASK-0006` visual-source, rendering, accessibility-equivalence,
  and learner-created-graphing decisions.
- [ ] Define the minimum student sample and evidence thresholds for item
  revision, reclassification, suspension, and retirement.
- [x] Require statistical performance signals to open human review rather than
  automatically changing an item's lifecycle state.
- [x] Allow diagnostic questions to graduate to teaching use or retire through
  a versioned lifecycle decision.
- [x] Permit independently expert-curated diagnostic candidates to be used
  before empirical confirmation.
- [x] Defer physical Supabase design until the logical governance model and
  application architecture are approved.
- [ ] Complete `TASK-0009` conceptual schema reconciliation before physical
  Supabase or Postgres design.
- [ ] Create source and rights plans for every artifact family.
- [ ] Establish production throughput and quality reporting.

#### CONTENT-001A - Question Distribution Analysis Handoff

**Status:** Owner Direction Recorded; Revision Required
**Owner:** Main Conductor revision; Orly Bloom / Learning Quality Owner reviews
**Decision Owner:** David Bloom

The analysis should return:

- the complete Module/Subtopic taxonomy used;
- recommended MCQ and FRQ counts for every Module/Subtopic pair;
- totals by module, question form, science practice, task verb, representation,
  difficulty, and intended use;
- the method used to translate exam weighting and skill coverage into bank size;
- assumptions about question reuse, exposure, diagnostics, transfer, delayed
  retrieval, and AI-created variants;
- minimum viable, recommended beta, and mature-bank scenarios;
- coverage gaps and pairs where ten total questions are insufficient or
  excessive;
- estimated authoring, validation, and revision workload;
- all sources, source dates, calculations, and uncertainty;
- a machine-readable table suitable for the governed coverage matrix.

The analysis must not reproduce official question text or use secure,
credential-restricted, or confidential material. Its recommendation does not
become policy until Learning Quality Owner review and Product Owner approval.

Claude's initial handoff was reviewed on 2026-06-12. Its useful planning model
was retained, but its 48-topic assumption and 784-item total were rejected. The
corrected approved-direction matrix uses 60 official topics and a 964-item
planning target. Physical Supabase DDL remains deferred.

### EVAL-001 - Efficacy Measurement

**Status:** Proposed
**Owner:** Learning Quality Owner with product analytics owner

- [ ] Define pre/post, same-session transfer, and delayed-retention measures.
- [ ] Define expert-AI agreement reporting.
- [ ] Define recommendation acceptance and outcome analysis.
- [ ] Separate activity, supported performance, independent performance, and
  durable evidence.
- [ ] Define pilot sample, analysis, and claims policy.

## 8. P2 MVP Experience and Implementation Backlog

### BUILD-001 - Core Platform Foundation

**Status:** Proposed
**Owner:** Technical owner
**Depends on:** Required P1 designs and approved implementation task

- [ ] Identity, consent, profile, and entitlement foundation.
- [ ] Exam specification, taxonomy, source, rights, content, and rubric stores.
- [ ] Session, submission, learner-evidence, and projection stores.
- [ ] Exam-pack resolver and version-pinned request context.
- [ ] Audit, observability, and transactional outbox.

### BUILD-002 - Learning Session Experience

**Status:** Proposed
**Owner:** Product and technical owners

- [ ] Sign-up and first-session onboarding.
- [ ] Resume-learning flow.
- [ ] Quick, Focused, and Buckle Down session modes for testing.
- [ ] Attempt-confidence-feedback-retry loop.
- [ ] Tighten, Show, Sideways, Apart, Down, Move On, Park, and Lock behavior.
- [ ] Transparent next-action recommendation and override.

### BUILD-003 - Practice and Grading

**Status:** Proposed
**Owner:** Technical owner with grading lead

- [ ] MCQ, quantitative, data-analysis, and FRQ delivery.
- [ ] Immutable submissions and criterion-level grading.
- [ ] Minimum-fix, improved-answer, and complete-answer feedback.
- [ ] Confidence, escalation, human review, and regrading.
- [ ] Production quality sampling and drift monitoring.
- [ ] Paper-first handwritten graph intake if `TASK-0011` passes its research
  gate.

### BUILD-004 - Student-Provided Questions

**Status:** Proposed
**Owner:** Product and technical owners
**Depends on:** Rights, privacy, upload, and grading designs

- [ ] Define MVP input formats and modes.
- [ ] Build text intake and approved image/document intake if feasible.
- [ ] Add scanning, extraction, missing-context, and confidence handling.
- [ ] Calibrate high, moderate, and low classification thresholds.
- [ ] Isolate user material from canonical content.
- [ ] Implement private use, anonymous improvement, and public-candidate
  separation.

### BUILD-005 - Progress and Review

**Status:** Proposed
**Owner:** Product and technical owners

- [ ] Activity and performance record.
- [ ] Criterion, skill, misconception, confidence, and review-due summaries.
- [ ] Lock queue and delayed-review scheduling.
- [ ] Comparable-evidence progress language.
- [ ] Recommendation history, acceptance, override, and outcomes.

### UX-001 - Initial Product UX Decisions

**Status:** In Progress
**Owner:** Product Owner with Learning and Marketing owners
**Task record:** `docs/tasks/UX-001-INITIAL-PRODUCT-UX-DECISIONS.md`
**Design record:** `docs/product/STUDENT_PORTAL_INTERACTION_DESIGN.md`

- [x] Draft the first-session onboarding explanation.
- [x] Design the post-account creation setup and first-session plan.
- [x] Define session-mode presentation variants for testing.
- [x] Define bracket-marker feedback variants for testing.
- [x] Draft peer-tone academic-integrity coaching copy.
- [x] Draft uncertainty, escalation, and disputed-grade language.
- [x] Produce the initial low-fidelity clickable prototype.
- [ ] Test the prototype with representative learners.
- [ ] Obtain Learning and Marketing review.
- [ ] Complete accessibility review.
- [ ] Obtain Product Owner decision on the proposed UX directions.

### UX-002 - Question and Answer Review Portal

**Status:** In Progress
**Owner:** Product Owner with Learning Quality Owner
**Task record:** `docs/tasks/UX-002-QUESTION-ANSWER-REVIEW-PORTAL.md`
**Design record:** `docs/product/QUESTION_AND_ANSWER_REVIEW_PORTAL_DESIGN.md`

- [x] Define independent two-tutor 1-3 scoring and aggregate outcomes.
- [x] Define AP Reader approval, recycle, and exclusion outcomes.
- [x] Define exact-agreement difficulty labeling and discussion.
- [x] Define question-first and four-answer MCQ review gates.
- [x] Draft reviewer queue and carousel interaction model.
- [x] Produce and verify the clickable reviewer prototype.
- [ ] Obtain tutor and AP Reader usability review.
- [ ] Complete Learning Quality, accessibility, and security review.
- [ ] Obtain Product Owner decision before production implementation.

## 9. P2 Commercial and Operating Backlog

### GTM-001 - Positioning and Launch Messaging

**Status:** Proposed
**Owner:** Micah Bloom

- [ ] Finalize and test positioning, tagline, and student/parent value
  propositions.
- [ ] Define readiness language without unsupported score prediction.
- [ ] Define social-proof and performance-claim evidence rules.
- [ ] Create the August 2026 beta launch plan and feedback loop.
- [ ] Define fall, winter early-access, and spring exam-season campaigns.

### BIZ-001 - Pricing and Access Policy

**Status:** Proposed
**Owner:** David Bloom with Strategy Advisor

- [ ] Set AP Biology launch price.
- [ ] Set access duration under the one-time purchase.
- [ ] Define refunds, discounts, and future bundles.
- [ ] Prevent sales of subject bundles before each pack passes quality gates.
- [ ] Define parent-purchaser handling without granting parent data access.

### OPS-001 - Economics and Staffing Plan

**Status:** Proposed
**Owner:** David Bloom with Strategy Advisor and functional owners

- [ ] Model AI, extraction, hosting, support, refund, validator, and acquisition
  costs.
- [ ] Set validator staffing and throughput requirements.
- [ ] Define founder time commitments and explicit work owners.
- [ ] Set launch budget and spending approval gates.
- [ ] Define unit economics and launch/no-launch thresholds.

## 10. P3 Deferred and Expansion Backlog

### PARENT-001 - Parent Progress Product

**Status:** Deferred
**Owner:** Product Owner

- [ ] Decide role, timing, pricing, consent, and learner visibility.
- [ ] Design approved aggregates without raw answers or private interactions.
- [ ] Show learners exactly what is shared.
- [ ] Define deferred-skill and effort rollups.
- [ ] Complete separate legal, privacy, security, and product approval.

### EXPAND-001 - Second Exam Pack

**Status:** Deferred
**Owner:** Product Owner with Strategy Advisor and Learning Quality Owner

- [ ] Rank subjects using demand and operating evidence.
- [ ] Select the next natural-science exam.
- [ ] Identify subject-specific notation, diagram, graph, formula, or tool needs.
- [ ] Define capability and validator gates before expansion.
- [ ] Require the same source, rights, teaching, grading, and release quality as
  AP Biology.

### DEFER-001 - Explicitly Deferred Product Scope

**Status:** Deferred

- [ ] Long-term course replacement.
- [ ] Guaranteed AP score prediction.
- [ ] Fully autonomous teaching or grading publication.
- [ ] Live tutoring marketplace.
- [ ] Parent-directed instructional control.
- [ ] Cross-subject pedagogy without exam-pack validation.
- [ ] Full timed-section simulation until core evidence and grading are stable.

## 11. Backlog Maintenance

The Main Conductor reviews this file:

- whenever a task, decision, approval, or major canonical design changes;
- before creating a new task;
- at least weekly during active build or launch periods;
- at least monthly during planning periods.

Maintenance checks:

- [ ] Every active task appears in the Active Task Register.
- [ ] Every `Ready for Owner Review` task has a named next action.
- [ ] Every execution item links to an approved task.
- [ ] Completed items have recorded QA and required Done decisions.
- [ ] Deferred items remain outside active implementation scope.
- [ ] New open questions from canonical documents are added or explicitly
  resolved.
- [ ] Duplicate or superseded items are linked rather than silently deleted.
