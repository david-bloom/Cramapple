# Cramapple Bio Reference Layer Plan

**Status:** Planning draft for Product Owner and Learning Quality review
**Owner:** Product Owner with Learning Quality Owner
**Last Updated:** 2026-06-17

## 1. Purpose

This document defines a plan for building a compact AP Biology reference layer
that Cramapple can retrieve during grading, feedback, repair, and content
authoring.

The immediate motivation is the summer beta. GPT-5.5 grading is accurate enough
to test the experience, but early measurements show high latency and cost for
short-FRQ grading. A task-shaped reference layer should reduce prompt size,
output verbosity, reasoning burden, and grading inconsistency.

This is not a plan to ingest a giant biology textbook or scrape official AP
materials. The useful artifact is a governed set of small, searchable,
versioned cards that tell the model exactly which biological facts, mechanisms,
accepted variants, misconceptions, and repair moves matter for a given task.

## 2. Goals

1. Improve criterion-level grading consistency.
2. Reduce model latency and cost per graded attempt.
3. Let cheaper model settings perform closer to expensive settings.
4. Reduce generic feedback and rubric recycling.
5. Support accepted answer variants without over-crediting vague answers.
6. Make one-point repair suggestions more precise.
7. Create reusable source material for future Cramapple-authored content.
8. Preserve rights, provenance, review status, and version history.

## 3. Non-Goals

- Do not copy College Board questions, scoring guidelines, sample responses, or
  protected figures into the reference layer.
- Do not use unreviewed generated biology text as production truth.
- Do not treat rights-restricted third-party study guides as Cramapple source
  material without separate approval.
- Do not create a broad literature library for open-ended biology research.
- Do not replace question-specific rubrics.
- Do not use the reference layer to reveal answer-bearing help before a cold
  attempt.
- Do not present retrieved references to learners as official AP scoring
  authority.

## 4. Product Hypothesis

For short FRQ grading, the model currently spends tokens discovering or
reconstructing the biological context, acceptable variants, and missing-step
language on every request.

If Cramapple retrieves 3-8 compact reference cards relevant to the question and
rubric, the grader can:

- use less reasoning;
- emit shorter structured feedback;
- avoid long generic explanations;
- make more stable criterion decisions; and
- support lower-cost model settings.

The first success target is not broad biology coverage. It is measurable
improvement on the six summer-beta FRQs.

The primary business test is whether compact reference context lets a cheaper
or faster model setting produce grading quality close enough to the current
high-quality baseline to justify the card-authoring pipeline. A smaller speed
or cost gain on the expensive setting is useful, but it is not the main reason
to build the layer.

## 4.1 Experiment Findings and Architecture Pivot

Phase 0 and follow-up tests did not support the original assumption that
biology reference cards would improve cost, speed, and quality for the sampled
AP Biology FRQs.

Observed results:

- generic biology cards did not improve quality, reasoning-token use, latency,
  or cost beyond the medium/compact no-card baseline;
- whole-response exemplars contained some calibration signal but were too
  blunt and expensive as prompt context;
- online criterion-precedent flywheel retrieval failed the protocol thresholds
  and showed no improvement curve as precedent volume grew;
- oracle-selected scored precedents improved quality-only C2 decisions when
  valid, but were slower, more expensive, and less schema-reliable than
  control;
- a first gated-prompt test worsened C2 over-credit because the gate still
  allowed vague "random allele-frequency change" wording to count as
  construction-event randomness.

The resulting architecture direction is:

```text
Optimize the grader-agent and rubric-boundary contract before investing in a
production biology-card or exemplar-retrieval layer.
```

The durable "intelligence layer" should start as governed criterion-boundary
knowledge, not a biology fact library. For each grading-sensitive criterion,
Cramapple needs:

- an explicit evidence gate;
- accepted and insufficient boundary examples reviewed as part of the rubric;
- contradiction and ambiguity rules;
- minimum-fix language;
- adjudicated labels for known boundary cases;
- a versioned prompt/agent contract that requires evidence extraction before
  awarding credit; and
- a defect path when labels and rubric wording disagree.

Reference cards may still be useful later for teaching, repair, authoring, and
long-tail biology. They are no longer the next production investment for
initial FRQ grading until the boundary-contract layer shows stable value.

## 5. Reference Card Types

### 5.1 Concept Card

Defines the core biological claim for a topic.

Example fields:

- unit;
- topic;
- canonical claim;
- concise explanation;
- learner-safe wording;
- technical wording;
- common insufficient wording.

### 5.2 Mechanism Chain Card

Defines a causal sequence that often earns FRQ points.

Example:

```text
heat increase -> weak interactions disrupted -> enzyme tertiary structure
changes -> active site shape changes -> substrate binding decreases ->
reaction rate decreases
```

Fields:

- trigger conditions;
- ordered mechanism steps;
- required links;
- optional enrichments;
- common skipped step;
- minimum fix.

Mechanism-chain cards can be answer-bearing. Phase 0 and Phase 1 should test
whether they improve grading without causing over-generous pattern matching.
If they increase over-credit risk, restrict them to teaching-after-attempt and
repair flows rather than initial grading.

### 5.3 Accepted Variant Card

Lists response phrasings that should count for a criterion.

Fields:

- criterion_id;
- accepted variant;
- equivalent technical wording;
- notes for English-learner or concise responses.

Accepted-variant cards are grading-sensitive rubric extensions. They must be
version-controlled with the rubric criterion they interpret. Adding, widening,
or narrowing an accepted variant triggers rubric review and may require
revalidation of affected grading behavior.

### 5.4 Insufficient Wording Card

Lists response phrasings that should not count for a criterion even when they
sound related to the target biology.

Fields:

- criterion_id;
- insufficient wording;
- why it is insufficient;
- borderline wording;
- not accepted wording;
- common over-credit risk;
- minimum fix.

### 5.5 Misconception Card

Defines a common wrong model without treating one answer as proof of a stable
misconception.

Fields:

- misconception hypothesis;
- response signals;
- distractor or FRQ pattern;
- discriminating probe;
- repair move;
- caution language.

### 5.6 Rubric Pattern Card

Defines recurring AP Biology scoring patterns without replacing the
question-specific rubric.

Examples:

- identify plus explain mechanism;
- data trend plus biological explanation;
- prediction plus justification;
- experimental control plus expected outcome;
- inherited trait plus evolutionary change.

### 5.7 Repair Move Card

Defines the smallest useful intervention for a missed criterion.

Fields:

- missed criterion type;
- repair prompt;
- bracket-marker pattern;
- worked-example pointer;
- transfer condition;
- when not to use.

### 5.8 Calculation or Data Rule Card

Defines formulas, graph-reading rules, units, or deterministic checks for
quantitative and data-analysis tasks.

Examples:

- chi-square interpretation;
- Hardy-Weinberg setup;
- water potential relationship;
- independent/dependent variable identification;
- error-bar comparison limits.

## 5.9 Criterion Boundary Contract

The next grading architecture layer is a criterion-boundary contract. This is
not a biology card. It is part of the rubric/scoring package and defines how a
specific point is awarded.

Fields:

- criterion_id;
- rubric_version_id;
- required evidence target;
- evidence_quote rule;
- pass gate;
- fail gate;
- accepted boundary examples;
- insufficient boundary examples;
- contradiction rules;
- ambiguity or abstain rules;
- minimal fix;
- adjudicated case IDs;
- reviewer and approval status;
- affected grader prompt version.

Example from `FRQ02-C2`:

```text
Required target: the response must tie randomness/non-selectiveness to the
construction destruction, survival, mortality, or resulting sample.

Insufficient: "allele frequencies change randomly" when it describes later
small-population drift but does not establish the construction event as random.
```

Boundary contracts are grading-sensitive rubric artifacts. Any material change
requires Learning Quality review and grader revalidation against affected
boundary cases.

## 6. Minimal Data Model

```text
bio_reference_cards
- id
- version
- status
- card_type
- ap_course
- unit
- topic
- skill_tags
- trigger_terms
- applies_to_content_package_ids
- applies_to_rubric_criterion_ids
- canonical_claim
- mechanism_chain
- accepted_variants
- insufficient_wording
- borderline_variants
- not_accepted_variants
- common_misconceptions
- minimum_fix
- learner_safe_summary
- grader_notes
- source_status
- source_notes
- source_type
- rights_basis
- rights_expiry
- model_input_allowed
- content_generation_allowed
- learner_display_allowed
- official_material_boundary_checked
- sensitivity
- use_scope
- author_class
- human_author_confidence
- author_id
- reviewer_id
- review_status
- supersedes_card_id
- derived_from_card_ids
- defect_status
- retired_reason
- created_at
- updated_at
- released_at
```

The `applies_to_content_package_ids` and
`applies_to_rubric_criterion_ids` entries describe logical relationships, not
a recommended physical schema. A production implementation should use explicit
binding or junction records so card-version pins, release state, and audit
history are enforceable.

Recommended statuses:

```text
draft
in_review
released_beta
released_production
suspended
retired
```

Recommended source statuses:

```text
cramapple_authored
expert_authored
public_domain_summary
licensed
needs_rights_review
```

Recommended sensitivity values:

```text
teaching_safe
grading_sensitive
answer_bearing
rights_restricted
```

Recommended use scopes:

```text
grading_only
teaching_after_attempt
repair_after_grade
authoring_brief
learner_visible_summary
user_provided_teaching_safe
```

Recommended author classes:

```text
cramapple_owner
learning_quality_owner
paid_ap_biology_tutor
ai_draft_human_reviewed
temporary_spike_only
```

Do not add an official College Board reference author class without a separate
rights decision. Official material may be referenced at a high level under the
source-boundary rules, but it is not a default source class for Cramapple
reference cards.

Embeddings are intentionally excluded from the Phase 1 data model because
Phase 1 retrieval is deterministic-only. Add embeddings later only when a
keyword or embedding retrieval phase is approved.

## 7. Retrieval and Boundary-Contract Design

The reference layer should be retrieved by server-side code, not loaded into the
client.

### 7.1 Retrieval Inputs

For seeded content:

- content_package_id;
- rubric_version_id;
- criterion IDs;
- criterion-boundary contract version IDs;
- question unit and topic tags;
- student response text;
- attempt condition.

For user-provided questions:

- classified AP Biology unit;
- question type;
- command verbs;
- extracted topic tags;
- classification confidence;
- student response text.

### 7.2 Retrieval Method

For Phase 1, use deterministic retrieval only:

1. Deterministic lookup by `content_package_id`, `rubric_version_id`, and
   `criterion_id`.
2. Always retrieve the approved criterion-boundary contract for each scored
   criterion.
3. Retrieve reference cards only when the experiment-backed gate for that
   card type has passed.
4. Hard cap of retrieved cards per model call.
5. Log every boundary contract, card ID, and version with the grading result.
6. Pin boundary-contract and card versions to the content-package and rubric
   versions used for the grade.

Boundary contracts are part of the grading package, not optional context. If a
released criterion has no approved boundary contract, the grader may still use
the rubric, but the result should be eligible for heightened monitoring until
the boundary contract exists.
   grade.

After the card format proves useful, later phases may use a hybrid approach:

1. Keyword or tag lookup by topic and skill.
2. Embedding search only when deterministic bindings are insufficient.
3. Hard cap of retrieved cards per model call.

Suggested first cap:

```text
max_cards: 8
max_total_reference_tokens: 900
```

### 7.3 Retrieval Contract

The grading prompt receives:

- the question;
- the rubric;
- the student response;
- the approved criterion-boundary contracts;
- any retrieved reference cards relevant to the rubric;
- strict instruction that rubric criteria remain authoritative.

Reference cards may clarify biological facts and variants. They may not add new
scoring criteria.

Criterion-boundary contracts may clarify scoring thresholds because they are
reviewed as part of the rubric. They are the correct home for accepted variants,
insufficient wording, and evidence-gate rules that change whether a response
earns a point.

If a card includes biology that is true but not required by the supplied
rubric, the grader may use it only to interpret the learner response. The card
must not create a new requirement, award extra credit, or withhold credit for
missing evidence that the rubric does not require.

### 7.4 User-Provided Question Boundary

User-provided question flows may retrieve only teaching-safe cards unless the
question is matched to a validated Cramapple content package.

For unmatched user-provided questions:

- skip any card where `use_scope` does not include
  `user_provided_teaching_safe` or `teaching_after_attempt`;
- skip any card where `sensitivity` is `grading_sensitive`, `answer_bearing`,
  or `rights_restricted`;
- do not present precise criterion scoring;
- clearly label guidance as inferred;
- preserve the UX-004 boundary between private learning, anonymous
  improvement, canonical content, and public publication.

## 8. Beta Pilot Scope

Start with the six summer-beta FRQs, but sequence the work differently from the
original card-first plan.

First create criterion-boundary contracts for the highest-risk criteria:

- criteria with prior over-credit or under-credit in spike results;
- criteria with prediction-plus-justification thresholds;
- criteria where correct topic vocabulary is insufficient;
- criteria where a common paraphrase may or may not count.

For each selected criterion, create:

- required evidence target;
- accepted and insufficient boundary examples;
- contradiction rule;
- minimal fix;
- adjudicated test cases.

Only after boundary contracts are validated should Cramapple decide whether
biology reference cards are still needed for that FRQ.

For each FRQ, create:

- 1 concept card;
- 1 mechanism-chain card;
- 1 accepted-variant card when the rubric needs it;
- 1 insufficient-wording card when over-credit risk is likely;
- 1 misconception card when there is a common wrong model;
- 1 repair-move card.

Original card-first target, now deferred until boundary contracts justify card
investment:

```text
6 FRQs x 5-6 cards = 30-36 cards
```

This is small enough for Learning Quality review and large enough to test cost
and latency effects, but the Phase 0 evidence does not currently justify it as
the next production path for initial grading.

At scale, these should not become 5-6 bespoke cards for every FRQ. Phase 1 may
bind cards to specific FRQs for measurement, but the durable architecture
should favor a shared pool of reviewed concept, mechanism, misconception,
insufficient-wording, repair, and data-rule cards reused across many content
packages. FRQ-specific accepted variants remain tied to the rubric criterion
and should be authored only where the rubric truly needs them.

## 9. Cost and Speed Evaluation

The reference layer must be evaluated with an actual measurement harness, not
only a frontend prototype. Lovable may be used for an internal dashboard that
displays fixture or aggregate results, but it must not run model calls, include
rights-restricted PDF text, or store real grading payloads.

The current six-FRQ grading baseline is not yet recorded in this plan. Before
any pass/fail decision, create a baseline table that records the current
high-quality model setting, prompt version, compactness setting, cost,
latency, schema validity, and criterion-level quality against human labels or
manual review. Until that table exists, "no material regression" means manual
spot-check only, not a statistically grounded quality claim.

Baseline owner and artifact:

```text
owner: Product Owner
artifact: docs/research/bio_reference_layer_baseline.md
required before: interpreting Phase 0 results or deciding Phase 1 investment
```

### 9.0 Temporary PDF Spike

A rights-restricted study guide may be used only for a contained concept test
under `docs/research/BIO_REFERENCE_LAYER_PDF_SPIKE_PROTOCOL.md`.

For that spike:

- use the PDF only as temporary internal reference context;
- do not commit extracted PDF text or PDF-derived cards;
- do not use PDF sample questions as Cramapple beta questions;
- store temporary artifacts outside the repository;
- commit only aggregate measurements and non-infringing observations;
- treat all PDF-derived material as unlicensed, unreleased, and not
  Cramapple-authored.
- confirm provider data-retention, training, and model-input settings before
  sending any PDF-derived text to a third-party API.

The spike can test whether compact reference context improves cost and speed.
It cannot approve the PDF, derivative cards, or any third-party content for
production use.

### 9.1 Baseline Metrics

Record before enabling retrieval:

- model;
- reasoning effort;
- prompt hash or immutable prompt version;
- input tokens;
- output tokens;
- reasoning tokens;
- app latency;
- OpenAI latency;
- total latency;
- cost per initial grade call;
- cost per attempt across initial grade, repair selection, revision grade,
  malformed-output retries, and provider retries where applicable;
- criterion agreement with expert or human labels where available;
- criterion agreement between model settings;
- over-credit rate;
- under-credit rate;
- rubric-expansion rate;
- invented-biology rate;
- unsafe or over-helpful repair rate;
- timeout rate;
- malformed-output rate.

### 9.2 Retrieval Metrics

Record after enabling retrieval:

- boundary-contract version IDs used;
- evidence-gate pass/fail per criterion;
- evidence quote presence and length;
- gate/status invariant violations;
- cards retrieved per call;
- reference token count;
- retrieval latency;
- total prompt token change;
- output token change;
- reasoning token change;
- cost change;
- latency change;
- prompt hash or immutable prompt version;
- prompt-caching status and cached-token count when available;
- criterion agreement with expert or human labels where available;
- criterion agreement;
- human spot-check defect rate.

### 9.3 Initial Targets

For short FRQ initial grading:

```text
p50 total latency: under 10 seconds
p95 total latency: under 25 seconds
cost target: under $0.01 per initial grade call
attempt cost target: separately measured for initial grade plus repair/regrade
criterion agreement: no material regression from GPT-5.5 high baseline
```

The cost target may require both retrieval and compact structured output.
Retrieval alone will not help if the model still emits verbose feedback.

Initial spike arms:

```text
Arm A: current rubric-only baseline with current output format
Arm B: rubric-only with strict compact output schema, no cards
Arm C: rubric plus verbose biology paragraph, no card structure
Arm D: rubric plus compact reference cards
Arm E: overstuffed context diagnostic, optional
```

Follow-up tests already run against this plan showed that Arm BM
medium/compact/no-cards captured the main cost and latency win, while biology
cards did not add value. Later scored-exemplar, online flywheel,
oracle-precedent, boundary-table, and gated-prompt diagnostics found calibration
signal in scored examples but no production-ready prompt-context memory design.

Do not treat card retrieval as the next default investment. The next
investment gate is a boundary-contract/grader-agent test:

```text
Arm BM: medium / compact / rubric-only
Arm G1: BM plus criterion-boundary contract and evidence gate
Arm G2: G1 plus strict JSON retry on malformed or invariant-violating output
Arm G3: G2 with lower reasoning effort, only if G2 matches or beats BM quality
```

Success requires strict agreement improvement or equal quality with lower
latency/cost, no increase in over-credit, 100% valid structured output after
allowed retry, and clear Learning Quality approval of any boundary labels used
as test truth.

Run the first pilot as one FRQ, three synthetic responses, and Arms A, B, C,
and D. Expand only if the small run shows that cards add value beyond compact
output alone and beyond generic biology context.

The model comparison should directly test the business case:

```text
high model / no cards / current output
high model / compact output / no cards
medium model / compact output / no cards
medium model / compact cards
```

If prompt caching is available in the intended runtime, measure with caching
off and on or explicitly state which mode the economics assume. Stable rubric
and card prefixes may make cached-token pricing a larger cost driver than card
compactness.

Pass/fail economics should use uncached numbers unless the intended production
runtime is confirmed to use prompt caching for the relevant stable prompt,
rubric, and card prefixes. Cached results may be reported as an upside case
before production caching is confirmed.

Small spike runs can validate speed and cost directionally. They cannot prove
grading-quality non-regression. Unless the sample is expanded substantially,
quality findings should be reported as manual spot-checks, not statistical
agreement claims.

The same caution applies to cost and latency gates in the smallest pilot. A
one-FRQ, three-response run is a directional smoke test. Apply the 25% cost and
20% latency gates as investment signals only after a larger pilot. Two FRQs
with five responses each is the floor; three FRQs with five responses each is
the recommended gate sample.

## 10. Grader-Agent Prompt Impact

The next grader prompt should use a criterion decision procedure before it uses
retrieved biology context:

```text
For each criterion:
1. Extract the shortest exact student phrase that could support earning the
   point.
2. Apply the criterion-boundary contract.
3. If the quote is empty or fails the evidence gate, mark not_earned.
4. Do not infer missing criterion evidence from correct topic vocabulary.
5. Return compact JSON with evidence_quote, gate result, status, confidence,
   and minimal fix.
```

The reference layer, when present, should let the grader prompt become simpler:

```text
Grade only against the supplied rubric.
Use criterion-boundary contracts to decide scoring thresholds.
Use retrieved reference cards only to interpret biology that the rubric already
requires.
Do not create new criteria from reference cards.
For earned criteria, return concise evidence and no missing_evidence.
For missed criteria, return the smallest missing step.
Return one highest-value gap.
Return compact JSON only.
If no reference cards are retrieved, grade against the rubric without invented
context.
```

Expected savings:

- fewer long explanations;
- fewer repeated biology definitions;
- less model uncertainty about accepted variants;
- less need for high reasoning effort on routine cases.

Expected quality effect:

- fewer over-credits from correct topic vocabulary without criterion evidence;
- clearer distinction between label defects and model defects;
- easier human review because every earned point has an evidence quote and
  gate result;
- faster revalidation when a rubric-boundary contract changes.

## 11. Quality and Governance

Each released reference card needs:

- author;
- reviewer;
- source status;
- version;
- review status;
- retirement path;
- defect reporting path.

Learning Quality review should check:

- scientific accuracy;
- AP Biology appropriateness;
- whether variants are overbroad;
- whether misconception labels are too confident;
- whether repair moves preserve learner agency;
- whether card use would leak answers before cold attempts.

Any card that changes whether a response earns a point should be treated as
grading-sensitive and may require stronger review than a teaching-only card.

Accepted-variant cards deserve the strongest treatment. They are not ordinary
biology hints; they define which wording earns a criterion. They must be
reviewed as part of the rubric criterion, and any material variant-card change
should trigger rubric review and affected-grader revalidation.

Criterion-boundary contracts deserve the same or stronger treatment because
they are explicitly part of the scoring package. Any change to an evidence
gate, accepted boundary example, insufficient boundary example, contradiction
rule, or ambiguity rule must:

- create a new boundary-contract version;
- identify affected criteria, content packages, and evaluation cases;
- rerun the affected grader validation set;
- decide whether historical grades remain reproducible or need defect review;
- record Product Owner and Learning Quality approval.

### 11.1 Grading-Sensitive Release Gate

A reference card may affect seeded FRQ grading only when:

- `status` is `released_beta` or `released_production`;
- `review_status` is Learning Quality approved;
- `source_status` is not `needs_rights_review`;
- `use_scope` includes `grading_only`;
- it is deterministically bound to an approved `content_package_id` and
  criterion ID;
- it has a named author and reviewer;
- it has a defect-reporting, suspension, retirement, and supersession path.

Grading-sensitive and answer-bearing cards may not be retrieved for unmatched
user-provided questions.

### 11.2 Reviewer Inspection Requirement

For every graded attempt that uses reference cards, an authorized reviewer must
be able to inspect:

- retrieved card IDs and versions;
- why each card was retrieved;
- retrieval method;
- prompt token contribution;
- whether any card was later suspended, superseded, or retired;
- the grading result that used those card versions.

### 11.3 Card Defect Propagation

When a released card is suspended, retired for defect, or materially
superseded, Cramapple must identify all grading results that used the affected
card version.

The defect review should decide whether affected attempts require:

- no action because the defect is teaching-only or immaterial;
- internal regrading analysis only;
- learner-visible correction or qualification;
- recalculation of progress projections;
- temporary suspension of affected content packages.

This policy must be approved before learner-facing Phase 1 grading uses
reference cards.

Required approvers: Product Owner and Learning Quality Owner. Counsel review is
also required if the defect involves rights, retention, provider use, or
learner notification language.

### 11.4 Card Version Reproducibility

Every grading result must pin exact card versions. If card v2 supersedes card
v1, historical grades remain reproducible against v1 unless a defect workflow
explicitly regrades them.

Content-package and rubric releases should identify the approved card-version
set. Two learners with the same response should not receive different scores
within the same released package version merely because a card changed in the
background.

If a content package is re-released with new card pins, prior learners remain
on the old release for reproducibility unless the approved defect workflow
requires regrading or learner-visible correction.

Historical grades are not recomputed by default. Future attempts on the same
content-package release use that release's pinned card-version set, even after
a superseding release exists.

## 12. Rights and Source Boundaries

Allowed:

- original Cramapple-authored summaries;
- expert-authored AP Biology explanations;
- public-domain or properly licensed facts summarized in original language;
- references to official AP concepts at a high level.

Not allowed without separate approval:

- copying official AP questions;
- copying College Board scoring criteria or sample responses;
- close paraphrases of proprietary review-book explanations;
- treating third-party study-guide explanations as Cramapple-authored
  reference text;
- third-party diagrams, tables, or graphs;
- unlicensed textbook passages.

The card should record source notes, but the learner-facing product should not
display source claims that overstate authority.

Rights-sensitive source candidates may be used for temporary internal
measurement only when the Product Owner explicitly approves the spike boundary.
They must remain out of committed reference cards, learner-facing copy, and
content-generation workflows until rights are cleared.

Sending rights-restricted text or derivative cards to a model provider is a
separate rights and provider-terms question from committing it to the
repository. The spike must confirm provider retention, training, and model
input settings before any such call.

Production grading also requires documented provider settings for student
response text, Cramapple reference cards, rubrics, prompts, and grading
outputs. Before learner-facing use, confirm retention, training, regional
processing, logging, abuse-monitoring, caching, and deletion behavior for the
actual production account and model endpoint.

Production provider-settings owner and artifact:

```text
owner: Product Owner
artifact: docs/governance/provider_settings_review.md
required before: enabling reference-card retrieval against real student
responses
```

## 13. Build Phases

### Phase 0 - Rights-Restricted Concept Spike Completed

- Use `docs/research/BIO_REFERENCE_LAYER_PDF_SPIKE_PROTOCOL.md`.
- Use the six summer-beta FRQs if they exist; otherwise label the run as a
  throwaway-FRQ concept test that cannot validate beta-specific quality.
- Test one to three original or throwaway FRQs for the first pilot.
- Compare current baseline, compact schema with no cards, verbose biology
  context, and compact temporary reference cards.
- Apply the spike-protocol token-matching rule for verbose biology context
  versus compact-card context.
- Run the D-prime compact-cards-without-mechanism variant on mechanism-heavy
  FRQs.
- Compare high-model baseline against medium-model compact-card grading.
- Measure token use, latency, cost, schema validity, and manual quality flags.
- Commit only aggregate results.
- Include kill criteria in the spike report.
- Do not create production cards, database migrations, or learner-facing
  artifacts.

Phase 0 outcome: biology-card retrieval did not demonstrate sufficient value to
justify production card authoring for initial FRQ grading. Treat the committed
reports as the baseline evidence:

- `docs/research/bio_reference_layer_gate_aggregate_report.md`
- `docs/research/bio_reference_layer_exemplar_test_report.md`
- `docs/research/bio_reference_layer_flywheel_volume_test_report.md`
- `docs/research/bio_reference_layer_oracle_boundary_test_report.md`
- `docs/research/bio_reference_layer_gated_prompt_test_report.md`

### Phase 1 - Criterion Boundary Contracts and Grader Agent

- Identify the highest-risk criteria from spike results.
- Adjudicate apparent label/rubric-boundary conflicts before using labels as
  ground truth. For `FRQ02-C2`, review at least `S010`, `S020`, `S028`,
  `S066`, and `S068`.
- Create criterion-boundary contracts for those criteria.
- Add evidence quote, decision gate, status, and minimal-fix fields to the
  grading output contract.
- Add strict validation and one bounded retry for malformed JSON or
  gate/status invariant violations.
- Compare BM against boundary-contract grader arms before adding any reference
  cards.
- Promote only if the boundary-contract grader improves strict agreement or
  preserves quality while lowering cost/latency.

### Phase 2 - Beta FRQ Reference Cards, If Still Needed

- Create 30-36 cards for six FRQs.
- Bind cards deterministically to content packages and criterion IDs.
- Add deterministic retrieval to grading only.
- Reuse the Phase 0 business-case matrix: high/no-cards/current output;
  high/compact-output/no-cards; medium/compact-output/no-cards; and
  medium/compact-cards.
- Compare against human criterion labels where available.
- Spot-check at least 20 graded outputs for over-credit, under-credit, rubric
  expansion, invented biology, and unsafe repair.
- Do not proceed unless the card-authoring owner, review path, and expected
  elapsed time are explicit.

### Phase 3 - MCQ and Distractor Cards

- Add misconception cards for MCQ distractors.
- Use deterministic grading for answer choice correctness.
- Use reference cards only for explanation and repair.

### Phase 4 - User-Provided Question Support

- Use classification to retrieve topic and rubric-pattern cards.
- Clearly label inferred guidance.
- Do not show precise scoring unless matched to a validated content package.

### Phase 5 - Authoring Workbench Integration

- Use cards as source material for new question-package briefs.
- Track which cards are used in content generation.
- Validate generated questions independently.

## 14. Open Decisions

1. Who adjudicates the first criterion-boundary conflicts and signs off when
   labels, rubric wording, and model behavior disagree?
2. What is the canonical data shape for criterion-boundary contracts inside a
   rubric package?
3. Which gate/status invariants require automatic retry, human review, or
   content suspension?
4. Who authors the first 30-36 cards if Phase 2 is still needed: David, Orly,
   AI draft plus Orly review, or paid AP Biology tutor?
5. If keyword or embedding retrieval is later approved, which model generates
   embeddings and what evaluation gates apply?
6. When, if ever, should retrieval expand beyond deterministic bindings to
   keyword or embedding retrieval?
7. What exact Learning Quality review evidence is required for
   `released_beta`?
8. What admin UI is needed to inspect boundary contracts and retrieved cards
   for a grading result?
9. Should unmatched user-provided questions ever use grading-sensitive cards?
10. What medium-versus-high quality gap is tolerable for general beta use
   versus AP-exam-week sessions?
11. Should a Lovable dashboard be created after the first aggregate spike run,
   or is a tabular report enough?
12. Who owns the card-authoring pipeline and what timeline is acceptable?
13. Should mechanism-chain cards be allowed in grading prompts, or limited to
   teaching-after-attempt and repair flows?

## 15. Recommended Immediate Next Step

Do not invest next in production biology-card authoring or licensing.

The immediate next step is Learning Quality adjudication of the observed
`FRQ02-C2` boundary conflict and creation of a narrow criterion-boundary
contract:

```text
FRQ02-C2: construction-event randomness/non-selectiveness
```

Minimum adjudication set:

```text
S010, S020, S028, S066, S068
```

Then rerun a boundary-contract grader test. If it beats BM-Control on strict
agreement without increasing cost or latency materially, expand to the other
high-risk criteria from the summer-beta FRQs.

Only revisit the pilot card packet if the boundary-contract grader still shows
a biology-knowledge gap rather than a rubric-threshold or label-quality gap.
