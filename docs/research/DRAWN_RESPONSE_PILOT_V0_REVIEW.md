# Drawn-Response Pilot V0 Review

**Status:** Revision required before participant use
**Related Tasks:** `TASK-0010`, `TASK-0011`
**Product Owner:** David Bloom
**Reviewed:** 2026-06-13
**Artifact Reviewed:** `Cramapple - Drawn-Response Pilot Set v0 (AI-Drafted Candidate)`
**Google Doc:** `1jJqfjV4_HMub3hX8m6a35DuVlDiy2p0xazj08YBfqUg`

## 1. Verdict

Claude's revised pilot is materially better than the retired historical
reference library. It follows the requested three-archetype structure,
separates student-facing and reviewer-only material, states its candidate
status, avoids universal title and ruler requirements, and correctly limits
Orly's responses to private expert development cases.

It is not ready for Orly to attempt. Two synthetic-dataset provenance claims
are not reproducible, one rights statement cites an approval that does not
exist, and several criterion choices would add avoidable confounds to a pilot
whose primary purpose is capture-flow learning.

**Proposed verdict:** `QA Blocked - Revision Required`

## 2. What Passed

- Exactly three quantitative graph archetypes are proposed.
- Historical official questions are no longer used as prompt seeds.
- Student-facing prompts are separated from reviewer packages.
- Candidate status and downstream governance gates are stated clearly.
- Titles, rulers, preferred wording, and over-labeling are not universal
  requirements.
- Orly's responses are correctly classified as development cases rather than a
  gold set.
- Capture A, Capture B, GPS, raw-file, filename, and no-external-model controls
  align with the approved pilot protocol.

## 3. Blocking Findings

### P0-1 - Prompt 2 Dataset Is Not Reproducible

Prompt 2 says its means were generated from:

```text
R(T) = Vmax * exp(-((T-Topt)^2)/(2*sigma^2)) * f(T)
```

with `Vmax = 9.2`, `Topt = 40`, `sigma = 12`, and an unspecified high-temperature
falloff factor.

The stated Gaussian component produces approximately:

| Temperature | Stated base model | Pilot table |
| --- | ---: | ---: |
| 5 C | 0.13 | 0.8 |
| 15 C | 1.05 | 2.1 |
| 25 C | 4.21 | 4.9 |
| 35 C | 8.44 | 8.2 |
| 40 C | 9.20 | 9.1 |
| 45 C | 8.44 | 7.4 |
| 50 C | 6.50 | 3.1 |
| 55 C | 4.21 | 0.4 |

An unspecified factor described only as a falloff above 50 C cannot explain
the lower-temperature differences or reproduce the table.

Required remediation:

- provide the complete formula for every temperature and regenerate the table;
  or
- provide explicit synthetic replicate observations and derive the displayed
  means and uncertainty values from those observations.

The method, parameters, rounding, and output must reproduce exactly.

### P0-2 - Prompt 3 Dataset Does Not Match Its Logistic Equation

Prompt 3 claims the table was computed from a logistic model with:

```text
K = 3.4e6
N0 = 1.2e4
r = 0.55 per hour
```

The equation produces approximate values of:

```text
0h  1.20e4
2h  3.58e4
4h  1.05e5
6h  2.98e5
8h  7.61e5
10h 1.58e6
12h 2.46e6
14h 3.02e6
16h 3.26e6
18h 3.35e6
20h 3.38e6
```

These do not equal the displayed table. Rounding does not account for the
differences.

Required remediation:

- regenerate the table directly from the stated parameters; or
- fit and disclose parameters that reproduce the intended table.

Do not describe hand-adjusted values as computed model output.

### P0-3 - Rights Status Is Overstated

The unresolved-rights section refers to a "moderate-originality threshold the
Product Owner approved." No such threshold or approval appears in the Cramapple
approval or decision logs.

Claude's statement that it did not knowingly use a released question is useful
process evidence, but Claude also states that it lacks visibility into the full
released-question corpus. It therefore cannot establish originality or
similarity clearance.

Required remediation:

- remove the nonexistent approval reference;
- label novelty and similarity status `unverified`;
- preserve the artifact as isolated internal capture-research material only;
- require qualified human source-isolation and similarity review before any
  reuse beyond this private pilot; and
- require a Paid Tutor Author to create or adopt a new immutable package before
  governance-pipeline entry.

This does not require a legal conclusion that common topics such as enzymes or
population growth are prohibited. It requires honest evidence boundaries.

## 4. Product And Learning Decisions

### 4.1 SEM Versus SD

**Decision recommendation:** Use the same uncertainty type in Prompts 1 and 2
for pilot round P0. Use SEM in both.

Rationale:

- The primary outcome is capture and visual-observation quality.
- One expert response per prompt cannot establish whether SEM/SD label
  attention is reliable.
- Changing uncertainty type adds construct-irrelevant variance to comparisons
  across graph archetypes.
- A later challenge set can deliberately test SEM versus SD after baseline
  capture and extraction behavior is understood.

Student-facing instructions should say `include symmetric error bars showing
plus or minus one SEM` so the pilot tests capture of a known visual primitive,
not free-form uncertainty encoding.

### 4.2 Prompt 3 Concept Wording

**Decision recommendation:** Replace `carrying capacity` in the student prompt
with:

> Estimate the population density around which the culture levels off under
> these conditions. Indicate the estimate on the graph and report its value.

Rationale:

- The pilot is testing graph construction and graphical estimation, not recall
  of the term `carrying capacity`.
- `Under these conditions` avoids implying an immutable species-level constant.
- `Levels off` is more accurate than saying biological growth has stopped.
- Requiring the estimate to be indicated on the graph makes the graphical
  evidence criterion visible rather than hidden.

The reviewer package may record that this operational plateau is an estimate of
carrying capacity in the modeled environment.

### 4.3 Prompt 3 Numeric Representation

Use a single linear y-axis convention for P0 and rescale the data to avoid
scientific-notation transcription becoming the dominant task.

Recommended table unit:

```text
Population density (10^5 cells per mL)
```

For example, `3.4e6 cells/mL` becomes `34` in the table and graph. The exact
values must come from the corrected logistic equation.

A logarithmic-axis variant may be tested later as a distinct archetype. It
should not be accepted interchangeably in the baseline because it changes curve
shape, geometry, OCR demands, and graphical interpretation.

## 5. Criterion Corrections

### 5.1 Uncertainty Marks

For P0:

- require symmetric `plus or minus one SEM` bars;
- do not accept one-sided bars;
- do not accept a box-plot-style display when quartiles or distributions were
  not supplied;
- do not accept a shaded band across unrelated categorical groups; and
- remove Prompt 1's malformed SD/SEM sentence and incorrect cross-reference to
  C5.

Mean points with symmetric bars and bars with symmetric whiskers may both be
accepted for Prompt 1.

### 5.2 Prompt 3 Graphical Estimate

The current C3 and C4 partly duplicate one another and infer whether the
participant "really" used the graph.

After the student instruction explicitly requires the estimate on the graph:

- score whether the reported value and unit are present;
- score whether a visible annotation links the value to the plateau;
- do not reject an estimate merely because it equals the highest observed
  value;
- do not infer the participant's mental process from equality to a table value;
  and
- judge consistency between the curve, annotation, and reported estimate.

### 5.3 Proposed Tolerances

The numeric plotting and uncertainty tolerances are hypotheses, not validated
rubric thresholds. Label them `proposed development tolerances`.

During Orly's pilot:

- record raw deviation from each expected value;
- do not use the proposed threshold to declare the prompt or grader passed;
- review whether the tolerance is compatible with ordinary paper, scale choice,
  line thickness, perspective, and image resolution; and
- retain criterion outcomes only as reviewer development notes.

### 5.4 Scale And Area Rules

Remove the rule that data occupying less than 25% of the plot area is
automatically contradictory. It is an unsupported threshold.

Record:

- fraction of available plot area used;
- whether marks are distinguishable;
- whether scale intervals are interpretable; and
- whether all required data fit.

Adopt a scoring threshold only after expert and learner evidence.

## 6. Orly Readiness Gate

Orly may begin only after:

- Prompt 2 and Prompt 3 provenance reproduce exactly;
- both uncertainty prompts use SEM and symmetric bars;
- Prompt 3 uses the operational plateau wording and a bounded linear scale;
- reviewer criteria are corrected as specified above;
- the nonexistent originality approval is removed;
- novelty is marked unverified;
- the Product Owner approves private capture-pilot use; and
- Orly receives student-facing pages only, not the reviewer packages.

The revised package should preserve the same IDs with a new version such as
`v0.2-ai-draft`; it must not overwrite v0.1.

## 7. Next Action

Return the findings in this review to Claude using:

`prompts/CLAUDE_REMEDIATE_DRAWN_RESPONSE_PILOT_V0.md`

After Claude returns v0.2, run:

1. deterministic provenance recalculation;
2. Learning Quality preflight;
3. rights and similarity-status check;
4. student/reviewer separation check; and
5. Product Owner proceed, revise, or stop decision.
