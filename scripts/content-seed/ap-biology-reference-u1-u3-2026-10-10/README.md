# ap-biology-reference-u1-u3-2026-10-10

**Scope:** ap_biology units 1, 2, 3. **Environment:** Development only (`wmgjsdkphcyhngaffbqf`). Production is a Hard Gate and was not touched.

**Protocol:** `docs/product/MEMORY_HOOKS_AND_UNIT_REFERENCE_PRODUCTION_PROTOCOL.md`. **Session record:** `docs/handoffs/REFERENCE_PACKS_UNITS_1_3_ALL_SUBJECTS_2026_10_10.md`.

## Roster (proposed for Product Owner ratification; smoke 3/3 each, 2026-10-10)

| Role | Model |
|---|---|
| Extractor | `anthropic/claude-sonnet-5.5` |
| Checker 1 | `google/gemini-3.5-flash` |
| Checker 2 | `openai/gpt-6-sol` |
| Own-family veto (reject-only) | `anthropic/claude-haiku-5.5` |

Unchanged from the AP Chemistry Unit 1 batch (`DECISION-0107`). Neither checker shares the extractor's family. The live gateway roster was re-read before the run; newer models exist (`google/gemini-3.8-flash`, `openai/gpt-6.1-sol`) but the ratified slate was kept.

## Inputs

CED PDF via `pdftotext -layout` (`CED_TXT_DIR`), page ranges below, plus the unit's fact-pack section (`out/factpack_*.md`). Page ranges were taken from each CED's unit divider pages. Six controls per unit, each verified against the CED text before the run.

## Results (Development)

| Unit | CED pp. | Extracted | Round 1 accepted | Round 2 | Loaded | Hooks | Escalated | Controls |
|---:|---|---:|---:|---|---:|---:|---:|---|
| 1 | 34-49 | 23 | 20 | 1 of 3 | **21** | 0 | 2 | 6/6 |
| 2 | 50-69 | 44 | 36 | 8 of 8 | **44** | 0 | 0 | 6/6 |
| 3 | 70-85 | 30 | 25 | 4 of 5 | **29** | 0 | 1 | 6/6 |

Controls include one hook control, which counts as caught only when its planted hook is rejected while its correct entry is accepted.

## Escalated to the Product Owner (not loaded)

- **`ap_biology-u1-r2-002`** — 1.4 list_sequence, “Illustrative polysaccharides”. Rejected twice by gpt-6-sol. Topic 1.4 lists cellulose, starch, and glycogen as illustrative examples and states that monosaccharides are the monomers for polysaccharides, connected by covalent bonds. Its exclusion statement also says, “The molecular structure of specific carbohydrate polymers is beyond the scope of the AP Exam.” However, EK 1.4.A
- **`ap_biology-u1-r2-001`** — 1.1 vocabulary, “Hydrogen bonding”. Rejected twice by gpt-6-sol. The entry incorrectly defines hydrogen bonding generally as arising from the polarity of water’s H–O bonds. The CED says that water’s polarity “contributes to hydrogen bonding between and within biological molecules” (1.1.A.1), not that all hydrogen bonding arises from water’s bonds. The CED also identifies hydrogen bo
- **`ap_biology-u3-r2-005`** — 3.5 list_sequence, “Required components of a constructed graph”. Rejected twice by gpt-6-sol. The five items match the ordered components in Skill 4.A, which the CED assigns to Topic 3.5: graph type; axis labeling, units, and legend; scaling; accurately plotted data, including error bars when appropriate; and a trend line when appropriate. No caution is needed. However, these are requirements of a suggested ski

## Product-Owner-directed correction pass (David, 2026-10-10)

David directed the session to correct the escalated rows rather than regenerate them. The protocol bars
hand-editing a generated row, so this is a recorded deviation under the Product Owner's authority over
escalations. Each correction restores the CED wording the checker identified as missing, and every corrected
row was re-checked by both independent checkers and the reject-only veto before loading.

### Corrected, re-checked, accepted and loaded

- `ap_biology-u1-r3-001` (1.1, body) — “Hydrogen bonding”. Restored 1.1.A.1's 'contributes to'; the entry had all hydrogen bonding in biological molecules arising from water's bonds.

### Rejected as inadmissible (no LO/EK basis; not correctable)

- `ap_biology-u1-r2-002` — Cellulose/Starch/Glycogen appear only under ILLUSTRATIVE EXAMPLES; EK 1.4.A.1 does not require reproducing the list.
- `ap_biology-u3-r2-005` — The graph components are Skill 4.A, not a Topic 3.5 LO/EK.
## Cost

440 gateway calls, $3.67 at gateway list prices (from `out/logs_*`, which are not committed).

