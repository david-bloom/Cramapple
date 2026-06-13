# Claude Remediation Brief - Drawn-Response Pilot V0

Revise `Cramapple - Drawn-Response Pilot Set v0 (AI-Drafted Candidate)` into a
new immutable `v0.2-ai-draft`.

Read:

- `docs/research/DRAWN_RESPONSE_PILOT_V0_REVIEW.md`
- `docs/research/ORLY_DRAWN_RESPONSE_PILOT_PROTOCOL.md`
- `prompts/CLAUDE_REVISE_DRAWN_RESPONSE_PILOT_SET.md`

Do not overwrite v0.1.

## Required Corrections

### 1. Reproducible Synthetic Data

For Prompt 2:

- provide a complete formula that reproduces every displayed mean and
  uncertainty value; or
- provide explicit synthetic replicate values and derive the table from them.

For Prompt 3:

- regenerate every table value from the stated logistic equation; or
- disclose corrected parameters that reproduce every displayed value.

Include a compact calculation table showing unrounded output, rounded output,
and displayed value.

### 2. Standardize Uncertainty

- Use SEM in Prompts 1 and 2.
- Tell the participant to include symmetric error bars showing plus or minus
  one SEM.
- Remove one-sided bars, box-plot-style summaries, and categorical shaded bands
  from accepted variants.
- Repair Prompt 1 C3's SD/SEM wording and cross-reference.

### 3. Revise Prompt 3

Use this student-facing operation:

> Plot the data and draw a smooth curve that summarizes the relationship
> between time and population density. Estimate the population density around
> which the culture levels off under these conditions. Indicate the estimate
> on the graph and report its value.

- Use a linear y-axis for pilot P0.
- Scale the table to a readable unit such as `10^5 cells per mL`.
- Do not accept a logarithmic axis in P0.
- Keep the conceptual mapping to carrying capacity in the reviewer package,
  not the student prompt.

### 4. Correct Criteria

- Remove unsupported inference about whether the participant read from the
  table or graph.
- Do not reject a plateau estimate solely because it equals the highest
  displayed value.
- Judge consistency among curve, plateau annotation, numeric estimate, and
  unit.
- Mark all plotting tolerances as proposed development tolerances.
- Remove the automatic `<25% plot area` failure threshold.
- Record plot-area usage as an observation.

### 5. Correct Rights Language

- Remove any claim that the Product Owner approved a moderate-originality
  threshold.
- State `novelty and similarity status: unverified`.
- State that Claude's no-known-reference declaration is process evidence, not
  originality clearance.
- Preserve private capture-research isolation.
- State that qualified human source-isolation and similarity review are needed
  before reuse, and Paid Tutor Author authorship or adoption is needed before
  governance-pipeline entry.

## Required Output

Return:

1. Three revised student-facing sheets.
2. Three revised reviewer-only packages.
3. Reproducibility calculations for every synthetic dataset.
4. A redline summary from v0.1 to v0.2.
5. An updated Orly administration checklist.
6. A short preflight table mapping every item in
   `DRAWN_RESPONSE_PILOT_V0_REVIEW.md` to `resolved`, `partially resolved`, or
   `unresolved`.

Do not tell Orly to begin. The revised package returns to Codex for preflight,
then to Learning Quality and the Product Owner for the proceed decision.
