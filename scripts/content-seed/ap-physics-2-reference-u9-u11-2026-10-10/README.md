# ap-physics-2-reference-u9-u11-2026-10-10

**Scope:** ap_physics_2 units 9, 10, 11. **Environment:** Development only (`wmgjsdkphcyhngaffbqf`). Production is a Hard Gate and was not touched.

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
| 9 | 28-43 | 27 | 24 | 3 of 3 | **27** | 0 | 0 | 6/6 |
| 10 | 44-61 | 37 | 28 | 6 of 9 | **34** | 0 | 3 | 6/6 |
| 11 | 62-81 | 38 | 35 | 0 of 3 | **35** | 0 | 3 | 6/6 |

Controls include one hook control, which counts as caught only when its planted hook is rejected while its correct entry is accepted.

## Escalated to the Product Owner (not loaded)

- **`ap_physics_2-u10-r2-001`** — 10.1 list_sequence, “Charges of the basic particles”. Rejected twice by gpt-6-sol. The particle charges match 10.1.A.1.iii: “The charge of an electron is −e, the charge of a proton is +e, and a neutron has no electric charge.” Topic 10.1 also requires the elementary-charge concept. However, 10.1.A.1.ii says e “can be considered to be the smallest indivisible amount of charge”; the body states this wi
- **`ap_physics_2-u10-r2-006`** — 10.6 convention, “Uniform field and motion between plates”. Rejected twice by gpt-6-sol. Topic 10.6 requires both the uniform-field and constant-acceleration ideas. However, 10.6.A.3 specifies that the plates have “uniformly distributed electric charge” for the field to be constant except near the edges. The entry omits that condition and states the field is constant between oppositely charged parallel pla
- **`ap_physics_2-u10-r2-009`** — 10.7 formula, “Change in electric potential energy of a charge”. Rejected twice by gpt-6-sol. The formula is correct and is required by 10.7.A.1. However, 10.5.A.3 first requires the same relationship: “The electric potential difference between two points is the change in electric potential energy per unit charge.” The owner should therefore be 10.5, with both 10.5 and 10.7 listed as topic codes. No caution is 
- **`ap_physics_2-u11-r2-002`** — 11.5 vocabulary, “Parallel connection”. Rejected twice by own-family veto. a_factual: The body matches CED 11.5.A.1.ii, "A parallel connection is one in which charges may flow through one of two or more paths. Across each path, the potential difference is the same." The paraphrase is faithful. b_topic_codes: owner_topic_code 11.5 is correct, since 11.5.A.1.ii is the first place the CED define
- **`ap_physics_2-u11-r2-001`** — 11.5 vocabulary, “Series connection”. Rejected twice by own-family veto. a_factual: The body matches 11.5.A.1.i: "A series connection is one in which any charge passing through one circuit element must proceed through all elements in that connection and has no other path available. The current in each element in series must be the same." The entry's 'so the current in each element is the sa
- **`ap_physics_2-u11-r2-003`** — 11.8 formula, “RC time constant”. Rejected twice by gpt-6-sol. Topic 11.8 requires the RC time constant: 11.8.B.1.i says it measures how quickly a capacitor charges or discharges and gives its definition. But the entry presents τ = R_eq C_eq without restricting it to a circuit reducible to one equivalent resistance and capacitance; the CED does not state that as a general rule for

## Product-Owner-directed correction pass (David, 2026-10-10)

David directed the session to correct the escalated rows rather than regenerate them. The protocol bars
hand-editing a generated row, so this is a recorded deviation under the Product Owner's authority over
escalations. Each correction restores the CED wording the checker identified as missing, and every corrected
row was re-checked by both independent checkers and the reject-only veto before loading.

### Corrected, re-checked, accepted and loaded

- `ap_physics_2-u10-r3-001` (10.1, body) — “Charges of the basic particles”. Restored 10.1.A.1.ii's qualifier 'can be considered to be'.
- `ap_physics_2-u10-r3-002` (10.6, body) — “Uniform field and motion between plates”. Added 10.6.A.3's 'uniformly distributed electric charge' condition and 10.6.A.3.ii's 'near Earth's surface'.
- `ap_physics_2-u11-r3-001` (11.5, topic_codes) — “Series connection”. Dropped 11.7: its LO/EK cover only Kirchhoff's junction rule and do not use the series definition.
- `ap_physics_2-u11-r3-002` (11.5, topic_codes) — “Parallel connection”. Dropped 11.7 for the same reason as the series entry.
- `ap_physics_2-u11-r3-003` (11.8, body, caution) — “RC time constant”. Restricted tau to a circuit reducible to one equivalent R and C, and replaced 'Only qualitative use is required' with the boundary statement's actual terms, which permit mathematical treatment of initial and final states.

### Still open for the Product Owner

- `ap_physics_2-u10-r5-003` — “Change in the electric potential energy of the object-field system”. Ownership contested; see section 11 of the session record.
## Cost

465 gateway calls, $4.09 at gateway list prices (from `out/logs_*`, which are not committed).

