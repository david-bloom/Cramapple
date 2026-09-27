# Unit tag distractor repair proposal — 2026-09-24

Work order: `/Users/davidbloom/Documents/Cramapple.nosync/prompts/CODEX_WORK_ORDER_UNIT_TAG_DISTRACTOR_REPAIR_2026_09_24.md`

Branch: `codex/unit-tag-distractor-repair-2026-09-24`

Scope: proposal only. No Production writes were made.

## Inputs read

- `docs/activity_log/DECISIONS_LOG.md`, DECISION-0066 "Correction, same day" section.
- Production project `pcntajvbdfqhbeewmdry`, read-only SQL only.
- Current/local corroboration for AP Chem FRQ repair:
  - `content/item-packages/ap-chemistry/apchem-frq-l-004.json`
  - `scripts/content-seed/reviewer-qa-remediation/20260805_apchem_frq_awe_repair.sql`

## Production facts verified

| content_key | current latest status inspected | version | current disputed serving label | proposal |
|---|---:|---:|---|---|
| `APBIO-MCQ-012` | `retired` | 1 | `{1,3}` provisional | tag-only correction to `[1]`; no content edit |
| `apchem-mcq-048` | `published` | 1 | `{5,6,7}` provisional | tag-only correction to `[5]`; no content edit |
| `APBIO-MCQ-041` | `retired` | 1 | `{4,6}` provisional | content proposal to make distractors Unit-4-only, then label `[4]` |
| `apchem-frq-l-004` | `published` | 3 | `{1,3,4}` provisional | tag-only correction to `[1,4]`; no content edit |

Important discrepancy: the work order says to verify APBIO-MCQ-012 and APBIO-MCQ-041 "against the current published item." Production currently has no published version for either Biology key; both latest rows are `retired`. I still inspected their version-1 stems/choices and serving labels because DECISION-0066 references those exact content keys.

## Per-item decisions

### `APBIO-MCQ-012`

I agree with DECISION-0066's over-tag finding.

Current stem: why identical glucose monomers produce polysaccharides with different structures, functions, and enzyme specificities. Current choices include the keyed glycosidic-linkage answer:

> The type of glycosidic linkage (α vs. β) between glucose monomers determines the polymer's three-dimensional shape and which enzyme active sites can accommodate it

That is Unit 1 macromolecule structure/enzyme-specificity reasoning. Unit 3 Cellular Energetics is not load-bearing. Proposal: required_units `[1]`, max_required_unit `1`, no content edit.

### `apchem-mcq-048`

I agree with DECISION-0066's over-tag finding.

The correct answer is Unit 5 kinetics:

> It provides an alternative reaction pathway with a lower activation energy, increasing the fraction of collisions with sufficient energy to react.

Distractors mention equilibrium and deltaH, but rejecting them is not the work that makes the correct answer selectable. A Unit 5 student can select B on the catalyst definition and activation-energy mechanism alone. Proposal: required_units `[5]`, max_required_unit `5`, no content edit.

### `APBIO-MCQ-041`

I chose the Unit 4-only direction.

Reason: the Production prompt_json already places the item in Unit 4 / `4.3 Disruptions to the Cell Cycle`, and the item’s intended construct is the cell-cycle cancer model: proto-oncogene activation acts like a stuck accelerator, while tumor-suppressor inactivation removes a brake. Keeping Unit 6 would require the item to test gene-expression/regulation mechanics beyond the apparent Unit 4 construct. The cleaner repair is to preserve the correct answer and make the distractors rejectable through Unit 4 cell-cycle-control reasoning only.

Proposed content edit: preserve correct choice B exactly. Replace distractors A/C/D:

- A: `Gene A is a tumor suppressor whose increased copy number removes a cell-cycle brake; Gene B is a proto-oncogene that stops cell division when both alleles are disrupted.`
- C: `Both genes are tumor suppressors: Gene A drives cancer because extra copies dilute checkpoint proteins, and Gene B drives cancer because one normal copy is always enough to stop division.`
- D: `Gene B requires only one altered allele to cause cancer because tumor suppressor genes normally act as accelerators of the cell cycle rather than brakes.`

These remain temptable cell-cycle misconceptions:

- A swaps accelerator/brake categories.
- C overgeneralizes tumor suppressors and invents a copy-number dilution misconception.
- D reverses the brake/accelerator model and incorrectly makes one altered tumor-suppressor allele sufficient.

Resulting proposal: required_units `[4]`, max_required_unit `4`, content edit and label correction should be QAed/applied atomically. Note again: the inspected Production version is retired, not published.

### `apchem-frq-l-004`

I chose the no-content-edit path: Unit 3 was not intended and should be removed.

The current published v3 stem/criteria require:

- part a: mole calculation and net ionic equation,
- part b: 1:1 mole ratio and completion assumption,
- part c: gravimetric collection/washing/drying-to-constant-mass/weighing/conversion to moles,
- part d: direction of systematic error through measured AgCl mass.

Those are Unit 1 mole/measurement foundations plus Unit 4 reactions/stoichiometry/precipitation. The item does not require Unit 3 properties of substances/mixtures, solution IMFs, or an authentic solution-concentration step. Adding a Unit 3 criterion would change the construct of an otherwise coherent gravimetric stoichiometry item.

Proposal: required_units `[1,4]`, max_required_unit `4`, no content edit.

## Artifacts

- `packet.jsonl` — evidence packet from Production reads and DECISION-0066 context.
- `proposal.jsonl` — applyable proposal rows: tag-only corrections plus the APBIO-MCQ-041 distractor text.
- `SUMMARY.md` — this summary.

## Validation

- JSONL parses successfully.
- Proposal contains exactly 4 rows.
- No SQL write statements were authored or run.
