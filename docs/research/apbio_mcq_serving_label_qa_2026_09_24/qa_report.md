# QA — 20 AP Biology MCQ Serving Labels Whose Content Was Republished Under Them

**Date:** 2026-09-24. **Reviewer:** Claude (independent QA). **Scope:** the 20 Biology MCQ whose
serving label carried a `validated_against_taxo_hash` that did not match current content *before*
today's migrations.

**Disposition: ACCEPT 15, REJECT 4, FLAG 1.** The 15 are re-anchored and servable again (M2.3).
The 5 are not, and their corrections are recorded rather than applied.

---

## Why these needed re-derivation, not re-anchoring

M2.2 re-anchored 22 labels on an argument: I knew precisely what had changed (M1 rewrote
`canonical_answer_1`, M4 removed `prompt_json.total_points`), and neither touches anything that
determines `required_units`.

**These 20 are not that case.** Every one was republished at `version_num >= 2` between
**2026-08-11 and 2026-08-13**, after its serving label was written on 08-04 or 08-08:

| Label written | Content republished | Items |
| --- | --- | ---: |
| 2026-08-04 (`legacy_unvalidated`) | 2026-08-11 | 5 |
| 2026-08-08 (`stale`) | 2026-08-11 → 08-13 | 15 |

So the content genuinely moved and the label was written against a version that no longer exists.
The only honest check is to read each item as it stands now. That is what this pass did: current
stem and keyed answer against `required_units`, judged on T9's rule — *a unit is required if a
student who had not covered it could not answer* — using the registry's own unit titles rather than
remembered ones.

**Unit titles, read from `app.taxonomy_topics`:** U1 Chemistry of Life · U2 Cells · U3 Cellular
Energetics · U4 Cell Communication and Cell Cycle · U5 Heredity · U6 Gene Expression and Regulation
· U7 Natural Selection · U8 Ecology.

---

## Accepted (15) — re-anchored

| Item | Units | Content |
| --- | --- | --- |
| `MCQ-043` | 4,5 | mitosis vs meiosis — cell cycle plus heredity |
| `MCQ-054` | 5 | incomplete dominance |
| `MCQ-056` | 5 | complementary epistasis, 9:7 |
| `MCQ-063` | 6 | 5′ cap and mRNA fate |
| `MCQ-067` | 6 | liver-specific enhancer |
| `MCQ-069` | 6 | alternative splicing and proteome complexity |
| `MCQ-074` | 6 | PCR primer mismatch (biotechnology) |
| `MCQ-079` | 7 | disruptive selection |
| `MCQ-084` | 7 | allopatric vs sympatric speciation |
| `MCQ-086` | 7 | synapomorphy vs symplesiomorphy |
| `MCQ-093` | 8 | trophic cascade |
| `MCQ-094` | 8 | species richness and resilience |
| `MCQ-095` | 8 | 10% rule energy transfer |
| `MCQ-097` | 8 | K-selected life history |
| `MCQ-099` | 8 | biodiversity and carbon sequestration |

Each keeps the status it had: `stale` rows restored to `provisional_model`, `legacy_unvalidated`
left as `legacy_unvalidated`. Re-anchoring is not a reason to upgrade a label nobody validated.

## Rejected (4) — not re-anchored, corrections recorded not applied

**Three share one systematic error: cell-signalling and cell-cycle content labelled Unit 3
(Cellular Energetics) when it belongs to Unit 4 (Cell Communication and Cell Cycle).** That is a
template-shaped mistake, not three independent slips, which is the same signature the Statistics
topic-label QA found and the reason that one was rejected wholesale.

| Item | Labelled | Proposed | Why |
| --- | --- | --- | --- |
| `MCQ-030` | 3 | **4** | apoptosis vs necrosis sculpting interdigital spaces — programmed cell death |
| `MCQ-033` | 3 | **4** | IP₃ receptor, Ca²⁺ release, PKC — signal transduction |
| `MCQ-046` | 3 | **4** | TSH/T3 negative feedback with a pituitary adenoma — feedback signalling |
| `MCQ-025` | 2,8 | **2,4** | ADH → AQP2 → osmosis in the collecting duct. U2 is right. **U8 (Ecology) has no basis** — this is organismal physiology, and the ADH signal is U4 |

## Flagged (1)

| Item | Labelled | Why flagged |
| --- | --- | --- |
| `MCQ-088` | 7 | Hamilton's rule and altruism. Kin selection is taught under Natural Selection (U7); behaviour sits in Ecology (U8). A genuine boundary call, and QA should not settle it silently |

---

## Why the corrections are not applied

Authoring the replacement label and then verifying it would collapse the builder/QA separation
DECISION-0055 depends on. The 5 go to Codex alongside work order N, which is already labelling 43
Biology items and will have the method loaded.

## Effect

Biology servable items: **41 → 56** (22 FRQ, 34 MCQ), spread across all eight units
(u1:2 u2:9 u3:2 u4:5 u5:8 u6:13 u7:9 u8:8).

## Finding carried forward

**MCQ-QA-001.** Twenty items were republished in August and every serving label silently stopped
matching. Nothing detected this for six weeks, because the selector treats a hash mismatch as "no
rows" rather than as an error. **Any republish silently removes an item from serving.** That is a
systemic gap, not a Biology one — it will behave identically for Statistics and Calculus AB. A
standing check that counts servable items per subject would have caught it the day it happened.
