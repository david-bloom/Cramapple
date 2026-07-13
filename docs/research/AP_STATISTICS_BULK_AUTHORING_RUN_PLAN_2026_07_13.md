# AP Statistics 2026-27 — Bulk-Authoring Run Plan (G2)

**Status:** PREPARED — ready to fire once the two gates below clear. **Not yet run.** Produces **artifacts only** (no DB staging, no publish) until Codex's H1 schema + P0 land.
**Owner:** Claude (authoring cascade) · **Input:** `AP_STATISTICS_2027_CED_FACT_PACK.md` (G0A) · **Governs:** `AP_STATISTICS_2027_CONTENT_REBUILD_ORCHESTRATION.md`
**Prepared:** 2026-07-13

## Fire gates (both must clear before G2 runs)

1. **Fact pack review (G0A)** — AP Statistics tutor confirms `AP_STATISTICS_2027_CED_FACT_PACK.md` (skills now anchored §3). *In process.*
2. **G3V re-review** — Codex clears the 3 remediated vertical-slice FRQs. *Pending.*

On both green, run this plan. Nothing here fires before then.

## 1. Inventory distribution — 71 MCQ + 33 FRQ (per `DECISION-0037`)

### MCQ (71) — by unit, proportional to CED multiple-choice weight

| Unit | MC weight | MCQs | Topic-coverage guidance |
|---|---|---|---|
| 1 | 20–30% | **19** | spread across 1.1–1.13; ≥1 per data-collection topic (1.10–1.13) |
| 2 | 15–25% | **15** | probability (2.3–2.7), random variables/distributions (2.8–2.12) |
| 3 | 15–25% | **15** | one- & two-proportion inference (3.1–3.13), chi-square hom./indep. (3.14–3.15) |
| 4 | 10–20% | **11** | one- & two-mean inference (4.1–4.10) |
| 5 | 10–20% | **11** | descriptive regression only (5.1–5.5) — **no slope inference** |
| **Total** | | **71** | |

Per unit: spread across topics (use §3 skills map), difficulty mix ≈ 30% easy / 50% medium / 20% hard, one keyed correct answer, 4 options, per-option rationale. Set-based (linked) items allowed where the CED uses them.

### FRQ (33) — by archetype, with content-area mapping

| Archetype | Practices | Count | Content areas |
|---|---|---|---|
| **Q1** — Multi-focus | 1 & 2 | **8** | sampling methods, study/experimental design, investigative questions (Unit 1: 1.10–1.13) |
| **Q2** — Multi-focus | 3 & 4 | **9** | representations + summary stats + describe/compare (Unit 1: 1.3–1.9; Unit 2: 2.1–2.2; Unit 5: 5.1–5.5) |
| **Q3** — Inference | 2, 3, 4 | **8** | hypothesis test **or** CI — 4 proportions (Unit 3), 4 means (Unit 4) |
| **Q4** — Multi-area | 2, 3, 4 | **8** | spans distributions/inference (Units 2/3/4/5) |
| **Total** | | **33** | |

Every FRQ = **10 points**, multi-part (A/B/C…, i/ii…), each point independently earnable, with a full criterion-boundary contract + student `minimum_fix` repair text (Orchestration B).

## 2. Cascade wiring (per orchestration; execution = Claude app / subagents, `DECISION-0037` Q4)

Pipeline per item (items pipeline independently; no barrier):

| Phase | Engine | Output |
|---|---|---|
| A1 blueprint | Opus 4.8 | authoring brief: unit/topic, skills (from §3), archetype, difficulty, modality tag |
| A2 author | Opus 4.8 | draft item from **fact pack only** (no CED PDF, no CB material) |
| A3 deterministic check | scripts | recompute every numeric; one-correct-answer (MCQ); part-answerability; points sum to archetype total; schema shape |
| A4 adversarial verify | Opus 4.8 (fresh ctx) | skeptical refute pass; **invariant checklist below**; verdict + defects |
| B1–B2 contract + repair | Opus 4.8 | criterion-boundary contract + `minimum_fix` (FRQ) |
| B3 verify contract | scripts + Opus (fresh) | boundary/ECF/task-verb checks |
| A5/B4 conform | Sonnet 5 | field completeness, tag validity, no-CB lint, package-complete |
| catalog | Haiku 4.5 / scripts | coverage matrix vs. targets; deterministic counts (declare convention: units/atomic) |

Deterministic scripts own all counts/recompute; Haiku is narrative only. Correctness verifier is a **separate Opus context**, never the author thread. Codex G3 samples 100% of inference FRQs + high-risk criteria before any MCQ sampling.

## 3. Authoring invariants — BAKED INTO A2/A4 (the G3V lesson)

Every FRQ must pass, or A4 fails it back to A2 (bounded retries):

1. **Population defined precisely** — the keyed sampling method must be unambiguous for that population (Q1-FAIL lesson).
2. **Verifiable conditions** — if the item asks to *verify* a condition (e.g., n ≤ 10%), the stimulus must supply/bound the population size; never "presumably" (Q3-FAIL lesson).
3. **Explicit decision rules** — state α and/or an explicit threshold; never leave the decision criterion implicit in the model answer (Q4-FAIL lesson).
4. **ECF on dependent chains** — every calc→decision chain carries consequential-error rules so a wrong upstream value is judged against the student's own work.
5. **Hedged inferred-shape language** ("apparent/likely") when inferring from summary statistics.
6. **No removed topics** — no slope inference, chi-square GOF, geometric distribution, combining random variables, or departures-from-linearity (fact pack §8).
7. **Task-verb ↔ demand match** — "Identify" needs no justification; "Explain/Justify" requires reasoning.

## 4. Per-item author prompt template (A2)

> Author one AP Statistics **[MCQ | FRQ archetype Qn]** for **Unit [U], Topic [X.Y] "[title]"**, targeting skill(s) **[skills from §3]**, difficulty **[easy/med/hard]**, modality **exam_aligned_digital**.
> Source of truth: the CED fact pack only (`AP_STATISTICS_2027_CED_FACT_PACK.md`). **Do not** use College Board questions, scoring language, or the CED PDF. Construct all context, data, and wording independently.
> **[FRQ]** Produce a 10-point multi-part item (parts A/B/C…, sub-parts i/ii…), a model solution, and a criterion-boundary contract of 10 independently-earnable points, each with earns/doesn't-earn boundary, ≥1 counterexample, and a `minimum_fix` repair line.
> Enforce the authoring invariants: define the population precisely; supply the info to verify any condition asked; state α/decision rules explicitly; attach ECF to dependent chains; hedge inferred-shape language; match rubric demand to the task verb; author no removed topics.
> Show every numeric computation so it can be independently recomputed.

## 5. Run controls

- Batch size 25 items; concurrency ≤ 8 (subagent cap); **max retries = 2** per item, then flag-for-human (never silent drop).
- **Stop conditions:** halt + escalate if deterministic-check defect rate > 20% in a batch, or any no-CB-lint cluster, or an invariant fails > 2×/item repeatedly (signals a systematic authoring error — fix the prompt, don't grind).
- Provenance per item: model IDs, fact-pack version, prompt-template version, run ID, recompute log, retry/defect history, author↔verifier separation.

## 6. Guardrails

- **Artifacts only** until Codex's H1 archetype schema exists — no DB staging; the `frq_form` gap blocks staging, not authoring.
- **No publish** (P0 + non-waivable grading gate); tutor content review (G4A) + grading/repair review + G4B calibration all still precede any student exposure.
- No College Board material as input; no-CB lint in A4/conform.

## 7. Output & handoff

- Staged as workflow artifacts under `docs/research/ap_statistics_bulk_<date>/` (item files + coverage matrix + provenance).
- On completion → Codex **G3** batch QA (100% inference FRQs + high-risk criteria) → tutor **G4A** content review vs. the approved fact pack → grading/repair review → **G4B** calibration → David publishes.
- The vertical slice's 7 passing units + 3 remediated FRQs are the seed; bulk fills to 71/33.

## Ready-to-fire checklist

- [ ] Fact pack review (G0A) — tutor
- [ ] G3V re-review of 3 FRQs — Codex
- [ ] (then) Claude fires this plan → artifacts → Codex G3 → tutor G4A → grading/repair → G4B → publish
