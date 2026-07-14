# AP Statistics 2026-27 — Vertical-Slice Draft Content (pre-G0A)

**Status:** ⚠️ **DRAFT — pre-G0A. Not cleared content.** Authored by Claude as a **contract proof-case**
against the H0/H1 subject-onboarding contract, not as launch-approved or tutor-reviewed content.

Per `AP_STATISTICS_2027_CONTENT_REBUILD_ORCHESTRATION.md`, the G2V vertical slice (Q1–Q4 + MCQ set)
is authored **after** G0A (the AP Statistics tutor approves the CED fact pack) and G1/G1.5 clear. The
fact pack (`docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md`) is itself still DRAFT pending that
tutor sign-off. These files are therefore:

- a **structurally valid** proof that real content flows green through
  `scripts/subject-harness/compiler.ts` against `ap-statistics-2026-27.subject-package.json`, and
- a concrete draft for the tutor (G0A/G4A) and Codex (G3V) to react to,

but they are **not** authorization to publish, do not manufacture gate evidence, and do not skip the
cascade. `QA-pass ≠ launch approval` (`feedback_governance`).

## Contents

| File | Item | Archetype | Pts | Response modalities | Content focus |
|------|------|-----------|-----|---------------------|---------------|
| `…-slice-q1.item-package.json` | Q1 — Practices 1 & 2 | `frq-practices-1-2` | 10 | typed-text | Investigative question, population/variables, SRS, sampling bias, observational-vs-causal (Unit 1) |
| `…-slice-q2.item-package.json` | Q2 — Practices 3 & 4 | `frq-practices-3-4` | 10 | typed-text, typed-math | Median/IQR, 1.5×IQR outliers, describe & compare distributions (Unit 1) |
| `…-slice-q3.item-package.json` | Q3 — Inference | `frq-inference` | 10 | typed-text, typed-math | One-proportion z-interval: conditions → compute → interpret → justify (Unit 3) |
| `…-slice-q4.item-package.json` | Q4 — Practices 2, 3 & 4 | `frq-multifocus-2-3-4` | 10 | typed-text, typed-math, table | Randomized experiment, two-way table, two-proportion inference, scope (Units 2–3) |

All four are 10 points with each point scored independently (the 2027 4×10 format), compile green
together (`plan_sha256 af858299…`), and carry verified canonical `content_sha256` values.

### MCQ portion (completes the G2V slice)

| File | Item | Unit | Answer |
|------|------|------|--------|
| `…-mcq-set1-q1/q2/q3.item-package.json` | 3-question set (shared five-number-summary stimulus): IQR, 1.5×IQR outlier, shape | Unit 1 | A / B / C |
| `…-mcq-u1.item-package.json` | Sampling method (SRS) | Unit 1 | A |
| `…-mcq-u2.item-package.json` | Binomial mean (np) | Unit 2 | A |
| `…-mcq-u3.item-package.json` | Sample size → margin of error | Unit 3 | B |
| `…-mcq-u4.item-package.json` | CI ↔ significance-test duality | Unit 4 | B |
| `…-mcq-u5.item-package.json` | Regression slope interpretation | Unit 5 | A |

8 MCQs (`archetype mcq-four-option`, 1 pt, `choice` modality, `choice-key` deterministic check).
Verify with `deno run --allow-read docs/content/ap_statistics_2026_27_slice/compile-check-mcq.ts`.
Full 12-item slice compiles as authored (`plan_sha256 28a27a86…`); the 4-FRQ anchor `af858299…`
is preserved by `compile-check.ts`.

**Two schema findings surfaced by MCQ authoring** (see
`docs/architecture/SUBJECT_HARNESS_MCQ_SCHEMA_FINDINGS_2026_07_13.md`): the item-package schema has no
structured MCQ **options** model (options are embedded in prompt text) and no **item-set** construct
(the set is 3 separate items duplicating the stimulus). Both are H1/schema-lane decisions for Codex.

Grounding: authored only from `AP_STATISTICS_2027_CED_FACT_PACK@2026-07-13` (no verbatim College
Board content; synthetic contexts). Skill anchoring per fact-pack §3–§4; task verbs per §6; digital
modality constraints per §7. Numeric answers embedded in criteria descriptions were computed exactly;
deterministic checks conform to the registry's `deterministic_check_contracts`.

**For the reviewing tutor (G0A/G4A):** every numeric value, condition check, and rubric point is a
draft to verify — especially Q3/Q4 inference conditions, the Q2 quartile/outlier arithmetic, and
whether each criterion's task verb (Identify vs Explain vs Justify) matches its required evidence.

## Validate locally

```
deno run --allow-read docs/content/ap_statistics_2026_27_slice/compile-check.ts
```
Compiles the subject package + this item through `compilePlan` with the platform capability registry
and prints the plan hash + item count on success, or the machine-readable issues on failure.
