# ap-physics-c-em-reference-u8-u10-2026-10-10

**Scope:** ap_physics_c_em units 8, 9, 10. **Environment:** Development only (`wmgjsdkphcyhngaffbqf`). Production is a Hard Gate and was not touched.

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
| 8 | 28-43 | 34 | 26 | 6 of 8 | **32** | 0 | 2 | 6/6 |
| 9 | 44-53 | 16 | 13 | 2 of 3 | **15** | 0 | 1 | 6/6 |
| 10 | 54-65 | 21 | 18 | 1 of 3 | **19** | 0 | 2 | 6/6 |

Controls include one hook control, which counts as caught only when its planted hook is rejected while its correct entry is accepted.

## Escalated to the Product Owner (not loaded)

- **`ap_physics_c_em-u10-r2-001`** — 10.3 list_sequence, “Capacitor geometries requiring quantitative analysis”. Rejected twice by gpt-6-sol. The three geometries match the 10.3 Boundary Statement, which names “parallel-plate capacitors, concentric spherical capacitors, and coaxial cylindrical capacitors.” The warning not to apply the parallel-plate formula to the other geometries is correct. However, Topic 10.4 addresses dielectrics, not this list of geomet
- **`ap_physics_c_em-u10-r2-002`** — 10.3 formula, “Field between parallel plates”. Rejected twice by gpt-6-sol. Topic 10.3.A.3.i requires the field magnitude for closely spaced parallel plates using Gauss’s law and superposition, and 10.3.A.3.ii states that the field is proportional to the surface charge density on either plate. Topic 10.4.A.4 also uses this field as the baseline for a dielectric comparison. But the caution’s co
- **`ap_physics_c_em-u8-r2-001`** — 8.1 vocabulary, “Elementary charge and charges of particles”. Rejected twice by gpt-6-sol. Topic 8.1 requires the particle charges stated here: 8.1.A.1.iii says an electron has charge −e, a proton +e, and a neutron no electric charge. But 8.1.A.1.ii says the elementary charge e “can be considered to be the smallest indivisible amount of charge.” The body changes that qualified statement to an unqualified “is
- **`ap_physics_c_em-u8-r2-003`** — 8.1 convention, “Limit on discrete-charge force calculations”. Rejected twice by gpt-6-sol. The Topic 8.1 boundary says the course “only expects students to make calculations of the electric force between four or fewer interacting charged objects or systems” and allows analysis of more charges “in situations of high symmetry.” The entry accurately summarizes that scope limit and assigns it to 8.1. But the lim
- **`ap_physics_c_em-u9-r2-002`** — 9.3 formula, “Change in potential energy of a charge moving through a potential difference”. Rejected twice by own-family veto. a_factual: ΔU_E = qΔV is the standard relation, and the CED 9.3.A.1 equation (not legible in the extracted text) is this relation. Symbols and sign convention are correct. b_topic_codes: 9.3 is the topic whose essential knowledge states the equation (9.3.A.1). Topic 9.2 introduces ΔV, but the ΔU = qΔV relation is first

## Cost

362 gateway calls, $2.70 at gateway list prices (from `out/logs_*`, which are not committed).

