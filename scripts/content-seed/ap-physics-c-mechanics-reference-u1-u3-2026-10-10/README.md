# ap-physics-c-mechanics-reference-u1-u3-2026-10-10

**Scope:** ap_physics_c_mechanics units 1, 2, 3. **Environment:** Development only (`wmgjsdkphcyhngaffbqf`). Production is a Hard Gate and was not touched.

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
| 1 | 28-41 | 32 | 29 | 2 of 3 | **31** | 0 | 1 | 6/6 |
| 2 | 42-67 | 47 | 42 | 5 of 5 | **47** | 0 | 0 | 6/6 |
| 3 | 68-83 | 34 | 21 | 10 of 13 | **31** | 0 | 3 | 6/6 |

Controls include one hook control, which counts as caught only when its planted hook is rejected while its correct entry is accepted.

## Escalated to the Product Owner (not loaded)

- **`ap_physics_c_mechanics-u1-r2-001`** — 1.2 formula, “Average velocity”. Rejected twice by gpt-6-sol. Topic 1.2 requires average velocity: 1.2.B.2 says it is “the displacement of an object divided by the interval of time.” But the formula does not follow the CED’s symbols. The CED identifies the position vector as r in 1.1.A.4.ii and distinguishes vector velocity dr/dt from x-component velocity dx/dt in 1.2.C.1.i. The 
- **`ap_physics_c_mechanics-u3-r2-003`** — 3.2 convention, “Only the parallel force component changes the system's energy”. Rejected twice by gpt-6-sol. The first clause matches 3.2.A.3.ii. The second conflates two different references for displacement: 3.2.A.3.iv specifies a force component perpendicular to “the displacement of the system’s center of mass,” not the displacement of the point of application. Topic 3.2 requires both statements, so the topic codes and CED
- **`ap_physics_c_mechanics-u3-r2-006`** — 3.2 formula, “Work–energy theorem”. Rejected twice by gpt-6-sol. Topic 3.2.A.4 requires the work–energy theorem: the change in kinetic energy equals the sum of the work done by all forces. But the entry’s further equality, ΣWᵢ = ΣF∥,ᵢdᵢ, is unqualified. The CED specifies in 3.2.A.3.iii that the parallel force component must be constant for work to equal that component times displace
- **`ap_physics_c_mechanics-u3-r2-008`** — 3.2 formula, “Energy dissipated by friction”. Rejected twice by own-family veto. a_factual: The body matches 3.2.A.4.iii, which says "The energy dissipated by friction is typically equated to the force of friction times the length of the path over which the force is exerted." The approximate sign, F_f, and path length s are stated correctly. b_topic_codes: owner 3.2 is correct, since the statement 

## Cost

527 gateway calls, $4.78 at gateway list prices (from `out/logs_*`, which are not committed).

