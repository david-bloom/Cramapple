# ap-precalculus-reference-u1-u3-2026-10-10

**Scope:** ap_precalculus units 1, 2, 3. **Environment:** Development only (`wmgjsdkphcyhngaffbqf`). Production is a Hard Gate and was not touched.

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
| 1 | 32-57 | 49 | 32 | 9 of 17 | **41** | 0 | 8 | 6/6 |
| 2 | 58-81 | 53 | 39 | 14 of 14 | **53** | 0 | 0 | 6/6 |
| 3 | 82-111 | 43 | 37 | 2 of 6 | **39** | 2 | 4 | 6/6 |

Controls include one hook control, which counts as caught only when its planted hook is rejected while its correct entry is accepted.

## Escalated to the Product Owner (not loaded)

- **`ap_precalculus-u1-r2-003`** — 1.3 convention, “Concavity from changing average rates of change”. Rejected twice by gpt-6-sol. Topic 1.3.B.3 requires the average rates of change to be increasing or decreasing “for all small-length intervals” before concluding concavity. The body omits that essential condition, so its unqualified claim is not what the CED states. Topic 1.3 first requires this equal-length-interval criterion; Topic 1.4.A.5 also 
- **`ap_precalculus-u1-r2-001`** — 1.1 vocabulary, “Image and preimage”. Rejected twice by gpt-6-sol. The body matches 1.1.A.2: “The image of an input value is the single output value yielded by the function rule. The preimage of an output value is the set of input values for which the function rule yields that output value.” Topic 1.1 is the correct owner. But 1.12.A.5 uses the terms for transformations of sets of poi
- **`ap_precalculus-u1-r2-005`** — 1.4 formula, “Polynomial function in standard form”. Rejected twice by gpt-6-sol. The formula omits a defining restriction in 1.4.A.1: “a_i is a real number for each i from 0 to n.” Topic 1.4 first requires this form; the other listed topics use polynomial degree, leading terms, or standard form. No caution is needed, but the omitted restriction must be added to the formula.
- **`ap_precalculus-u1-r2-011`** — 1.11 convention, “Factored form vs. standard form”. Rejected twice by gpt-6-sol. Topic 1.11 is the correct placement, and EK 1.11.A.1–2 requires this distinction. But the body overstates what factored form readily provides. The CED says it "readily provides information about real zeros" and therefore "can reveal information about x-intercepts, asymptotes, holes, domain, and range." It does not say 
- **`ap_precalculus-u1-r2-010`** — 1.6 formula, “End behavior limit notation for polynomials”. Rejected twice by gpt-6-sol. The limits are correct for nonconstant polynomials, but the entry says only “polynomials” and leaves p unrestricted. CED 1.6.A.1 and 1.6.A.2 expressly say “a nonconstant polynomial function”; a constant polynomial does not have either stated limit. No caution supplies that missing restriction. Topic 1.6 first requires 
- **`ap_precalculus-u1-r2-012`** — 1.10 formula, “Location of a hole”. Rejected twice by gpt-6-sol. The implication is missing a necessary condition: a finite limit alone does not establish a hole. For example, r(x)=x has limit 0 as x approaches 0 but no hole there. CED 1.10.A.2 begins, “If the graph of a rational function r has a hole at x = c,” before explaining how to locate it; 1.10.A.1 gives the multiplicity con
- **`ap_precalculus-u1-r2-014`** — 1.13 list_sequence, “Choosing a function type for a model”. Rejected twice by gpt-6-sol. The list follows 1.13.A.1–1.13.A.7, and Topic 1.14 applies function types in model construction. However, the quadratic and cubic items overstate 1.13.A.3: the CED says geometric contexts involving area or two dimensions, and volume or three dimensions, “can often be modeled” by those functions—not that those contexts 
- **`ap_precalculus-u1-r2-015`** — 1.12 list_sequence, “Additive and multiplicative transformations”. Rejected twice by gpt-6-sol. Topic 1.12.A.1–1.12.A.4 requires all four forms; 1.14.A.2 also uses transformations to construct models. The absolute-value factors correctly describe the scale when the listed reflection is applied. However, the CED phrases the factors as “a factor of a” and “a factor of 1/b,” with a separate reflection when the param
- **`ap_precalculus-u3-r2-002`** — 3.5 convention, “Concavity of sinusoidal graphs”. Rejected twice by gpt-6-sol. The body reproduces Topic 3.5 essential knowledge 3.5.A.5: “As input values increase, the graphs of sinusoidal functions oscillate between concave down and concave up.” Topic 3.5 is the appropriate owner. The caution correctly names the CED's concavity terms, but its claim that scoring guidelines prohibit “increasing a
- **`ap_precalculus-u3-r2-001`** — 3.5 formula, “Period and frequency are reciprocals”. Rejected twice by own-family veto. a_factual: The body matches 3.5.A.2 exactly: "The period and frequency of a sinusoidal function are reciprocals. The period of f(θ)=sinθ and g(θ)=cosθ is 2π, and the frequency is 1/(2π)." The formula symbols and values are correct. b_topic_codes: owner 3.5 is correct because 3.5.A.2 is the first place the relationship 
- **`ap_precalculus-u3-r2-003`** — 3.7 formula, “Converting frequency to the parameter b”. Rejected twice by gpt-6-sol. The body correctly combines 3.5.A.2, which says period and frequency are reciprocals, with 3.6.A.6's period formula. Topic 3.7.A.1 uses period and frequency to construct sinusoidal models. However, the caution says a frequency of 200 cycles per second 'gives b = 2π·200.' The body correctly specifies |b|: a negative b h
- **`ap_precalculus-u3-r2-006`** — 3.11 formula, “Secant, cosecant, and cotangent definitions”. Rejected twice by gpt-6-sol. Topic 3.11 first requires these definitions, and Topic 3.12 uses equivalent trigonometric forms. However, the body applies “tan θ≠0” to the entire cotangent equality. CED 3.11.A.4 gives the forms separately: cot θ is the reciprocal of tangent “where tan θ≠0”; equivalently, “cot θ = cos θ / sin θ, where sin θ≠0.” The qu

## Product-Owner-directed correction pass (David, 2026-10-10)

David directed the session to correct the escalated rows rather than regenerate them. The protocol bars
hand-editing a generated row, so this is a recorded deviation under the Product Owner's authority over
escalations. Each correction restores the CED wording the checker identified as missing, and every corrected
row was re-checked by both independent checkers and the reject-only veto before loading.

### Corrected, re-checked, accepted and loaded

- `ap_precalculus-u1-r3-002` (1.1, body) — “Image and preimage”. Restored 1.3.B.3's 'for all small-length intervals'; rates rising over some intervals do not establish concavity.
- `ap_precalculus-u1-r3-003` (1.4, body) — “Polynomial function in standard form”. Added 1.4.A.1's condition that every coefficient is real; without it the form admits complex coefficients.
- `ap_precalculus-u1-r3-004` (1.11, body) — “Factored form vs. standard form”. Restored 1.11.A.1's structure: 'readily provides' applies to real zeros, and the rest follows from that.
- `ap_precalculus-u1-r3-005` (1.6, body) — “End behavior limit notation for polynomials”. Added 'nonconstant' from 1.6.A.1-2; a constant polynomial has finite end-behavior limits.
- `ap_precalculus-u1-r3-006` (1.10, body) — “Location of a hole”. Reversed the implication to match 1.10.A.2, which presupposes a hole at x = c and then locates it; a finite limit alone does not establish one.
- `ap_precalculus-u1-r3-008` (1.12, items) — “Additive and multiplicative transformations”. Replaced the absolute-value dilation factors with the CED's own phrasing, 'by a factor of a' and 'by a factor of 1/b', each followed by its reflection condition.
- `ap_precalculus-u1-r4-007` (1.13, items) — “Choosing a function type for a model”. Added the piecewise-defined type from 1.13.A.7 and split 1.13.A.4 from 1.13.A.5, which the entry had folded into one item.
- `ap_precalculus-u3-r3-001` (3.5, ) — “Concavity of sinusoidal graphs”. 
- `ap_precalculus-u3-r3-002` (3.5, caution) — “Period and frequency are reciprocals”. Deleted the caution: the CED pages say nothing about scoring guidelines rejecting 'increasing at an increasing rate'. The body matches 3.5.A.5 and needs no caution.
- `ap_precalculus-u3-r3-004` (3.11, body) — “Secant, cosecant, and cotangent definitions”. Separated the cotangent restrictions as 3.11.A.4 does; the combined condition wrongly excluded angles where cos theta = 0.
- `ap_precalculus-u3-r3-003` (3.6, caution, owner_topic_code, topic_codes) — “Converting frequency to the parameter b”. Ownership moves to 3.6, the first topic requiring the parameter b, and the caution now gives |b| = 400 pi rather than the entry's incorrect b = 2 pi times 200.

### Still open for the Product Owner

- `ap_precalculus-u1-r3-001` — “Concavity from changing average rates of change”. Ownership contested; see section 11 of the session record.
## Cost

687 gateway calls, $8.19 at gateway list prices (from `out/logs_*`, which are not committed).

