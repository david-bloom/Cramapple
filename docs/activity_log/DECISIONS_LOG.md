# Decisions Log

This log records product, architecture, operating, security, design, and workflow decisions.

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
