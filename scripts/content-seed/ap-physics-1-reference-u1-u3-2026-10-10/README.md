# ap-physics-1-reference-u1-u3-2026-10-10

**Scope:** ap_physics_1 units 1, 2, 3. **Environment:** Development only (`wmgjsdkphcyhngaffbqf`). Production is a Hard Gate and was not touched.

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
| 1 | 28-41 | 31 | 30 | 0 of 1 | **30** | 3 | 1 | 6/6 |
| 2 | 42-65 | 44 | 32 | 6 of 12 | **38** | 0 | 6 | 6/6 |
| 3 | 66-81 | 25 | 18 | 5 of 7 | **23** | 0 | 2 | 6/6 |

Controls include one hook control, which counts as caught only when its planted hook is rejected while its correct entry is accepted.

## Escalated to the Product Owner (not loaded)

- **`ap_physics_1-u1-r2-001`** — 1.3 formula, “Kinematic equation: velocity vs. time (constant acceleration)”. Rejected twice by gpt-6-sol. The formula and constant-acceleration caution agree with 1.3.A.2, which lists “v_x = v_x0 + a_x t” among the equations for constant acceleration. Topic 1.5.B.1 supports applying one-dimensional relationships to components of two-dimensional motion. However, the CED first gives this exact component equation in 1.1.A.3.i
- **`ap_physics_1-u2-r2-003`** — 2.3 convention, “Action at a distance is gravitational only”. Rejected twice by gpt-6-sol. The body accurately paraphrases the Topic 2.3 boundary statement: “The interaction between objects or systems at a distance is limited to gravitational forces in AP Physics 1.” Topic 2.3 is therefore the correct code. However, the cited text is a boundary statement, not a learning objective or essential-knowledge state
- **`ap_physics_1-u2-r2-006`** — 2.5 convention, “Direction of acceleration and when velocity changes”. Rejected twice by own-family veto. The first clause is correct. CED 2.5.A.2: the acceleration of a system's center of mass 'is in the same direction as that net force.' The second clause misstates the CED. CED 2.5.A.3 says 'The velocity of a system's center of mass will only change if a nonzero net external force is exerted on that system.' The entry dr
- **`ap_physics_1-u2-r2-001`** — 2.2 diagram, “Free-body diagram (FBD)”. Rejected twice by own-family veto. a_factual: The body matches CED 2.2.B.2 ('The free-body diagram of an object or system shows each of the forces exerted on the object by the environment') and 2.2.B.3 (forces are vectors originating from a dot at the center of mass). The items match the Boundary Statement under 2.2.B: individual forces are 'individual 
- **`ap_physics_1-u2-r2-007`** — 2.5 formula, “Newton's second law”. Rejected twice by own-family veto. a_factual: The symbols and form match the CED's 2.5.A.2 statement that the acceleration of a system's center of mass is proportional to the magnitude of the net force on the system and in the same direction. The CED's 'Relevant equation' image is not in the extracted text, so the exact typeset form cannot be confirmed 
- **`ap_physics_1-u2-r2-008`** — 2.6 formula, “Weight”. Rejected twice by gpt-6-sol. Topic 2.6.A.3 explicitly gives the derived equation “Weight = Fg = mg,” so the formula is correct, required, and correctly assigned to 2.6. The caution makes unsupported grading claims: the CED gives Fg and mg but does not state that F_G or W are accepted free-body-diagram labels, or specify which labels are not accept
- **`ap_physics_1-u2-r2-011`** — 2.7 vocabulary, “Normal force”. Rejected twice by gpt-6-sol. The body matches 2.7.A.2.ii: normal force is the perpendicular component of the surface’s force, directed away from the surface. But 2.6.C.1 already requires the concept: apparent weight is 'the magnitude of the normal force exerted on the system,' so 2.7 is not the first topic that requires it. Topic 2.9 also uses nor
- **`ap_physics_1-u3-r2-002`** — 3.2 formula, “Work-energy theorem”. Rejected twice by gpt-6-sol. Topic 3.2 requires the work-energy theorem: 3.2.A.4 says the change in an object’s kinetic energy equals “the sum of the work (net work) being done by all forces exerted on the object.” But the unqualified formula ΣF∥,i d treats every force’s work as its parallel component times one shared displacement. The CED specifi
- **`ap_physics_1-u3-r2-004`** — 3.3 vocabulary, “Potential energy of a system”. Rejected twice by own-family veto. a_factual: The scalar-quantity statement matches 3.3.A.2 ('Potential energy is a scalar quantity associated with the position of objects within a system'). The system condition matches 3.3.A.1 ('has potential energy if the objects within that system only interact with each other through conservative forces'). The body'

## Product-Owner-directed correction pass (David, 2026-10-10)

David directed the session to correct the escalated rows rather than regenerate them. The protocol bars
hand-editing a generated row, so this is a recorded deviation under the Product Owner's authority over
escalations. Each correction restores the CED wording the checker identified as missing, and every corrected
row was re-checked by both independent checkers and the reject-only veto before loading.

### Corrected, re-checked, accepted and loaded

- `ap_physics_1-u2-r3-001` (2.5, ) — “Direction of acceleration and when velocity changes”. 
- `ap_physics_1-u2-r3-002` (2.2, body) — “Free-body diagram (FBD)”. Restored 'of the system's center of mass' in the second clause; without it the claim is false for a system whose parts move.
- `ap_physics_1-u2-r3-003` (2.5, body, caution) — “Newton's second law”. Replaced a_sys with a_cm and SigmaF with SigmaF_ext to match 2.5.A.2/2.5.A.3, dropped the redundant second equality, and added the center-of-mass caution the veto asked for twice.
- `ap_physics_1-u2-r3-004` (2.6, caution) — “Weight”. Deleted the unsupported label-acceptance caution; 2.6.A.3 gives 'Weight = F_g = mg' and the body matches it, so no caution is needed.
- `ap_physics_1-u3-r3-002` (3.3, body) — “Potential energy of a system”. Restored 3.3.A.1's 'if ... only interact through conservative forces'; the entry had turned it into 'only if ... interact', a different and stronger claim.
- `ap_physics_1-u3-r3-001` (3.2, body, caution) — “Work-energy theorem”. Dropped 'Sigma F_parallel d', which gave every force the same displacement; 3.2.A.3 ties work to the displacement of each force's point of application.

### Rejected as inadmissible (no LO/EK basis; not correctable)

- `ap_physics_1-u2-r2-003` — 'Action at a distance is gravitational only' exists solely in the Topic 2.3 boundary statement.

### Still open for the Product Owner

- `ap_physics_1-u1-r3-001` — “Kinematic equation: velocity vs. time (constant acceleration)”. Ownership contested; see section 11 of the session record.
- `ap_physics_1-u2-r3-005` — “Normal force”. Ownership contested; see section 11 of the session record.
## Cost

485 gateway calls, $4.34 at gateway list prices (from `out/logs_*`, which are not committed).

