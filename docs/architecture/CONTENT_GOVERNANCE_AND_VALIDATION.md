# Cramapple Content Governance and Validation

**Status:** Proposed for Product Owner approval
**Document Version:** 0.2
**Date:** 2026-07-08 (v0.2, DECISION-0034: criterion-boundary contract and
per-subject deterministic checks required in the FRQ package, §10.5)
**Policy Owner:** David Bloom, Product Owner
**Learning Quality Owner:** Orly Bloom, Vice President of Learning
**Related Task:** TASK-0005, TASK-0010

## 1. Purpose

This document defines the operating procedure for creating, sourcing, validating,
approving, publishing, monitoring, changing, retiring, and rolling back
Cramapple exam-pack content.

It converts the governance boundaries in the approved architecture into exact
roles, records, checklists, reviewer counts, release thresholds, refresh
schedules, and revalidation rules.

The initial scope is AP Biology. The same controls apply to later exam packs,
with subject-specific qualifications and validation cases.

## 2. Status and Approval Boundary

This document is a proposed policy until David Bloom approves it and the
approval is recorded in `docs/activity_log/APPROVALS_LOG.md`.

Drafting this procedure is documentation work under the standing approval lane.
Adopting its expert-quality gates, rights policy, release authority, or launch
thresholds is a hard gate.

Until approval:

- no artifact may claim compliance with this procedure;
- no validator qualification may be treated as production authorization;
- no release may rely on the proposed thresholds;
- existing approved architecture and task-specific approvals remain controlling.

## 3. Governing Principles

1. Canonical content, rubrics, source records, validation evidence, and exam-pack
   releases are immutable and versioned.
2. Every educational or scoring claim has traceable source provenance or is
   explicitly labeled as Cramapple-authored judgment.
3. Rights approval is separate from scientific or pedagogical accuracy.
4. Authors cannot approve their own work.
5. Teaching validation and grading validation are independent gates.
6. Release approval verifies that required evidence exists; it does not replace
   expert validation.
7. Exam packs publish atomically through an immutable manifest.
8. Regrading and revalidation append new evidence; they do not overwrite
   history.
9. A source, rights, teaching, grading, or release failure blocks publication.
10. Uncertainty is recorded and escalated rather than resolved through
    unsupported inference.
11. Public publication, private learner use, and anonymous internal improvement
    use remain separate governed states.
12. Numeric thresholds are policy, not scientific claims. Changing a threshold
    requires a new policy version, rationale, impact analysis, and approval.

## 4. Roles and Separation of Duties

### 4.1 Roles

| Role | Primary responsibility | May approve |
| --- | --- | --- |
| Product Owner | Product scope, risk acceptance, final quality and launch authority | Policy adoption, first production launch, major release, exceptions, risk acceptance, Done |
| Learning Quality Owner | Curriculum quality, validator program, subject coverage, teaching-quality leadership | Validator qualification recommendations and teaching-quality recommendations |
| Paid Tutor Author | Independently create original questions and complete question packages from approved briefs | Nothing authored by that person |
| Content Author | Draft exam facts, lessons, hints, examples, misconceptions, and transfer items | Nothing authored by that person |
| Rubric Author | Draft criteria, accepted variants, contradictions, samples, and calibration cases | Nothing authored by that person |
| Source Steward | Capture sources, scope, checksums, dates, and refresh requirements | Provenance completeness, not rights or educational accuracy |
| Rights Reviewer | Classify permitted use and restrictions under approved legal policy | Routine permitted-use classifications within delegated policy |
| Counsel / Legal Approver | Decide unresolved copyright, trademark, licensing, privacy, and contractual questions | Legal exceptions and high-risk rights decisions |
| Teaching Validator | Review scientific accuracy, exam alignment, pedagogy, accessibility, and answer leakage | Assigned teaching artifacts within qualification scope |
| Grading Validator | Blind-score cases and review rubric validity, accepted variants, contradictions, and feedback | Assigned grading packages within qualification scope |
| Lead Teaching Validator | Calibrate teaching validators and adjudicate teaching disagreement | Teaching adjudication within scope |
| Lead Grading Validator | Calibrate graders and adjudicate rubric or scoring disagreement | Grading adjudication within scope |
| Release Approver | Verify that all required gates and evidence are complete | Routine release candidates within delegated release class |
| Quality Monitor | Run production sampling, trend review, and defect triage | Monitoring disposition, not release or risk acceptance |
| Incident Commander | Coordinate containment, correction, revalidation, and communication | Operational containment within incident policy |
| System Administrator | Administer accounts, entitlements, queues, and release tooling | No educational or rights decision solely by administrator authority |

### 4.2 Mandatory Independence

The following rules are enforced by assignment and release services:

- An author or rubric author cannot serve as a required validator, adjudicator,
  or release approver for the same artifact version.
- A Paid Tutor Author cannot validate another artifact produced from the same
  shared draft, co-authoring session, or coordinated question family.
- Teaching validators cannot see another teaching validator's decision until
  both independent decisions are submitted.
- Grading validators score validation responses blind to model output, other
  reviewers, and adjudicated answers during the independent pass.
- A lead validator may adjudicate only after independent reviews are locked.
- A release approver cannot be the sole author, required validator, or
  adjudicator for any blocking artifact in the release.
- System administrators cannot grant themselves validator or release authority.
- Product Owner approval does not substitute for missing teaching, grading,
  source, or rights evidence.
- One person may hold multiple organizational roles, but cannot fill conflicting
  roles for the same artifact version or release candidate.

### 4.3 Conflict of Interest

A reviewer must recuse when the reviewer:

- authored or materially edited the version;
- owns or is paid by a source whose use is being assessed;
- has a personal, academic, or commercial relationship that could affect the
  decision;
- has previously seen the gold answer for a blind validation case;
- cannot review independently because of direct supervision or pressure.

Recusal creates an audit event and a replacement assignment. It is not a failed
review.

## 5. Author and Validator Qualifications

Qualifications are versioned, scoped, expiring records. Experience alone does
not grant production access.

### 5.1 Paid Tutor Author

A Paid Tutor Author must satisfy all of the following:

- one of:
  - bachelor's degree or higher in biology or a closely related field;
  - two completed years teaching AP Biology;
  - 200 documented hours tutoring AP Biology in the previous three years;
- demonstrated familiarity with the active AP Biology course and exam
  description;
- pass an original-question writing exercise reviewed by the Learning Quality
  Owner or delegated lead;
- complete Cramapple training on originality, source use, accessibility,
  confidentiality, and conflicts;
- sign an agreement assigning or licensing the commissioned work to Cramapple
  on terms approved by counsel;
- attest for every submission that the work is original and does not reproduce,
  closely adapt, or derive expressive content from official, secure, licensed,
  student-provided, or third-party questions;
- disclose all factual sources, datasets, images, collaborators, and tools used.

Paid Tutor Authors create or sell Cramapple the base question packages.
Generative AI does not create a base question from official or third-party
material. After Cramapple owns or holds sufficient rights to a base package, AI
may create candidate variants under Section 10.3. AI variants do not inherit
the base package's approval.

Compensation is for commissioned authoring work and required revisions, not for
approval. Payment must not pressure validators to accept an artifact.

### 5.2 Teaching Validator

A teaching validator must satisfy all of the following:

- one of:
  - bachelor's degree or higher in the subject or a closely related field;
  - two completed years teaching the AP subject;
  - 200 documented hours tutoring the AP subject in the previous three years;
- familiarity with the active AP course and exam description;
- completion of Cramapple confidentiality, source-use, accessibility, and
  conflict training;
- score at least 90% on a 30-item subject and exam-alignment qualification set;
- pass at least 11 of 12 teaching scenarios with no scientific-accuracy,
  answer-leakage, or grading-conflict blocker;
- sign the reviewer code of conduct.

At least one of the two required teaching validators for a standard or higher
risk artifact must have taught the AP subject or completed at least 200 hours of
AP-subject tutoring within the previous three years.

### 5.3 Grading Validator

A grading validator must satisfy all of the following:

- meet the subject-knowledge requirement for a teaching validator;
- demonstrate experience scoring constructed responses, teaching AP free
  response, or applying comparable criterion-based science rubrics;
- complete blind qualification on at least 40 responses containing correct,
  incorrect, partial, equivalent, contradictory, ambiguous, and adversarial
  cases;
- achieve at least 90% criterion-level exact agreement with the adjudicated
  qualification key;
- achieve weighted Cohen's Kappa of at least 0.80 when the response set supports
  an ordinal total-score calculation;
- make zero severe errors, where a severe error invents evidence, ignores a
  direct contradiction, or awards credit for a response that demonstrates the
  opposite of the required claim;
- complete Cramapple grading, feedback-grounding, privacy, conflict, and
  escalation training.

### 5.4 Lead Validator

A lead teaching or grading validator must:

- hold the underlying active qualification for at least 90 days;
- complete at least 100 accepted production or preproduction decisions;
- maintain the applicable calibration thresholds for the preceding 90 days;
- complete adjudication training;
- receive approval from the Learning Quality Owner;
- have no unresolved integrity or repeated calibration finding.

For the first exam-pack launch, the Learning Quality Owner may nominate a lead
based on equivalent external experience. The Product Owner must approve that
exception.

### 5.5 AP Reader Validator

For the initial AP Biology bank, a reviewer may be designated an AP Reader
Validator only when the person:

- served as an AP Biology Reader in at least one of calendar years 2024, 2025,
  or 2026;
- provides reasonable verification of that service;
- meets the applicable Teaching Validator or Grading Validator qualification;
- completes Cramapple confidentiality, conflict, source-use, and restricted
  material training;
- agrees not to disclose or rely on secure questions, confidential Reading
  discussions, unreleased scoring information, or other restricted material.

AP Reader experience supports exam-authenticity and scoring review. It does not
replace scientific, pedagogical, rights, originality, or independent grading
gates, and does not authorize the reviewer to approve authored work in which the
reviewer participated.

### 5.6 Source and Rights Qualifications

A Source Steward must complete provenance, source hierarchy, checksum, citation,
and change-detection training.

A Rights Reviewer must complete the approved rights decision tree and may
approve only cases explicitly delegated by counsel. The following always
require counsel or written permission:

- reproduction or generative use of official questions, scoring materials, or
  restricted teacher resources;
- ambiguous licenses or terms;
- third-party commercial content;
- trademark uses outside approved brand guidance;
- a request to rely on fair use as the commercial publication basis;
- any source with `rights_status = unknown`, `disputed`, or `restricted`.

### 5.7 Qualification Renewal and Suspension

| Qualification | Routine renewal | Interim calibration | Automatic suspension |
| --- | --- | --- | --- |
| Paid Tutor Author | Every 12 months | First three packages and then one sampled package per 10 submissions | Any plagiarism, restricted-material use, material source nondisclosure, or repeated quality failure |
| Teaching validator | Every 12 months | 12 scenarios every 90 days | Below 90% overall, any repeated blocker miss, expired training |
| Grading validator | Every 12 months | 20 responses every 30 days while active | Below 90% criterion agreement, Kappa below 0.80 where calculable, any severe error |
| AP Reader Validator designation | Verified for the applicable 2024-2026 service window | Same calibration as underlying validator role | Unverifiable service, restricted-material disclosure, or underlying qualification suspension |
| Lead validator | Every 12 months | Five adjudications audited every 90 days | Two overturned adjudications in 90 days or underlying qualification suspended |
| Source Steward | Every 12 months | Five records audited every 90 days | More than one material provenance miss in an audit |
| Rights Reviewer | Every 12 months or policy change | Quarterly decision audit | Any unauthorized-use approval or expired legal training |
| Release Approver | Every 12 months | One release audit per quarter | Any bypassed blocking gate or unauthorized publication |

Suspension prevents new assignments immediately. Open work is reassigned. A
suspended reviewer cannot regain access until remediation and requalification
are recorded.

## 6. Artifact and Change Risk Classes

### 6.1 Artifact Risk

| Risk | Description | Examples |
| --- | --- | --- |
| R0 Administrative | No educational, scoring, rights, or learner-visible semantic effect | Internal label, queue priority, non-public note |
| R1 Teaching | Learner-visible instruction without independent scoring authority | Explanation, hint, misconception intervention, transfer item |
| R2 Grading | Can change whether a learner earns a criterion or the feedback attached to it | Rubric, accepted variant, contradiction, grader prompt, scoring logic |
| R3 Pack-Critical | Can affect many artifacts, official exam alignment, legal use, or release integrity | Exam fact, taxonomy, shared policy, source-rights change, model change, pack manifest |

The highest applicable risk controls the review.

### 6.2 Change Class

| Class | Definition | Default validation |
| --- | --- | --- |
| C0 Non-semantic | Formatting, spelling, broken-link replacement to the same source, or metadata correction with no meaning change | Independent verifier and checksum update |
| C1 Local semantic | Meaning changes within one artifact without changing scoring boundaries or shared policy | Partial revalidation of changed artifact and direct dependents |
| C2 Scoring or shared behavior | Changes criteria, accepted answers, contradictions, prompts, model behavior, recommendation logic, or reusable teaching policy | Full artifact-family revalidation and dependency impact review |
| C3 Exam-pack material | Changes exam specification, taxonomy identity, rights availability, broad scientific basis, release policy, or multiple artifact families | Full exam-pack revalidation |

A reviewer may increase a class. Reducing the automatically assigned class
requires a written lead-validator rationale and Release Approver approval.

## 7. Canonical Record Schemas

These are logical contract schemas. The physical database design may normalize
them further, but it must preserve all fields, constraints, append-only evidence,
and immutable payloads.

Physical Supabase or Postgres DDL is deferred until this logical governance
model and the applicable application architecture are approved. A physical
schema proposal must be reviewed as a separate hard-gated task and must not
replace these logical contracts with mutable approval booleans or overwriteable
content rows.

### 7.1 Common Types

```text
UUID             = RFC 4122 UUID
ULID             = 26-character sortable ULID
Timestamp        = UTC RFC 3339 timestamp
LocalDate        = YYYY-MM-DD
SHA256           = lowercase 64-character hexadecimal digest
SemVer           = MAJOR.MINOR.PATCH
URI              = absolute URI
ActorType        = human | service | model
Environment      = development | validation | production
Decision         = approve | approve_with_notes | changes_required | reject | abstain
Severity         = S0 | S1 | S2 | S3
```

All records include `created_at`, `created_by`, and an audit event. Fields marked
immutable cannot be updated after insertion.

### 7.2 Source Record

```text
source_record {
  source_id: UUID
  source_version_id: UUID
  version_sequence: integer >= 1
  title: string 1..500
  publisher: string 1..300
  authors: string[]
  source_type:
    official_exam | official_scoring | government | peer_reviewed |
    textbook | professional_body | licensed_content | cramapple_authored |
    third_party_web | user_provided | other
  canonical_uri: URI | null
  publication_date: LocalDate | null
  source_update_date: LocalDate | null
  retrieved_at: Timestamp
  effective_from: LocalDate | null
  effective_to: LocalDate | null
  exam_id: UUID | null
  school_year: string | null
  scope_statement: string 1..2000
  source_excerpt_locator: string | null
  stored_object_id: UUID | null
  content_sha256: SHA256
  authority_tier: 1 | 2 | 3 | 4
  refresh_class: EXAM | RIGHTS | SCIENCE_STABLE | SCIENCE_VOLATILE |
                 LINK_ONLY | PROVIDER_POLICY
  next_refresh_due_at: Timestamp
  supersedes_source_version_id: UUID | null
  provenance_status: draft | verified | superseded | withdrawn
}
```

Constraints:

- `source_id` is the stable identity; `source_version_id` identifies one
  immutable capture.
- A stored source must have a checksum. A link-only source uses the checksum of
  the retrieved representation or a recorded metadata snapshot.
- `scope_statement` must state exactly what the source supports.
- A withdrawn source cannot support a new release.

### 7.3 Rights Record

```text
rights_record {
  rights_record_id: UUID
  source_version_id: UUID
  rights_status:
    cramapple_owned | public_domain | licensed | written_permission |
    link_only | internal_reference_only | restricted | disputed | unknown
  permitted_uses: enum[] from
    [store, quote_limited, transform, model_input, internal_validation,
     learner_display, public_display, commercial_distribution]
  prohibited_uses: string[]
  territory: string[]
  audience_restrictions: string[]
  license_or_permission_id: string | null
  license_effective_at: Timestamp | null
  license_expires_at: Timestamp | null
  attribution_required: boolean
  attribution_text: string | null
  reviewed_by: UUID
  reviewed_at: Timestamp
  legal_approval_required: boolean
  legal_approval_id: UUID | null
  next_review_due_at: Timestamp
  notes: string | null
}
```

Constraints:

- `unknown`, `disputed`, and `restricted` block publication and model input.
- A use is prohibited unless it appears in `permitted_uses`.
- Expired permission blocks the affected use automatically.
- Rights approval does not establish educational accuracy.

### 7.4 Artifact Version

```text
artifact_version {
  artifact_id: UUID
  artifact_version_id: UUID
  artifact_type:
    exam_fact | taxonomy_node | question | stimulus | asset | lesson |
    explanation | hint | misconception | intervention | transfer_item |
    delayed_retrieval_item | rubric | criterion | accepted_variant |
    contradiction | sample_response | calibration_case | teaching_policy |
    grading_policy | prompt | model_configuration | validator_policy
  exam_id: UUID
  school_year: string
  version_sequence: integer >= 1
  semantic_version: SemVer
  language: BCP-47 string
  payload_schema_version: SemVer
  payload: JSON
  payload_sha256: SHA256
  risk_class: R0 | R1 | R2 | R3
  change_class: C0 | C1 | C2 | C3
  change_summary: string 1..2000
  change_rationale: string 1..4000
  authored_by: UUID[]
  authored_at: Timestamp
  predecessor_version_id: UUID | null
}

artifact_state_event {
  artifact_state_event_id: UUID
  artifact_version_id: UUID
  prior_state:
    null | draft | in_review | approved | published | suspended |
    superseded | retired | withdrawn
  new_state:
    draft | in_review | approved | published | suspended |
    superseded | retired | withdrawn
  reason_code: string
  evidence_record_ids: UUID[]
  changed_by: UUID
  changed_at: Timestamp
}
```

Constraints:

- `payload`, authorship, predecessor, and checksums are immutable.
- A revision creates a new `artifact_version_id`.
- Current lifecycle state is projected from append-only `artifact_state_event`
  records. State changes cannot alter the artifact payload.
- `approved` requires every applicable gate.
- `published` is valid only when referenced by an active release manifest.
- A version cannot return from `retired` or `withdrawn`; restoration creates a
  new version or reactivates an earlier approved exam-pack release.

### 7.5 Provenance Claim

```text
provenance_claim {
  claim_id: UUID
  artifact_version_id: UUID
  claim_path: JSON Pointer
  claim_text: string 1..4000
  claim_kind:
    official_fact | scientific_fact | product_inference |
    pedagogical_judgment | scoring_judgment | authored_example
  source_version_ids: UUID[]
  derivation:
    direct | paraphrase | synthesis | calculation | expert_judgment |
    cramapple_original
  formula: string | null
  assumptions: string[]
  confidence: high | medium | low
  verified_by: UUID | null
  verified_at: Timestamp | null
}
```

Every official or scientific factual claim requires at least one supporting
source. Product inference, pedagogical judgment, and scoring judgment must be
labeled and must not be presented as official fact.

### 7.6 Dependency Edge

```text
artifact_dependency {
  dependency_id: UUID
  from_artifact_version_id: UUID
  to_artifact_version_id: UUID
  dependency_type:
    cites | derived_from | teaches | assesses | scored_by | accepts |
    contradicts | example_for | prerequisite_of | configured_by |
    included_in | supersedes
  impact_mode: none | review_on_change | revalidate_on_change | retire_on_change
  created_at: Timestamp
  created_by: UUID
}
```

The impact graph must be acyclic for `derived_from`, `scored_by`,
`configured_by`, and `included_in`.

### 7.7 Authoring Brief, Commission, and Attestation

```text
question_coverage_target {
  coverage_target_id: UUID
  exam_id: UUID
  subject_id: UUID
  scope_type: topic | unit
  taxonomy_scope_id: UUID
  school_year: string
  mcq_target: integer >= 0
  short_frq_prompt_target: integer >= 0
  long_frq_prompt_target: integer >= 0
  required_skill_ids: UUID[]
  required_representation_types: string[]
  required_difficulty_bands: string[]
  approved_by: UUID[]
  effective_at: Timestamp
}

authoring_brief {
  brief_id: UUID
  brief_version_id: UUID
  exam_id: UUID
  school_year: string
  taxonomy_scope_ids: UUID[]
  assessable_skill_target_ids: UUID[]
  task_verbs: string[]
  question_form: string
  intended_use:
    teaching | independent_practice | diagnostic_candidate |
    transfer | delayed_retrieval
  intended_difficulty: string
  approved_source_version_ids: UUID[]
  stimulus_requirements: JSON
  reasoning_requirements: JSON
  accessibility_requirements: JSON
  prohibited_similarities: string[]
  deliverable_schema_version: SemVer
  brief_sha256: SHA256
  approved_by: UUID[]
  created_at: Timestamp
}

author_qualification {
  author_qualification_id: UUID
  author_id: UUID
  exam_ids: UUID[]
  school_years: string[]
  taxonomy_scope_ids: UUID[]
  evidence_record_ids: UUID[]
  qualification_policy_version_id: UUID
  effective_at: Timestamp
  expires_at: Timestamp
  status: pending | active | suspended | expired | revoked
  suspension_reason: string | null
  granted_by: UUID
}

author_commission {
  commission_id: UUID
  brief_version_id: UUID
  author_id: UUID
  author_qualification_id: UUID
  agreement_record_id: UUID
  compensation_terms_record_id: UUID
  commissioned_deliverables: string[]
  assigned_at: Timestamp
  due_at: Timestamp
  status:
    offered | accepted | submitted | revision_requested |
    validation | accepted | rejected | cancelled
}

content_rights_release {
  release_id: UUID
  author_or_seller_id: UUID
  commission_id: UUID | null
  covered_artifact_ids: UUID[]
  compensation_record_id: UUID
  ownership_mode: assignment | exclusive_license
  rights_granted:
    reproduce | edit | adapt | create_derivatives | model_input |
    internal_validation | learner_display | public_display |
    commercial_distribution | sublicense
  worldwide: boolean
  perpetual: boolean
  originality_warranty: boolean
  no_conflicting_rights_warranty: boolean
  source_and_asset_disclosure_required: boolean
  restricted_material_prohibited: boolean
  further_payment_required: boolean
  signed_by_creator: UUID
  signed_by_cramapple: UUID
  signed_at: Timestamp
  agreement_sha256: SHA256
  counsel_approved_template_version_id: UUID
}

originality_attestation {
  attestation_id: UUID
  commission_id: UUID
  artifact_version_ids: UUID[]
  independently_authored: boolean
  no_official_or_third_party_adaptation: boolean
  no_restricted_material_use: boolean
  prior_publication_or_assignment_disclosed: boolean
  factual_source_version_ids: UUID[]
  asset_rights_record_ids: UUID[]
  disclosed_collaborator_ids: UUID[]
  disclosed_tools: string[]
  statement: string
  signed_by: UUID
  signed_at: Timestamp
  attestation_sha256: SHA256
}

ai_variant_run {
  variant_run_id: UUID
  base_artifact_version_ids: UUID[]
  content_rights_release_ids: UUID[]
  authoring_brief_version_id: UUID
  prompt_version_id: UUID
  model_configuration_version_id: UUID
  parameter_payload: JSON
  invariant_requirements: JSON
  permitted_changes: JSON
  approved_source_version_ids: UUID[]
  generated_candidate_version_ids: UUID[]
  run_input_sha256: SHA256
  run_output_sha256: SHA256
  created_at: Timestamp
  created_by: UUID
  holdout_policy_version_id: UUID | null
  holdout_result: pending | passed | failed | not_approved
}

question_use_assignment {
  use_assignment_id: UUID
  artifact_version_id: UUID
  use_class:
    reject | revise | diagnostic_candidate | diagnostic_active |
    teaching_candidate | teaching_active | dual_candidate | retired
  population_scope: JSON | null
  exposure_summary: JSON
  decision_record_ids: UUID[]
  effective_at: Timestamp
  ended_at: Timestamp | null
  replaced_by_artifact_version_id: UUID | null
}
```

Constraints:

- A commission cannot enter validation unless the author qualification is
  active and the originality attestation is complete.
- A purchased or commissioned package cannot enter the canonical repository
  unless a signed `content_rights_release` grants every intended use.
- AI versioning requires `adapt`, `create_derivatives`, and `model_input`
  rights. Missing rights block AI use.
- `author_id` cannot appear as a required validator or release approver for any
  commissioned artifact version.
- A new or corrected artifact version requires a new attestation.
- Compensation and acceptance are separate records; payment does not create
  approval.
- A false attestation suspends the author immediately and opens a rights and
  quality incident.
- Coverage targets count only independently approved production inventory
  items. One inventory item is one MCQ or one independently delivered and
  answered FRQ prompt. Stimuli, subparts, rubric criteria, and package
  components do not count separately. Drafts, superficial reskins, and
  validation-only AI variants do not count.
- A `topic` scope requires `mcq_target >= 10` and
  `short_frq_prompt_target >= 5`. A `unit` scope records the long-FRQ target and
  initially requires `long_frq_prompt_target >= 8`.
- An AI variant run is invalid unless every base package has the required
  release rights and complete provenance.
- A question may have only one active `diagnostic_active` or `teaching_active`
  assignment for the same population scope.

### 7.8 Validator Qualification and Entitlement

```text
validator_qualification {
  qualification_id: UUID
  reviewer_id: UUID
  qualification_type:
    teaching | grading | ap_reader_teaching | ap_reader_grading |
    lead_teaching | lead_grading |
    source_steward | rights_reviewer | release_approver
  exam_ids: UUID[]
  school_years: string[]
  taxonomy_scope_ids: UUID[]
  artifact_types: string[]
  environment_scope: Environment[]
  evidence_record_ids: UUID[]
  qualification_policy_version_id: UUID
  granted_by: UUID
  granted_at: Timestamp
  effective_at: Timestamp
  expires_at: Timestamp
  status: pending | active | suspended | expired | revoked
  suspension_reason: string | null
}

validator_entitlement {
  entitlement_id: UUID
  reviewer_id: UUID
  qualification_id: UUID
  allowed_actions:
    view | annotate | score | approve | adjudicate | release |
    assign | administer
  exam_ids: UUID[]
  artifact_types: string[]
  assignment_ids: UUID[]
  environment_scope: Environment[]
  effective_at: Timestamp
  expires_at: Timestamp
  granted_by: UUID
  status: active | suspended | expired | revoked
}
```

Constraints:

- An entitlement is invalid unless its qualification is active and covers the
  same exam, artifact, action, school year, and environment.
- Expiration or suspension of a qualification immediately disables dependent
  entitlements.
- `granted_by` cannot equal `reviewer_id`.
- Production release authority requires an explicit `release` entitlement; a
  validator or administrator role alone is insufficient.

### 7.9 Review Assignment and Decision

```text
review_assignment {
  assignment_id: UUID
  artifact_version_id: UUID
  review_type: source | rights | teaching | grading | accessibility |
               adjudication | release
  required_qualification_id: UUID
  assigned_reviewer_id: UUID
  blind_group_id: UUID | null
  assigned_at: Timestamp
  due_at: Timestamp
  status: assigned | opened | submitted | recused | expired | cancelled
  conflict_attestation: boolean
}

review_decision {
  review_decision_id: UUID
  assignment_id: UUID
  artifact_version_id: UUID
  checklist_version_id: UUID
  decision: Decision
  blocker_codes: string[]
  non_blocking_codes: string[]
  criterion_results: JSON
  rationale: string 1..8000
  submitted_at: Timestamp
  decision_sha256: SHA256
  supersedes_review_decision_id: UUID | null
}
```

Submitted decisions are immutable. A correction is a new decision linked by
`supersedes_review_decision_id`.

### 7.10 Validation Suite, Case, and Result

```text
validation_suite {
  suite_id: UUID
  suite_version_id: UUID
  name: string
  exam_id: UUID
  suite_type: teaching | grading | regression | calibration | monitoring
  coverage_requirements: JSON
  case_ids: UUID[]
  split: qualification | development | validation | held_out | production_sample
  content_sha256: SHA256
  approved_by: UUID[]
}

validation_case {
  case_id: UUID
  case_version_id: UUID
  case_type:
    correct | incorrect | partial | equivalent | contradictory |
    ambiguous | adversarial | accessibility | answer_leakage |
    misconception | transfer | abstention
  input_payload: JSON
  expected_payload: JSON
  source_artifact_version_ids: UUID[]
  gold_status: draft | dual_reviewed | adjudicated | retired
  sensitivity: internal | confidential | deidentified_learner
  content_sha256: SHA256
}

validation_run {
  run_id: UUID
  suite_version_id: UUID
  target_version_ids: UUID[]
  environment: Environment
  runner_type: human | deterministic | model | combined
  prompt_version_id: UUID | null
  model_configuration_version_id: UUID | null
  started_at: Timestamp
  completed_at: Timestamp | null
  status: running | passed | failed | invalidated | cancelled
}

validation_result {
  result_id: UUID
  run_id: UUID
  case_version_id: UUID
  output_payload: JSON
  expected_comparison: JSON
  metric_values: JSON
  error_codes: string[]
  reviewer_decision_ids: UUID[]
  created_at: Timestamp
}
```

Held-out cases cannot be used for prompt or model tuning before the associated
release decision. Exposure invalidates the split and requires replacement.

### 7.11 Release Candidate and Exam-Pack Manifest

```text
release_candidate {
  release_candidate_id: UUID
  exam_id: UUID
  school_year: string
  proposed_version: SemVer
  release_class: patch | minor | major | emergency
  manifest_id: UUID
  source_gate: pending | passed | failed
  rights_gate: pending | passed | failed
  teaching_gate: pending | passed | failed | not_applicable
  grading_gate: pending | passed | failed | not_applicable
  security_privacy_gate: pending | passed | failed | not_applicable
  release_gate: pending | passed | failed
  blocking_findings: UUID[]
  created_by: UUID
  created_at: Timestamp
}

exam_pack_manifest {
  manifest_id: UUID
  exam_id: UUID
  school_year: string
  exam_pack_version: SemVer
  artifact_version_ids: UUID[]
  source_version_ids: UUID[]
  rights_record_ids: UUID[]
  validator_policy_version_id: UUID
  teaching_policy_version_id: UUID
  grading_policy_version_id: UUID
  prompt_version_ids: UUID[]
  model_configuration_version_ids: UUID[]
  validation_run_ids: UUID[]
  qualification_rule_version_ids: UUID[]
  manifest_sha256: SHA256
  generated_at: Timestamp
}
```

The manifest is complete, immutable, and self-resolving. No production request
may combine versions from different active manifests.

### 7.12 Publication, Incident, Revalidation, and Audit

```text
publication_event {
  publication_event_id: UUID
  release_candidate_id: UUID
  manifest_id: UUID
  environment: Environment
  prior_manifest_id: UUID | null
  action: publish | rollback | suspend | resume
  approved_by: UUID[]
  executed_by: UUID
  executed_at: Timestamp
  transaction_id: string
  smoke_test_run_id: UUID
  outcome: succeeded | failed | reverted
}

quality_incident {
  incident_id: UUID
  severity: Severity
  detected_at: Timestamp
  detected_by: UUID
  affected_version_ids: UUID[]
  affected_manifest_ids: UUID[]
  category:
    scientific | exam_alignment | teaching | grading | rights |
    privacy | security | accessibility | release_integrity
  evidence: JSON
  containment_action: JSON
  status: open | contained | remediating | monitoring | closed
  incident_commander_id: UUID
  root_cause: string | null
  closed_at: Timestamp | null
}

revalidation_case {
  revalidation_id: UUID
  trigger_type:
    source_change | rights_change | artifact_change | dependency_change |
    model_change | prompt_change | metric_drift | incident |
    scheduled_review | reviewer_challenge
  trigger_record_id: UUID
  affected_version_ids: UUID[]
  impact_graph_snapshot: JSON
  required_scope: C0 | C1 | C2 | C3
  required_gates: string[]
  due_at: Timestamp
  status: open | in_progress | passed | failed | superseded
  disposition_manifest_id: UUID | null
}

audit_event {
  audit_event_id: ULID
  occurred_at: Timestamp
  actor_type: ActorType
  actor_id: string
  action: string
  object_type: string
  object_id: string
  prior_event_id: ULID | null
  request_id: string | null
  reason_code: string | null
  metadata: JSON
  event_sha256: SHA256
}
```

Audit events are append-only, time-ordered, access-controlled, and exported to
tamper-evident storage at least daily. Protected reads, exports, assignments,
reviews, approvals, publications, rollbacks, overrides, and entitlement changes
must be audited.

## 8. Source Hierarchy and Provenance Procedure

### 8.1 Authority Tiers

1. **Tier 1:** Current official exam authority, statute, regulation, license, or
   first-party scientific standard.
2. **Tier 2:** Peer-reviewed primary research, authoritative professional body,
   or current university-level reference.
3. **Tier 3:** Reputable textbook, review article, or established educational
   reference.
4. **Tier 4:** Third-party web content, informal explanation, or unverified
   user-provided material.

Tier 4 may identify issues or inspire original work but cannot be the sole source
for an official exam fact, disputed scientific claim, or scoring rule.

### 8.2 Source Intake

The Source Steward:

1. captures the exact source version or metadata snapshot;
2. records publisher, date, scope, retrieval date, and checksum;
3. assigns source type, authority tier, and refresh class;
4. creates claim-level links to affected artifact paths;
5. routes rights review;
6. routes factual review;
7. sets the next refresh due date;
8. records supersession or conflict with earlier sources.

### 8.3 Source Acceptance Checklist

Every blocking answer must be `Yes`:

- Is the source identity unambiguous?
- Is the captured version or retrieval snapshot immutable and checksummed?
- Does the scope statement avoid claiming more than the source supports?
- Is the publication or update date recorded when available?
- Is the source current for the target school year?
- Are conflicts with other sources identified?
- Are official facts separated from Cramapple calculations or judgments?
- Does every factual claim map to a source or explicit authored-judgment label?
- Is the refresh class and due date assigned?
- Is the source still available and not withdrawn?

## 9. Rights Review Procedure

The Rights Reviewer applies permitted use separately for storage, model input,
internal validation, learner display, and public commercial display.

### 9.1 Rights Acceptance Checklist

- Is ownership or license status documented?
- Is the exact intended use listed as permitted?
- Are territory, audience, attribution, and expiration conditions captured?
- Is generative-model input explicitly allowed when planned?
- Is commercial reproduction explicitly allowed when planned?
- Are official AP questions, scoring materials, and restricted teacher
  resources excluded unless written permission or counsel approval exists?
- Are student-provided materials isolated from canonical content?
- Are required notices and attributions included?
- Is the next rights review date set?
- Has counsel approved every non-routine or ambiguous case?

Any `No`, `Unknown`, expired permission, or dispute blocks the affected use.

### 9.2 Simple Tutor and AP Reader Release

Cramapple will use a short, plain-language release approved by counsel. The
release must cover, at minimum:

- identification of the creator or reviewer and covered work;
- payment and whether any further compensation is owed;
- assignment to Cramapple or an exclusive, perpetual, worldwide commercial
  license;
- rights to reproduce, edit, adapt, create derivatives, use as model input,
  validate, display, distribute, and sublicense;
- originality and no-conflicting-rights warranty;
- disclosure of sources, assets, collaborators, and tools;
- prohibition on official, secure, confidential, student-provided, or
  unauthorized third-party material;
- confidentiality and return or deletion of Cramapple materials;
- permission or prohibition for use of the person's name and credentials;
- correction, rejection, and takedown cooperation;
- signatures and governing template version.

AP Readers sign the same applicable IP and confidentiality terms plus an
attestation that their work does not disclose or rely on secure or confidential
Reading material. Counsel owns the final language; this section defines
operational requirements, not legal advice.

## 10. Authoring Procedure

### 10.1 Paid-Tutor Original-Question Model

Cramapple commissions qualified tutors to create original question packages.
Official historical questions are not production inputs.

The initial AP Biology bank uses all 60 official public topics in the current
Course and Exam Description. The planning target for every topic is at least ten
approved MCQs and five approved short-FRQ prompts. Each unit additionally
targets four long-FRQ stimulus packages with two independently deliverable
prompts per package.

One MCQ or one independently delivered and answered FRQ prompt counts as one
inventory item. The corrected full planning target is 964 inventory items:
600 MCQs, 300 short-FRQ prompts, and 64 long-FRQ prompts. The detailed matrix is
defined in `../product/CONTENT_QUANTITY_AND_DISTRIBUTION.md`.

These quantities are targets Cramapple will work to meet or exceed. A launch
below target requires a visible gap report, Learning Quality review, and Product
Owner approval; it does not silently lower the target.

Paid Tutor Authors receive an approved authoring brief containing:

- exam pack and school year;
- module, topic, learning objective, science practice, assessable skill target,
  task verb, question form, and intended difficulty;
- intended use, such as teaching, independent practice, diagnostic candidate,
  transfer, or delayed retrieval;
- required scientific concepts and approved factual sources;
- stimulus and representation requirements;
- point count and required reasoning operations;
- accessibility requirements;
- prohibited similarities and known coverage overlaps.

The brief may use abstract exam attributes derived from the public AP framework,
such as task verbs, science practices, timing, point structure, and public
weighting. It must not include official question text as a seed, paraphrase
target, transformation target, few-shot example, or generative-model input.

Paid Tutor Authors must not:

- copy, paraphrase, reskin, translate, or make numerical or organism-level
  substitutions to an official or third-party question;
- use secure AP Classroom, unreleased exam, credential-restricted, or
  confidential Reading material;
- submit a question previously sold, licensed, assigned, posted, or created for
  another client unless Cramapple has documented rights;
- reuse a third-party graph, image, dataset, passage, or answer choice without
  approved rights and provenance;
- claim that prior AP Reader, teacher, or tutor status makes a question
  approved.

Official public materials may be reviewed by authorized humans to maintain exam
familiarity and verify abstract alignment where legally permitted. That review
does not make official material part of the authored artifact or authorize
reproduction, adaptation, or model use.

### 10.2 Commission and Assignment Procedure

1. The Learning Quality Owner sets a coverage matrix by module, skill, task,
   representation, difficulty, and intended use.
2. A coordinator issues a versioned brief to one Paid Tutor Author.
3. The author accepts compensation, ownership, confidentiality, originality,
   source-disclosure, and revision terms.
4. The author submits a complete question package and originality attestation.
5. Automated and human preflight checks test completeness, internal consistency,
   source and rights status, and similarity to known material.
6. Failed preflight work is rejected or returned for revision before validation.
7. Teaching and grading validators review independently under Sections 11 and
   12.
8. The author may revise in response to findings, but each revision creates a
   new immutable version and repeats affected reviews.
9. Only an independently approved version may enter an exam-pack manifest.
10. Production evidence may trigger revision, suspension, retirement, or a new
    commission; it never silently changes the published version.

Question-family targets are set by coverage need, not by a fixed number of
derivatives from each historical question. Multiple questions in one family
must vary substantive context, representation, and reasoning demand enough to
support transfer rather than memorization.

### 10.3 Controlled AI Versioning

AI may create candidate versions only from base packages that Cramapple owns or
licenses with explicit rights to edit, adapt, create derivatives, and use as
model input.

The versioning request must identify:

- exact base artifact version;
- authoring brief and target subject-and-subtopic pair;
- permitted changes and invariants;
- target question form, representation, difficulty, and intended use;
- approved scientific sources and asset constraints;
- similarity limits;
- prompt, model, parameter, and policy versions.

AI versioning may vary context, values, organisms, representation, distractors,
or reasoning path only when the resulting question remains scientifically
sound, independently solvable, meaningfully distinct, and aligned to the target
skill. A superficial reskin does not count toward the ten-question coverage
target.

Every AI-created candidate:

- receives a new immutable artifact identity and version;
- identifies the human-owned base package and complete generation provenance;
- includes a complete rubric and teaching package;
- passes originality, similarity, source, rights, scientific, teaching,
  grading, accessibility, and exam-alignment review;
- is treated as unapproved until all applicable gates pass;
- is tested against an independent holdout procedure before production release.

The holdout design and passing thresholds are TBD. Until they are approved, AI
variants may be created and reviewed in validation but cannot count toward
production coverage or enter a production exam-pack manifest.

### 10.3.1 Alternative Authoring Model Experiment

The paid-tutor model remains the production baseline. AI-led creation of base
packages may be tested only in an isolated validation experiment using blank
governed briefs, approved factual sources, arm blinding, and the same
independent gates applied to tutor-authored packages.

Experimental base packages:

- receive complete immutable generation and review provenance;
- cannot use official questions, adaptation descriptions, contaminated
  artifacts, or evaluation holdouts;
- cannot count toward production coverage;
- cannot enter a production exam-pack manifest;
- remain subject to paid human accountability and independent review according
  to their experimental arm; and
- require a separate Product Owner decision before any authoring arm becomes
  production policy.

The approved experimental design is defined in
`../product/CONTENT_AUTHORING_MODEL_EXPERIMENT.md`.

### 10.4 Required Authoring Package

An author submits:

- immutable artifact payload;
- authoring brief version and commission identifier;
- signed originality and rights attestation;
- change summary and rationale;
- exam, taxonomy, skill, task, and question-type tags;
- provenance claims and source links;
- rights dependencies;
- teaching and grading dependencies;
- expected learner behavior;
- known failure and ambiguity cases;
- accessibility considerations;
- validation cases;
- proposed risk and change class.

### 10.4.1 Rejected Content and Anti-Examples

Rejected questions are not automatically useful training material. A rejected
artifact with official-question derivation, uncertain rights, contamination, or
distinctive source resemblance must be deleted or quarantined outside the
authoring and evaluation systems according to counsel-approved retention rules.

When a failure teaches a general lesson, Cramapple records an abstract failure
card containing the failure type, consequence, detection question, remediation,
and a newly authored synthetic regression case. It does not retain the rejected
wording, scenario, organisms, values, answer choices, or source locator.

The failure-card policy and initial catalog are defined in
`CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md`.

### 10.5 Question Package Minimum

Every canonical question contains:

- original question text and assets;
- exam pack, unit, topic, learning objective, science practice, skill, task verb,
  archetype, and difficulty;
- expected reasoning path without forcing one wording;
- required context and assumptions;
- rubric and independent point criteria;
- accepted alternatives and equivalent language;
- insufficient responses and contradictions;
- full-, partial-, and no-credit samples;
- teaching explanation, minimum fix, transfer item, and delayed variant;
- source, rights, version, and approval references.

Question text alone is not a complete commissioned deliverable.

For an MCQ package, the rubric and teaching package also include:

- keyed answer and a proof that it is the best answer;
- rationale for every distractor;
- misconception or error pattern represented by each distractor;
- ambiguity, cueing, and option-length review;
- stimulus interpretation requirements;
- minimum correction, teaching explanation, transfer item, and delayed variant.

For an FRQ package, the rubric and teaching package also include:

- independently decidable point criteria where the task permits;
- a required criterion-boundary contract for every criterion, per
  `CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §9.1 (earned/not-earned decision
  rule, required evidence, accepted variants, insufficient wording, contradiction
  rule, and at least one worked near-boundary positive and negative example); a
  criterion without a boundary contract is an incomplete package and cannot enter
  validation. The boundary contract's *required evidence* persists as a
  **non-empty `evidence_requirements`** field on every criterion record;
- required deterministic checks for every mechanical or structurally-checkable
  criterion, per the subject's `verification_profile`
  (`CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §7.1);
- accepted equivalent language and reasoning paths;
- insufficient, contradictory, and boundary responses;
- calculation, unit, graph, diagram, and notation rules where applicable;
- full-, partial-, and no-credit samples;
- criterion-specific minimum fixes — persisted as a **non-empty `minimum_fix`**
  field on every criterion record — plus transfer item and delayed variant.

**Required-field publication gate (both item types).** Every FRQ criterion record
MUST carry a non-empty `evidence_requirements` and a non-empty `minimum_fix`; every
MCQ distractor MUST carry a non-empty `rationale`. These are the persisted form of
the boundary contract's grading instruction and the student-facing repair coaching,
consumed at runtime by the grader prompt (`evidence_requirements`) and the
highest-value-gap repair path (`minimum_fix`); an empty value silently degrades
grading consistency and collapses repair coaching to a generic placeholder. An item
with any criterion missing either field **fails publication preflight and cannot be
published or remain published** — this is a blocking package-completeness gate,
enforced as a validation check in the fail-closed publication path (§16 /
`DECISION-0039`), not an authoring nicety. Changing a populated `evidence_requirements`
is a **C2** change (it alters grading behavior) and triggers artifact-family
revalidation; first-time population of an empty field on already-published content is
remediation of an incomplete package and is likewise gated and revalidated.

Author-generated samples are development cases. They do not establish a human
gold set, calibrate a grader, or satisfy the held-out requirements in Section
12. Gold evidence requires blind independent human scoring and adjudication.

MCQ and FRQ authoring may proceed simultaneously. Neither form inherits
approval from the other, and each artifact must pass its applicable independent
gates. Unreviewed candidate FRQs may be revised into new immutable versions or
rejected; candidate status does not make them exemplars, calibration evidence,
or production content.

### 10.6 Visual Stimulus Packages

Tables, charts, graphs, diagrams, models, experimental setups, and
learner-created graphs are governed content, not decorative attachments.

Every visual package must:

- identify its intended visual purpose and assessed representation;
- retain immutable data, specification, asset, accessible-representation, and
  renderer-profile dependencies;
- disclose source, rights, transformations, units, uncertainty, and synthetic
  status;
- pass scientific, teaching, grading, accessibility, answer-leakage, and
  rendered-output review;
- preserve the assessed construct across supported delivery modes; and
- fail closed rather than silently substitute prose when the visual operation
  is material to the question.

Free-form model-generated scientific images and untrusted SVG are not approved
production inputs. Deterministic rendering of validated structured
specifications and governed authored or constrained diagrams are the proposed
production paths.

The complete proposed logical design, validation checklist, revalidation rules,
and open owner decisions are defined in
`VISUAL_STIMULUS_AND_RENDERING_SYSTEM.md` and `TASK-0006`. Those decisions must
be approved before physical schema or renderer implementation.

### 10.7 Question Use Classification and Lifecycle

AP Reader Validators classify independently reviewed questions for intended
use. The classifications are:

- `reject`: do not use;
- `revise`: return for a new immutable version;
- `diagnostic_candidate`: eligible for a reserved diagnostic pool;
- `teaching_candidate`: eligible for teaching and practice;
- `dual_candidate`: potentially useful for either diagnostic or teaching use,
  but assigned to one active use at a time.

For the initial AP Reader review interface, `Yes` maps to
`teaching_candidate`, `No` maps to `reject`, and `Diagnostic` maps to
`diagnostic_candidate`. Reviewers may additionally select `revise` or
`dual_candidate` with a rationale.

An active diagnostic question is withheld from prior teaching and answer
exposure for the learner population in which it is intended to measure cold
performance. A diagnostic question may later graduate to teaching use or be
retired. Graduation or retirement requires a recorded lifecycle decision,
exposure review, replacement-coverage check, and new exam-pack manifest.

An independently expert-curated `diagnostic_candidate` may be used with
students before empirical confirmation. Its status records expert judgment, not
a claim of statistical validation.

Student use never changes an immutable question version. Performance evidence
may trigger investigation, reclassification, revision, suspension, retirement,
or a commission for additional questions.

Statistical thresholds and monitoring signals open a human review case. They do
not automatically demote, retire, revise, or republish an item. Any lifecycle
change requires an authorized human decision and a recorded rationale.

## 11. Teaching Validation Gate

### 11.1 Reviewer Count

| Artifact | Required independent reviewers | Adjudication |
| --- | --- | --- |
| R0 administrative | One verifier | Release Approver if disputed |
| R1 teaching artifact | Two Teaching Validators | Lead Teaching Validator for any disagreement |
| R2 rubric-linked teaching artifact | Two Teaching Validators, neither serving as its grading validators | Lead Teaching Validator |
| R3 shared policy or first artifact family | Three Teaching Validators, including one Lead | Learning Quality Owner recommendation and Product Owner approval for first production use |

Required reviewers must approve independently. `approve_with_notes` passes only
when every note is non-blocking and assigned a due date or explicitly accepted
as no-action.

### 11.2 Teaching Review Checklist

Blocker criteria require unanimous `Pass`:

- Scientific claims are accurate and source-supported.
- Exam facts align with the active school-year exam specification.
- The teaching objective matches the assessed skill and task.
- Diagnosis and intervention address the observed gap.
- Cold orientation does not reveal answer-bearing concepts, hidden criteria,
  formula choice, misconception identity, or data trend.
- Hints increase support gradually and do not jump directly to the answer.
- The explanation does not conflict with the approved rubric.
- The transfer item tests the same operation with meaningfully changed surface
  features.
- The artifact does not imply unsupported mastery, score prediction, or causal
  efficacy.
- Uncertainty and source limitations are represented.
- Rights and privacy gates pass.
- No protected or identifying learner material appears.

Scored criteria use 1 = unacceptable, 2 = major revision, 3 = acceptable,
4 = strong:

- clarity and concision;
- age-appropriate language;
- accessibility and representation;
- usefulness of feedback;
- alignment between misconception and repair;
- transfer quality;
- realistic AP task demand;
- recommendation quality and learner agency.

Release requires:

- all blocker criteria passed by every required reviewer;
- average at least 3.5 across scored criteria across reviewers;
- no individual scored criterion below 3;
- at least 11 of 12 applicable teaching validation scenarios passed;
- zero scientific, answer-leakage, rights, privacy, or grading-conflict defects.

## 12. Grading Validation Gate

### 12.1 Human Gold-Set Creation

Each validation response is blind-scored at criterion level by two qualified
Grading Validators.

- Exact agreement locks the provisional gold result.
- Any criterion or total-score disagreement goes to a Lead Grading Validator.
- The lead records an adjudication rationale tied to response evidence and
  rubric language.
- A rubric defect discovered during adjudication invalidates affected cases and
  reopens the rubric version.
- Model output is not shown until the gold result is locked.

### 12.2 Minimum Held-Out Set

Before first production release of an AP Biology grader:

- at least 300 independently authored, licensed, synthetic, or properly
  deidentified responses;
- at least 40 responses for each supported FRQ archetype;
- at least 25 positive and 25 negative examples for every criterion where
  feasible; rare criteria require all available cases plus a documented
  limitation;
- at least 15% partial-credit responses;
- at least 10% equivalent-language responses;
- at least 10% contradictory or internally inconsistent responses;
- at least 10% ambiguous, adversarial, or abstention-worthy responses;
- representation of concise, verbose, grammatically imperfect, and
  non-standard-but-valid responses;
- subgroup reporting only where attributes are lawfully collected, appropriately
  consented, and each reported group has at least 30 cases.

For a new question using an already approved archetype and unchanged grading
system, the minimum question-specific set is 40 responses, including at least
five each of full-credit, partial-credit, no-credit, equivalent, contradictory,
and ambiguous cases.

### 12.3 Automated Grading Release Thresholds

All thresholds apply to the held-out set and must pass:

| Metric | Required threshold |
| --- | --- |
| Criterion exact agreement | At least 95% overall and at least 90% for every criterion |
| Criterion precision | At least 0.93 for every criterion and 0.95 macro average |
| Criterion recall | At least 0.93 for every criterion and 0.95 macro average |
| Long-FRQ total-score exact agreement | At least 80% |
| Short-FRQ total-score exact agreement | At least 90% |
| Total score within one point | At least 98% |
| Mean absolute total-score error | At most 0.25 points |
| Weighted Kappa | At least 0.80 when statistically appropriate |
| Over-scoring rate | At most 5% of responses |
| Under-scoring rate | At most 5% of responses |
| Severe error rate | Zero confirmed severe errors |
| Ambiguity/escalation recall | At least 90% |
| False abstention rate on scorable responses | At most 10% |
| Feedback evidence grounding | At least 98% references actual response evidence and the applicable criterion |
| Generic or rubric-recycled feedback defect | At most 2% |

Additional release rules:

- No statistically or practically meaningful proportional bias may remain
  unexplained. A significant Bland-Altman slope or score-dependent error pattern
  blocks release until corrected and revalidated.
- No lawfully measured subgroup may fall below 90% criterion agreement or trail
  the overall rate by more than five percentage points without remediation,
  expanded evidence, and a passing rerun. If lawful sample size is insufficient,
  record the limitation and do not make subgroup-quality claims.
- Coverage is reported with accuracy. A system cannot pass by abstaining on
  difficult cases without meeting the false-abstention threshold.
- Passing aggregate metrics cannot override a repeated scientific, contradiction,
  rights, privacy, or severe feedback defect.

### 12.4 Grading Package Review Checklist

- Each point is independently decidable where the exam design permits.
- Criteria state required evidence, not preferred wording.
- Accepted variants are scientifically and logically equivalent.
- Insufficient responses distinguish vague truth from point-earning evidence.
- Contradictions identify when otherwise valid language must not earn credit.
- Samples cover score extremes and realistic middle performance.
- Calculation, units, graph, notation, and rounding rules are explicit.
- Rubric criteria do not leak into cold orientation.
- Feedback cites the learner response and criterion.
- The minimum fix is actually sufficient for the next point.
- Ambiguous and unsupported cases have an escalation rule.
- The package passes the complete metric suite.

### 12.5 Confidence-Building Release Sequence

Reasonable confidence comes from converging evidence, not a model-generated
confidence label.

1. Validate criterion independence and deterministic checks.
2. Create blind dual-human gold labels with lead adjudication.
3. Separate development, calibration, locked holdout, and challenge sets.
4. Calibrate abstention and confidence bands against observed criterion error.
5. Use independent grading passes for high-value or high-risk responses and
   escalate disagreement.
6. Run a shadow cohort in which humans review every response before automated
   scores become learner-facing.
7. During limited release, review every escalation and at least 20% of
   apparently high-confidence cases.
8. Graduate from limited release only through a recorded gate decision; general
   release then begins the first-30-days sampling regime in Section 17.1.
9. Maintain hidden sentinel cases, production sampling, dispute review,
   regrading, drift monitoring, and suspension triggers.

Author-generated responses remain development cases. Synthetic responses may
expand coverage but cannot substitute for independently adjudicated evidence.
The operational plan and Done gates are defined in `TASK-0010`.

## 13. Approval Thresholds and Release Authority

### 13.1 Gate Matrix

| Release content | Source | Rights | Teaching | Grading | Release approval |
| --- | --- | --- | --- | --- | --- |
| Teaching-only patch | Required | Required | Two Teaching Validators | Not applicable unless rubric-linked | One Release Approver |
| New question and rubric | Required | Required | Two Teaching Validators | Two Grading Validators plus adjudication as needed and metric pass | One Release Approver |
| Shared teaching or grading policy | Required | Required | Three Teaching Validators | Three Grading Validators when scoring is affected | Learning Quality Owner recommendation plus Product Owner |
| New school-year exam pack | Required | Required | Full teaching gate | Full grading gate | Learning Quality Owner recommendation plus Product Owner |
| First production launch | Required | Required, including counsel gate | Full teaching gate | Full grading gate | Product Owner |
| Emergency rollback | Existing approved evidence | Existing approved evidence | Prior approved gate | Prior approved gate | Incident Commander executes; Product Owner notified immediately |

Approval requires all assigned reviewers, not a majority. Disagreement is
resolved through adjudication, revision, rejection, or risk acceptance. A tie or
missing decision never passes.

### 13.2 Exceptions

No exception may bypass:

- unknown or prohibited rights;
- missing source provenance for official or scientific facts;
- a confirmed scientific error;
- a confirmed scoring-boundary error;
- exposed restricted learner data;
- an invalid or incomplete release manifest.

Other exceptions require a written risk statement, scope, expiration, monitoring
plan, rollback plan, Learning Quality Owner recommendation where educational
quality is affected, and Product Owner approval.

An exception cannot waive a teaching blocker, a grading release threshold, or
required validator independence for a first production launch or new school-year
exam pack. A bounded non-production pilot may use a lower exploratory threshold
only when learners do not receive the result as authoritative, the deviation is
disclosed, and the Product Owner approves the pilot.

## 14. Atomic Publication Procedure

The Release Approver performs:

1. Freeze the release candidate and generate its immutable manifest.
2. Verify every referenced version exists and its checksum matches.
3. Verify no referenced source is withdrawn and no rights record is expired.
4. Verify all applicable gates are `passed` and all blocking findings are closed.
5. Verify required validation runs use the exact manifest versions.
6. Run schema, dependency-cycle, missing-reference, entitlement, and policy
   checks.
7. Run production-like smoke tests in validation.
8. Record release approval.
9. In one database transaction:
   - insert the publication event;
   - set the active exam-pack pointer to the new manifest;
   - write the outbox event;
   - preserve the prior pointer.
10. Resolve the active pack from a fresh production request and run smoke tests.
11. If smoke tests fail, atomically restore the prior manifest and open an
    incident.
12. Begin heightened monitoring.

Partial activation is prohibited. Caches use the manifest ID as part of the key
and must not mix versions.

## 15. Source Refresh Schedule

The next review occurs at the earlier of the scheduled interval or an event
trigger.

| Refresh class | Scheduled review | Event trigger |
| --- | --- | --- |
| EXAM official specification and scoring | Monthly from June 1 through January 14; weekly from January 15 through the exam date; within 30 days after the exam | Official bulletin, new course/exam description, scoring update, erratum, delivery-mode change |
| RIGHTS license, permission, trademark, and terms | Quarterly and 30 days before any major release | Notice, dispute, expiration within 60 days, terms change, takedown request |
| SCIENCE_STABLE foundational scientific claims | Every 12 months | Source withdrawal, authoritative correction, validator challenge |
| SCIENCE_VOLATILE current data, policy, or actively changing science | Every 90 days | New authoritative publication or material contradiction |
| LINK_ONLY availability and metadata | Automated monthly link check; human review every 180 days | Broken link, redirect to different content, checksum change |
| PROVIDER_POLICY model, data use, retention, and service terms | Every 30 days | Provider notice, model retirement, policy or regional-processing change |

For every refresh:

- unchanged content records a completed review and a new due date;
- changed content creates a new source version;
- the impact service traverses all `review_on_change`,
  `revalidate_on_change`, and `retire_on_change` dependencies;
- overdue blocking sources prevent new publication;
- an active release with a source overdue by more than 30 days creates an S2
  incident unless a documented grace period was approved before the due date.

## 16. Full Versus Partial Revalidation

### 16.1 C0 Verification

C0 applies only when meaning, scoring, learner behavior, source scope, and rights
do not change.

Required:

- one independent verifier;
- automated diff and checksum evidence;
- link and render check where applicable;
- no teaching or grading metric rerun.

Examples: spelling correction, layout correction, alt-text punctuation, or
replacement of a broken URL with the canonical URL for the identical source.

### 16.2 C1 Partial Revalidation

C1 applies to a local semantic change that does not change scoring boundaries or
shared policy.

Required:

- complete source and rights checks for changed claims;
- two teaching reviews for learner-visible teaching;
- rerun all direct validation cases and regression cases selected through the
  dependency graph;
- review direct dependents;
- no untouched artifact is presumed affected without a dependency path.

Examples: clarify an explanation, improve a hint, add a scientifically
equivalent example, or revise a transfer item without changing the target.

### 16.3 C2 Full Artifact-Family Revalidation

C2 is mandatory when any of the following changes:

- criterion meaning, point boundary, accepted variant, insufficiency, or
  contradiction;
- question demand, required reasoning, data, answer, or point count;
- grader prompt, deterministic scoring logic, model, model parameters, output
  schema, confidence policy, or escalation behavior;
- shared teaching policy, diagnosis rule, hint policy, or recommendation rule;
- a source change materially alters a supported claim;
- a defect indicates similar artifacts may share the same cause.

Required:

- new immutable versions for all changed artifacts;
- full teaching review for the artifact family;
- full grading review and held-out metric suite when grading is affected;
- regression of every dependent question, rubric, teaching artifact, and
  validation suite selected by the impact graph;
- release as a new minor or major exam-pack version.

### 16.4 C3 Full Exam-Pack Revalidation

C3 is mandatory when any of the following occurs:

- new school-year exam specification;
- change to exam timing, section weight, question count, point distribution,
  task definition, calculator rule, delivery mode, or curriculum scope;
- taxonomy IDs or meanings change in a way that affects evidence continuity;
- rights loss affects a source or asset used across the pack;
- shared scientific correction affects more than one artifact family;
- validator qualification policy or release threshold materially changes;
- architecture or data migration can change version resolution or scoring
  provenance;
- an S0 or systemic S1 incident occurs;
- Product Owner, Learning Quality Owner, or counsel requires full review.

Required:

- regenerate the complete manifest;
- refresh all Tier 1 exam sources and blocking rights records;
- validate all pack-critical artifact families;
- run the full teaching and grading suites;
- verify learner-evidence comparability and migration behavior;
- run atomic-publication rehearsal and rollback rehearsal;
- Learning Quality Owner recommendation;
- Product Owner approval.

### 16.5 Revalidation Deadline

| Trigger severity | Triage | Containment or decision | Revalidation due |
| --- | --- | --- | --- |
| S0 | 15 minutes | 30 minutes | Before any resume |
| S1 | 1 hour | 4 hours | Five business days |
| S2 | One business day | Two business days | Ten business days |
| S3 | Three business days | Five business days | Next scheduled release, no later than 30 days |

## 17. Production Monitoring

### 17.1 Sampling

For the first 30 days after a new major exam-pack or grading-system release:

- review all learner disputes, `content_uncertain` cases, and low-confidence
  grades;
- random-review 5% of graded FRQ responses, with a minimum of 100 and maximum
  of 500 per week; if volume is below 100, review all available responses;
- random-review 2% of teaching interactions, with a minimum of 50 and maximum
  of 250 per week;
- stratify by question archetype, score band, confidence, and support level.

After 30 stable days:

- random-review 1% of graded FRQ responses, minimum 50 and maximum 250 per week;
- random-review 0.5% of teaching interactions, minimum 25 and maximum 100 per
  week;
- continue 100% review of disputes, severe flags, rights reports, and
  `content_uncertain` escalations.

Monitoring samples use deidentified evidence unless identifiable access is
strictly required and authorized.

### 17.2 Monitoring Metrics

Track by manifest, question, criterion, archetype, prompt, model, and lawful
subgroup where available:

- criterion agreement, precision, recall, and total-score error;
- over-scoring, under-scoring, abstention, and severe errors;
- disagreement reason and adjudication outcome;
- scientific and exam-alignment defects;
- generic, unsupported, or contradictory feedback;
- answer leakage and inappropriate support;
- immediate transfer, delayed retention, and hint dependence;
- student confusion and dispute rates;
- accessibility defects;
- source freshness and rights expiration;
- validator agreement, queue age, and calibration drift;
- manifest-resolution, checksum, and mixed-version errors.
- question attempt count, completion time, omission rate, facility, criterion
  performance, MCQ option functioning, discrimination, dispute rate, grader
  disagreement, support exposure, and diagnostic-versus-teaching use;
- coverage gaps by subject, subtopic, skill, representation, difficulty, and
  intended use.

The minimum student sample required to revise, reclassify, suspend, or retire an
item based on performance statistics is TBD. Until approved, performance data
opens a human review case but does not automatically change item status.

### 17.3 Automatic Triggers

Open revalidation and suspend affected versions when:

- any confirmed rights prohibition, restricted-data exposure, mixed-manifest
  response, or systemic scientific error occurs;
- rolling criterion agreement over 200 reviewed cases falls below 92%;
- any criterion falls below 88% agreement over at least 30 reviewed cases;
- severe grading error exceeds 0.5% or two confirmed severe errors share a cause
  within 30 days;
- over-scoring or under-scoring exceeds 7% over 200 cases;
- verified learner disputes exceed 1% over at least 200 uses;
- answer-leakage blockers occur twice in one artifact family within 30 days;
- a source is withdrawn, materially changed, or overdue beyond policy;
- validator calibration or model performance falls below qualification or
  release thresholds;
- a dependency or checksum mismatch is detected.

Crossing a trigger does not automatically blame a learner or model. It creates
an evidence-preserving quality case.

## 18. Incident Severity and Response

| Severity | Definition | Default action |
| --- | --- | --- |
| S0 Critical | Active rights violation, restricted-data exposure, pack integrity failure, or widespread materially wrong scoring/teaching | Stop affected service or pack, rollback immediately, notify Product Owner |
| S1 High | Material scientific/scoring defect with meaningful learner impact but bounded scope | Suspend affected artifacts, route to safe fallback, begin urgent revalidation |
| S2 Medium | Confirmed defect with limited impact or a threshold breach without evidence of widespread harm | Remove from selection where practical, queue correction, increase monitoring |
| S3 Low | Cosmetic, clarity, metadata, or isolated non-blocking issue | Correct through scheduled patch |

Incident procedure:

1. preserve evidence and identify active manifest IDs;
2. contain without overwriting history;
3. assign severity and Incident Commander;
4. identify affected learners and outputs where possible;
5. rollback, suspend, or route to `content_uncertain`;
6. notify required owners;
7. perform root-cause and dependency analysis;
8. create replacement versions and revalidation cases;
9. determine whether learner-visible correction is required;
10. monitor the remediated release;
11. close only after evidence, corrective action, and approval are recorded.

## 19. Retirement and Rollback

### 19.1 Retirement

Retire an artifact when:

- superseded by a newer approved version;
- no longer aligned with the active exam;
- its source or rights are withdrawn;
- it contains a confirmed defect and correction is not immediate;
- usage is no longer justified and dependencies have migrated.

Retirement requires:

- impact graph and affected manifest list;
- replacement or safe-fallback plan;
- learner-history preservation;
- search, cache, and recommendation exclusion;
- effective date and reason;
- Release Approver decision;
- Product Owner approval when pack coverage, product scope, or accepted risk is
  materially reduced.

Retired content remains available to authorized audit and historical result
resolution. It is not deleted merely because it is no longer active.

### 19.2 Rollback

Rollback always targets a previously approved immutable manifest.

Procedure:

1. select the most recent compatible approved manifest;
2. verify its rights have not expired or been withdrawn;
3. atomically switch the active pointer;
4. invalidate manifest-keyed caches;
5. run production smoke tests;
6. preserve responses already graded under the superseded manifest;
7. create new evaluations if regrading is required;
8. notify Product Owner and Learning Quality Owner;
9. open revalidation for the failed release.

Rollback never rewrites a learner's original submission or original evaluation.

## 20. Audit and Reporting

### 20.1 Required Audit Events

Audit:

- source and rights creation, review, expiry, and supersession;
- artifact creation and state transition;
- assignment, access, recusal, decision, adjudication, and override;
- qualification grant, renewal, suspension, and revocation;
- validation-suite access and held-out exposure;
- release candidate creation, approval, publication, rollback, and failure;
- incident creation, severity change, containment, and closure;
- protected export and administrative entitlement change.

### 20.2 Retention

Governance, release, source, rights, qualification, and audit records are
retained for at least seven years after the last active use of the associated
exam-pack release, unless counsel requires a longer period or privacy law
requires deletion or deidentification of a linked person.

Learner response retention is governed separately. Governance records should
reference deidentified case IDs rather than duplicate learner identity.

### 20.3 Reports

| Report | Frequency | Owner |
| --- | --- | --- |
| Open blockers, queue age, overdue sources, expiring rights | Weekly | Quality Monitor |
| Validator agreement and calibration | Monthly | Learning Quality Owner |
| Grading and teaching production quality | Monthly in season; quarterly otherwise | Quality Monitor |
| Rights and source audit | Quarterly | Rights Reviewer and Source Steward |
| Exam-pack readiness | At each release candidate | Release Approver |
| Governance effectiveness and threshold review | Annually after the AP exam season | Product Owner and Learning Quality Owner |

Reports may recommend threshold changes, but cannot change gates without a new
approved policy version.

## 21. End-to-End Operating Procedure

1. **Plan:** define artifact, owner, exam-pack scope, risk, sources, rights, and
   acceptance criteria.
2. **Source:** capture immutable sources and claim-level provenance.
3. **Rights:** approve each intended use or block it.
4. **Author:** create immutable artifact and dependency versions.
5. **Preflight:** validate schemas, checksums, references, permissions, and
   conflicts.
6. **Teach review:** collect required blind-independent teaching decisions.
7. **Grade review:** create adjudicated gold cases and run the metric suite where
   scoring is affected.
8. **Adjudicate:** resolve disagreement without changing locked evidence.
9. **Revise:** create new versions for any change and invalidate superseded
   review evidence as necessary.
10. **Assemble:** generate the complete immutable exam-pack manifest.
11. **Approve:** verify every applicable gate and record release authority.
12. **Publish:** atomically activate the full manifest.
13. **Monitor:** sample production behavior and compare with release baselines.
14. **Respond:** contain incidents, suspend, retire, or rollback when required.
15. **Refresh:** recheck sources, rights, validators, models, and policies on
    schedule or event.
16. **Revalidate:** apply C0, C1, C2, or C3 rules through the dependency graph.
17. **Audit:** retain a reconstructable history of every learner-visible version
    and decision.

## 22. Definition of Ready for Production

An exam pack is ready for Product Owner production review only when:

- every manifest reference resolves and matches its checksum;
- every official and scientific claim has accepted provenance;
- every intended use has current rights approval;
- all required teaching reviews and scenario thresholds pass;
- all required grading gold sets and metrics pass;
- all validators were qualified and independent at decision time;
- all blocker findings are closed;
- monitoring, incident, retirement, and rollback procedures are configured;
- source-refresh and rights-review due dates are active;
- validation and production environments resolve the same manifest;
- the rollback rehearsal succeeded;
- the Learning Quality Owner recommends release;
- residual risks and limitations are written plainly.

Only the Product Owner may approve the first production launch, a new school-year
exam pack, a major policy change, or explicit quality-risk acceptance.

## 23. Initial Implementation Requirements

Before this procedure can be operational rather than documentary, Cramapple
must implement:

- immutable source, rights, artifact, review, validation, release, incident, and
  audit stores;
- qualification and conflict-aware assignment;
- blind independent review;
- dependency impact analysis;
- held-out-set access controls;
- gate computation;
- atomic manifest publication and rollback;
- production sampling and threshold alerts;
- validator and release dashboards;
- tamper-evident audit export;
- least-privilege entitlements and protected-content handling.

Implementation requires separately approved technical tasks, physical schemas,
security review, and QA.
