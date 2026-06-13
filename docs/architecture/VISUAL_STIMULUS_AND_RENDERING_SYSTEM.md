# Visual Stimulus and Rendering System

**Status:** Proposed for Product Owner and Learning Quality review
**Owner:** Main Conductor / Technical Owner
**Product Owner:** David Bloom
**Related Tasks:** `TASK-0005`, `TASK-0006`, `CONTENT-001`
**Last Updated:** 2026-06-12

## 1. Purpose

This document defines the proposed logical architecture for tables, charts,
graphs, diagrams, models, experimental setups, and learner-created graphs in
Cramapple content.

The system must preserve:

- the scientific meaning of every visual;
- the skill the question is intended to assess;
- accessibility without answer leakage;
- immutable versioning, provenance, rights, and independent validation;
- deterministic rendering where a constrained representation exists; and
- exam-authentic practice across supported devices.

This is a logical design. It does not approve a charting library, physical
database column, API, storage provider, or production implementation.

## 2. Assessment of the Initial A/B/C Proposal

### 2.1 Strengths

The proposal is directionally correct in four important ways:

1. Structured data is safer and more testable than accepting free-form
   model-generated chart images.
2. Product-side rendering can make common quantitative stimuli reproducible,
   responsive, and easier to validate.
3. Free-form image generation is not reliable enough to be a production source
   for scientifically precise diagrams.
4. Visual rendering needs a dedicated specification, validation, accessibility,
   and quality-assurance workstream.

### 2.2 Required Corrections

The proposal should not be adopted as written.

- Structured rendering reduces label and alignment errors; it does not
  eliminate wrong data, misleading scales, invalid units, or internally
  inconsistent specifications.
- The claim that structured charts cover approximately 70% of AP Biology
  stimulus needs is unverified. Cramapple must measure its own planned
  964-item inventory by representation type before accepting a percentage.
- A prose description is not an interchangeable fallback when the assessed
  construct is visual interpretation, representation translation, graph
  construction, or model analysis.
- Data tables should render as semantic HTML rather than as chart images.
- "No model-generated SVG" should mean no untrusted, free-form SVG enters the
  content pipeline. A deterministic product renderer may legitimately emit
  governed SVG or canvas output.
- Diagrams should not be reduced to prose for version 1 when the visual itself
  is educationally material. A governed authored-asset and constrained-diagram
  lane is required.
- A mutable `stimulus` plus `stimulus_data` database-column design is premature.
  The logical contract must be approved before physical Supabase design.
- Presented stimuli and learner-created graphs are different systems and
  require different authoring, interaction, grading, and accessibility rules.

### 2.3 Legal and Accessibility Correction

College Board-style prose descriptions are not, by themselves, an
ADA-mandated format. Applicable legal obligations depend on the product,
audience, and jurisdiction. Cramapple should adopt WCAG 2.2 Level AA as its
product accessibility target, while counsel confirms the legal requirements
that apply to a private educational service used by minors.

## 3. Recommended Four-Lane Model

### Lane A - Structured Quantitative Visuals

Use versioned structured specifications and deterministic rendering for:

- semantic data tables;
- line charts;
- bar charts;
- scatter plots;
- multiple data series;
- uncertainty or error bars;
- categorical and continuous axes; and
- other chart forms added only after validation.

The model may propose a candidate specification from approved source material.
The candidate is unapproved until schema, semantic, scientific, accessibility,
teaching, grading, and rendered-output checks pass.

### Lane B - Governed Authored and Constrained Diagrams

Use human-authored, licensed, or constrained-renderer assets for:

- phylogenetic trees;
- pedigrees;
- experimental setups;
- biological process diagrams;
- cell, organism, or system models; and
- spatial relationships that cannot be assessed faithfully through prose.

Preferred methods, in order:

1. a domain-specific structured grammar rendered deterministically;
2. a reviewed reusable component or symbol library;
3. a commissioned vector or raster asset with complete source and rights
   records.

Free-form generative images do not enter production under this lane.

### Lane C - Accessible Equivalent Representation

Every visual requires an accessible companion appropriate to its purpose:

- concise alternative text identifying the visual and its function;
- a structured data table when underlying values exist;
- a task-equivalent long description or accessible interaction;
- labels, legends, units, and instructions available to assistive technology;
- no reliance on color alone; and
- a separately validated alternative item when an equivalent description would
  reveal the answer or remove the assessed operation.

Lane C is not a silent runtime replacement for Lane A or Lane B. If the visual
is incidental context, a description may be sufficient. If the visual is the
construct being assessed, the item must have a validated accessible equivalent
or remain ineligible for that delivery mode.

### Lane D - Free-Form Generative Images

Defer free-form image-generated scientific diagrams and data visuals from
production use.

A future pilot may reopen this lane only after:

- a bounded supported-use specification;
- scientific and spatial accuracy benchmarks;
- source, originality, and rights rules;
- accessibility-equivalence validation;
- held-out testing;
- deterministic failure detection where feasible; and
- Product Owner approval.

## 4. Core Learning Rules

### 4.1 Preserve the Assessed Construct

Each visual stimulus declares one purpose:

```text
visual_purpose =
  incidental_context |
  data_lookup |
  visual_interpretation |
  representation_translation |
  model_analysis |
  learner_constructs_visual
```

Fallback behavior depends on purpose:

| Purpose | Prose fallback allowed? | Requirement |
| --- | --- | --- |
| Incidental context | Yes, after review | Meaning and difficulty remain equivalent |
| Data lookup | Usually | Expose the same values in a semantic table |
| Visual interpretation | No silent fallback | Validated accessible equivalent item required |
| Representation translation | No | Alternative must preserve the translation operation |
| Model analysis | No silent fallback | Equivalent model access or alternate item required |
| Learner constructs visual | No | Accessible graph-construction and grading method required |

Delivery must fail closed when the approved visual or equivalent representation
cannot load. It must not silently convert the task into a different construct.

### 4.2 Prevent Answer Leakage

Accessible descriptions must provide access, not interpretation.

For a cold question, descriptions may state:

- visual type;
- title, labels, units, legend, and scale;
- individual data values or relationships needed to navigate the visual; and
- interaction instructions.

They must not state:

- the trend the learner is being asked to identify;
- the correct comparison, inference, or causal explanation;
- the important anomaly when finding it is the task;
- rubric criteria or point-earning language; or
- a conclusion not explicitly printed in the visual.

When raw data access still fails to preserve task equivalence, Cramapple must
provide a separately authored and validated alternative question.

### 4.3 Preserve Representation Evidence

Learner evidence must record the representation actually delivered. Success on
a prose equivalent is not automatically evidence of success on a graph,
diagram, table, or model. Cross-representation evidence may be combined only
under the approved learning-system rules.

## 5. Logical Artifact Contract

Visual content is a family of immutable artifacts, not an ungoverned JSON field
inside a mutable question row.

```text
visual_stimulus_version {
  visual_stimulus_id: UUID
  visual_stimulus_version_id: UUID
  semantic_version: SemVer
  schema_version: SemVer
  visual_kind:
    semantic_table | line_chart | bar_chart | scatter_plot |
    phylogenetic_tree | pedigree | experimental_setup |
    biological_diagram | authored_image | other
  visual_purpose:
    incidental_context | data_lookup | visual_interpretation |
    representation_translation | model_analysis |
    learner_constructs_visual
  specification: JSON
  specification_sha256: SHA256
  dataset_version_id: UUID | null
  asset_version_ids: UUID[]
  renderer_profile_version_id: UUID
  accessible_representation_version_ids: UUID[]
  source_version_ids: UUID[]
  rights_record_ids: UUID[]
  authored_by: UUID[]
  predecessor_version_id: UUID | null
  risk_class: R0 | R1 | R2 | R3
  change_class: C0 | C1 | C2 | C3
}

dataset_version {
  dataset_id: UUID
  dataset_version_id: UUID
  schema_version: SemVer
  variables: JSON
  observations: JSON
  missing_value_rules: JSON
  transformations: JSON[]
  units: JSON
  source_version_ids: UUID[]
  rights_record_ids: UUID[]
  synthetic_status:
    observed | transformed_observed | scientifically_simulated |
    pedagogically_synthetic
  generation_method: string | null
  dataset_sha256: SHA256
}

accessible_representation_version {
  accessible_representation_id: UUID
  accessible_representation_version_id: UUID
  representation_type:
    short_alt | long_description | semantic_table |
    accessible_interaction | alternate_item
  content: JSON
  language: BCP-47 string
  construct_equivalence_status:
    pending | approved | rejected
  answer_leakage_status:
    pending | passed | failed
  validated_by: UUID[]
  content_sha256: SHA256
}

renderer_profile_version {
  renderer_profile_id: UUID
  renderer_profile_version_id: UUID
  supported_schema_versions: SemVer[]
  output_modes: string[]
  typography_rules: JSON
  color_and_pattern_rules: JSON
  responsive_rules: JSON
  accessibility_rules: JSON
  implementation_version: string
  profile_sha256: SHA256
}
```

Rendered SVG, canvas, PNG, or cached HTML is a derived output. It must retain
the source artifact IDs, renderer profile version, and checksum. A renderer
change does not mutate the approved visual specification.

## 6. Authoring and Source Rules

Every visual package must disclose:

- whether the data are observed, transformed, simulated, or synthetic;
- source, retrieval date, scope, and rights for every dataset and asset;
- all transformations, exclusions, rounding, normalization, and aggregation;
- units, uncertainty, sample size, and missing-value treatment where relevant;
- authoring and generation tools;
- scientific assumptions;
- intended assessed skill and visual purpose; and
- the accessible representation plan.

Pedagogically synthetic data may be used when:

- it is clearly recorded as synthetic internally;
- the values are scientifically plausible;
- the complete dataset and generation method are retained;
- the question does not imply that the data came from a real study;
- validators confirm that the pattern is not misleading; and
- the synthetic pattern was not reverse-engineered from protected question
  content.

No visual may reuse or closely redraw an unlicensed third-party graph, table,
diagram, image, or dataset. The human abstraction firewall continues to apply
to official question text and visual assets.

## 7. Validation Gates

### 7.1 Automated Specification Checks

Applicable checks must pass:

- schema is valid and contains no executable code, HTML, scripts, or arbitrary
  remote URLs;
- series lengths, categories, and observation keys align;
- numeric values are finite and units are declared;
- duplicate labels and ambiguous categories are rejected;
- axis domains include the data and obey approved scale rules;
- bar charts use a defensible baseline or carry an explicit validator-reviewed
  exception;
- logarithmic, broken, reversed, or truncated axes are explicit and reviewed;
- uncertainty values are non-negative and correctly paired;
- missing values remain distinguishable from zero;
- legends map uniquely to series;
- color is not the sole encoding;
- text and non-text contrast meet the approved accessibility target;
- responsive layouts preserve labels, scale, and task meaning;
- the semantic table represents the same underlying data;
- the rendered output matches the approved specification; and
- payload size, series count, label length, and nesting stay within security and
  usability limits.

### 7.2 Human Review

Visual packages require the existing independent teaching and grading gates.
Reviewers additionally verify:

- scientific and statistical correctness;
- provenance, rights, attribution, and transformation disclosure;
- fidelity between data, specification, rendering, question, rubric, and
  explanation;
- absence of misleading scale, emphasis, decoration, or omitted context;
- legibility at every supported viewport and zoom level;
- accessibility and construct equivalence;
- absence of answer leakage;
- realistic AP Biology demand without imitation of protected material;
- correct handling of uncertainty, error bars, sample size, and units;
- representation tags and intended-use classification; and
- a deterministic failure behavior.

An accessibility validator and a qualified AP Biology teaching validator must
approve any alternate item intended to replace a visual-dependent task.

Minimum reviewer counts are:

| Release scope | Required visual reviewers |
| --- | --- |
| New or changed visual stimulus | Existing two Teaching Validators, existing Grading Validators when scoring is affected, plus one independent Accessibility Validator |
| Accessible alternate for a visual-dependent task | One Accessibility Validator and two Teaching Validators; at least one Teaching Validator must be qualified for AP Biology |
| Shared visual schema, renderer profile, or accessibility policy | Two Accessibility Validators, two Teaching Validators, one technical validation owner, and the existing release authority |
| Cosmetic renderer patch proven not to affect meaning | One technical validation owner plus one Accessibility Validator; sampled teaching review under C1 |

All required reviewers must pass the package. Missing, tied, or conditional
review does not pass.

An Accessibility Validator must demonstrate current competence in WCAG testing,
keyboard-only operation, screen-reader testing, zoom and reflow, contrast,
complex-image alternatives, and accessible data tables. Automated scans do not
replace manual testing.

### 7.3 Refresh and Monitoring

- Dataset source and rights refresh follow the governing source record's
  refresh class and expiration date.
- Every active visual is re-rendered and regression-tested before a renderer
  profile becomes eligible for production.
- Renderer dependencies receive a monthly security and maintenance review and
  immediate review after a material vulnerability, abandonment, license
  change, or breaking release.
- Accessibility standards and testing policy receive at least annual review and
  immediate impact review after a controlling legal or WCAG change.
- Synthetic datasets do not require external source refresh, but their
  scientific plausibility and curriculum alignment are reviewed with each
  school-year exam pack.
- Production monitoring opens human review for loading failures, clipping,
  inaccessible interaction, anomalous performance by delivery mode, or evidence
  that a description changes answer rates.

### 7.4 Change and Revalidation Rules

| Change | Minimum class |
| --- | --- |
| Text-only typo with no meaning or layout effect | C0 |
| Cosmetic rendering change with unchanged meaning | C1 |
| Labels, units, legend, color encoding, scale, description, or responsive behavior | C2 |
| Data values, diagram structure, visual purpose, accessible alternate, or scoring dependency | C2 |
| Shared schema, renderer behavior, accessibility policy, source rights, or broad asset replacement | C3 |

Any change that could alter a learner's interpretation, response, score, or
access requires teaching and grading impact review. Renderer upgrades require
regression testing against all active visual specifications before release.

## 8. Learner-Created Graphs

Graph construction is a separate capability from rendering a stimulus.

The graphing workspace must capture semantic intent, not only pixels:

- selected graph type;
- independent and dependent variables;
- axis labels, units, scale, and bounds;
- plotted points or bars;
- uncertainty representation;
- legend and series mapping;
- title when required; and
- learner revisions and final submission.

The grading package must define which properties earn each point and which
errors are mechanical, scientific, or interpretive. Cold mode must not select
the axes, scale, graph type, trend, or interpretation for the learner.

An accessible graph-construction path and expert-validated scoring method are
required before graph-construction questions may be released to learners who
cannot use the default visual editor.

## 9. Renderer Selection Process

Do not select a production library from feature lists alone.

Run a bounded prototype using:

- one semantic table;
- one single-series line chart;
- one multi-series chart;
- one bar chart with uncertainty;
- one scatter plot;
- one dense mobile case;
- one screen-reader case; and
- one intentionally invalid specification.

Evaluate:

- declarative schema fit and validation;
- deterministic SVG or canvas output;
- semantic accessibility support;
- keyboard and screen-reader behavior;
- responsive behavior;
- export and snapshot testing;
- security surface;
- maintenance activity and license;
- bundle size and performance; and
- ability to keep the canonical Cramapple schema independent of the vendor.

Vega-Lite is a strong prototype candidate because it is declarative and
JSON-based, but it is not approved as the canonical Cramapple schema or
production renderer. Semantic HTML remains the preferred table renderer.

## 10. V1 Recommendation

Approve the following planning direction:

1. Lane A for tables and common quantitative charts.
2. Lane B for constrained or human-authored scientific diagrams.
3. Lane C as a required accessible companion or separately validated equivalent,
   not a universal prose fallback.
4. Lane D deferred from production.
5. Separate learner-created graphing from displayed-stimulus rendering.
6. Define a vendor-neutral logical specification before physical database
   design.
7. Audit the 964-item plan by representation type before estimating coverage or
   implementation effort.
8. Support responsive chart and table viewing on phones, tablets, and desktops.
9. Treat tablet or desktop as the initial exam-equivalent graph-construction
   environment. Phone-created graphs may be offered for convenience but do not
   count as equivalent graph-construction evidence until usability and scoring
   validation pass.

The initial Lane A prototype should support semantic tables, line charts, bar
charts, scatter plots, multiple series, and error bars. Phylogenetic trees
should be the first constrained Lane B prototype because they are structured,
scientifically important, and poorly served by prose-only replacement.

## 11. Owner Decisions Required

1. Approve, revise, or reject the four-lane model.
2. Confirm that a visual-dependent item must fail closed when no approved
   equivalent is available.
3. Confirm the proposed V1 visual types and phylogenetic-tree prototype.
4. Confirm that pedagogically synthetic data are allowed under the stated
   disclosure and validation rules.
5. Confirm the recommended device rule: responsive viewing on all supported
   devices, with tablet or desktop required initially for exam-equivalent
   graph-construction evidence.

## 12. Required Follow-On Analysis

- Classify the planned 964 items by visual kind and visual purpose.
- Count how many items require visual interpretation versus incidental context.
- Identify which official topics require diagrams, trees, experimental setups,
  or learner-created graphs.
- Define the canonical vendor-neutral visual schema and JSON Schema validation.
- Prototype and compare eligible renderers.
- Conduct screen-reader, keyboard, zoom, contrast, and mobile testing.
- Define accessible-equivalence review exercises and validator qualifications.
- Define graph-construction interaction and grading requirements.
- Establish visual regression, semantic equivalence, and renderer-migration
  tests.

## 13. Primary References

- [W3C WAI: Complex Images](https://www.w3.org/WAI/tutorials/images/complex/)
- [WCAG 2.2: Non-text Content](https://www.w3.org/WAI/WCAG22/Understanding/non-text-content.html)
- [WCAG 2.2: Use of Color](https://www.w3.org/WAI/WCAG22/Understanding/use-of-color.html)
- [WCAG 2.2: Non-text Contrast](https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html)
- [W3C WAI: Tables Tutorial](https://www.w3.org/WAI/tutorials/tables/)
- [ADA.gov: Web and Mobile Application Accessibility Rule](https://www.ada.gov/resources/2024-03-08-web-rule/)
- [AP Biology Exam Assessment](https://apstudents.collegeboard.org/courses/ap-biology/assessment)
- [Vega-Lite Specification](https://vega.github.io/vega-lite/docs/spec.html)
