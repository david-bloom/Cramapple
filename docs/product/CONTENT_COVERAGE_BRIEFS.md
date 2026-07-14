# AP Biology Content Coverage Briefs

**Status:** Draft — awaits Learning Quality Owner review and Product Owner decision
**Owner:** Main Conductor (drafting) / Orly Bloom, Learning Quality Owner (review)
**Product Owner:** David Bloom
**Related Tasks:** `CONTENT-001`, `TASK-0007`, `TASK-0008`, `TASK-0005`
**Related Design:** `docs/architecture/CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md`
**Date:** 2026-07-14

## 1. Purpose

This document defines Cramapple's **coverage brief** — the versioned authoring
instruction that tells a qualified tutor author exactly what content package to
produce for one slot in the 964-item AP Biology plan. It closes the open
`CONTENT-001` checklist item:

> Define versioned coverage briefs for questions, rubrics, lessons, hints,
> worked examples, probes, transfer items, and delayed variants.

A coverage brief is **concern #5 (Coverage brief)** of the prompt build manifest
in `CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §5. It specifies "exact topic,
skill, difficulty, representation, use, and portfolio gap" for a single authoring
run. It is the assignment; the authored package is the deliverable that answers
it.

### What this document is not

- **Not question content.** A coverage brief never contains a stem, answer key,
  distractors, rubric text, or any authored artifact. It specifies *what to
  author*, not the author's output. Generating production content is Hard-Gated
  (`CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §11) and out of scope here.
- **Not an approval.** Drafting these briefs does not commission an author,
  authorize spend, or admit anything to the content pool. Those gates remain open
  (§7).
- **Not a taxonomy or quantity change.** The 60-topic taxonomy and the
  10-MCQ / 5-short-FRQ per-topic and per-unit long-FRQ targets are fixed by
  `CONTENT_QUANTITY_AND_DISTRIBUTION.md`. Briefs consume those targets; they do
  not reopen them.

## 2. Governing Rules (restated for this artifact — not reopened)

These are already settled by prior decisions and are repeated so a brief author
does not have to cross-reference to stay compliant. They are load-bearing.

1. **No official material as input.** Official AP question text, scoring
   guidelines, and identifiable official question structures never enter a
   coverage brief, an authoring prompt, an exemplar, or a model input
   (`CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §2.1). A brief describes an
   *abstract* construct to assess (topic, science practice, task verb,
   representation) — never a specific official scenario, organism, dataset, or
   value to imitate.
2. **Tutor-authored baseline.** The production authoring arm is paid qualified
   tutors producing complete proprietary base packages
   (`CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §2.2). A brief targets a human
   author unless it is explicitly tagged for the isolated
   `CONTENT_AUTHORING_MODEL_EXPERIMENT.md` arm.
3. **Complete-package requirement.** A brief must require the author to deliver
   the full package contract — MCQ (§8) or FRQ (§9) of the authoring
   architecture — including rubric, teaching explanation, minimum correction,
   transfer candidate, delayed-retrieval candidate, accessibility
   representation, source/rights claims, and failure-card self-checks. A brief
   never lets an author skip a contract field.
4. **Same gates for every arm.** Every package a brief produces receives the same
   independent originality, scientific, teaching, grading, accessibility, rights,
   and release gates (`CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §2.5,
   `CONTENT_GOVERNANCE_AND_VALIDATION.md`). A brief cannot waive a gate.
5. **Author-generated responses are development test cases, not gold.** Any
   sample learner responses a brief asks for are development fixtures. They are
   never a human gold set and never sufficient to calibrate or release a grader
   (`CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §9).

## 3. Coverage Brief Identity and Versioning

Every coverage brief is an immutable, individually versioned artifact so it can
be referenced by `authoring_brief_version_id` in a prompt build manifest.

**Brief ID:** `CB-BIO-<topic>-<form>-<seq>`

- `<topic>` — official topic identifier from
  `CONTENT_QUANTITY_AND_DISTRIBUTION.md` (e.g. `7.5`). Long-FRQ packages, which
  are scoped per unit rather than per topic, use the unit number with a package
  letter (e.g. `U8-A`).
- `<form>` — `MCQ`, `SFRQ` (short FRQ), or `LFRQ` (long FRQ).
- `<seq>` — zero-padded sequence within that topic+form (e.g. `01`).

Example: `CB-BIO-7.5-MCQ-01`.

**Version:** each brief carries `Brief-Version: vNN`. A brief is immutable once
issued to an author. A material change (topic, science practice, difficulty
band, representation requirement, or use) produces a new `Brief-Version`, never
an edit in place. Editorial fixes that do not change what an author must produce
(typo, clarified wording) may reuse the version with a dated changelog line.

**State:** `Drafted` → `LQ-Reviewed` → `Approved` → `Assigned` → `Retired`.
Only the Learning Quality Owner advances a brief to `LQ-Reviewed`; only the
Product Owner (or delegated LQ Owner within lane) advances to `Approved`. A brief
must be `Approved` before it can be `Assigned` to an author.

## 4. Coverage Brief Schema

Every brief instantiates the following fields. Fields marked **(required)** must
be present and non-empty before a brief can reach `LQ-Reviewed`.

```text
coverage_brief {
  brief_id: string                    # CB-BIO-<topic>-<form>-<seq>   (required)
  brief_version: string               # vNN                            (required)
  state: enum                         # per §3                         (required)
  exam_pack: string                   # active AP Biology exam pack    (required)

  # --- What to assess (the abstract construct) ---
  primary_topic: string               # official topic id + name       (required)
  secondary_topics: string[]          # optional additional topic tags
  science_practices: string[]         # SP1..SP6 from the CED           (required)
  task_verbs: string[]                # Describe/Explain/Calculate/...  (required)
  target_skill_statement: string      # one sentence: what a correct
                                      #   response demonstrates          (required)
  representations: string[]           # table/graph/diagram/model/prose (required)
  difficulty_band: enum               # Easy/Medium/Hard/Very Hard      (required)
  intended_use: enum                  # teaching | diagnostic | transfer(required)

  # --- Package the author must deliver (points to the contract) ---
  form: enum                          # MCQ | SFRQ | LFRQ               (required)
  package_contract_ref: string        # §8 or §9 of authoring arch      (required)
  required_artifacts: string[]        # questions, rubric, lesson,
                                      #   hints, worked example, probe,
                                      #   transfer item, delayed variant(required)
  point_count_rule: string            # "resolve from active exam pack"
  visual_requirement: string|null     # if a visual is required, the
                                      #   abstract kind (not the data)

  # --- Portfolio bookkeeping ---
  portfolio_slot: string              # which target slot this fills    (required)
  portfolio_gap_note: string          # why this brief exists now

  # --- Guardrails carried into the author's hands ---
  prohibited_inputs: string[]         # official material, rejected
                                      #   candidate, secure content     (required)
  rights_posture: string              # originality + IP assignment     (required)
  applicable_failure_cards: string[]  # codes from authoring arch §4    (required)
  accessibility_requirement: string   # equivalent non-visual access    (required)

  # --- Provenance ---
  drafted_by: string
  drafted_date: string
  lq_reviewed_by: string|null
  approved_by: string|null
}
```

### 4.1 Required artifacts, expanded

The `CONTENT-001` item names eight artifact families a brief must require. Each
maps to a package-contract field the author owns:

| Artifact family | Where it lives in the package | Brief must specify |
| --- | --- | --- |
| Question(s) | MCQ stem+choices / FRQ prompt parts | topic, SP, task verb, difficulty |
| Rubric | criterion-level scoring rules + boundary contracts | criterion granularity expected |
| Lesson | teaching explanation | the misconception(s) the lesson must resolve |
| Hints | minimum correction / fade steps | whether staged hints are in scope |
| Worked example | teaching explanation exemplar | representation the worked example uses |
| Probes | diagnostic distractors / criterion boundaries | the error mechanisms to discriminate |
| Transfer item | immediate-transfer candidate | required transfer distance |
| Delayed variant | delayed-retrieval candidate | required delay/interference profile |

A brief does not author these — it states the coverage requirement for each so
the author's package is complete and reviewable against the same expectation.

## 5. Portfolio-Gap Model

Coverage briefs are generated against the fixed target matrix in
`CONTENT_QUANTITY_AND_DISTRIBUTION.md`. The portfolio ledger answers one
question per slot: *is this slot targeted, drafted, in review, or approved?*

- **Slot** = one row of the target (a topic+form pair for MCQ/short-FRQ; a
  unit+package for long-FRQ). Topic `7.5` MCQ is 10 slots; topic `7.5` short-FRQ
  is 5 slots.
- Each brief fills exactly **one** slot and records it in `portfolio_slot`.
- The ledger is the machine-readable coverage matrix `CONTENT-001A` requested.
  Its authoritative form is a table keyed by `portfolio_slot`; this document
  seeds it and the eventual governed matrix supersedes the inline copy.
- A slot may hold at most one `Approved` brief at a time. Over-authoring (more
  briefs than target) is allowed at `Drafted` state for diversity selection but
  must not inflate the counted target.

Only the **primary topic** earns inventory credit
(`CONTENT_QUANTITY_AND_DISTRIBUTION.md`), so a brief's `portfolio_slot` is always
its `primary_topic` + `form`, regardless of secondary topic tags.

## 6. Initial Vertical-Slice Briefs

`CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §10 requires the first vertical
slice to be one MCQ package, one short-FRQ package, one long-FRQ package, and one
quantitative visual, all carried through the full authoring, provenance,
validation, release-candidate, and rollback trail before content scales.

The three briefs below are drafted to **be** that first vertical slice. They are
deliberately spread across a quantitative topic, a data-analysis topic, and an
ecology package (aligning with the unapproved ecology FRQ candidates noted in
`CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §10). The quantitative visual
requirement is satisfied inside the MCQ and short-FRQ briefs.

All three are `state: Drafted`. None is assigned. Each abstract construct is
described so no official scenario is imitated.

---

### CB-BIO-7.5-MCQ-01

```text
brief_id: CB-BIO-7.5-MCQ-01
brief_version: v01
state: Drafted
exam_pack: AP Biology (active pack — resolve at manifest build)

primary_topic: 7.5 Hardy-Weinberg Equilibrium
secondary_topics: [7.4 Population Genetics]
science_practices: [SP5 Statistical Tests and Data Analysis,
                    SP6 Argumentation]
task_verbs: [Calculate, Justify]
target_skill_statement: >
  Given allele or genotype frequency data for a described population, the learner
  calculates an expected Hardy-Weinberg value and justifies whether an observed
  deviation is consistent with the equilibrium assumptions.
representations: [data table OR allele/genotype frequency figure, algebraic model]
difficulty_band: Hard
intended_use: teaching

form: MCQ
package_contract_ref: CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md §8
required_artifacts: [stem+four choices, keyed-answer proof, per-choice rationale,
                     per-distractor error mechanism, teaching lesson,
                     minimum correction, transfer item, delayed variant,
                     accessibility representation, failure-card self-checks]
point_count_rule: single best answer of four unless active exam pack differs
visual_requirement: >
  ONE original quantitative representation (data table or simple frequency
  figure) sufficient for the calculation. Author supplies an original synthetic
  dataset — never an official dataset. This brief carries the vertical slice's
  quantitative-visual requirement.

portfolio_slot: 7.5-MCQ
portfolio_gap_note: >
  First of ten MCQ slots for 7.5. Chosen for the vertical slice because
  Hardy-Weinberg is quantitative, high-frequency in the prompts already in the
  repo, and exercises deterministic calculation-check verification.

prohibited_inputs: [official AP question text/scoring material, the rejected
                    official-derived candidate, any secure or credential-gated
                    content, any real dataset the author cannot license]
rights_posture: >
  Original work by a paid qualified tutor under the standard originality
  warranty and full IP assignment; no derivative of any official item.
applicable_failure_cards: [MISSING_OPERAND, DUPLICATE_DISTRACTOR_LOGIC,
                           UNSOURCED_SPECIFICITY, EXAM_FORMAT_MISMATCH]
accessibility_requirement: >
  Every value needed for the calculation must be available in accessible text or
  table form, not only in a figure. Screen-reader-equivalent data required.

drafted_by: Main Conductor
drafted_date: 2026-07-14
lq_reviewed_by: null
approved_by: null
```

---

### CB-BIO-3.2-SFRQ-01

```text
brief_id: CB-BIO-3.2-SFRQ-01
brief_version: v01
state: Drafted
exam_pack: AP Biology (active pack — resolve at manifest build)

primary_topic: 3.2 Environmental Impacts on Enzyme Function
secondary_topics: [3.1 Enzymes]
science_practices: [SP4 Representing and Describing Data,
                    SP3 Questions and Methods]
task_verbs: [Describe, Explain, Predict]
target_skill_statement: >
  Given results from a described enzyme experiment that varies one environmental
  factor, the learner describes the trend, explains it mechanistically at the
  level of enzyme structure/active site, and predicts the outcome of a stated
  change in conditions.
representations: [results table OR line graph with an independent and dependent
                  variable, prose]
difficulty_band: Medium
intended_use: teaching

form: SFRQ
package_contract_ref: CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md §9
required_artifacts: [shared stimulus+assumptions, independently deliverable
                     prompt parts, criterion-level scoring rules,
                     criterion-boundary contracts with evidence gates,
                     accepted alternatives, insufficient/contradictory/boundary
                     responses, teaching lesson, per-criterion minimum fixes,
                     transfer item, delayed variant, source/rights/accessibility]
point_count_rule: resolve point count from the active exam pack (short-FRQ form)
visual_requirement: >
  ONE original data representation (results table or simple line graph) built on
  an original synthetic dataset. Original data only — no official dataset.

portfolio_slot: 3.2-SFRQ
portfolio_gap_note: >
  First of five short-FRQ slots for 3.2. Chosen for the vertical slice as a
  data-analysis + mechanism item that exercises criterion-boundary contracts and
  partial-credit test cases.

prohibited_inputs: [official AP question text/scoring material, the rejected
                    official-derived candidate, any secure or credential-gated
                    content, any real dataset the author cannot license]
rights_posture: >
  Original work by a paid qualified tutor under the standard originality
  warranty and full IP assignment.
applicable_failure_cards: [UNDERDETERMINED_PREDICTION, OMITTED_CAUSAL_LINK,
                           UNDEFINED_QUALITATIVE_THRESHOLD,
                           PSEUDOREPLICATION_OR_UNCERTAINTY]
accessibility_requirement: >
  Graph or table data must have a screen-reader-equivalent text form; the item
  must be answerable without color perception.

drafted_by: Main Conductor
drafted_date: 2026-07-14
lq_reviewed_by: null
approved_by: null
```

---

### CB-BIO-U8-A-LFRQ-01

```text
brief_id: CB-BIO-U8-A-LFRQ-01
brief_version: v01
state: Drafted
exam_pack: AP Biology (active pack — resolve at manifest build)

primary_topic: Unit 8 Ecology (package A; primary topic 8.2 Energy Flow
               Through Ecosystems for inventory credit)
secondary_topics: [8.3 Population Ecology, 8.5 Community Ecology,
                   8.7 Disruptions in Ecosystems]
science_practices: [SP4 Representing and Describing Data,
                    SP5 Statistical Tests and Data Analysis,
                    SP6 Argumentation]
task_verbs: [Describe, Calculate, Predict, Justify]
target_skill_statement: >
  Working from a shared ecological stimulus with quantitative data, the learner
  describes a pattern, performs a supported calculation, predicts a system
  response to a described disturbance, and justifies a claim using the presented
  evidence.
representations: [multi-part shared stimulus with at least one quantitative
                  data display, algebraic/quantitative reasoning, prose argument]
difficulty_band: Hard
intended_use: teaching

form: LFRQ
package_contract_ref: CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md §9
required_artifacts: [shared stimulus package (reusable, immutable),
                     two independently deliverable long-FRQ prompts from the
                     shared stimulus, per-prompt criterion-level scoring rules,
                     criterion-boundary contracts, accepted alternatives,
                     full/partial/no-credit/equivalent/contradiction/ambiguity
                     test cases, teaching lesson, per-criterion minimum fixes,
                     transfer items, delayed variants, source/rights/
                     accessibility/generation provenance]
point_count_rule: resolve point count from the active exam pack (long-FRQ form)
visual_requirement: >
  Shared stimulus must include at least one original quantitative data display
  built on an original synthetic dataset. No official stimulus, dataset, or
  scenario.

portfolio_slot: U8-LFRQ-A
portfolio_gap_note: >
  First of four long-FRQ packages for Unit 8 (each package yields two counted
  prompts). Ecology chosen to align with the unapproved ecology FRQ candidates
  noted in the authoring architecture §10 — those remain candidates, not inputs;
  this brief is authored from blank, not from them.

prohibited_inputs: [official AP question text/scoring material, the rejected
                    official-derived candidate, the unapproved external-archive
                    ecology candidates as adaptation sources, any secure content,
                    any real dataset the author cannot license]
rights_posture: >
  Original work by a paid qualified tutor under the standard originality
  warranty and full IP assignment; the shared stimulus is a proprietary reusable
  governed artifact.
applicable_failure_cards: [MISSING_OPERAND, UNDERDETERMINED_PREDICTION,
                           OMITTED_CAUSAL_LINK, PSEUDOREPLICATION_OR_UNCERTAINTY,
                           UNDEFINED_QUALITATIVE_THRESHOLD, EXAM_FORMAT_MISMATCH]
accessibility_requirement: >
  Every data display needs a screen-reader-equivalent text form; all quantitative
  values required for scoring must be available without visual perception.

drafted_by: Main Conductor
drafted_date: 2026-07-14
lq_reviewed_by: null
approved_by: null
```

## 7. Open Gates and Questions

These block a brief from advancing past `Drafted`; they are flagged, not decided.

1. **Learning Quality Owner review (Orly).** Confirm the schema fields, the
   science-practice/task-verb/representation choices, and the difficulty bands on
   the three seed briefs are pedagogically right, and confirm the primary-topic
   assignment for the long-FRQ package (currently 8.2 for inventory credit).
2. **Author qualification and agreements (open in `CONTENT-001` / `TASK-0008`).**
   No brief can be `Assigned` until tutor-author qualifications, the counsel-
   approved originality/IP/confidentiality release, and compensation terms are in
   place. Briefs are ready to hand to an author the moment those gates close.
3. **Governed coverage matrix location.** Decide whether the portfolio ledger
   (§5) lives as a committed machine-readable table (CSV/JSON in `docs/` or a
   generated artifact) or inside the eventual content database. Until then this
   document seeds it inline.
4. **Brief-to-manifest binding.** The `prompt_build_manifest`
   (`CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §5) references
   `authoring_brief_version_id`. Confirm whether that ID resolves to this
   document's brief IDs directly or through the deferred physical schema
   (`TASK-0009`).

## 8. What This Document Does Not Cover

- Authoring, storing, or approving any actual question, rubric, or teaching text
  (Hard-Gated; §1).
- Author recruitment, compensation, or contracting (`CONTENT-001`,
  `TASK-0008`).
- The AI-authoring experiment arm's briefs — those follow the same schema but are
  scoped and gated separately in `CONTENT_AUTHORING_MODEL_EXPERIMENT.md`
  (`TASK-0007`).
- The remaining 961 slots. This draft defines the brief system and seeds the
  three vertical-slice briefs; scaling to the full matrix follows a successful
  vertical slice per `CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §10.
