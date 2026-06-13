# Content Authoring and Prompt Architecture

**Status:** Proposed architecture; experiment direction approved
**Owner:** Main Conductor / Learning Quality Owner / Technical Owner
**Product Owner:** David Bloom
**Related Tasks:** `TASK-0005`, `TASK-0007`, `CONTENT-001`
**Last Updated:** 2026-06-13

## 1. Purpose

This document defines how Cramapple composes authoring instructions, creates
candidate MCQ and FRQ packages, protects the human abstraction firewall, and
tests alternative authoring business models without silently changing
production policy.

The architecture must support additional AP subjects eventually, but AP Biology
quality and the August 2026 beta remain the immediate priority.

## 2. Controlling Decisions

1. Official question text, scoring material, and identifiable official question
   structures do not enter authoring prompts, examples, adaptation workflows,
   or model inputs.
2. The current production baseline remains paid qualified tutors creating or
   selling complete proprietary base packages.
3. AI may create controlled variants from proprietary packages with explicit
   derivative and model-input rights.
4. Alternative AI-led base-authoring models may be tested only through the
   isolated experiment in
   `../product/CONTENT_AUTHORING_MODEL_EXPERIMENT.md`.
5. Every candidate, regardless of authoring arm, receives the same independent
   originality, scientific, teaching, grading, accessibility, rights, and
   release gates.
6. Physical Supabase or Postgres design remains deferred.

## 3. Rejected Material

The proposed official-derived MCQ is rejected and must not be stored in
Cramapple's content repository, exemplar library, prompts, model inputs,
evaluation sets, or anti-example corpus. Its provenance explicitly identified
an official question as the adaptation source. Changing the organism, location,
or numbers does not satisfy the approved abstraction firewall.

Any model conversation, draft, file, or derived artifact exposed to the source
question must be treated as contaminated until a Source Steward determines its
scope. Contaminated content is excluded from production and evaluation.

## 4. Anti-Example Policy

Flawed candidate questions can teach useful lessons, but retaining complete
items creates unnecessary contamination, anchoring, and rights risk.

Cramapple retains **failure cards**, not rejected questions.

Each failure card contains:

```text
failure_card {
  failure_code: string
  artifact_family: mcq | short_frq | long_frq | visual | rubric | teaching
  abstract_failure: string
  why_consequential: string
  detection_question: string
  blocking_or_scored: blocker | scored
  automated_check_possible: boolean
  required_human_qualification: string
  remediation_rule: string
  regression_case: synthetic and independently authored
}
```

Failure cards must not retain:

- original or rejected question wording;
- distinctive organisms, locations, datasets, values, or answer choices;
- source-question descriptions or locators;
- copyrighted or credential-restricted material;
- a "before" example that could become a model seed; or
- enough detail to reconstruct the rejected item.

The initial failure-card catalog includes:

| Code | Abstract failure | Detection question |
| --- | --- | --- |
| `MISSING_OPERAND` | The keyed calculation relies on a value absent from the stimulus | Can a learner derive every required value from the presented package? |
| `DUPLICATE_DISTRACTOR_LOGIC` | Multiple distractors test the same error while another plausible error is uncovered | Does each distractor provide distinct diagnostic information? |
| `UNDERDETERMINED_PREDICTION` | More than one outcome is defensible without a stated assumption | Is one response best, or does the rubric accept all justified outcomes? |
| `OMITTED_CAUSAL_LINK` | The expected conclusion skips a material intermediate relationship | Does the claimed mechanism follow from the complete system described? |
| `UNSOURCED_SPECIFICITY` | A biologically specific dependency or exclusivity claim lacks authoritative support | Is every consequential scientific claim sourced at the required tier? |
| `PSEUDOREPLICATION_OR_UNCERTAINTY` | The design or displayed evidence cannot support the strength of the requested conclusion | Are replication, independence, variation, and uncertainty adequate? |
| `UNDEFINED_QUALITATIVE_THRESHOLD` | Terms such as high, moderate, or resilient have no decision rule | Could independent validators apply the label consistently? |
| `EXAM_FORMAT_MISMATCH` | Point count, task structure, or timing conflicts with the active exam specification | Does the package resolve to the current exam-pack rules? |

Regression cases for these cards must be written from a blank brief by a person
or model that has not received the rejected item.

## 5. Prompt Composition Model

The useful part of the proposed shared/subject/question-type architecture is
retained, but raw Markdown concatenation is not the authoritative design.

Every authoring run uses an immutable **prompt build manifest**:

```text
prompt_build_manifest {
  manifest_id: UUID
  manifest_version_id: UUID
  governance_policy_version_id: UUID
  exam_pack_version_id: UUID
  taxonomy_scheme_version_ids: UUID[]
  task_archetype_version_id: UUID
  authoring_brief_version_id: UUID
  source_package_version_ids: UUID[]
  base_package_version_ids: UUID[]
  output_schema_version_id: UUID
  failure_card_suite_version_id: UUID
  model_configuration_version_id: UUID
  ordered_component_hashes: SHA256[]
  compiled_prompt_sha256: SHA256
}
```

The manifest composes seven concerns:

1. **Universal governance:** originality, rights, provenance, complete-package,
   accessibility, validation, and prohibited-input rules.
2. **Exam pack:** school-year-specific public exam structure and official facts.
3. **Taxonomy schemes:** topics, practices, task verbs, representations,
   misconceptions, and other parallel classifications.
4. **Task archetype:** MCQ, short FRQ, long FRQ, graph construction, model
   analysis, and future subject-specific forms.
5. **Coverage brief:** exact topic, skill, difficulty, representation, use, and
   portfolio gap.
6. **Permitted source or base package:** approved factual sources and, when
   applicable, proprietary packages with model-input rights.
7. **Output and validation contract:** structured schema, self-checks, and
   applicable failure cards.

Markdown remains the human-reviewable canonical medium for instruction
components. A deterministic compiler resolves the manifest, validates required
components, produces the provider-specific prompt, and records the exact hash.

Components use explicit identifiers and insertion points. They are not
unstructured files concatenated in an undocumented order.

## 6. Multi-Subject Logical Model

The architecture should avoid AP Biology-only names without prematurely
designing all future subjects.

Logical entities include:

- `subject`;
- `exam_pack` by school year;
- `taxonomy_scheme`;
- `taxonomy_node`;
- `task_archetype`;
- `representation_type`;
- `stimulus_package`;
- `verification_profile`; and
- immutable question, rubric, teaching, and evaluation artifacts.

A subject may have multiple parallel taxonomy schemes. For example, a future
history course may need content periods, historical reasoning processes, and
document-use skills. A single generalized `course_practices` list is
insufficient.

Stimulus packages are reusable governed artifacts. One package may contain
ordered passages, documents, tables, charts, maps, images, or accessible
alternatives. Questions link to immutable stimulus-package versions rather than
owning mutable stimulus rows.

## 7. Verification Architecture

Authoring-model self-critique is useful but never authoritative.

Verification runs after generation through controlled pipeline services:

- JSON Schema and package-completeness validation;
- source, rights, and similarity preflight;
- deterministic calculation checks;
- visual-specification validation;
- symbolic mathematics where applicable;
- sandboxed code compilation and execution where applicable;
- scientific consistency checks; and
- independent human teaching and grading gates.

The model may receive verifier feedback during a repair loop, but the release
record comes from the external pipeline. A model cannot mark its own output
verified.

## 8. MCQ Package Contract

An MCQ authoring result is a complete candidate package containing:

- stem and any immutable stimulus dependency;
- four answer choices unless the active exam pack specifies otherwise;
- one best answer;
- proof of the keyed answer;
- rationale for every choice;
- a distinct misconception or error mechanism for every distractor;
- accepted assumptions;
- source and rights claims;
- difficulty and representation rationale;
- teaching explanation;
- minimum correction;
- immediate transfer and delayed-retrieval candidates;
- accessibility representation; and
- failure-card self-check results.

Parseable JSON is necessary but not evidence of quality.

## 9. FRQ Package Contract

Short and long FRQs may use separate authoring components initially, but this is
an empirical architecture hypothesis rather than a permanent rule.

Question-number labels such as Q1 through Q6 are exam-pack metadata. Prompt
logic uses versioned task archetypes so an exam change does not require
rewriting the entire authoring architecture.

An FRQ candidate package includes:

- shared stimulus and assumptions;
- independently deliverable prompt parts;
- point count resolved from the active exam pack;
- criterion-level scoring rules;
- accepted alternatives and equivalent reasoning;
- insufficient, contradictory, and boundary responses;
- calculation, unit, graph, diagram, and notation rules;
- full-, partial-, no-credit, equivalent, contradiction, and ambiguity test
  cases;
- teaching explanation and criterion-specific minimum fixes;
- transfer and delayed-retrieval candidates; and
- complete source, rights, accessibility, and generation provenance.

Author-generated sample responses are **development test cases**, not a human
gold set and not sufficient to calibrate or release a grader. Gold evidence
continues to require blind independent human scoring and the held-out thresholds
in `CONTENT_GOVERNANCE_AND_VALIDATION.md`.

## 10. Sequencing

Cramapple develops MCQ and FRQ authoring in parallel. They share governance,
prompt-build, source, rights, and validation infrastructure, while retaining
separate package contracts and specialist review.

Parallel does not mean uncoordinated. Shared failures and improvements are
recorded once in the governing component or failure-card suite and then tested
across both workstreams.

The first vertical slice should include:

1. one MCQ package;
2. one short-FRQ package;
3. one long-FRQ package;
4. one quantitative visual;
5. criterion-level human scoring; and
6. the complete authoring, provenance, validation, release-candidate, and
   rollback trail.

After the vertical slice passes, content can scale by portfolio priority.

The ecology FRQs reviewed from the external archive are unapproved candidates.
They are not exemplars, production content, or calibration evidence. Qualified
tutors and AP Reader Validators may edit them into new immutable versions or
reject them. Promotion depends on complete source, rights, teaching, grading,
visual, and accessibility review.

## 11. Approval Boundaries

The following require Product Owner approval:

- moving any experimental authoring arm into production;
- adopting an authoring prompt or model configuration;
- changing the human abstraction firewall;
- treating generated samples as calibration evidence;
- executing a physical database design;
- changing the required independence or reviewer counts; or
- lowering an originality, rights, teaching, grading, or accessibility gate.
