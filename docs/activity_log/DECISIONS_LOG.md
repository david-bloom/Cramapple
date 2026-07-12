# Decisions Log

This log records product, architecture, operating, security, design, and workflow decisions.

## Index

Most recent entries (full chronological list follows below):

- DECISION-0036 — Approve TASK-0010 Grader Confidence and Calibration Program
- DECISION-0035 — Resolve Phase 0 of the Backend Consolidation Migration (Schema Reconciliation, Option A/A2)
- DECISION-0031 — Launch AP Statistics as Subject 2, Reusing the Tutor-Authored Content Model
- DECISION-0030 — Failed/Rejected Grading Burns the Daily Budget Cap When Cost Is Known
- DECISION-0029 — ALLOWED_ORIGINS Required in All Environments; No Wildcard CORS Fallback
- DECISION-0028 — Auto-Trigger QA and Model Routing (Codex Proposal Folded In)
- DECISION-0027 — Adopt Charter Simplification and Tiering (Pilot: Cramapple Only)
- DECISION-0026 — Separate Authoring, Revision, and Independent Review
- DECISION-0025 — Use a Verified Five-Stage Outside-Question Intake
- DECISION-0024 — Use Staged Tutor and AP Reader Candidate Review
- DECISION-0023 — Resolve Official Exam Dates from the Exam Specification

**Rotation rule:** once this log exceeds ~600 lines, archive the older entries to `docs/activity_log/archive/DECISIONS_LOG-<range>.md` and update this index to point at the archive. Keep the index itself to the last ~10 entries. (This log is already well over that threshold — the first archive pass is overdue, not optional.)

(Note: the TASK-0012 branch independently logged its own DECISION-0027/0028 — CORS/ALLOWED_ORIGINS and budget-burn semantics — under different numbers on its own branch. Those land separately when that work merges to `main`; this charter-adoption decision claimed 0027/0028 here because `main` had not yet recorded entries past DECISION-0026 at merge time. If both branches' numbering collides on merge, renumber on whichever side merges second and update this index.)

## Decision Format

```markdown
## DECISION-0000 — Decision Title

**Date:** YYYY-MM-DD
**Decision Owner:** David Bloom
**Status:** Proposed / Approved / Superseded
**Related Task:** TASK-0000 / N/A
**Area:** Product / Architecture / Security / Design / Operations / Integration

### Context

### Decision

### Rationale

### Consequences

### Risks / Follow-ups
```

## DECISION-0001 — Use GitHub as Cramapple's Durable Source of Truth

**Date:** 2026-06-09
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0001
**Area:** Operations

### Context

Cramapple planning has begun in chat and in speculative blueprint documents. Durable project state needs a consistent home and operating workflow.

### Decision

Use the AI Project Operating Kit and store canonical documents, tasks, approvals, decisions, and activity records in `david-bloom/Cramapple`.

### Rationale

This prevents chat-only decisions, establishes approval boundaries, and allows human and AI collaborators to reorient from the same records.

### Consequences

GitHub documents override unrecorded chat memory. Earlier `Blueprint_*` files remain speculative inputs unless promoted through an approved decision.

### Risks / Follow-ups

The operating workflow may need simplification after practical use.

## DECISION-0002 — Product and Strategy Authority

**Date:** 2026-06-09
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0001
**Area:** Operations

### Context

The project needs explicit authority for product decisions and a role for strategic planning.

### Decision

David Bloom is Product Owner and final approver. Add Strategy Advisor to work with David and the co-founders on plans and business decisions.

### Rationale

The team benefits from strong strategic challenge and planning support while preserving one clear final product authority.

### Consequences

The Strategy Advisor may recommend, draft, analyze, and challenge. The role may not independently approve product scope, execution, risk, Done decisions, or launch.

### Risks / Follow-ups

The named person or agent filling the Strategy Advisor role may vary and should be recorded when assigned.

## DECISION-0003 — Allow Qualified Estimated AP Score Guidance

**Date:** 2026-06-09
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0002
**Area:** Product

### Context

The initial vision prohibited official AP score prediction but left the role of estimated scoring unresolved. Students need understandable guidance about their likely current range and what improvement could move them forward.

### Decision

Cramapple may provide estimated AP score ranges or readiness estimates when supported by sufficient evidence. Estimates must be clearly identified as non-official, express uncertainty, disclose important evidence gaps, and connect the estimate to concrete next actions.

### Rationale

Qualified estimates can make criterion-level feedback more useful and motivating while preserving a clear distinction between Cramapple guidance and official College Board scoring.

### Consequences

The grading and recommendation systems will need evidence thresholds, confidence rules, calibration datasets, versioned estimation logic, and monitoring for systematic error. A single response must not be presented as a definitive overall AP score.

### Risks / Follow-ups

- Define the minimum evidence required before displaying an estimate.
- Establish expert review and calibration standards before launch.
- Determine how estimated ranges should be updated as new performance evidence arrives.
- Validate customer-facing language with students, parents, tutors, and legal review.

## DECISION-0004 — High-Level Architecture Boundaries

**Date:** 2026-06-09
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0003
**Area:** Architecture

### Context

Cramapple needs a durable architecture before detailed teaching, grading, data, and implementation designs. Earlier root-level blueprints move too quickly into preliminary schemas and provider-specific model routing.

### Decision

Adopt a high-level architecture organized around managed presentation and application services, Supabase as the proposed durable system of record, replaceable task-specific AI providers, versioned canonical content, durable learner evidence, separate teaching and grading responsibilities, first-class validator operations, and event-based marketing interoperability.

### Rationale

This establishes stable ownership and trust boundaries before committing to detailed schemas or vendors. It supports grading and teaching quality, low-code maintainability, cross-session learning, and additional AP exams.

### Consequences

- Detailed teaching and grading designs will be separate canonical documents.
- Student attempts remain durable while mastery, recommendations, and progress are derived and rebuildable.
- Validators require scoped entitlements and version-specific approval workflows.
- Marketing integrations receive approved events rather than sensitive learning content.
- User-provided questions remain isolated from canonical content.
- Parent progress is a future paid entitlement with separate relationship, consent, billing, and visibility checks.

### Risks / Follow-ups

- Detailed data, security, teaching, grading, and integration designs remain open.
- Managed-service boundaries must be tested against latency, cost, privacy, and seasonal load.
- Legal review is required for minors, uploads, official materials, and parent access.

## DECISION-0005 — Version Official Exam Facts Separately from Product Models

**Date:** 2026-06-10
**Decision Owner:** David Bloom
**Status:** Proposed
**Related Task:** TASK-0004
**Area:** Architecture

### Context

Section weights, point distributions, task types, and curriculum ranges directly influence what Cramapple recommends. Scattering those facts through prompts or prose would make updates, review, and audit unreliable.

### Decision

Create a versioned Exam Specification Registry for official exam facts. Store Cramapple-derived weights, formulas, and predictions as separate records with explicit assumptions and model versions.

### Rationale

This prevents official facts from being confused with product inference and allows each school year's exam pack to be reviewed, activated, superseded, and audited.

### Consequences

- Every recommendation can identify the exam facts and derived model that influenced it.
- Source scope must be precise; for example, AP Biology unit ranges apply to the multiple-choice section.
- Exam changes can trigger impact analysis and revalidation.

### Risks / Follow-ups

- Source licensing and authorized-material rules require legal review.
- The physical schema and update workflow remain to be designed.

## DECISION-0006 — Adopt an Exam-Horizon Retrieval Pedagogy

**Date:** 2026-06-10
**Decision Owner:** David Bloom
**Status:** Proposed
**Related Task:** TASK-0004
**Area:** Product

### Context

Cramapple's initial use case is approximately ten days before an AP exam. A year-long curriculum model does not fit this constraint, while passive cramming offers weak evidence of independent retrieval and transfer.

### Decision

Use attempt-first diagnosis, minimal targeted teaching, immediate transfer, delayed retrieval, deliberate interleaving, confidence calibration, and exam-value-aware recommendations as the teaching-system foundation.

### Rationale

The approach directs limited study time toward demonstrated gaps that appear teachable and valuable while preserving return visits before exam day.

### Consequences

- Weakness, improvability, and exam value are separate recommendation inputs.
- Explanations do not count as mastery without retrieval.
- FRQs are taught by task and criterion; CER is used where the scoring opportunity calls for argumentation.
- Student-facing recommendations explain their reasoning.

### Risks / Follow-ups

- AP Biology tutors must review the pedagogy before implementation or launch.
- Cramapple-specific intervals and effect claims require product validation.
- A detailed grading and calibration design remains open.

## DECISION-0007 — Use Evidence-Weighted Escalation Within One Learning Model

**Date:** 2026-06-10
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0004
**Area:** Product

### Context

A deterministic three-miss trigger, universal Sideways-first sequence, and generic learner-preference memory would create false precision and could waste limited study time.

### Decision

Use one per-assessable-target-and-facet learning-state model. Weight failure evidence by independence, variation, delay, and support; use discriminating probes to select Sideways, Apart, or Down; confirm intervention success through independent and delayed performance; offer Move On; and calculate Park return from exam horizon, frustration, and expected exam utility.

Anonymous student responses and outcome traces may be used to improve Cramapple's grading, teaching, content, evaluation, model configurations, and routing. Public publication remains separately gated and includes a signed-in-user proper-name sweep.

### Rationale

The model creates a rational, auditable policy without claiming certainty about hidden cognitive causes. Subsequent independent performance tests whether the selected intervention was useful.

### Consequences

- Learner state must preserve support level, route, immediate transfer, delayed retention, Move On, and Park evidence.
- The content graph needs prerequisite, component, representation, and transfer relationships.
- Validators need compact evidence packages for uncertain and repeated-failure cases.
- Demonstrated intervention effectiveness is specific to skill and task type.
- Legal terms and notices must describe anonymous improvement use.

### Risks / Follow-ups

- Entry weights, thresholds, and Park constants require pilot calibration.
- Counsel must finalize age, consent, retention, deletion, and jurisdictional requirements.
- Grading thresholds remain owned by the future grading design.

## DECISION-0008 — Define Skill Evidence, Learner Override, and Publishing Ownership

**Date:** 2026-06-11
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0004
**Area:** Product

### Context

The unified model required clearer boundaries for what counts as the same skill, how Frame affects evidence, who chooses interventions, when success becomes independent, and whether public question pages belong to learning or marketing.

### Decision

Use an assessable skill target composed of canonical operation, required knowledge or concept cluster, and substantive success criterion, with representation and support recorded as facets. Use Frame for both diagnosis and teaching, but classify evidence according to what the Frame reveals. Recommend interventions with visible alternatives and learner override. Treat per-target time and stronger success thresholds as research items. Assign public student-question publishing primarily to marketing/content while requiring pedagogical and grading release gates.

### Rationale

This avoids counters that are either too broad or question-specific, preserves the evidentiary meaning of assistance, and implements the principle that Cramapple guides without dictating. It also keeps private learning evidence separate from acquisition publishing while protecting educational quality.

### Consequences

- Learner evidence stores target identity, representation, support, Frame type, recommendation, and override.
- A supported attempt cannot become independent merely through relabeling; a fresh unsupported transfer attempt is required.
- The product may recommend Move On but does not enforce an unvalidated pedagogical time cap.
- Marketing owns public packaging and distribution; validators own teaching and grading quality approval.

### Risks / Follow-ups

- AP Biology tutors must validate target-equivalence examples.
- Product research must establish stable-improvement thresholds and time budgets by task type and exam horizon.
- Analytics must distinguish recommendation acceptance, override, and outcome without penalizing learner agency.

## DECISION-0009 — Adopt Content Governance and Validation Operating Policy

**Date:** 2026-06-12
**Decision Owner:** David Bloom
**Status:** Proposed
**Related Task:** TASK-0005
**Area:** Architecture / Operations

### Context

The approved architecture requires immutable versioned content, source and
rights provenance, separate teaching and grading validators, independent release
gates, atomic exam-pack publication, monitoring, revalidation, retirement,
rollback, and audit. Exact operating rules and thresholds were still open.

### Decision

Adopt `docs/architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md` as the controlling
operating procedure for content and rubric governance after Learning Quality
Owner, counsel, and Product Owner review.

### Rationale

The policy makes release authority, reviewer independence, qualifications,
schemas, acceptance criteria, numeric quality thresholds, refresh schedules,
and revalidation scope explicit and auditable.

### Consequences

- Content and rubric releases use immutable versions and complete manifests.
- Teaching and grading have independent reviewer and evidence gates.
- Source and rights status can block use independently of educational quality.
- Model, prompt, rubric, source, and policy changes receive defined
  revalidation scope.
- Implementation requires separate approved technical, security, and data work.

### Risks / Follow-ups

- Numeric thresholds require expert review and pilot evidence before adoption.
- Counsel must review official-material, license, retention, and public-use
  boundaries.
- Validator staffing and cost must be tested against launch coverage.
- Physical schemas and workbench implementation remain separate tasks.

## DECISION-0010 — Use Paid Tutors for Original Question Authoring

**Date:** 2026-06-12
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0005 / CONTENT-001
**Area:** Product / Operations

### Context

Cramapple needs a scalable original question bank. A proposed model would have
used historical College Board questions as seed material for a proprietary
question-making skill. That approach creates rights risk, derivative-content
risk, and weak accountability for question quality.

### Decision

Pay qualified tutors and subject experts to independently author original
questions and complete question packages from Cramapple coverage briefs.

Official historical questions and scoring materials are not seeds, adaptation
targets, few-shot examples, or generative-model inputs. Authorized humans may
review public official materials for abstract alignment where legally permitted,
but commissioned artifacts must be independently expressed.

Paid tutors create or sell Cramapple the base AP Biology packages. AI does not
draft base questions from official or third-party material. Controlled
versioning of Cramapple-owned or fully licensed packages is governed by
`DECISION-0011`.

### Rationale

Paid human authorship creates clear accountability, supports contractual
ownership and originality attestations, and separates exam familiarity from
copying or automated derivation. It also allows question quality to be improved
through structured author feedback without making official material part of the
production pipeline.

### Consequences

- Content coverage is commissioned from a coverage matrix rather than generated
  as a fixed number of derivatives per historical question.
- Tutor authors deliver complete question packages, not question text alone.
- Authors may revise but cannot approve their own work.
- Validation remains independent and includes scientific, teaching, grading,
  originality, provenance, and rights gates.
- Contracts must address compensation, confidentiality, originality, source
  disclosure, restricted materials, revisions, and IP assignment or license.

### Risks / Follow-ups

- Human authoring cost and throughput may constrain coverage.
- Tutor quality and writing skill will vary and require qualification.
- Independent similarity review is still required.
- Counsel must approve author agreements and official-material review guidance.

## DECISION-0011 — Define the Proprietary Question Bank and AI Versioning Model

**Date:** 2026-06-12
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0005 / CONTENT-001
**Area:** Product / Operations

### Context

The paid-tutor model required decisions about bank coverage, MCQ and FRQ scope,
AI use, AP Reader eligibility, IP release, diagnostic lifecycle, and production
monitoring.

### Decision

- Use a human abstraction firewall. Official question text and scoring material
  do not enter the authoring or AI-versioning workflow.
- Include both MCQs and FRQs.
- Target at least ten approved questions for each subject-and-subtopic pair.
- Build the proprietary base set from Cramapple-authored and purchased question
  packages.
- Permit AI to create candidate variants only from proprietary packages for
  which Cramapple holds explicit adaptation, derivative-work, and model-input
  rights.
- Require a complete rubric and teaching package for every base question and
  every AI variant.
- Define an AP Reader Validator as someone who served as an AP Biology Reader
  in at least one of 2024, 2025, or 2026 and also meets the applicable Cramapple
  validator qualification.
- Use a simple counsel-approved release for authors, sellers, and AP Reader
  reviewers.
- Allow diagnostic questions to graduate to teaching use or be retired through
  a governed lifecycle decision.

### Rationale

This creates a coverage-driven proprietary bank while preserving human
accountability, contractual rights, exam authenticity, and independent
validation. AI expands owned content rather than deriving content from official
questions.

### Consequences

- AI variants are new immutable artifacts and do not inherit base approval.
- Superficial reskins do not count toward coverage targets.
- Question performance is monitored by version and intended use.
- Performance evidence opens review but does not automatically change item
  status until sample and decision thresholds are approved.
- AP Reader status does not authorize disclosure or use of secure material.

### Open Gates

- Minimum student sample and evidence thresholds for changing or retiring an
  item.
- Independent holdout set and passing thresholds for AI-versioning changes.
- Permitted sources and rights rules for graphs, datasets, experimental
  contexts, passages, and images.
- Final counsel-approved release language.

### Supersession Note

The quantity language in this decision is superseded by `DECISION-0014`, which
uses all 60 official topics and sets separate MCQ, short-FRQ, and long-FRQ
planning targets.

## DECISION-0012 — Require Local Documents to Be Synchronized to GitHub

**Date:** 2026-06-12
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** N/A
**Area:** Operations

### Context

GitHub is Cramapple's durable source of truth, but project documents can still
be created or revised locally before they are pushed.

### Decision

Every project document retained in the local Cramapple workspace must also be
committed and pushed to `david-bloom/Cramapple`. A local-only document is not a
durable project record.

Temporary renders, caches, editor files, and operating-system metadata are not
project documents and should remain untracked.

### Rationale

This prevents source-of-truth drift, preserves work across machines and agents,
and ensures project decisions can be reconstructed from GitHub.

### Consequences

- Agents include all retained project documents in the relevant commit.
- Synchronization is complete only after the commit is pushed and the remote
  branch is verified.
- Any document that cannot be pushed must be reported explicitly.
- `.DS_Store` and comparable machine-local files are excluded.

### Risks / Follow-ups

- Sensitive information must not be placed in project documents merely to
  satisfy synchronization; secrets and protected data require approved secure
  storage.

## DECISION-0013 — Make Markdown the Default Project Document Medium

**Date:** 2026-06-12
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** N/A
**Area:** Operations / Documentation

### Context

Cramapple has accumulated Markdown, Word, RTF, spreadsheet, and other document
formats. Maintaining ordinary project documents in multiple editable formats
creates synchronization work and ambiguity about which copy governs.

### Decision

Markdown (`.md`) in GitHub is the default and canonical medium for project
documents.

Google Docs is the preferred secondary format when live collaboration,
comments, suggestion mode, or a cloud backup copy is useful. Accepted changes
must be incorporated into the canonical Markdown file.

Word (`.docx`) should be avoided unless a specific external recipient,
submission, printing, or layout-fidelity requirement makes it necessary. A Word
document must be derived from a canonical source and must not become an
independent competing source.

### Rationale

Markdown is easy to review, compare, version, search, and maintain in GitHub.
Google Docs supports human collaboration without replacing the source of truth.
Limiting Word documents reduces duplicate maintenance and format drift.

### Consequences

- Agents create ordinary durable project documents as Markdown by default.
- Google Docs are collaboration or backup copies, not authoritative records.
- Accepted Google Docs edits return to Markdown and GitHub.
- Existing Word snapshots may remain, but they are not refreshed by default.
- New or updated Word deliverables require a specific format need.
- Artifact-native formats such as spreadsheets, images, presentations, and
  executable source files remain appropriate when Markdown cannot represent the
  artifact itself.

### Risks / Follow-ups

- A Google Docs backup process and link registry may be defined later if needed.
- External stakeholders may occasionally require Word, PDF, or another format.

## DECISION-0014 — Adopt Corrected AP Biology Coverage and Diagnostic Direction

**Date:** 2026-06-12
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0005 / CONTENT-001A
**Area:** Product / Content Operations / Architecture

### Context

Claude proposed a useful coverage model but calculated the bank using 48
topics. The current official AP Biology Course and Exam Description contains 60
topics, and the proposed table was internally inconsistent. The review also
identified unresolved definitions for inventory counting, pre-confirmation
diagnostic use, automated lifecycle changes, and physical database timing.

### Decision

- Use all 60 official public AP Biology topics as Cramapple's coverage taxonomy.
- Target at least ten approved MCQs and five approved short-FRQ prompts for each
  topic.
- Target four long-FRQ stimulus packages per unit, with two independently
  deliverable prompts per package.
- Count one MCQ or one independently delivered and answered FRQ prompt as one
  inventory item.
- Treat 964 items as the corrected full planning target: 600 MCQs, 300
  short-FRQ prompts, and 64 long-FRQ prompts.
- Work to meet or exceed the target; any launch shortfall requires a visible
  coverage-gap report, Learning Quality review, and Product Owner decision.
- Permit independently expert-curated diagnostic candidates to be used with
  students before empirical confirmation.
- Require statistical item signals to open human review. They do not
  automatically demote, retire, revise, or publish an item.
- Defer physical Supabase or Postgres design until the logical governance model
  and application architecture are approved.

### Rationale

The official taxonomy gives Cramapple a stable public alignment layer. Separate
targets for MCQs and FRQs support focused practice without confusing inventory
count with package workload. Human review preserves governance authority when
early item statistics are noisy or assignment is adaptive. Deferring physical
DDL prevents a premature schema from weakening immutable content, independent
approval, audit, and atomic-release requirements.

### Consequences

- `CONTENT_QUANTITY_AND_DISTRIBUTION.md` is the controlling planning matrix.
- The prior ten-total-questions quantity in `DECISION-0011` is superseded.
- The initial Claude patch and its 784-item calculation must not be applied.
- Diagnostic candidates may serve learners before statistical confirmation,
  while remaining clearly classified as expert-curated candidates.
- A later physical-schema task must implement the approved logical contracts
  rather than replacing them with mutable rows or direct approval booleans.

### Open Gates

- Learning Quality review of topic-level feasibility and content variety.
- Beta-launch coverage threshold and prioritization if 964 items are incomplete.
- Minimum sample sizes and statistical methods for item-performance review.
- AI-variant holdout policy and permitted source/asset rules.

## DECISION-0015 — Adopt a Governed Four-Lane Visual Architecture

**Date:** 2026-06-12
**Decision Owner:** David Bloom
**Status:** Proposed
**Related Task:** TASK-0006
**Area:** Architecture / Product / Accessibility / Content Operations

### Context

The initial visual proposal recommended structured product-rendered data
visuals, prose fallback for diagrams, and deferral of image generation. Review
found that this direction reduces rendering risk but does not fully preserve
visual-assessment validity, accessibility equivalence, diagram coverage,
versioning, rights, or learner-created graphing.

### Proposed Decision

- Use deterministic structured rendering for semantic tables and common
  quantitative charts.
- Use governed human-authored assets or constrained domain renderers for
  diagrams, trees, models, and experimental setups.
- Require an accessible companion or separately validated equivalent for every
  visual.
- Do not silently replace a visual-dependent task with prose.
- Defer free-form generative scientific images from production.
- Treat learner-created graphing as a separate assessment capability.
- Define vendor-neutral logical artifacts before physical database design or
  renderer selection.

### Rationale

Visual interpretation and graph construction are assessed operations, not
presentation details. The architecture must give learners access without
revealing the answer or changing the skill being measured. Immutable visual,
dataset, accessibility, and renderer dependencies also preserve audit and
revalidation integrity.

### Consequences

- The 964-item content plan requires a representation audit.
- Common charts and phylogenetic trees become the first proposed prototypes.
- Semantic HTML is preferred for tables.
- Renderer upgrades require corpus-wide regression testing.
- Missing or unsupported visual equivalents fail closed.

### Risks / Follow-ups

- Product Owner direction is required on the five decisions in `TASK-0006`.
- Learning Quality, accessibility, and counsel reviews remain required.
- Graph construction may need a larger minimum viewport than chart viewing.
- Renderer and physical-schema decisions remain deferred.

## DECISION-0016 — Reject the Official-Derived Candidate and Use Abstract Failure Cards

**Date:** 2026-06-13
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0007
**Area:** Content Operations / Rights / Quality

### Context

A proposed MCQ identified an official question as its source and changed the
organism, setting, and values. The same review found consequential quality
failures in other candidate questions.

### Decision

- Reject the official-derived item completely.
- Do not store it in the Cramapple repository, prompt library, exemplar pool,
  model inputs, evaluation sets, or production content.
- Preserve useful lessons from flawed candidates only as abstract failure cards
  and independently authored synthetic regression cases.
- Do not retain the original wording, distinctive scenario, organisms, values,
  answer choices, or source locator in an anti-example corpus.

### Rationale

Numerical and organism substitutions remain adaptation and violate the approved
human abstraction firewall. Abstract failure cards preserve quality lessons
without creating rights, contamination, or prompt-anchoring risk.

### Consequences

- The reviewed ZIP patches are not applied.
- Initial failure cards cover missing data, duplicate distractor logic,
  underdetermined predictions, omitted causal links, unsourced specificity,
  pseudoreplication, undefined thresholds, and exam-format mismatch.
- Future contaminated artifacts require documented scope review and exclusion.

### Risks / Follow-ups

- Counsel must define retention and deletion rules for contaminated working
  material outside the canonical repository.

## DECISION-0017 — Test Alternative Authoring Models Without Changing Production Policy

**Date:** 2026-06-13
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0007
**Area:** Product / Content Operations / Experimentation

### Context

The reviewed proposal implicitly replaced paid tutor authorship with
AI-generated base questions seeded by exemplars. The potential quality, speed,
cost, and scaling differences are worth measuring, but an implicit replacement
would bypass approved governance.

### Decision

- Keep paid qualified tutors as the production base-package authors.
- Run a controlled validation-only experiment comparing tutor-first, AI-first
  with paid tutor revision, and AI-first with independent validation.
- Give all arms the same blank governed briefs, approved factual sources,
  package contracts, and independent gates.
- Prohibit official questions, adaptation descriptions, contaminated content,
  and evaluation holdouts from every arm.
- Do not count experimental items toward production coverage or publish them
  without a later Product Owner decision.

### Rationale

A blinded comparison can test the business model without allowing cost or speed
to override originality, scientific accuracy, educational quality, grading
reliability, accessibility, or accountability.

### Consequences

- `CONTENT_AUTHORING_MODEL_EXPERIMENT.md` controls the pilot design.
- Experiment execution still requires Learning Quality, counsel, participant,
  data-capture, and budget gates.
- Pilot success authorizes analysis, not production use.

### Risks / Follow-ups

- Validator labor can hide the true cost of weak AI drafts.
- Small pilot samples cannot establish broad equivalence.
- Long FRQs require a later replicated phase.

## DECISION-0018 — Use Versioned Prompt Build Manifests

**Date:** 2026-06-13
**Decision Owner:** David Bloom
**Status:** Proposed
**Related Task:** TASK-0007
**Area:** Architecture / Content Operations

### Context

The reviewed multi-subject proposal correctly separated shared, subject, and
question-type concerns but proposed loosely concatenating Markdown files and
premature physical database changes.

### Proposed Decision

Use immutable prompt build manifests that resolve universal governance, exam
pack, taxonomy schemes, task archetype, coverage brief, permitted sources or
base packages, output contract, failure-card suite, and model configuration.
Keep Markdown as the human-reviewable source while a deterministic compiler
records the ordered components and final prompt hash.

### Rationale

This preserves reviewability while making prompt assembly reproducible,
testable, provider-independent, and compatible with multiple parallel
taxonomies and future subjects.

### Consequences

- Multi-subject support remains logical rather than physical.
- External pipeline services, not model self-critique, own authoritative
  verification.
- Physical Supabase design remains deferred.

### Risks / Follow-ups

- The compiler and manifest schema require a later approved implementation
  task.

## DECISION-0019 — Create a Clean Proprietary Replacement Exemplar

**Date:** 2026-06-13
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0008
**Area:** Content Operations / Rights

### Context

The rejected official-derived candidate left the authoring workflow without its
intended first MCQ exemplar.

### Decision

Create a replacement from a blank governed brief through a paid qualified tutor
who has not received the rejected candidate or its source description. The new
package must pass the complete originality, rights, scientific, teaching,
grading, accessibility, and exemplar-admission gates.

### Consequences

- The rejected candidate is not repaired or used as inspiration.
- Approval as production content does not automatically approve use as a model
  exemplar.
- `TASK-0008` owns the replacement workflow.

## DECISION-0020 — Reconcile Schemas Before Physical Database Design

**Date:** 2026-06-13
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0009
**Area:** Architecture / Data Governance

### Context

The reviewed Supabase proposals contain useful entities but use mutable content
rows, approval booleans, direct state updates, and cascade deletion that
conflict with approved governance.

### Decision

Create a conceptual reconciliation model mapping useful schema concepts to
immutable artifact versions, append-only reviews and lifecycle events,
rebuildable projections, reusable stimulus packages, and atomic release
manifests. Do not create or approve physical DDL until reconciliation passes.

Text-only visual storage is not accepted as the permanent approach. Authoring
may proceed against logical stimulus-package Markdown and JSON contracts while
physical design remains deferred.

### Consequences

- The archive schemas are inputs to analysis, not canonical schemas.
- `TASK-0009` precedes physical Supabase design.
- Structured visual work does not need to wait for DDL.

## DECISION-0021 — Develop MCQ and FRQ Authoring Simultaneously

**Date:** 2026-06-13
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0007
**Area:** Content Operations

### Context

The reviewed proposal deferred FRQ implementation until MCQ authoring reached
coverage. That sequence would delay discovery of grading, visual, and graphing
risks.

### Decision

Run coordinated MCQ and FRQ authoring workstreams simultaneously. Share
governance and infrastructure, but preserve separate package contracts and
independent gates.

All currently reviewed FRQs remain unapproved candidates. Tutors and AP Reader
Validators may edit them into new immutable versions or drop them.

### Consequences

- Neither question form blocks initial architecture work on the other.
- Candidate FRQs are not exemplars, calibration evidence, or production
  content.
- The first vertical slice includes MCQ, short FRQ, and long FRQ packages.

## DECISION-0022 — Research Paper-First Handwritten Graph Capture

**Date:** 2026-06-13
**Decision Owner:** David Bloom
**Status:** Approved for Research
**Related Task:** TASK-0011
**Area:** Product / Assessment / Accessibility

### Context

A general digital graph editor would be complex and may be less authentic than
paper graph construction.

### Decision

Prefer paper-first graphing and research a QR-linked secure phone camera flow.
The system may assist with image quality and feature extraction, but uncertain
graphs require retake or human review.

### Consequences

- Digital drawing is not the default graph-construction plan.
- Production use requires upload-security, privacy, accessibility, usability,
  and held-out grading validation.
- `TASK-0011` is a research placeholder, not implementation approval.

## DECISION-0023 — Resolve Official Exam Dates from the Exam Specification

**Date:** 2026-06-13
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** UX-001
**Area:** Product / Architecture

### Context

The first-run UX asked students to enter the date of a standardized AP exam
whose official schedule is already known to Cramapple.

### Decision

Resolve and display the official date from the active versioned exam
specification. Ask the learner to confirm registration status instead of
entering the date.

### Rationale

The exam authority, not the learner, defines the official date. Treating it as
system data removes avoidable input burden and prevents conflicting dates while
still capturing the learner-specific fact that affects reminders and planning.

### Consequences

- Learner setup stores registration status, not a user-entered official date.
- The UX supports registered, not registered yet, and unsure states.
- Missing official-date data is a system-data problem and must not be shifted
  to the learner.
- Registration itself remains outside Cramapple and occurs through a school or
  AP coordinator.

## DECISION-0024 — Use Staged Tutor and AP Reader Candidate Review

**Date:** 2026-06-13
**Decision Owner:** David Bloom
**Status:** Approved for UX Design
**Related Task:** UX-002
**Area:** Product / Content Operations

### Context

Cramapple needs a simple reviewer workflow for deciding whether original
question candidates and MCQ answer options should advance, be revised, or be
excluded.

### Decision

Use two independent tutor scores of 1 Yes, 2 Maybe, or 3 No. Sum the locked
tutor scores: aggregate 2 advances to AP Reader review, aggregate 3 reserves a
new version for modification and reassessment, and aggregate 4-6 excludes the
current version.

Use AP Reader scores of 1 Approve, 2 Edit and recycle to two tutors, and
3 Exclude. Apply the same staged review independently to each of the four MCQ
answer options after the question passes question review.

### Rationale

The model is easy to teach, preserves two independent tutor judgments, creates
a clear expert escalation, and prevents edits from inheriting approval.

### Consequences

- Any excluded answer excludes the current four-option MCQ package.
- All four answers must pass before answer review is complete.
- Edits create new immutable versions and reset the affected review.
- Every question receives two tutor difficulty labels; a question reaching AP
  Reader review receives the third label.
- Exact agreement confirms difficulty; disagreement creates a discussion item.
- This workflow decides candidate disposition and does not replace downstream
  content-governance or release gates.

## DECISION-0025 — Use a Verified Five-Stage Outside-Question Intake

**Date:** 2026-06-13
**Decision Owner:** David Bloom
**Status:** Approved for UX Design
**Related Task:** UX-004
**Area:** Product / Learning / Trust

### Context

Students may bring incomplete, photographed, copyrighted, personally
identifying, off-subject, or actively assessed questions. A single text box
does not provide enough context or trust handling.

### Decision

Use five stages: add the question, confirm capture, confirm match, choose help,
and review before beginning. Support typed/pasted, photo/screenshot, and
document concepts. Use one clarification round for missing context or relevance
and disclose confidence before teaching or grading.

### Rationale

The staged flow preserves the student's real intent while preventing extraction
errors, missing context, and uncertain classification from silently becoming
confident teaching or scoring.

### Consequences

- Check My Work requires the learner's attempted answer.
- Low-confidence matches avoid authoritative scoring.
- External questions remain isolated from canonical content.
- Anonymous improvement and public publication remain separate.
- A conservative active-assessment prototype limits solution and answer-check
  behavior, but final enforcement awaits the approved academic-integrity
  policy.
- Photo and document implementation remains blocked on upload security,
  privacy, rights, retention, and provider decisions.

## DECISION-0026 — Separate Authoring, Revision, and Independent Review

**Date:** 2026-06-15
**Decision Owner:** David Bloom
**Status:** Approved for UX Design
**Related Task:** UX-003
**Area:** Product / Content Operations / Rights

### Context

UX-002 can reserve or recycle a question or answer version, but it previously
had no designed interface where an author could receive the task, revise the
complete package, preserve provenance, and return a successor version for
reassessment.

### Decision

Use UX-003 as a content authoring and revision workbench. It owns assigned-work
acknowledgement, complete MCQ and FRQ package editing, document import,
reviewer-comment response, immutable version comparison, provenance and rights
capture, preflight, and resubmission.

Keep UX-002 as the independent scoring and disposition surface. Qualified users
may switch between modes, but cannot review work they authored, revised, or
collaborated on.

Renumber the student-provided question intake to UX-004.

### Rationale

This gives recycled review outcomes an operational destination while preserving
reviewer independence, immutable history, complete-package integrity, and
rights controls.

### Consequences

- Tutor aggregate 3, AP Reader score 2, and revision outcomes create UX-003
  tasks.
- Resubmission creates a new immutable version and returns it to the required
  reassessment queue.
- Autosaves remain drafts and are not version history.
- Reviewer comments remain immutable; authors attach responses and changes.
- Provenance and rights checks can block submission without implying counsel
  approval.
- UX-004 now identifies student-provided question intake.

## DECISION-0027 — Adopt Charter Simplification and Tiering (Pilot: Cramapple Only)

**Date:** 2026-06-23
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** N/A (governance/process)
**Area:** Operations

### Context

The AI Project Operating Kit, in production use on Cramapple and PassTo, had accumulated real friction: heavy approval ceremony routed entirely through the Product Owner, duplicated guidance across charter docs (most visibly the sync handshake, repeated near-verbatim in five files), self-reported "synced"/"done" claims with nothing checking them, and unrotated logs already running to 1,000+ lines. Two independent reviews (`docs/proposals/2026-06-14-team-charter-improvements.md` and `docs/proposals/2026-06-23-kit-simplification-memo.md`) converged on largely the same diagnosis but had six unreconciled points of conflict between them.

### Decision

Adopt, into Cramapple's `docs/team_charter/` only (the public `ai-project-operating-kit` repo is explicitly out of scope for this decision):

- The full content of `docs/proposals/2026-06-23-kit-simplification-memo.md`.
- Proposals 1, 2 (recording structure/SLA substrate, not its deferred automation), 3, 4, 5 (reconciled), 7, 8 (reconciled), and 9 of `docs/proposals/2026-06-14-team-charter-improvements.md`.
- Not adopted: Proposal 6 and Proposal 10 of the 06-14 proposal — out of scope, not depended on by the simplification memo.

Conflict resolutions (see `APPROVAL-0022` for full detail): the 6-state status taxonomy wins over keeping `QA Passed`/`QA Blocked` distinct, with Proposal 5's actual safety property (only the Main Conductor closes a task) preserved as a role rule; `APPROVALS_LOG.md` stays a separate file rather than merging into `DECISIONS_LOG.md`, since Proposal 2's structure is the substrate the new Standing-tier SLA depends on.

### Rationale

Both proposals identified the same root cause from different angles: high-stakes process machinery was being applied uniformly regardless of actual risk. The fix is conditional rigor, not less rigor — ambiguous-but-reversible work gets a clarifying question instead of an automatic hard gate; domain-specific decisions go to a named delegate instead of always to the Product Owner; small reversible work skips ceremony it doesn't need; sync claims get a real check instead of a narrated one; and the two governance docs that disagreed on six points needed to be reconciled before either was implementable, not adopted independently.

### Consequences

- Seven `docs/team_charter/` documents changed; `SKILLS_GUIDE.md` renamed to `TOOL_AND_INTEGRATION_GUIDE.md`; two new files added (`CHANGELOG.md`, `scripts/verify-sync.sh`); both new-session prompts updated; `docs/tasks/TASK_TEMPLATE.md` gained a `Tier` field; all three activity logs gained an index block and a stated (not yet executed) rotation rule.
- Existing tasks and log entries are **not** retroactively rewritten onto the new status vocabulary or tiering scheme — old entries read under the rules in force when they were written.
- The public `ai-project-operating-kit` repository is untouched. Upstreaming is a separate future decision, contingent on this pilot working in practice.

### Risks / Follow-ups

- Two leading indicators should be watched for a few weeks: hard-gate escalations per week, and QA round-trips per task. No tooling collects these automatically yet — this is currently a manual read of `APPROVALS_LOG.md` and `DECISIONS_LOG.md`.
- `DECISIONS_LOG.md` is already roughly double its newly-stated rotation threshold (~600 lines); the first archive pass is overdue and not done as part of this decision.
- Proposal 2's batch-approval expiration automation, Proposal 6, and Proposal 10 (Cross-Agent Notes) remain candidates for separate future decisions.
- This decision does not authorize pushing any of this work to `github.com/david-bloom/ai-project-operating-kit`.

## DECISION-0028 — Auto-Trigger QA and Model Routing (Codex Proposal Folded In)

**Date:** 2026-06-23
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** N/A (governance/process)
**Area:** Operations

### Context

`docs/proposals/2026-06-23-agent-routing-and-qa-proposal-for-claude.md` (Codex) observed that the charter adopted under DECISION-0027, while reducing approval ceremony, still left QA-triggering and model selection as things someone had to remember to ask for, rather than automatic workflow steps — a residual source of avoidable waiting.

### Decision

Fold into `AGENT_OPERATING_MODEL.md`:

- The Main Conductor auto-triggers QA for any `Standard`/`Hard-Gate` tier task reaching `Ready for Review`; `Micro` tier QA remains optional at the conductor's judgment.
- The Main Conductor auto-applies the Model and Effort Policy per agent call rather than asking the Product Owner to pick a model each time.
- Explicit good-use/bad-use guidance for spawning additional agents, and three new Anti-Patterns reflecting the above.

The proposal's guardrail requiring the orchestrator to record which model was used and why on every call was narrowed to: record only on deviation from the default tier.

### Rationale

Auto-triggering QA and model selection removes waiting without removing any approval boundary — QA was already Lane 1 standing-approved, this just makes it fire automatically instead of on request, and model choice was never itself a hard-gated decision. Recording every routine model choice would have reintroduced exactly the ceremony DECISION-0027 was trying to remove; recording only deviations keeps the audit trail useful instead of noisy.

### Consequences

- `AGENT_OPERATING_MODEL.md` gains explicit auto-trigger language in the Main Conductor and QA Agent sections, a narrowed recording requirement in Model and Effort Policy, agent-spawning good-use/bad-use guidance in the Default Pattern section, and three new Anti-Patterns.
- No change to any Hard Gate, Standing Approval Lane, or Delegated Domain Approval boundary from DECISION-0027 — this decision is additive process automation, not a new approval grant.

### Risks / Follow-ups

- If auto-triggered QA produces a backlog of QA work outpacing available QA-agent capacity, revisit whether `Standard` tier should auto-trigger QA at the same rate as `Hard-Gate` tier, or whether `Standard` should batch.
- Same success metrics as DECISION-0027 (hard-gate escalations/week, QA round-trips/task) apply; no new metric introduced for this decision specifically.

## DECISION-0029 — ALLOWED_ORIGINS Required in All Environments; No Wildcard CORS Fallback

**Date:** 2026-06-21
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0012
**Area:** Security

### Context

PR #14 introduced an `ALLOWED_ORIGINS` env-driven allow-list in
`supabase/functions/_shared/cors.ts`. The first cut kept a wildcard
fallback (`Access-Control-Allow-Origin: *`) when the env was unset, on
the rationale that dev / local convenience was worth the production risk
of a missed deployment checklist item.

QA flagged the wildcard fallback as a real production footgun. With no
code-level guard, a production deploy without `ALLOWED_ORIGINS` would
silently send `*` and weaken defense-in-depth against CSRF-style abuse
from rogue origins.

### Decision

`ALLOWED_ORIGINS` is required in every environment (production, beta,
preview, local dev). The Edge Function `_shared/cors.ts` module fails
fast at load time if the env is unset or parses to an empty list. There
is no wildcard fallback path in the code.

Local-dev convention:

```
ALLOWED_ORIGINS=http://localhost:5173,http://localhost:3000,https://cramapple-beta.lovable.app
```

### Rationale

- Production wildcard CORS is a real risk; the dev cost of setting one
  env var is trivial.
- Eliminating the conditional removes a class of operational error
  (forget the checklist item, ship wildcard to prod).
- Non-browser callers (curl, server-to-server, CI) don't need CORS
  headers and are unaffected by the strict policy.

### Consequences

- All Cramapple deploys (Supabase Edge Functions in production and dev,
  any future preview environment, local Supabase) must set
  `ALLOWED_ORIGINS` before functions can start. The function will throw
  `Missing required environment variable: ALLOWED_ORIGINS` at module
  load otherwise.
- The `corsHeaders` legacy export with `Access-Control-Allow-Origin: *`
  has been removed; nothing in the repo imported it.
- The deployment checklist gains one mandatory env var per environment.

### Risks / Follow-ups

- First-time local-dev setup must include the env. Document in any
  developer-onboarding instructions (no such doc exists yet — when one
  lands, the env example above belongs in it).
- Future preview / staging environments need their origins added.
- This decision does not address Decision 2 (failed/rejected grading
  and the daily budget cap), which remains pending owner direction.

## DECISION-0030 — Failed/Rejected Grading Burns the Daily Budget Cap When Cost Is Known

**Date:** 2026-06-22
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0012
**Area:** Cost control

### Context

`app.complete_model_usage` (introduced in `202606210004_daily_budget_row_lock.sql`)
burned `actual_cost_usd` against `OPENAI_DAILY_CAP_USD` only when a
grading call completed successfully. Any `failed` or `rejected`
outcome burned `0`, regardless of whether the provider call had
already incurred a real, known cost (e.g. OpenAI returned a billable
response but Cramapple's own downstream validation then rejected it).
This under-counted real spend against the daily cap.

### Decision

`app.complete_model_usage` now burns cost as follows:

- `completed` — burns `actual_cost_usd` (unchanged).
- `failed` / `rejected` with a non-null `actual_cost_usd` — burns
  `actual_cost_usd`.
- `failed` / `rejected` with a null `actual_cost_usd` — burns `0`
  (caller has no cost data to report; the provider call may never have
  happened).

Implemented in
`202606210010_complete_model_usage_burn_known_cost_on_failure.sql`.
Reservation-release behavior (`reserved_cost_usd` reduction on the
`app.daily_budgets` row) is unchanged.

### Rationale

- `OPENAI_DAILY_CAP_USD` should track real provider spend, not just
  spend on calls that happened to finish cleanly. A failed call that
  still cost money is still money spent.
- Burning `0` only when the cost is genuinely unknown avoids inventing
  a cost figure for calls that never reached the provider.

### Consequences

- Grading calls that fail after the provider responds (with usage
  data) now reduce remaining daily budget headroom.
- `supabase/functions/evaluate-attempt/index.ts` is unaffected by this
  migration — it already passes whatever `actual_cost_usd` it computed
  (defaulting to `0` if the provider call never returned usage), so no
  Edge Function change was required.

### Risks / Follow-ups

- Failed rows that complete with a null `actual_cost_usd` are not
  reconciled against provider billing by this migration. That
  reconciliation should happen during production monitoring — compare
  `app.model_usage_ledger` against the OpenAI usage dashboard/API — not
  be guessed at here.
- No real Postgres instance was available to apply this migration
  (Docker/Colima/Podman unavailable in this environment); verification
  was `deno check` / `deno fmt --check` (no Edge Function files
  changed) plus manual schema cross-reference against
  `202606210004_daily_budget_row_lock.sql` and
  `202606210008_reserve_model_usage_race_fix.sql`.

## DECISION-0031 — Launch AP Statistics as Subject 2, Reusing the Tutor-Authored Content Model

**Date:** 2026-06-30
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0013
**Area:** Product / Architecture / Operations

### Context

Cramapple's architecture was designed for multiple subjects
(`CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §6, `app.subjects` schema
normalization) but only AP Biology is built and live. David requested an
assessment of which AP subject — among AP Statistics, AP Calculus AB, and AP
English Literature (Orly's subjects this year) and AP World History (Micah's)
— is the closest technical match to AP Biology, then asked for a launch plan.

### Decision

1. AP Statistics is Subject 2. It ranked closest to AP Biology on
   grading-architecture reuse: criterion/rubric-scored FRQs with quantitative
   thresholds (same scoring shape as Biology's FRQ criterion contracts), and
   it needs a verification technique (deterministic calculation checks)
   already named but unbuilt in §7, rather than a wholly new grading
   paradigm (e.g. holistic essay scoring, which AP English Literature would
   require).
2. Content sourcing reuses the existing tutor-authored-base-package model
   (TASK-0007/0008) under Orly — no new authoring arm.
3. The pilot content batch follows AP Statistics' 9-unit structure with
   per-unit MCQ/FRQ counts David provided (71 MCQs / 33 FRQs total across
   units 1–9; investigative-task form and count still TBD — see
   `TASK-0013-AP-STATISTICS-LAUNCH.md` Approval State for the full table).
4. Existing reviewers can be cross-credentialed across subjects, including
   AP Statistics — no new tutor pool required for the review/calibration
   pipeline.
5. Rights/licensing posture is unchanged from AP Biology: no official
   CollegeBoard material as model input or exemplar. This was already
   settled policy and is restated here for the record, not reopened.

Full phased delegation plan (Codex / Lovable / Orly / David) recorded in
`docs/tasks/TASK-0013-AP-STATISTICS-LAUNCH.md`.

### Rationale

Maximize reuse of the grading/verification investment already made for AP
Biology, and avoid opening a new content-ownership or tutor-credentialing
relationship at the same time as a new subject.

### Consequences

- Phase 1 (de-hardcoding `grade-frq`/`evaluate-attempt` away from literal "AP
  Biology" strings, wiring the prompt-build manifest to `subject_id`) is
  cleared for Codex to execute — it was the one piece blocking any second
  subject regardless of which one was chosen.
- The investigative-task archetype is not yet defined and blocks Phase 4
  content authoring for that item type specifically; it does not block the
  MCQ/FRQ portions of the pilot batch.
- No target date is set for the pilot batch yet — pending Orly's bandwidth
  confirmation alongside ongoing AP Biology work.

## DECISION-0032 — Authorize TASK-0013 Phase 2 Database Migration (AP Statistics Schema)

**Date:** 2026-06-30
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0013
**Area:** Architecture / Operations

### Context

`TASK-0013`'s overall Hard-Gate approval (`DECISION-0031`) covered subject
selection, content-sourcing model, and pilot batch composition — it did not
cover the Phase 2 database migration itself. `STANDING_APPROVAL_LANES.md`
Lane 3 lists database migrations as their own Hard Gate, separate from
"implementation not already covered by an approved task," so Phase 2's
migration (`prompts/CODEX_AP_STATISTICS_PHASE2_SCHEMA_INSTANTIATION.md`)
was drafted but explicitly marked do-not-execute pending a separate
sign-off.

### Decision

David authorized the Phase 2 migration to proceed, in the same exchange
where Phase 3 (PR #24) was confirmed merged. Scope: one additive,
idempotent migration inserting an `app.subjects` row for AP Statistics, an
`app.exam_packs`/`exam_pack_versions` pair (version `status: 'draft'`, not
`'published'`), and `app.content_labels` rows for the 9 AP Statistics units
— exactly as scoped in the Phase 2 prompt. No other migration is authorized
by this decision.

### Rationale

Phase 1 (subject-driven grading) and Phase 3 (calculation verifier) are
both complete and merged with passing independent QA. The schema work is
additive-only and was deliberately scoped (draft status, no publish) to
stay inert until content actually exists, so the blast radius of proceeding
now is low.

### Consequences

- `prompts/CODEX_AP_STATISTICS_PHASE2_SCHEMA_INSTANTIATION.md`'s
  do-not-execute condition is satisfied; Codex is cleared to execute it.
- Phase 4 (content authoring) unblocks once Phase 2 lands.
- This decision does not authorize publishing the exam pack, content
  labels, or any content — that remains a separate decision per the
  prompt's explicit scope boundary.

## DECISION-0035 — Resolve Phase 0 of the Backend Consolidation Migration (Schema Reconciliation, Option A/A2)

**Date:** 2026-07-09
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** N/A (Backend Consolidation & Migration Plan, 2026-07-08)
**Area:** Architecture / Integration

### Context

The live Lovable app (Supabase project `tazjfzphsevtgervlyit`, `public.*`, ~26
tables) and Production (`pcntajvbdfqhbeewmdry`, `app.*`, ~60 tables, RPC/view
design) are two independently-built, diverged schemas — the root cause of
"published content doesn't appear in the app." The plan
(`docs/architecture/BACKEND_CONSOLIDATION_MIGRATION_PLAN_2026_07_08.md`, with the
mapping in `APP_SCHEMA_RECONCILIATION_2026_07_08.md`) already chose **Option A /
A2**: adapt the app to the `app` schema via a curated `public` interface (views
for reads + `supabase.rpc(...)` for writes), not a table-for-table env flip.
Phase 0 (decisions only) blocked all downstream work and was reserved for the
Product Owner. This entry resolves it.

### Decision

1. **Review workflow →** the reviewer UI targets **`content_review_*`**
   (content-version review: `app.content_review_assignments` /
   `content_review_decisions`), not the artifact-review `review_*` tables.
2. **Auth users →** **start fresh** in Production; the Lovable-Cloud users on
   `tazjfzphsevtgervlyit` do NOT carry over (treated as pre-beta/test accounts).
3. **Anonymous practice →** **No** — require sign-in on prod. Drop
   `anonymous_sessions`; curated views grant only `authenticated` (no `anon`).
4. **App AI keys →** move the app's own AI features to **`OPENAI_API_KEY`**
   (already set), off the Lovable AI Gateway. (Distinct from the grading runners'
   Vercel AI Gateway, which is unchanged.)
5. **Gap tables →** `config`: **add a small `app.config`** KV table (exposed via a
   curated read view). Drop `anonymous_sessions`, `capture_sessions` (re-add when
   the TASK-0011 capture path lands), `idempotency_keys` (use
   `grading_results.request_id/request_hash`), and `predictions` (embedded in
   `grading_results`). Adapt the app to the **`blind_group_id` column** instead of
   a `review_blind_groups` table. **Rebuild the 6 `dashboard_*_v1` views** as
   `public` views over `app`.

### Rationale

Each choice minimizes surface and churn for an Aug-2026 beta: `content_review_*`
matches a pre-launch content-vetting reviewer UI; fresh auth avoids a `pg_dump`
migration of throwaway accounts; sign-in-only shrinks the public API surface;
`OPENAI_API_KEY` decouples the app's AI from Lovable now that the key exists; the
gap-table dispositions follow the schema's existing design (idempotency and
predictions already live in `grading_results`; blind grouping is already a
column).

### Consequences

- **Unblocks Phase 1** (Codex: build the curated `public` interface — views +
  RPC confirmation over `app`, incl. `app.config` and rebuilt `dashboard_*_v1`)
  and **Phase 2** (Lovable: repoint to the curated interface, native Supabase
  Google OAuth, `.env`/`config.toml` → Production).
- Docs `BACKEND_CONSOLIDATION_MIGRATION_PLAN_2026_07_08.md` §7 and
  `APP_SCHEMA_RECONCILIATION_2026_07_08.md` gap table updated to "resolved."
- Phase 1 build spec captured in
  `prompts/CODEX_BACKEND_CONSOLIDATION_PHASE1_CURATED_INTERFACE.md`.

### Risks / Follow-ups

- "Start fresh" auth assumes the current Lovable-Cloud users are not real
  beta users with data to preserve — reconfirm before disabling Lovable Cloud.
- `content_review_*` pick should be validated against the actual reviewer UI
  routes during Phase 2; if the UI also grades artifacts, revisit (the "both"
  option was declined).
- Migration docs and this decision originate on branch
  `claude/backend-consolidation-migration` (off `main`). `main` is at
  DECISION-0032; branches for DECISION-0033/0034 are outstanding. If numbering
  collides on merge, renumber whichever merges second and update the index.

## DECISION-0036 — Approve TASK-0010 Grader Confidence and Calibration Program

**Date:** 2026-07-12
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0010
**Area:** Product / Learning Quality / Grading

### Context

`TASK-0010` has sat at `Proposed` since 2026-06-13 — a six-phase program
(rubric/development cases, adjudicated gold sets, locked evaluation, shadow
operation, limited release, continuous monitoring) required before any
learner-facing automated FRQ score, per `NOW-013`. The same session that
requested this approval also shipped `TASK-0016` Phase A (deterministic
layer + existing single-call grader) directly to Production for tutor
visibility, ahead of this program's completion — see
`docs/activity_log/ACTIVITY_LOG.md`, 2026-07-12 entries, for that separate
decision and its scoping.

### Decision

Approve `TASK-0010` to move from `Proposed` to active execution. The
program in the task file — Phases 1 through 6 — is authorized to proceed
as written.

### Rationale

The Phase A ship decision creates real, immediate pressure to have this
program actually running rather than sitting proposed: tutors are now
looking at live deterministic + LLM grading output, and this program is
the mechanism that turns their observations into adjudicated gold labels,
calibrated confidence, and an eventual real release gate — rather than
tutor feedback accumulating with no formal process to act on it.

### Consequences

- `TASK-0010` status: `Proposed` → `Approved`. `NOW-013` and the
  `MASTER_TODO.md` Active Task Register row move to `In Progress`.
- Does **not** mark any of `TASK-0010`'s eleven acceptance criteria as met —
  none are. This is authorization to execute the program, not a Done
  decision, and not itself a launch decision.
- Does **not** satisfy `NOW-013`'s learner-facing-automated-scores gate,
  which still requires Phase 4 (shadow cohort) and Phase 5 (limited
  release) to actually pass.
- Does **not** retroactively expand the Phase A tutor-visibility ship
  decision to general student-facing release — those remain two separate,
  independently-scoped decisions made the same day.

### Risks / Follow-ups

- No Learning Quality Owner or Grading Lead has been named yet (task file
  lists the role, not a person) — Phase 2's "two qualified Grading
  Validators" and "Lead Grading Validator adjudicate" requirements can't
  start without someone actually filling those roles.
- The stuck FRQ02 cases (`S020`, `S028`, `S068`) and suspected corpus-label
  inconsistencies (`S014`, `S054`, `S058`, `S062`, `S070`) flagged in
  `docs/research/frq_grading_status_2026-06-18.md` are ready-made Phase 2
  adjudication-queue material — good first real work for this program
  once staffed.
