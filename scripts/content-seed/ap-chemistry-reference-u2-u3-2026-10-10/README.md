# ap-chemistry-reference-u2-u3-2026-10-10

**Scope:** ap_chemistry units 2, 3. **Environment:** Development only (`wmgjsdkphcyhngaffbqf`). Production is a Hard Gate and was not touched.

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
| 2 | 46-59 | 21 | 14 | 6 of 7 | **20** | 0 | 1 | 6/6 |
| 3 | 60-79 | 32 | 22 | 7 of 10 | **29** | 0 | 3 | 6/6 |

Controls include one hook control, which counts as caught only when its planted hook is rejected while its correct entry is accepted.

## Escalated to the Product Owner (not loaded)

- **`ap_chemistry-u2-r2-003`** — 2.6 convention, “Resonance for equivalent Lewis structures”. Rejected twice by gpt-6-sol. Topic 2.6.A.1 requires resonance when more than one equivalent Lewis structure can be constructed. But the body overstates its effect on predictions: the CED says, “In many such cases, this refinement is needed to provide qualitatively accurate predictions,” not that including resonance makes predictions qualitatively 
- **`ap_chemistry-u3-r2-006`** — 3.5 formula, “Kinetic energy of a particle”. Rejected twice by own-family veto. a_factual: The body KE = ½mv² matches the CED equation in 3.5.A.2 ("EQN: KE = ½ mv2"), and the symbols are correct. b_topic_codes: 3.5 is the only topic listed and is where the equation appears in Unit 3. c_ced_required: 3.5.A.2 requires students to apply this relationship. d_caution: The CED states the relation for th
- **`ap_chemistry-u3-r2-005`** — 3.1 vocabulary, “Noncovalent interactions in large biomolecules”. Rejected twice by gpt-6-sol. Topics 3.1.A.5 and 3.2.A.7 require noncovalent interactions in large biomolecules; 3.2.A.7 also addresses polymers, so the topic codes and owner are appropriate. However, the body changes the CED’s causal claim. The CED says functionality and properties “depend strongly on the shape of the molecule, which is largely di
- **`ap_chemistry-u3-r2-009`** — 3.9 vocabulary, “Chromatography”. Rejected twice by gpt-6-sol. Topic 3.9.A.1 requires chromatography, but the body omits part of its stated mechanism: interactions occur “between and among the components of the solution (the mobile phase) and with the surface components of the stationary phase.” The body describes only interactions between mobile- and stationary-phase components. 

## Product-Owner-directed correction pass (David, 2026-10-10)

David directed the session to correct the escalated rows rather than regenerate them. The protocol bars
hand-editing a generated row, so this is a recorded deviation under the Product Owner's authority over
escalations. Each correction restores the CED wording the checker identified as missing, and every corrected
row was re-checked by both independent checkers and the reject-only veto before loading.

### Corrected, re-checked, accepted and loaded

- `ap_chemistry-u2-r3-001` (2.6, body) — “Resonance for equivalent Lewis structures”. Restored 2.6.A.1's hedge 'In many such cases'; the entry had made the accuracy claim universal.
- `ap_chemistry-u3-r3-003` (3.9, body) — “Chromatography”. Restored 3.9.A.1's 'between and among the components of the solution (the mobile phase)', which the entry omitted.
- `ap_chemistry-u3-r3-001` (3.5, caution, title) — “Average kinetic energy of a particle”. 3.5.A.2 ties the equation to average kinetic energy and average velocity; title restored and the gap cautioned.
- `ap_chemistry-u3-r3-002` (3.1, body) — “Noncovalent interactions in large biomolecules”. Restored 3.2.A.7's causal chain through shape; the entry had the interactions dictating properties directly.
## Cost

294 gateway calls, $2.45 at gateway list prices (from `out/logs_*`, which are not committed).

