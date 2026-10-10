# AP Chemistry Unit 1 — Reference Pack batch (`task0067-chem-u1-2026-10-09`)

**Scope:** AP Chemistry Unit 1 (topics 1.1–1.8), following the Reference Pack build protocol in
`docs/product/AP_CHEMISTRY_CED_SCOPE_INVENTORY_2026_10_09.md`. **Environment:** Development, then **Production on 2026-10-10 (APPROVAL-0147)**: the same SQL file, the same
QA checks and the same probe counts. The two escalations below are not loaded in either environment.

## Roster (smoke-tested 3/3 each, 2026-10-09)

| Role | Model |
|---|---|
| Extractor | `anthropic/claude-sonnet-5.5` |
| Checker 1 | `google/gemini-3.5-flash` |
| Checker 2 | `openai/gpt-6-sol` |
| Reject-only own-family veto | `anthropic/claude-haiku-5.5` (first batch with it; DECISION-0107) |

Gemini first failed the smoke LaTeX item 0/3. Its ~385 reasoning tokens used up the smoke harness's
400-token cap, so the model wasn't at fault. With the cap at 2000 it passed 3/3. Checker `max_tokens` was raised
from 3000 to 8000 for the same reason.

## Changes from the pilot scripts

- `check.py`: a hook control (`control_target: "hook"`) is caught when its hook is rejected. Entry and
  hook verdicts are independent, so a correct entry carrying a bad hook is expected to be accepted.
- `extract.py`: the round-2 lesson goes into round 1. Tag a later topic only when its own LO/EK uses the
  entry, respect every Exclusion Statement, and cite EK/LO codes.
- `smoke.py`: Haiku replaces Opus. The cap was raised (above).

## Inputs

CED pp. 29–45 (`pdftotext -layout`, `CED_TXT_DIR`), fact-pack lines 349–410 (`out/factpack_ap_chemistry_u1.md`),
six controls (`controls_ap_chemistry_u1.json`), each verified against the CED text before the run.

## Results

| Stage | Count |
|---|---:|
| Extracted (round 1) | 26 entries, 1 hook |
| Round 1 accepted | 22 |
| Round 2 (stateless re-extraction of the 4 rejected) | 2 accepted |
| **Loaded to Development** | **24 entries, 1 hook** (diagonal-rule hook on the Aufbau order) |
| Escalated to the Product Owner | 2 |
| Controls | 6/6 caught |

Kinds loaded: vocabulary 11, convention 5, formula 4, list_sequence 2, diagram 2.

**Development QA:** all 8 checks in `scripts/qa/unit_reference_and_memory_hooks_qa.sql` returned ok. RPC probes
(authenticated) gave these counts:

| Probe | Reference entries | Hooks |
|---|---:|---:|
| 1.5 | 8 | 1 |
| 1.7 | 6 | 0 |
| Unit 1 roll-up | 24 | 1 |
| 2.1 (empty) | 0 | 0, briefs unchanged |
| 4.9 (regression) | 4 | 1, unchanged from the pilot |

## Escalations (not loaded): Product Owner call needed

1. **`ap_chemistry-u1-r2-003` "Bond likelihood from valence electrons and nuclei" (1.8).** Rejected by
   GPT-6 Sol in both rounds. CED 1.8.A.1 says *"The likelihood that two elements will form a chemical bond is
   determined by …"*, but both extractions wrote "Whether two elements will form …", which turns a likelihood
   into a categorical claim, with no caution. **Recommendation: reject.** The checker is right on the
   evidence, and the protocol bars hand edits.
2. **`ap_chemistry-u1-r2-004` "Tools for explaining periodic trends" (1.7).** Both checkers accepted it. The
   Haiku veto rejected it in both rounds on ownership: the four tools are each first introduced in 1.5. The
   list as a set, used to explain trends, is what 1.7.A.2 requires, and the individual tools already exist
   as 1.5-owned entries reused in 1.7. **Recommendation: accept with 1.7 as owner** (same pattern as
   DECISION-0107's 1.13 call). Load with `load.py --po-accept`.

## Completeness disposition (inventory row → outcome)

All Unit 1 inventory phrases are dispositioned:

- **Accepted:** mole and molar mass (n = m/M), Avogadro's number, amu ↔ g/mol, mass spectrum (with isotope
  and relative abundance as its items/body), average atomic mass, formula unit, law of definite
  proportions, empirical formula, pure substance, mixture, elemental analysis and purity, Coulomb's law,
  atom composition (proton, neutron, electron, nucleus), shells and subshells, core and valence electrons,
  Aufbau order, ionization energy, effective nuclear charge and shielding, PES, periodic properties (radii,
  IE, electron affinity, electronegativity), periodic-table organization, analogous compounds, typical
  ionic charge.
- **Excluded, not in the CED Unit 1 required content (EK/LO text):** percent composition (named only in an
  instructional activity), molecular formula, orbital, isoelectronic species, cation/anion as separate terms,
  binding energy as a term (PES uses removal energy, covered by the PES entry).
- **Excluded by CED Exclusion Statement:** quantum-number assignment (1.5), Aufbau-exception
  configurations (1.5/1.7), multi-element mass spectra (1.2).

## Cost

$1.01 recorded at gateway prices: Sonnet $0.17, Gemini $0.76, Haiku $0.09. GPT-6 Sol's 52 calls came back
from the gateway with cost $0, so the real total is higher, probably about $1.50–2.50. Even so, that is far
below the pilot's $20.29.

Raw JSONL model logs (`out/logs_*`) are kept locally and not committed.
