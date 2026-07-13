# AP Biology — CED Fact Pack (authoring/review input)

**Status:** DRAFT — **built from the standard AP Biology course framework + the repo's existing Bio materials, NOT from a loaded CED document.** Needs (a) anchoring against the actual *AP Biology Course and Exam Description* for exact EK/LO IDs and precise weights, and (b) AP Biology tutor review. Treat the CED-derived specifics below as **provisional pending that anchoring** — the same posture the AP Statistics pack had before it was anchored from the CED I read.
**Purpose:** authoring/review input for Cramapple's **existing** AP Biology content (242 draft `content_items`), not a rebuild. Analogous to `AP_STATISTICS_2027_CED_FACT_PACK.md`.
**Prepared:** 2026-07-13 · **Reviewer (sign-off):** AP Biology subject tutor (once onboarded)
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

*Weights above are the widely-published AP Biology ranges but were not read from a CED document for this pack — verify.*

## 3. Topic map (TO ANCHOR from the AP Biology CED)

Unlike the Stats pack (topic list read from the CED), the per-unit topic list and EK/LO IDs for Biology are **not enumerated here** — I did not have the AP Biology CED loaded. **Action:** anchor the topic list (`U.T` numbering) and EK IDs per unit from the AP Biology CED unit guides, then populate this section as a topic→science-practice→EK table (mirror `AP_STATISTICS_2027_CED_FACT_PACK.md` §3). Until then, author/review at the unit level and tag science practices from §4.

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

1. **Anchor §2/§3/§4 against the actual AP Biology CED** — exact weights, full topic list, EK/LO IDs, science-practice skill sub-codes. *(Provide the AP Biology CED PDF and I'll anchor it the way I did the Stats §3.)*
2. **AP Biology tutor sign-off** (once a Bio-qualified tutor is onboarded — note the two current candidates are AP-Statistics-oriented).
3. **Confirm the FRQ question-type breakdown** (long/short focuses) against the CED.
4. Decide whether Biology content is authored-new, or the existing 242 draft items are reviewed/completed toward publication (likely the latter — no format change).
