# Orly Drawn-Response Pilot Protocol

**Status:** Draft internal research protocol; not a gold-set or implementation approval
**Related Tasks:** `TASK-0010`, `TASK-0011`
**Product Owner:** David Bloom
**Learning Quality Owner / Participant:** Orly Bloom
**Prepared:** 2026-06-13

## 1. Purpose

This protocol defines a small first batch of handwritten AP Biology graph
responses and phone photographs.

The batch is intended to answer:

- Can an expert complete the proposed tasks naturally on paper?
- Are the prompt, table, and drawing instructions clear?
- What does a useful raw phone capture look like?
- Which capture defects are visible before grading?
- Can reviewers consistently identify the observable graph features?

The batch does not establish grading accuracy, student usability, subgroup
performance, or production readiness.

## 2. Review Of Claude's Reference Library

Claude's Google Doc, `Cramapple - Hand-Drawn AP Biology Reference Library &
Scoring Best Practices`, is useful as a survey of possible response forms. It
must not be treated as the pilot question set or as a seed gold set.

### Retain

- The distinction between quantitative graph construction and free-form
  diagrams.
- The recurring graph-feature taxonomy:
  - graph type;
  - axis variables;
  - labels and units;
  - scale;
  - plotted values;
  - uncertainty marks;
  - series identity; and
  - criterion-specific trend or relationship.
- The recommendation to begin with bounded quantitative graphs and defer
  pedigrees and signaling diagrams.

### Correct

- The listed items are substantially based on identifiable historical official
  AP questions. They are not eligible as Cramapple prompts, model inputs,
  exemplars, or evaluation cases under the approved rights boundary.
- Items 8 and 9 are graph-interpretation tasks, not hand-drawn response tasks.
- Graph conventions are question-specific. "Independent variable always on
  the x-axis," "continuous variable means line graph," and "connect every
  point" are not universal scoring rules.
- Error-bar overlap does not by itself prove or disprove statistical
  significance.
- A title, zero baseline, ruler use, unit, legend, error bar, or diagram label
  earns credit only when required by the question-specific scoring package.
- Extra labels can create contradictions or ambiguity. "Always over-label" is
  unsafe advice.
- Pedigree carrier notation, pathway component requirements, and graph-shape
  expectations must be defined by the specific prompt and approved rubric.
- Claims about the most frequent errors, high-scoring behavior, time allocation,
  or grader trust need evidence before Cramapple presents them as facts.
- A respondent cannot count hidden rubric points before drawing unless the
  task explicitly exposes a checklist. Cold assessment must not reveal
  answer-bearing criteria.

## 3. Pilot Scope

Use three or fewer newly authored, rights-clean AP Biology quantitative graph
prompts.

Recommended first archetypes:

1. **Categorical comparison:** bar graph from group means with a supplied
   uncertainty measure.
2. **Continuous series:** line or scatter representation from measurements
   across time, concentration, temperature, or another continuous variable.
3. **Relationship and estimate:** plot continuous paired data, represent the
   relationship appropriately, and estimate a biologically meaningful value
   from the graph.

Each prompt must be independently authored from a blank Cramapple brief. Do not
reuse the organisms, values, wording, tables, distinctive scenarios, or scoring
language in Claude's historical reference items.

Exclude from this first batch:

- pedigrees;
- signaling pathways;
- cell diagrams;
- food webs;
- conceptual economics-style curves;
- graph interpretation without drawing;
- multi-page responses; and
- handwritten prose grading.

## 4. Orly Instructions

### Before Starting

- Complete each prompt without seeing its grading checklist.
- Use one blank sheet per response.
- Write only the assigned response ID, not a name, signature, email, school, or
  other personal information.
- Disable camera location tagging before taking the pilot photographs so the
  raw files do not contain GPS coordinates.
- Use the writing instrument that feels natural. Record whether it was pencil
  or pen after completing the response.
- Do not aim to manufacture a perfect exemplar. Respond as a knowledgeable
  participant under ordinary time pressure.

### While Responding

- Work independently.
- Do not consult Claude, an answer key, official response samples, or the
  scoring checklist.
- Record start and finish times separately from the response page.
- Cross-outs and corrections are allowed and should remain visible.
- Use ordinary paper rather than a preprinted graph grid unless the prompt
  explicitly supplies one.

### After Responding

For each response, record:

- response ID;
- completion time;
- pen or pencil;
- any instruction that felt ambiguous;
- any feature that was difficult to draw;
- whether a ruler, calculator, or graph paper was used; and
- confidence that the intended answer is scientifically correct.

This self-report is research context, not scoring evidence.

## 5. Photograph Protocol

Create two raw captures per response.

### Capture A - Best Reasonable Capture

- Entire page and all page edges visible.
- Camera approximately parallel to the paper.
- Bright, even lighting.
- No hand, face, name, answer key, computer screen, or unrelated document in
  frame.
- Highest normal camera resolution.
- No filters, markup, portrait effects, or document-scan cleanup.

### Capture B - Ordinary Desk Capture

- Use the position and lighting a learner would naturally use.
- Keep the complete response visible and human-readable.
- A modest angle or shadow is acceptable.
- Do not intentionally create an unreadable image.

Do not crop, rotate, enhance, compress, or convert the original files before
submission. Derived versions should be created by the research pipeline while
the raw capture remains unchanged.

Recommended filename:

```text
ORLY-P0-Q01-R01-CAP-A-original.jpg
```

Where:

- `P0` is pilot round 0;
- `Q01` is prompt 1;
- `R01` is the first response to that prompt; and
- `CAP-A` or `CAP-B` identifies the capture condition.

## 6. Submission Package

Submit one package containing:

```text
prompt_version_id
response_id
raw_capture_A
raw_capture_B
completion_time
writing_instrument
tools_used
participant_notes
```

Keep prompt text and expected scoring criteria separate from the image files.
The response page may contain the response ID but must not contain Orly's name.

Before using a third-party model or service on the images, confirm the approved
provider, retention, training-use, and deletion boundary. Internal collection
does not authorize external model submission.

## 7. How The Evidence May Be Used

This first batch may be used for:

- prompt clarity review;
- capture-flow planning;
- image-quality rule development;
- visual-observation schema development;
- preliminary offline pipeline debugging; and
- creation of synthetic transformation tests from rights-clean originals after
  approval.

It may not be represented as:

- a learner gold set;
- an independent grading validation set;
- evidence of automated grading accuracy;
- representative student handwriting;
- evidence of accessibility;
- a production content package; or
- consent for provider training or public display.

Because Orly is the Learning Quality Owner and a knowledgeable participant, her
responses can be expert development cases. They require independent blind
scoring and lead adjudication before any derivative case could qualify for a
locked evaluation set. The final held-out set must remain inaccessible to
prompt and pipeline developers.

## 8. Review After Submission

Run the following review in order:

1. **Rights and provenance:** confirm every prompt and dataset is independently
   authored and traceable.
2. **Prompt clarity:** identify ambiguity before judging the response.
3. **Capture quality:** label cutoff, blur, glare, perspective, resolution, and
   legibility independently for Capture A and Capture B.
4. **Visual observation:** record visible axes, labels, values, marks, and
   uncertainty features without awarding points.
5. **Criterion review:** have qualified reviewers apply the question-specific
   rubric only after observations are locked.
6. **Disagreement analysis:** distinguish capture failure, observation failure,
   rubric ambiguity, and scientific disagreement.
7. **Next-round decision:** revise prompts, revise capture instructions, or
   authorize a larger development corpus.

## 9. Immediate Gate

Do not ask Orly to answer the 12 historical-reference items as the formal pilot.
Claude should first replace them with three original pilot prompts and complete
logical scoring packages under the accompanying revision brief:

`prompts/CLAUDE_REVISE_DRAWN_RESPONSE_PILOT_SET.md`

If Orly has already answered any historical-reference item, retain the response
only as a private workflow sample pending rights review. Do not place it in the
canonical content library, prompt library, model inputs, or grading evaluation
set.
