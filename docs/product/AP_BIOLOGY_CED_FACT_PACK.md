# AP Biology — CED Fact Pack (authoring/review input)

**Status:** **G0A DRAFT — ready for AP Biology tutor (Morgan) sign-off.** Exam
structure, 8-unit map, unit weights, and the full topic map (§3) are now anchored
from the public AP Biology course framework (2026-07-14). Remaining for G0A: verify
any **2025-CED topic deltas**, supply exact **EK/LO IDs** and per-practice **skill
sub-codes**, and confirm the FRQ question-type focuses. Granular EK codes are cited
per item at authoring time (as in the Stats pack), not bulk-transcribed here.
**Purpose:** authoring/review input for Cramapple's **existing** AP Biology content (242 draft `content_items`), not a rebuild. Analogous to `AP_STATISTICS_2027_CED_FACT_PACK.md`.
**Prepared:** 2026-07-13 · **Topic map anchored:** 2026-07-14 · **Reviewer (G0A sign-off):** AP Biology subject tutor (Morgan) — *pending*
**Related:** `AP_STATISTICS_2027_CONTENT_REBUILD_ORCHESTRATION.md` (same cascade/gates apply), `DECISION-0036` (AI-led authoring), `AP_BIOLOGY_VERIFICATION_PROFILE.json`, `project_ap_biology_publish_gap` memory.

## Important difference from AP Statistics (do not conflate)

**AP Biology is NOT undergoing a 2026-27 format change.** The digital/format change confirmed this session is **AP Statistics only**. This fact pack supports reviewing/completing the *existing* Bio content, which is all `status='draft'` (the publish-gap), toward review and publication — it does **not** trigger a rebuild. AP Biology's hybrid format (paper FRQ booklets + digital MCQ) and its hand-drawn-graph (HDG) work remain in scope and unaffected.

## Provenance & rights

Derived from the standard AP Biology course framework (public unit structure, science practices, exam blueprint) and the repo's existing Bio materials. Contains **no official College Board questions or scoring guidelines** — those must never enter authoring (`DECISION-0031`/`0033`). Any authored item is independent synthetic content.

## Confidence flags (read before using)

- **High confidence (stable/standard):** the 8-unit structure and unit names; the 6 science practices; the exam being 60 MCQ + 6 FRQ, 90 min each section, 50/50.
- **Provisional — verify against the AP Biology CED:** exact per-unit MC weight ranges; the exact FRQ question-type breakdown (long vs. short and their focuses); the full topic list per unit; and **all EK/LO IDs** (e.g., `1.2.A.1`). These were **not** read from a CED document for this pack — anchor them from the AP Biology CED before per-item authoring keys on them (mirror the Stats §3 anchoring pass).
- **From the repo:** existing content keys use `APBIO-MCQ-*`, `APBIO-FRQ-L-*` (long), `APBIO-SFRQ-*` (short), `APBIO-HDG-*` (hand-drawn graph). 242 items exist, all draft. See `AP_BIOLOGY_VERIFICATION_PROFILE.json` for grading checks/hard cases.

## 1. Exam structure (high confidence; verify FRQ breakdown against CED)

- **3 hours.** Section I: **60 multiple-choice**, 90 min, **50%**. Section II: **6 free-response**, 90 min, **50%**.
- FRQ section is commonly **2 long-answer + 4 short-answer** (long ≈ 8–10 pts, short ≈ 4 pts). The long questions center on **interpreting/evaluating experimental results** (incl. graphing and statistics) and **analyzing a model/visual representation**; short questions cover scientific investigation, conceptual analysis, model/visual analysis, and data analysis. **Confirm the exact per-question focuses against the CED.**
- Four-function/scientific/graphing calculator permitted; a formula/statistics reference sheet is provided.

## 2. Units & MC weighting (unit names high confidence; **weights provisional — verify against CED**)

| Unit | Title | MC weight (provisional) |
|---|---|---|
| 1 | Chemistry of Life | 8–11% |
| 2 | Cell Structure and Function | 10–13% |
| 3 | Cellular Energetics | 12–16% |
| 4 | Cell Communication and Cell Cycle | 10–15% |
| 5 | Heredity | 8–11% |
| 6 | Gene Expression and Regulation | 12–16% |
| 7 | Natural Selection | 13–20% |
| 8 | Ecology | 10–15% |

*Weights above match the public AP Biology course-framework ranges (confirmed 2026-07-14 against College Board AP Central + course-framework summaries); confirm no 2025-CED revision at Morgan's G0A.*

## 3. Topic map (anchored from the public AP Biology course framework; verify 2025-CED deltas + EK/LO IDs at G0A)

Topic list and `U.T` numbering below are from the published AP Biology course
framework (unit-at-a-glance structure). **Morgan (G0A) verifies** against the current
**2025 CED** for any topic deltas (the 2025 CED revised some content) and supplies
exact **EK/LO IDs** (`U.T.A / U.T.A.n`) — mirroring the Stats §3 posture, granular EK
codes are cited **per item at authoring time**, not bulk-transcribed here. The item's
**science-practice tag (§4)** is what the cascade keys on for skill alignment.

**Unit 1 — Chemistry of Life** (8–11%)
1.1 Structure of Water and Hydrogen Bonding · 1.2 Elements of Life · 1.3 Introduction to Biological Macromolecules · 1.4 Properties of Biological Macromolecules · 1.5 Structure and Function of Biological Macromolecules · 1.6 Nucleic Acids

**Unit 2 — Cell Structure and Function** (10–13%)
2.1 Cell Structure: Subcellular Components · 2.2 Cell Structure and Function · 2.3 Cell Size · 2.4 Plasma Membranes · 2.5 Membrane Permeability · 2.6 Membrane Transport · 2.7 Facilitated Diffusion · 2.8 Tonicity and Osmoregulation · 2.9 Mechanisms of Transport · 2.10 Cell Compartmentalization · 2.11 Origins of Cell Compartmentalization (endosymbiosis)

**Unit 3 — Cellular Energetics** (12–16%)
3.1 Enzyme Structure · 3.2 Enzyme Catalysis · 3.3 Environmental Impacts on Enzyme Function · 3.4 Cellular Energy · 3.5 Photosynthesis · 3.6 Cellular Respiration · 3.7 Fitness

**Unit 4 — Cell Communication and Cell Cycle** (10–15%)
4.1 Cell Communication · 4.2 Introduction to Signal Transduction · 4.3 Signal Transduction · 4.4 Changes in Signal Transduction Pathways · 4.5 Feedback · 4.6 Cell Cycle · 4.7 Regulation of Cell Cycle

**Unit 5 — Heredity** (8–11%)
5.1 Meiosis · 5.2 Meiosis and Genetic Diversity · 5.3 Mendelian Genetics · 5.4 Non-Mendelian Genetics · 5.5 Environmental Effects on Phenotype · 5.6 Chromosomal Inheritance

**Unit 6 — Gene Expression and Regulation** (12–16%)
6.1 DNA and RNA Structure · 6.2 Replication · 6.3 Transcription and RNA Processing · 6.4 Translation · 6.5 Regulation of Gene Expression · 6.6 Gene Expression and Cell Specialization · 6.7 Mutations · 6.8 Biotechnology

**Unit 7 — Natural Selection** (13–20%)
7.1 Introduction to Natural Selection · 7.2 Natural Selection · 7.3 Artificial Selection · 7.4 Population Genetics · 7.5 Hardy-Weinberg Equilibrium · 7.6 Evidence of Evolution · 7.7 Common Ancestry · 7.8 Continuing Evolution · 7.9 Phylogeny · 7.10 Speciation · 7.11 Extinction · 7.12 Variations in Populations · 7.13 Origin of Life on Earth

**Unit 8 — Ecology** (10–15%)
8.1 Responses to the Environment · 8.2 Energy Flow Through Ecosystems · 8.3 Population Ecology · 8.4 Effect of Density of Populations · 8.5 Community Ecology · 8.6 Biodiversity · 8.7 Disruptions to Ecosystems

> Source of the structure above: public AP Biology course-framework listings
> (College Board AP Central course page + course-framework summaries). **No official
> CB questions or scoring guidelines are used.** Confidence: unit/topic names and
> numbering are high-confidence for the standard framework; **the 2025 CED may have
> topic-level revisions** — Morgan confirms at G0A before this drives per-item keys.

## 4. Science practices (high confidence)

1. **Concept Explanation** — describe and explain biological concepts, processes, and models.
2. **Visual Representations** — analyze visual representations of biological concepts/processes.
3. **Questions and Methods** — determine scientific questions and methods.
4. **Representing and Describing Data** — represent and describe data.
5. **Statistical Tests and Data Analysis** — perform statistical tests and mathematical calculations to analyze and interpret data.
6. **Argumentation** — develop and justify scientific arguments using evidence.

*(Exact skill sub-codes per practice — e.g., `1.A`, `5.B` — should be anchored from the CED like the Stats skills.)*

## 5. FRQ archetypes (verify focuses against CED) — authoring targets

- **Long 1 — Interpret and evaluate experimental results** (with graphing and statistical analysis; science practices 4, 5, 6 heavy).
- **Long 2 — Interpret and evaluate experimental results with a model** (practices 2, 6).
- **Short — Scientific investigation** (practice 3).
- **Short — Conceptual analysis** (practice 1, 6).
- **Short — Analyze model/visual representation** (practice 2).
- **Short — Analyze data** (practices 4, 5).

Each FRQ carries a criterion-boundary contract + `minimum_fix` repair per criterion (Orchestration B), and — per the AP Statistics G3V lessons — must satisfy the same **authoring invariants** (defined population/context, verifiable conditions, explicit decision rules, ECF on dependent chains, task-verb↔criterion match, task-coverage completeness). See `AP_STATISTICS_BULK_AUTHORING_RUN_PLAN_2026_07_13.md` §3.

## 6. Task verbs (common AP Biology; verify full list against CED)

Calculate · Construct/Draw (e.g., a graph) · Describe · Determine · Explain · Identify · Justify · Make/Support a claim · Predict · Represent · State. Same authoring rule as Stats: "Identify/State" needs no justification; "Explain/Justify/Support a claim" requires reasoning with evidence.

## 7. Response modality

AP Biology is **hybrid** (not fully digital): MCQ digital, FRQ handwritten in paper booklets (incl. graphing). Cramapple's **hand-drawn-graph capture (HDG)** work applies to Biology and is exam-aligned here (unlike Stats, where HDG is supplemental). Tag Bio items `exam_aligned` for both typed and hand-drawn where appropriate.

## 8. Content-state note (the publish gap)

All 242 AP Biology `content_items` are `status='draft'` (`project_ap_biology_publish_gap` memory). This fact pack supports getting that content **reviewed and publishable**: existing items were QA'd (2026-07-12 pass fixed defects, backfilled canonical answers for the 42 `APBIO-FRQ-L-*`), but they still need tutor content review (G4A), grading calibration (G4B, non-waivable), and publication (G5) — the same gate chain as Stats, and now hard-enforced by the P0 publish fix.

## 9. Open items (before this pack drives authoring/review)

1. ~~Anchor §2/§3 (weights + full topic map)~~ **DONE 2026-07-14** from the public
   course framework. Remaining anchoring for Morgan's G0A: verify **2025-CED topic
   deltas**, exact **EK/LO IDs**, and per-practice **skill sub-codes** (§4).
2. **AP Biology tutor (Morgan) G0A sign-off** — Morgan is onboarded and Bio-qualified.
   This pack is ready for her review (mirror Jill's Stats G0A: approve, or flag changes).
3. **Confirm the FRQ question-type breakdown** (§5 long/short focuses) at G0A.
4. Biology is **review/complete the existing 242 draft items** toward publication (no
   2026-27 format change; not an authored-new rebuild) — confirmed at §8/§10.
