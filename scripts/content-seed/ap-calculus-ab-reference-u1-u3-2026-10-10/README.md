# ap-calculus-ab-reference-u1-u3-2026-10-10

**Scope:** ap_calculus_ab units 1, 2, 3. **Environment:** Development only (`wmgjsdkphcyhngaffbqf`). Production is a Hard Gate and was not touched.

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
| 1 | 32-53 | 24 | 18 | 6 of 6 | **24** | 0 | 0 | 6/6 |
| 2 | 54-69 | 19 | 12 | 4 of 7 | **16** | 0 | 3 | 6/6 |
| 3 | 70-81 | 10 | 9 | 0 of 1 | **9** | 1 | 1 | 6/6 |

Controls include one hook control, which counts as caught only when its planted hook is rejected while its correct entry is accepted.

## Escalated to the Product Owner (not loaded)

- **`ap_calculus_ab-u2-r2-002`** — 2.3 convention, “Calculator answers: rounding”. Rejected twice by gpt-6-sol. Topic 2.3 is the unit's explicit technology topic: CHA-2.D.2 says technology can be used to calculate or estimate a derivative at a point. But no learning objective or essential-knowledge statement requires a three-decimal calculator-answer convention. The Preparing for the AP Exam guidance says to use “specified round
- **`ap_calculus_ab-u2-r2-003`** — 2.2 convention, “Keep notation precise: parentheses and defined names”. Rejected twice by gpt-6-sol. Topic 2.2 lists dy/dx, f′(x), and y′ as derivative notation (CHA-2.B.3), and the Unit 2 introduction warns that students may 'drop important notation, such as a parenthesis.' The CED does not state the additional rule 'do not rename a derivative to a new symbol without defining it' or require students to apply it. The 
- **`ap_calculus_ab-u2-r2-006`** — 2.8 formula, “Product rule”. Rejected twice by own-family veto. a_factual: The formula d/dx[u(x)v(x)] = u(x)v'(x) + v(x)u'(x) matches FUN-3.B.1 ('Derivatives of products of differentiable functions can be found using the product rule') and the CED example 'f′(3) = u(3)v′(3) + v(3)u′(3)' in the Unit 2 Preparing for the AP Exam text. b_topic_codes: owner_topic_code 2.8 is correct, si
- **`ap_calculus_ab-u3-r2-001`** — 3.2 formula, “Chain rule applied to y in implicit differentiation”. Rejected twice by gpt-6-sol. The formula correctly applies the chain rule to g(y), and Topic 3.2 states, “The chain rule is the basis for implicit differentiation.” The caution overstates the rule: not every term produced by differentiating an expression containing y has a dy/dx factor. For example, d(xy)/dx = y + x(dy/dx). The caution should dist

## Product-Owner-directed correction pass (David, 2026-10-10)

David directed the session to correct the escalated rows rather than regenerate them. The protocol bars
hand-editing a generated row, so this is a recorded deviation under the Product Owner's authority over
escalations. Each correction restores the CED wording the checker identified as missing, and every corrected
row was re-checked by both independent checkers and the reject-only veto before loading.

### Corrected, re-checked, accepted and loaded

- `ap_calculus_ab-u2-r3-001` (2.8, topic_codes) — “Product rule”. Dropped 2.10: FUN-3.B.3 covers rewriting tangent, cotangent, secant and cosecant with identities and does not use the product rule.
- `ap_calculus_ab-u3-r3-001` (3.2, caution) — “Chain rule applied to y in implicit differentiation”. Corrected the caution's over-general claim that every term containing y needs a dy/dx factor, using the d(xy)/dx counterexample the checker raised.

### Rejected as inadmissible (no LO/EK basis; not correctable)

- `ap_calculus_ab-u2-r2-002` — Three-decimal rounding comes from 'Preparing for the AP Exam', not an LO/EK; the entry also drops 'specified'/'typically'.
- `ap_calculus_ab-u2-r2-003` — Derivative-notation rules trace to Skill 4.C plus an invented rule ('do not rename a derivative') the CED never states.
## Cost

307 gateway calls, $2.42 at gateway list prices (from `out/logs_*`, which are not committed).

