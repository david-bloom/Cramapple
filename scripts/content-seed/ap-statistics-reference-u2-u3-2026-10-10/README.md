# ap-statistics-reference-u2-u3-2026-10-10

**Scope:** ap_statistics units 2, 3. **Environment:** Development only (`wmgjsdkphcyhngaffbqf`). Production is a Hard Gate and was not touched.

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
| 2 | 58-83 | 42 | 38 | 4 of 4 | **42** | 0 | 0 | 6/6 |
| 3 | 82-119 | 61 | 50 | 8 of 11 | **57** | 0 | 3 | 6/6 |

Controls include one hook control, which counts as caught only when its planted hook is rejected while its correct entry is accepted.

### Rows refused by the pre-load schema guard

- unit 3, `ap_statistics-u3-r1-015`: owner_topic_code 3.3 missing from topic_codes ['3.4']

## Escalated to the Product Owner (not loaded)

- **`ap_statistics-u3-r2-001`** — 3.2 convention, “Interpret sampling distribution results in context”. Rejected twice by own-family veto. a_factual fails on modality. The body says the mean, standard deviation, and probabilities 'must be interpreted in the context of a specific population.' CED 3.2.C.1 reads: 'The mean, standard deviation, and probabilities for a sampling distribution of a sample proportion should be interpreted in the context of a speci
- **`ap_statistics-u3-r2-008`** — 3.7 convention, “Conclusion wording for a hypothesis test”. Rejected twice by gpt-6-sol. The conclusion convention is required in 3.7.B.6, 3.13.C.3, and 3.15.D.3, and 3.7 is its first listed topic. But the body applies a requirement to refer to a parameter across all three tests. For chi-square conclusions, 3.15.D.3 requires a reference to the population(s), not a parameter; for two-proportion conclusions,
- **`ap_statistics-u3-r2-011`** — 3.10 formula, “Standard error of \hat{p}_1 - \hat{p}_2”. Rejected twice by own-family veto. a_factual: The formula matches the CED's 3.10.D.1 structure, SE = sqrt(p1(1-p1)/n1 + p2(1-p2)/n2), with the two-proportion sum under the root and n1 and n2 in the denominators. The hats were lost in text extraction, so the sample-proportion notation is taken as the intended form. b_topic_codes: 3.10.D.1 is where the st

## Cost

445 gateway calls, $5.16 at gateway list prices (from `out/logs_*`, which are not committed).

