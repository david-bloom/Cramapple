# Decisions Log

This log records product, architecture, operating, security, design, and workflow decisions.

## Index

Most recent entries (full chronological list follows below):

- DECISION-0041 — Accept the DECISION-0039 Consequence: TASK-0010 Grading Calibration Is on the Critical Path to ANY Publish
- DECISION-0040 — Ratify TASK-0009 Fast-Track Conceptual Slices (H1 item-package/archetype identity; H2 multi-scheme taxonomy)
- DECISION-0039 — Approve TASK-0017 H0/H1 Design + P0 Publication Repair (repository/local-verification stage; no environment application)
- DECISION-0038 — Approve TASK-0009 Schema-Governance Reconciliation Scope (with conditions)
- DECISION-0037 — Open TASK-0017 (Subject-Onboarding Harness); Publication-Trust P0 Repair; Gate-Waivability, Canonical-Record, and School-Year Policy
- DECISION-0036 — Anthropic Multi-Model Cascade Leads AP Statistics 2026-27 Content Rebuild
- DECISION-0035 — August Pilot May Launch Without Tutor Content Review
- DECISION-0034 — Adopt Five Grading Standards (Boundary Contracts, Gold-Set Depth, Deterministic Layer, Feedback-Quality Evaluation, Single-Grader Default)
- DECISION-0033 — Publish and Publicly Expose Unreviewed AP Statistics Content for Feedback and Tutor Recruiting
- DECISION-0032 — Authorize TASK-0013 Phase 2 Database Migration (AP Statistics Schema)
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

## DECISION-0033 — Publish and Publicly Expose Unreviewed AP Statistics Content for Feedback and Tutor Recruiting

**Date:** 2026-07-01 through 2026-07-03
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0013
**Area:** Content Governance / Product

### Context

`TASK-0013` Phase 4's authoring brief (`docs/product/AP_STATISTICS_PHASE4_CONTENT_AUTHORING_BRIEF.md`)
states pilot content gets "the same originality, scientific/statistical,
and teaching/grading gates Biology content goes through — no shortcut for
being 'just a pilot.'" As of 2026-07-01, 48 AP Statistics items (18
Claude-generated MCQs, 18 David-supplied short FRQs, 12 Codex-generated
hand-drawn graph-response FRQs) existed with zero tutor/reader review and
zero formal rights-clearance record (`content_item_versions.review_status`
null on all items; no `app.rights_records` row for any of them). This
decision retroactively records three related, previously chat-only
instructions as durable governance, per `feedback_governance`'s "chat-only
decisions don't count" rule.

### Decision

1. **Publish despite no tutor review (2026-07-01).** David instructed
   directly: "fix the errors and publish." 36 of the 48 items (the MCQ and
   short-FRQ smoke batch) were promoted from `content_ingest_rows` staging
   into the live `content_items`/`content_item_versions` tables
   (`status = 'published'`), after two confirmed computational errors were
   found and fixed by independent recomputation (see
   `docs/research/ap_statistics_phase4_mcq_smoke_batch_2026_07_01/README.md`).
   `content_item_versions.review_status` was deliberately left `NULL`
   rather than fabricated, and no `app.release_candidates`/`rights_gate`
   assertion was written, since neither was true. The remaining 12
   hand-drawn graph-response items were staged only (per explicit
   instruction that tutors would review those before publish) and remain
   in `content_ingest_rows`, not yet promoted.
2. **Rights/originality clearance is not a blocking concern for this
   content (2026-07-03 clarification).** David: "Rights/originality
   clearance is not an issue. By rule we are not using College Board
   questions." This restates, rather than reopens, the rights posture
   already settled in `DECISION-0031` ("no official CollegeBoard material
   as model input or exemplar") and the general policy in
   `CONTENT_GOVERNANCE_AND_VALIDATION.md`: because all AP Statistics
   content is independently authored synthetic material by construction,
   not derived from copyrighted CollegeBoard exam content, the
   infringement risk the formal `rights_records`/`rights_gate` process
   exists to catch does not apply here. This does **not** mean the formal
   DB-level rights gate has been run (it hasn't, and the `content_gate`
   comment in `supabase/functions/admin-content/index.ts:156-186` about
   client-asserted-but-unverified gates still stands as a real system gap)
   — it means the underlying risk is judged not present for this specific
   content by policy, so the absence of that DB record is not itself a
   blocker.
3. **Show it as live/selectable on the public site despite no review
   (2026-07-03).** David: "we are showing cramapple to students and tutors
   and so need the site to look live even though payment is not live and
   tutors and readers have not reviewed. this is necessary for user
   feedback and tutor recruiting." This authorizes
   `prompts/LOVABLE_SIGNUP_DYNAMIC_SUBJECTS.md`'s design: AP Statistics
   renders as "Available" (not "Coming Soon") on `/signup`, selectable by
   real external users, specifically because real payment processing is
   not currently live site-wide (no financial exposure) and because
   showing it to tutors is part of how it gets reviewed. This is a
   deliberate, scoped exception — it does not authorize marketing AP
   Statistics as launch-ready, does not authorize enabling real payment
   for it, and does not extend to any other unreviewed subject without a
   separate decision.

### Rationale

Cramapple's stated near-term need (per this decision) is user feedback and
tutor recruiting, not a commercial AP Statistics launch. With payment not
live, the actual risk surface of showing unreviewed content is bounded —
no student can be charged for it, and the tutors seeing it are exactly the
population meant to review it. The rights concern is resolved by the
project's standing no-official-material authoring policy, not by this
decision creating a new exception.

### Consequences

- AP Statistics MCQ/short-FRQ content (36 items) is live and gradeable in
  Production without tutor review. The 12 hand-drawn graph-response items
  remain staged, not published, pending tutor review as originally
  instructed.
- `/signup` may render AP Statistics as purchasable-looking even though no
  real purchase should be expected to complete meaningfully differently
  from Biology's current (possibly also non-live) payment state — see the
  open question this raises about Biology's own `evaluate-attempt` publish
  gate, tracked separately, not resolved by this decision.
- This decision does **not** constitute a Done decision, a QA pass, or a
  production launch approval for AP Statistics per `feedback_governance`'s
  Definition of Done — tutor review, rights-gate formalization (if ever
  desired), and a genuine launch-readiness review remain separate, future
  decisions.
- Test reviewer accounts (`tutor-a`, `tutor-b`, `reader-a`,
  `admin@cramapple-test.internal`) were disabled (`auth.users.banned_until`
  set to 2099, not deleted — deletion was blocked by real historical
  `content_review_assignments`/`content_review_decisions` rows that would
  have cascade-deleted) ahead of real tutors being recruited under this
  decision.

## DECISION-0034 — Adopt Five Grading Standards (Boundary Contracts, Gold-Set Depth, Deterministic Layer, Feedback-Quality Evaluation, Single-Grader Default)

**Date:** 2026-07-08
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0010, TASK-0005
**Area:** Architecture

### Context

A second-opinion assessment of Cramapple's grading approach reviewed the vision,
the research canonical process and reporting standard, the governance/calibration
gates, and the actual experimental evidence across AP Biology (the deep FRQ02
investigation), AP Statistics, and AP Chemistry. The strongest, most-repeated
finding across every isolated test was that rubric-boundary precision — not model
size, routing, escalation, exemplar retrieval, or flywheel volume — is the
dominant grading-quality lever, yet that finding lived only in scattered research
reports. Related findings: deterministic zero-cost checks catch error classes
model confidence cannot; feedback quality (the product's actual promise) was not
being measured; and the only decision-grade evidence was a single question
against a provisional corpus with suspected label defects.

### Decision

Adopt five standards for the grading program and record them in the durable docs:

1. The **criterion-boundary contract is a required, authored artifact** for every
   FRQ criterion, authored with the rubric and sharpened (not invented) during
   calibration. A criterion without one is an incomplete package that cannot
   enter validation.
2. **Redirect research effort from breadth to depth** — one fully-adjudicated AP
   Biology gold set before further synthetic breadth corpora; corpora carry an
   explicit tier label and only adjudicated/held-out evidence may support quality
   claims.
3. Ship a **required per-subject deterministic-check layer**, declared in a
   `verification_profile`, run independently of the model and version-pinned to
   the grading result.
4. **Measure feedback quality** — grounding, minimum-fix sufficiency, and
   error-classification accuracy — in every grading experiment, not only the
   criterion earned/not-earned decision.
5. Make the **single fast grader + boundary contract + deterministic checks the
   default runtime**; retire confidence-triggered escalation, fallback ensembles,
   and reference layers from the default; use multiple models only as boundary
   auditors.

This decision changes documentation and standing research/engineering direction.
It does not by itself approve any content for launch, close TASK-0010, accept
quality risk, or ratify the numeric §12.3 release thresholds (still to be tested
against the first real adjudicated gold set).

### Rationale

The evidence base is cited in `docs/research/grading_cross_subject_takeaways.md`
(the new durable home for these lessons). Several of these concepts already
existed in partial form in the docs (§9 named boundary contracts as "preferred";
§12.3 already carried feedback thresholds; §7 listed deterministic checks); this
decision elevates them to required and wires the research evaluation layer to the
governance requirements so the lessons stop being re-derived.

### Consequences

- Docs updated: `CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` (§7.1, §7.2, §9.1;
  Last Updated bumped), `CONTENT_GOVERNANCE_AND_VALIDATION.md` (v0.2, §10.5),
  `TASK-0010` (adopted-standard section + acceptance criteria),
  `GRADING_RESEARCH_CANONICAL_PROCESS.md` (standing direction, corpus tiers,
  feedback evaluation), `grading_packet_backlog_2026_07_07.md` (superseding
  depth-first priority).
- New artifacts: `docs/research/grading_cross_subject_takeaways.md` and
  `docs/research/AP_BIOLOGY_VERIFICATION_PROFILE.json`.
- The boundary contract becomes a blocking FRQ package element; existing
  candidate FRQs without one are incomplete until it is added.

### Risks / Follow-ups

- The FRQ02-derived lessons need replication on other criteria and a second
  subject before being treated as fully general (assessment next-experiment #1).
- The §12.3 thresholds may prove infeasible; that is tested by follow-up #2 (one
  adjudicated gold set), which is now the top research priority.
- Grading tail-latency (escalation's 8-11s outliers vs. the brand-critical
  exam-week window) remains an open product decision, not resolved here.
- Index note: this entry is DECISION-0034 on branch
  `claude/ap-statistics-mcq-short-frq-prompts`; if another branch also claims
  0034, renumber whichever merges second and update the index.

## DECISION-0035 — August Pilot May Launch Without Tutor Content Review

**Date:** 2026-07-12
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** Cross-cutting — tutor content-review workstream, `docs/research/TUTOR_CONTENT_ASSESSMENT_PILOT_2026_07_12.md`
**Area:** Content Governance / Product

### Context

The tutor content-review pipeline was repaired and verified functional on 2026-07-12 (see `ACTIVITY_LOG.md`'s "Tutor Content-Review Pipeline Repaired..." entry), and a full QA pass fixed 17 confirmed defects across all 200 draft MCQs and 254 draft FRQs. Despite that progress, actual onboarding and assignment of the two hired tutors against real content is not confirmed done, and no adjudicated tutor sign-off exists for either subject's launch corpus. With an August pilot target, tutor review was at risk of being the blocking gate.

### Decision

David: "We may launch the August pilot without tutor review. This is my decision." The August pilot launch is authorized to proceed without completed expert tutor content review as a precondition, at the Product Owner's discretion.

### Rationale

Not separately elaborated beyond the owner's direct instruction. Consistent with `DECISION-0033`'s precedent (AP Statistics MCQ/short-FRQ content was published live without tutor review on 2026-07-01, David accepting that risk after being told what it skips) — this decision generalizes the same owner override to the August pilot as a whole, across both subjects.

### Consequences

- Tutor content review (onboarding the two hired tutors, running assignments, collecting `tutor_clear` outcomes) is **not** a hard gate for the August pilot. It remains valuable and should continue, but its completion is not a precondition David requires before launch.
- This does not retroactively validate content as reviewed, does not close the content-governance requirement that expert sign-off is normally a launch gate (`CONTENT_GOVERNANCE_AND_VALIDATION.md`), and does not extend to grading-side gates (TASK-0010 gold-set adjudication, PR #38 deployment, launch-bar measurement) — those remain separate, ungated by this decision.
- Per `feedback_governance`'s "QA-pass ≠ launch approval" rule: the 17-defect QA fix pass and pipeline repair are QA work, not a substitute for tutor review; this decision is what actually removes tutor review as a blocking requirement, not the QA pass itself.
- `docs/research/TUTOR_CONTENT_ASSESSMENT_PILOT_2026_07_12.md` was updated the same day to mark its operational-status claims stale and to point here.

## DECISION-0036 — Anthropic Multi-Model Cascade Leads AP Statistics 2026-27 Content Rebuild

**Date:** 2026-07-13
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** Cross-cutting — TASK-0013 (AP Statistics), relates to TASK-0016 (grading engine), `DECISION-0034`, `DECISION-0035`, `DECISION-0031`
**Area:** Content Governance / Product / Process

### Context

The AP Statistics *Course and Exam Description, Effective Fall 2026* (exam May 2027 — the Aug-2026-beta cohort's actual exam) restructures the course: 9 modules → 5 units, FRQ section 6×~4pt → 4×10pt multi-part questions, 42 MCQ + 4 FRQ, and two topics Cramapple currently covers (inference for the regression slope; chi-square goodness-of-fit) do not appear in the new unit list. Cramapple's existing Stats content is largely mis-shaped for this exam and needs rebuilding under time pressure. David expanded the Anthropic subscription specifically to have Anthropic models lead complex-reasoning and content-execution work.

### Decision

1. **Anthropic models lead AP Statistics content authoring for this rebuild.** This is a deliberate shift from the tutor-authored base-package model (`DECISION-0031`, TASK-0005/0007/0008) for this specific workstream, made explicitly by the Product Owner — not backed into via tooling.
2. **Adopt a corrected multi-model cascade** (documented in `docs/product/AP_STATISTICS_2027_CONTENT_REBUILD_ORCHESTRATION.md`): **Opus 4.8** (`claude-opus-4-8`) authors items, criterion-boundary contracts, and student repair text, and also runs the correctness verification as an independent, adversarially-framed pass with fresh context; **Sonnet 5** (`claude-sonnet-5`) runs conformance/schema checks and bulk mechanical transforms; **Haiku 4.5** (`claude-haiku-4-5-20251001`) catalogs and reports. The strongest model's correctness output is never screened by a lighter model.
3. **Codex is the independent reviewer** — a plan review before authoring (Gate G1) and an independent QA pass on staged output (Gate G3), separate from the in-cascade Opus verifier.
4. **Two orchestrations are defined:** (A) item re-creation to the 5-unit / 4×10pt structure; (B) rubric-block (criterion-boundary contract) and student-facing repair refresh, including a sync of the AP Statistics deterministic verification profile.

### Rationale

Speed to the Aug 2026 beta with the new exam shape, using the capability David is paying to lead this work. The cascade is shaped to avoid the obvious failure mode (screening the strongest model's statistical output with a weaker QA model) by keeping correctness verification at Opus tier and independent, consistent with `DECISION-0034`'s emphasis that a precise rubric contract, not raw model size, is the main quality lever.

### Consequences / guardrails (unchanged and binding)

- **AI output is candidate content, not cleared content.** The cascade writes only to staging (`content_ingest_batches`/`content_ingest_rows`); it does not satisfy the content-quality launch gate. Clearing is human tutor review (`TUTOR_REVIEWER_QUICKSTART.md`) **or** an explicit `DECISION-0035` waiver recorded per batch — never assumed because the models QA'd it (`feedback_governance`: QA-pass ≠ launch approval).
- **No auto-publish.** Promotion to `status='published'` remains a separate Product-Owner-gated action (Gate G5).
- **No College Board material** as model input, exemplar, or seed (`DECISION-0031`/`0033`) — the CED is used for structure/standards only, not item content.
- **Every FRQ criterion requires an authored boundary contract** (`DECISION-0034` standard 1); the deterministic verification layer is version-pinned to match (standard 3).
- **Blocked on curriculum lock (Gate G0, Orly):** final unit/topic map, the slope-inference and chi-square-GOF in/out call, per-unit counts, and FRQ blueprints are prerequisites. The orchestration is documented and ready but is **not yet run** pending G0 + G1.
- This decision authorizes the *authoring process*; it does not approve any specific content, close TASK-0013, or accept content-quality risk beyond what `DECISION-0035` already records.

### Update 2026-07-13 — Codex G1 review: return for revision, then approve

Codex performed the independent G1 plan review and endorsed the executive change (Claude leads Stats curriculum authoring; Codex stays independent reviewer/QA, not a competing author). Verdict: **return for targeted revision, then approve.** The orchestration spec was revised to **v2** incorporating Codex's required corrections; the decision stands with these tightened guardrails now binding:

- The **five removed topics are confirmed College Board facts** (verified against the CB revision page 2026-07-13): departures-from-linearity (2.9), combining random variables (4.9), geometric distribution (4.12), chi-square goodness-of-fit (8.2/8.3), and inference for slopes (old Unit 9). Residual plots/curvature **remain** (new Topic 5.4). This corrects v1's "unconfirmed-removed" framing.
- Authoring input is a **human-reviewed CED fact pack**, never the full CED PDF (which contains official questions/scoring guidelines).
- **Curriculum authoring (Claude) is split from verifier implementation (Codex/TASK-0016):** the cascade emits a verifier-requirements manifest and does **not** edit `statistics-verifier.ts` or production verifier config.
- Added **G−1 containment** (freeze + classify/dispose current corpus, incl. live removed-topic items) and a separate **G4B grading-clearance gate** — `DECISION-0035` waives tutor review, not grading calibration.
- **Deterministic scripts** own counts/coverage/numeric recomputation; Haiku is narrative-only; a **vertical slice** must clear Codex review before any bulk generation.
- v1 and the reviewer quickstart were flagged by Codex as **uncommitted local changes** — durability in GitHub (source of truth) is a pending action, at David's direction.
- Seven open scope questions (inventory target, live removed-topic disposition, supplemental policy, app-vs-API, keying, waiver scope, fact-pack drafting) are recorded in the spec for David; several block bulk execution, none block drafting the fact pack or the vertical slice design.

## DECISION-0037 — Open TASK-0017 (Subject-Onboarding Harness); Publication-Trust P0 Repair; Gate-Waivability, Canonical-Record, and School-Year Policy

**Date:** 2026-07-13
**Decision Owner:** David Bloom
**Status:** Approved (task opened; design approval still required before Dev migrations)
**Related Task:** TASK-0017 (new), relates to TASK-0016, TASK-0014/0015, TASK-0009, `DECISION-0036`, `DECISION-0035`, `DECISION-0034`
**Area:** Architecture / Content Governance / Publication Trust

### Context

Following the AI-led content-authoring shift (`DECISION-0036`), the dominant repeat-work cost for launching a new subject (or a new annual exam version) is the hand-built per-subject machinery: schema/taxonomy instantiation, ingestion/staging, deterministic verification, reviewer qualification, and publication gating. Codex reviewed the proposed reusable-harness prompt and returned a detailed set of required structural revisions plus a verified P0 publication-trust defect. David resolved the open decisions.

### Decision

1. **Open TASK-0017 — Reusable Subject-Onboarding Harness** as a Hard-Gate task, design-approval-first (`docs/tasks/TASK-0017-SUBJECT-ONBOARDING-HARNESS.md`). Implementation is Codex's lane; content authoring stays Claude's (`DECISION-0036`); calibration stays Claude + Learning Quality.
2. **Publication-trust P0 repair, first.** `admin-content` `changeArtifactState` flips `content_items`/`content_item_versions` to `published` before validating the release manifest and gates, non-atomically — a rejected publish can leave content served/gradeable (verified 2026-07-13, `supabase/functions/admin-content/index.ts` ≈ lines 638–660 vs 663–714). Repair: compute eligibility server-side from authoritative evidence, apply state/serving/manifest/release atomically with rollback, prove reviewed-version == activated-version, add a regression test.
3. **Gate-waivability policy:** publication eligibility is evidence-derived. A Product Owner may waive **content-clearance only** (tutor/content review — consistent with `DECISION-0035`) with a recorded exception. **Grading/calibration, rights, and security/privacy gates are never waivable.**
4. **Canonical question-version record (v1) = `content_item_versions.id`** (serving, review, attempts, grading, release manifests all reference it). `artifact_versions` (0 rows in Production) is not resurrected as a parallel canonical record; any consolidation is `TASK-0009`'s call.
5. **Canonical school-year identifier uses academic-year form (`YYYY-YY`) derived from the official exam date.** A legacy `"2026"` row with a May 2026 exam becomes `2025-26`; a May 2027 exam becomes `2026-27`; do not blanket-map `"2026"`.
6. **AP Chemistry (TASK-0014) / AP Physics (TASK-0015)** adopt the harness once ready; no net-new bespoke scaffolding for them in the meantime (not paused, no new one-offs).
7. **Harness supports both** `create-subject` and `create-exam-pack-version` (annual revision preserving historical taxonomy/labels/content/attempts/calibration).
8. **Deprecate the legacy manifest name.** `exam_pack_manifests.artifact_version_ids` is not the durable canonical name for v1 content-version manifests. H0/H1 must design a correctly named, typed replacement and backward-compatible migration; the legacy field may remain only as a temporary P0 carrier.
9. **Typed validation-suite registry.** Replace unconstrained suite-category text with a typed/versioned registry, including `security_privacy` as a first-class publication-gate category.
10. **Typed content-clearance exceptions.** H5 must introduce a dedicated immutable record with scope, Product Owner approval, rationale/evidence, effective/expiry bounds, and revocation/supersession. It can waive content clearance only; grading/calibration, rights, and security/privacy remain non-waivable.
11. **Schema authority split:** TASK-0017 does not supersede TASK-0009. TASK-0017 supplies approved v1 consumer constraints; TASK-0009 retains conceptual schema/governance authority and must ratify and incorporate them before related physical DDL.
12. **Chemistry fixture scope:** AC4 tests reconciliation of the existing AP Chemistry subject/exam-pack/taxonomy scaffold. AP Chemistry content is not authorized for publication.
13. **August pilot release intent:** human-verified AP Biology and AP Statistics content is authorized for the August pilot with live checking/monitoring. The content is AI-generated and treated as Cramapple-authored candidate material, subject to the recorded human verification and evidence requirements.
14. **No gate fiction:** the August authorization does not mark P0 verified, manufacture source/rights/security/grading evidence, or waive non-waivable gates. Release execution follows only after the required database tests and authoritative records are complete.

### Rationale

The harness removes the fixed per-subject engineering cost so future subjects are config-and-content drops. The P0 must precede any automation built on the publish path, or the harness would industrialize an unsound gate. Waivability mirrors `DECISION-0035` (content review waivable) while hard-protecting grading/rights/security. `content_item_versions` is already the de-facto canonical record; formalizing it avoids magnifying today's drift.

### Consequences / guardrails

- **Design approval before any Dev migration**; Dev migrations separately approved; Production is a distinct Hard-Gate review (migration + rollback + evidence). Dev-first (`wmgjsdkphcyhngaffbqf`); no Production schema change without a recorded approval ID.
- Harness makes subjects fast to **stand up**, never fast to **publish** — content/grading/publication gates remain hard stops (H5 proves eligibility from authoritative records).
- Config never executes arbitrary code (declarative checks + reviewed plugins). Reviewer *people* stay out of reusable configs.
- Gold-set/calibration tooling and frontend implementation remain out of scope; the harness only emits calibration status and a Lovable UI-capability handoff.
- The three design directions in items 8–10 are approved. Their schema implementation and any Dev/Production application still require the task's design, migration, QA, and environment approval gates.
- AP Biology/AP Statistics August release intent is approved, but publication execution remains a separate evidence-backed operation. AP Chemistry is explicitly excluded.
- This opens the task and records the policy calls; it does not approve the harness design, any migration, or any Production change — those are later gates.

### Update 2026-07-13 — AP Statistics tutor owns the review chain

David reassigned the AP Statistics review chain to the qualified subject tutor: the tutor (1) reviews/approves the **fact pack** (G0A — was Orly's confirmation under this decision's Q7), then (2) reviews **content** against the approved fact pack (G4A), then (3) reviews **grading & repair** once content is **released to the tutor**. Clarified: "released" = handed to the tutor for review, **not** a student-facing publish — so the non-waivable grading-calibration gate (G4B) is unchanged and all three tutor reviews occur before any student sees content. Orly remains Curriculum Owner. Reflected in `AP_STATISTICS_2027_CONTENT_REBUILD_ORCHESTRATION.md` (gate table + responsibilities) and `AP_STATISTICS_2027_CED_FACT_PACK.md` (status/reviewer).

## DECISION-0038 — Approve TASK-0009 Schema-Governance Reconciliation Scope (with conditions)

**Date:** 2026-07-13
**Decision Owner:** David Bloom
**Status:** Approved — scope only (conceptual model returns for final Hard-Gate approval before DDL)
**Related Task:** TASK-0009; relates to TASK-0017, `DECISION-0037`
**Area:** Architecture / Content Governance

### Context

TASK-0009 (Schema and Governance Reconciliation) is a conceptual-model task — translate the approved governance contracts into a coherent data model before any physical Postgres/RLS design. It contains no DDL to approve yet; the deliverable is the model + a gap/contradiction report. Reviewed at David's request; it overlaps the canonical-record and manifest decisions made in `DECISION-0037`/`TASK-0017`.

### Decision

Approve the **scope/approach to proceed**, with two binding conditions. The actual conceptual model + gap report return for the final Hard-Gate approval before any DDL.

1. **Directional canonical-identity reconciliation.** The "stable identity + immutable version" concept must map onto the existing `content_items`/`content_item_versions` records (v1 canonical per `DECISION-0037`). The model must not resurrect `artifact_versions` (0 rows in Production) as a parallel canonical record; conflicts return an explicit compatibility/migration decision to TASK-0017. Added as a named acceptance criterion.
2. **Fast-track the two slices TASK-0017 H1/H2 depend on** — immutable item-package/archetype identity and multi-scheme taxonomy per `exam_pack_version` — so this task does not become the long-pole blocker on the August AP Statistics rebuild's staging path.

### Rationale

The scope is at the right altitude (model before DDL), its invariants are correct (immutable versioned payloads, append-only reviews/state, projections separated from authoritative evidence), and its Authority Boundary section already arbitrates the TASK-0017 overlap correctly. The two conditions prevent the one real drift risk (a resurrected parallel canonical record) and the one real schedule risk (a comprehensive model exercise blocking the narrow schema the rebuild needs).

### Consequences

- TASK-0009 status → "Approved with conditions — conceptual-model deliverable pending." Approval State records scope approval; the model deliverable remains Pending for the final Hard-Gate.
- TASK-0017 H1/H2 DDL remains gated on TASK-0009 ratifying the relevant slices; Condition 2 keeps that from stalling August.
- This approves scope, not the model; it does not authorize any DDL, migration, or physical design.

## DECISION-0039 — Approve TASK-0017 H0/H1 Design + P0 Publication Repair (repository/local-verification stage; no environment application)

**Date:** 2026-07-13
**Decision Owner:** David Bloom
**Status:** Approved — repository + local-verification stage only; no Dev/Production application authorized
**Related Task:** TASK-0017; relates to TASK-0009 (`DECISION-0038`), TASK-0010, `DECISION-0037`
**Area:** Publication Trust / Architecture / Content Governance

### Context

Codex delivered the TASK-0017 H0/H1 design packet, the P0 atomic-publication migration (`202607130001_atomic_content_publication.sql`), and two SQL regression tests, plus JSON contract schemas + a pinned Ajv validator. Reviewed at David's request against the actual repo.

### What was verified

- **H0/H1 contracts — independently executed by Claude (green, 2026-07-13):** the Deno/Ajv contract tests pass 3/3 — AP Statistics Q1–Q4 fixtures validate; the `YYYY-YY` school-year rule fails closed on a calendar-year value; item packages reject executable-verifier fields.
- **P0 migration — reviewed line-by-line + dependency-checked:** gates now precede all state mutations (fixes the ordering bug); eligibility is derived from stored evidence (source/rights/review-status/validation-runs), not client-asserted gate strings; row-locked (`for update`); publishes the exact requested `content_item_versions.id` and retires siblings; `service_role`-only execute. All referenced tables/columns exist.
- **Both SQL tests — reviewed (design):** prove AC#1 (late failure → full rollback, content stays draft, zero surviving release/manifest/publication rows) and AC#2 (exact reviewed version; a newer unapproved draft is not published). TASK-0017 reports these locally verified against disposable PostgreSQL 17. **Claude reviewed but did not independently re-execute the SQL** — local PG17 pass is per Codex's report and must be re-run in the Dev execution packet.

### Decision

1. **Approve the H0/H1 SubjectPackage/ItemPackage contracts** (verified) for non-persistent package authoring/validation.
2. **Approve the P0 publication repair as repository implementation** at the local-verification stage. **P0 is not "done" for any environment until both SQL tests are re-run green in the Dev execution packet.**
3. **Endorse** the `exam_pack_manifest_content_versions` manifest-relation replacement, the typed validation registry (with `waiver_policy`), and the immutable content-clearance-exception record — routed through TASK-0009 M0 ratification + a separate additive migration approval (per `DECISION-0038`).

### Not approved / conditions

- No Dev or Production migration, application, or publication is authorized by this decision. P0 stays repository + local-verification only.
- The three schema designs proceed to physical design only after TASK-0009 ratification and separate migration approval.
- Before any environment application: (a) an edge-function↔RPC integration test proving the caller supplies all required evidence IDs (source, rights, validation runs, approved_by, policy versions); (b) supersede the interim `manifest_sha256` (currently a hash of the request payload, not content) with the canonical content/relation hash per the packet.

### Noted consequence — ACCEPTED 2026-07-14 (see DECISION-0041)

The repaired path is fail-closed on a full evidence contract: nothing publishes until verified source, valid rights, approved `review_status`, passed grading/calibration **and** security/privacy validation runs targeting the exact version, release approval, and policy-version IDs all exist. This puts **TASK-0010 grading calibration on the critical path to ANY publish**, including the AP Statistics rebuild and all AP Biology draft content. Recorded as a consequence of the correct fail-closed design. **David Bloom explicitly accepted this consequence on 2026-07-14; see DECISION-0041.** No interim carve-out was requested.

## DECISION-0040 — Ratify TASK-0009 Fast-Track Conceptual Slices (H1 item-package/archetype identity; H2 multi-scheme taxonomy)

**Date:** 2026-07-13
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0009; unblocks the `DECISION-0039`-endorsed designs and TASK-0017 H1/H2
**Area:** Architecture / Content Governance

### Context

`DECISION-0038` approved TASK-0009 scope and directed a fast-track of the two conceptual slices TASK-0017 H1/H2 depend on; `DECISION-0039` endorsed the delivered designs but routed them "through TASK-0009 M0 ratification + a separate additive migration approval." That ratification was the remaining Pending gate.

### Decision

Ratify the two TASK-0009 fast-track **conceptual** slices as delivered in the TASK-0017 H0/H1 design packet:
1. **Immutable item-package / archetype identity**, mapped onto the canonical `content_items` / `content_item_versions` records (no resurrected `artifact_versions` parallel record — `DECISION-0038` Condition 1 preserved).
2. **Multi-scheme taxonomy per `exam_pack_version`** (historical schemes preserved; annual revision coexists with the prior pack).

This satisfies the "TASK-0009 M0 ratification" precondition in `DECISION-0038`/`0039`.

### What this unblocks

- Codex may now produce the **physical H1/H2 design** (DDL/migrations) and the manifest-relation / validation-registry / exception schema — the `DECISION-0039`-endorsed designs may proceed to physical design.
- Satisfies the ratification half of TASK-0017's next checkpoint.

### What this does NOT approve (still separate gates)

- The **produced physical H1/H2 design** returns for its own Hard-Gate design/migration review before any environment.
- A **separate Dev execution approval ID** is still required before applying ANY migration to Dev — **not issued here** (David to provide when ready).
- The P0 SQL regression tests must **re-run green in the Dev execution packet** (verification, separate from authorization).
- No Production change; the full TASK-0009 conceptual model + gap report still return for the final Hard-Gate.

### Consequences

- TASK-0009: fast-track slice ratification → Approved (2026-07-13); full model deliverable still Pending.
- TASK-0017: ratification checkpoint met; physical H1/H2 design may proceed; Dev application still gated on a separate approval ID.

### Product Owner execution clarification — 2026-07-13

David Bloom subsequently clarified DECISION-0040's repository-execution boundary: Codex is approved to build the H1/H2 physical design and additive migration artifacts, the compiler/persistence layer, and H3–H5 in the repository, and to verify them locally. This clarification supersedes the narrower wording above that limited the next step to producing a design packet only.

The environment boundary is unchanged: no migration or function may be applied to Dev without a separate Dev execution approval ID, and no Production migration, deployment, configuration change, or publication is authorized. The completed repository implementation and local evidence return for Hard-Gate review before environment execution.

## DECISION-0041 — Accept the DECISION-0039 Consequence: TASK-0010 Grading Calibration Is on the Critical Path to ANY Publish

**Date:** 2026-07-14
**Decision Owner:** David Bloom
**Status:** Approved
**Related:** DECISION-0039 (fail-closed publication repair); TASK-0010 (grading calibration); TASK-0016 (grading engines); AP Statistics 2026-27 rebuild; AP Biology publish gap
**Area:** Governance / Content Publication / Grading

### Context

DECISION-0039 repaired the publication path to be **fail-closed on a full evidence contract** — nothing publishes until verified source, valid rights, approved `review_status`, a passed **grading/calibration** validation run *and* a security/privacy validation run (both targeting the exact content version), a release approval, and policy-version IDs all exist. That decision explicitly left one item **open for explicit acceptance**: the consequence that requiring a passed grading/calibration run puts **TASK-0010 grading calibration on the critical path to ANY publish**.

### Decision

David Bloom **explicitly accepts** that consequence. The fail-closed evidence contract stands as designed; **no interim carve-out or waiver was requested**. Accordingly:

- **No content publishes** — not the AP Statistics 2026-27 rebuild, not any AP Biology draft content, not any other subject — until a passed **TASK-0010 grading/calibration** validation run exists for the exact content version, alongside the other evidence-contract requirements.
- TASK-0010 calibration is therefore a **launch-gating dependency**, not a parallel nice-to-have. It should be resourced and sequenced as such.

### What this changes

- The AP Statistics rebuild and the AP Biology publish gap are both **blocked on TASK-0010 calibration** (in addition to their own content/QA gates). The push-button AP Statistics calibration harness built 2026-07-14 (`scripts/grading-model-assessment/calibrate-ap-statistics.ts`) becomes authoritative only once **human dual-blind adjudicated gold** and **real grader captures** replace the provisional inputs — that adjudicated run is the gating artifact.

### What this does NOT change / authorize

- No change to the fail-closed design itself (already decided in DECISION-0039).
- Does not lower any other gate; `QA-pass ≠ launch approval` still holds.
- No Production or Dev change is authorized by this record; it is a governance acceptance only.

### Consequences

- DECISION-0039's "Noted consequence — open for explicit acceptance" is **resolved: Accepted (2026-07-14)**.
- TASK-0010 moves onto the critical path for all publication.

## DECISION-0042 — Adopt the AP Biology Depth-Threshold Boundary Policy; Approve `L-001/b` at 1/2; Resolve `L-009/b` at 1/2 (Coaching Contract); Ratify the `L-001/a_i` Variant-Scope Fix

**Date:** 2026-07-17
**Decision Owner:** David Bloom (Product Owner / Final Approver)
**Status:** Approved (Product Owner gate). Curriculum sign-off interface noted below.
**Related:** TASK-0010 (grading calibration); DECISION-0034 (five grading standards; boundary contracts required, §9.1); DECISION-0041 (TASK-0010 on the critical path to any publish); `docs/research/AP_BIOLOGY_CRITERION_BOUNDARY_CONTRACT_SHARPENING_2026_07_17.md`
**Area:** Grading / Criterion-Boundary Contracts / AP Biology

### Context

The AP Biology gold-set candidate (`ap_biology_gold_set_candidate_2026_07_08/`) surfaced a 9-item adjudication queue. A 2026-07-17 pass drafted §9.1 boundary-contract language for each flagged criterion and found that **five of the nine items are the same underlying question**: on a 2-point *describe / explain / trace* criterion, does a response that gives the correct direction/outcome and names the correct actors — but omits a finer mechanistic step the rubric also lists — earn full, partial, or nothing?

### Decision

David Bloom, as Product Owner, makes three calls:

1. **Adopt one governing depth-threshold policy** for all AP Biology "describe/explain/trace" criteria (resolving queue items `L-001/a_i`, `L-009/b`, `L-017/a`, `L-033/b`, `L-033/c` consistently):
   > A required element earns its point when the response **(1) names the correct actor(s)** and **(2) states the correct causal relationship, direction, or outcome** the element tests. Omitting a finer sub-mechanistic intermediate the rubric lists as *enrichment* does **not** void the point. A required element does **not** earn when the response **(a)** states the wrong direction/outcome (fluent, complete, confident wrong answers still earn nothing — model self-reported confidence is not evidence), **(b)** gives only a definitional restatement in place of the required causal link, or **(c)** omits a *distinct required transformation/step* (not merely a finer detail of a step it already has).

2. **Approve the `APBIO-FRQ-L-001 / b` disposition at `partially_earned` (1/2)** — one step up from the AI provisional `not_earned` — on the **independent-element reading**: on a 2-point criterion scored "two of three elements for full credit," one cleanly-correct required element earns 1 pt; a directionally-reversed mechanism (here, reversed proton-pump direction) voids the element it describes but does not retract a separately-correct element.

3. **Ratify the `APBIO-FRQ-L-001 / a_i` variant-scope fix** (executed 2026-07-17): the definitional restatement `"net O2 is zero"` was removed from the criterion's `accepted_variants` and an explicit boundary clause added to `evidence_requirements`, so the definitional phrasing identifies the compensation point but no longer satisfies the required rate-equality explanation.

4. **Resolve `APBIO-FRQ-L-009 / b` at `partially_earned` (1/2)** — Learning Quality (Orly)'s call, closing the last of the four ranked decisions. P1 (process backbone: fixation → nitrification → uptake → assimilation) earns; P2 is withheld. Rationale is product-driven, not only rubric purity: the coaching engine (`grading-feedback.ts` → `highest_value_gap`, ranked by `points_possible / estimated_repair_effort`, surfaced with `minimum_fix` + `predicted_improvement`) is built to push students to their cheapest next point; a whole-pathway response at **1/2** reads as "one specific addition from a point" (the high-leverage repair the ranking prioritizes), while **0/2** makes the same content look like a vaguer rebuild. 1/2 also matches the real modern AP standard (process points generally are not gated on memorized genus names) and still signals incompleteness (not 2/2), preserving coaching pressure.

   **Coaching contract (authored):** the score does not coach — the `minimum_fix` does. Coaching for `L-009/b` **must name both point-2 gaps**: (a) the **nitrate-reduction step** (NO3- → NH4+ in the plant), the point-securing element in either reading; and (b) **organism naming** (Rhizobium, Nitrosomonas/Nitrobacter). Framing of the organism gap follows one factual input — does the operational AP standard require genus names? **If required →** imperative ("you must name…"); **if enrichment →** "naming the organisms strengthens this; the missing point is the nitrate-reduction step" (so students are not sent to memorize genera they do not need). **Working default = enrichment** (moderate-high confidence). The live `minimum_fix` was updated 2026-07-17 to an **enrichment-safe** wording that names both gaps and frames organisms as "strengthen further" without asserting they are optional — correct even if the standard is stricter. The sole residual is Orly confirming whether the target standard requires genera, which flips the wording to imperative (a one-line C2 edit; no score or student-behavior change).

### What this changes

- These become the guard rails the AP Biology adjudicated gold set is scored against. Each encoded contract is a **C2 change** under `CONTENT_GOVERNANCE_AND_VALIDATION.md` §16.3.
- The `L-001/a_i` fix is applied to the four corpus/calibration artifacts that carried the inconsistent variant list (`ap_biology_frq_bootstrap_corpus_2026_07_07.json`, `ap_biology_frq_full_export_2026_07_07.json`, `apbio_frq_tutor_ready_packet.json`, and the candidate package's `provisional_labels.json`).

### What this does NOT change / authorize

- **Does not upgrade the package to `adjudicated_gold`.** Labels remain `calibration` until **two qualified human Grading Validators score blind + a Lead adjudicates** (§12.1). These dispositions are inputs to that human pass, not a substitute for it, and do not by themselves satisfy the DECISION-0041 grading/calibration publish gate.
- **Curriculum sign-off interface:** `L-009/b` was resolved by Learning Quality (Orly) at 1/2 in this same session (see call 4 above); no ranked decision remains open. The sole residual is an emphasis-only coaching confirmation (enrichment vs imperative genus-name wording). If curriculum review later conflicts with any disposition here, it reopens as a C2 revision.
- No Production or Dev change; no other gate lowered; `QA-pass ≠ launch approval` still holds.

### Consequences

- The depth policy applies uniformly: tightening or loosening it later moves all five depth-governed items together, by design.
- Feeds the DECISION-0041 critical path — but only the human dual-blind adjudicated run is the gating artifact.
