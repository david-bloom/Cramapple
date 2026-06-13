# Claude Brief - Replace The Drawn-Response Reference Set With A Rights-Clean Pilot

## Objective

Replace the historical AP-question reference library with a bounded,
independently authored AP Biology graph-construction pilot for Orly Bloom to
complete on paper and photograph.

Read:

- `docs/research/ORLY_DRAWN_RESPONSE_PILOT_PROTOCOL.md`
- `docs/research/DRAWN_RESPONSE_ARCHITECTURE_REVIEW.md`
- `docs/tasks/TASK-0010-GRADER-CONFIDENCE-AND-CALIBRATION.md`
- `docs/tasks/TASK-0011-HANDWRITTEN-GRAPH-CAPTURE.md`
- `docs/architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md`
- `docs/teaching/TEACHING_AND_PEDAGOGY_DESIGN.md`

## Rights Boundary

Start from blank Cramapple briefs.

Do not use, adapt, paraphrase, imitate, or preserve:

- official College Board question wording;
- historical AP scenarios, organisms, values, or data tables;
- scoring-guide language;
- released student responses;
- distinctive prompt structures; or
- Claude's 12 historical reference items.

Use independently created, scientifically plausible synthetic datasets and
original scenarios.

## Required Pilot Set

Create exactly three AP Biology quantitative graph prompts:

1. Categorical comparison with group means and an uncertainty measure.
2. Continuous series across a continuous independent variable.
3. Paired continuous data requiring a relationship representation and a
   biologically meaningful graphical estimate.

Keep each prompt completable on one blank sheet of paper in approximately
8-12 minutes by an AP Biology expert.

Do not include pedigrees, signaling diagrams, cell drawings, graph-only
interpretation, or extended prose grading.

## Required Package For Each Prompt

Provide:

```text
prompt_id
prompt_version
originality_statement
scientific_sources
synthetic_dataset_method
student_prompt
data_table
allowed_tools
expected_response_form
criterion_definitions
accepted_variants
insufficient_or_contradictory_patterns
visual_observation_schema
capture_requirements
accessibility_note
expert_review_questions
```

### Student Prompt

- Do not reveal the grading checklist.
- State the requested operation clearly.
- Include all needed data and units.
- Do not prescribe a graph type unless selecting the representation is outside
  the assessed construct.
- Separate the graph-construction task from any optional written follow-up.

### Criterion Definitions

Each criterion must:

- identify required evidence;
- avoid preferred-wording rules;
- define tolerances for plotted values and uncertainty marks;
- state whether labels, units, title, legend, baseline, line connection,
  best-fit treatment, or interpolation are required;
- define accepted alternatives;
- define contradictions;
- identify capture conditions that make the criterion unscorable; and
- state whether the criterion is a candidate for deterministic, OCR,
  multimodal, hybrid, or human-only review.

### Visual Observation Schema

Define observations without awarding points:

- page and graph-region bounds;
- axis lines and orientation;
- axis-label text and confidence;
- units;
- tick positions and values;
- plotted marks;
- series identity;
- uncertainty marks;
- connecting line or fitted relationship;
- annotations and corrections; and
- unreadable or ambiguous regions.

## Required Review

Before calling the set ready for Orly:

1. Check scientific plausibility.
2. Check that prompt and data are independently authored.
3. Check that the intended graph representation is not underdetermined.
4. Check every criterion against the actual student instructions.
5. Check that the graph can fit legibly on ordinary letter-size paper.
6. Check that no cold instruction leaks the scoring checklist or answer.
7. Identify what Orly should report after completing each prompt.

## Output

Return:

1. The three student-facing prompt sheets.
2. A separate reviewer-only package for each prompt.
3. A one-page originality and provenance report.
4. A one-page Orly administration checklist aligned to
   `ORLY_DRAWN_RESPONSE_PILOT_PROTOCOL.md`.
5. A list of unresolved Learning Quality, rights, accessibility, and Product
   Owner decisions.

Do not call these questions approved, AP-equivalent, production-ready, or
eligible for a gold set. They remain proposed development cases until the
required independent reviews and recorded gates are complete.
