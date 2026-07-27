# Grading Program — Master Index

**Purpose:** the single entry point for all grading-engine work — the umbrella
task, the engine architecture, phase status, the research corpus, and the
backend interface it runs on. Start here; every section links to the durable
artifact. Keep this hub current when a phase or engine status changes.

**Umbrella task:** [`TASK-0016`](tasks/TASK-0016-GRADING-ENGINE-ROLLOUT.md) —
build the grading/feedback engines for the four rubric types and launch AP
Statistics end-to-end first.

**Standing standard:** DECISION-0034 (five grading standards) + the durable
lesson layer: [`GRADING_RESEARCH_CANONICAL_PROCESS.md`](research/GRADING_RESEARCH_CANONICAL_PROCESS.md)
and [`grading_cross_subject_takeaways.md`](research/grading_cross_subject_takeaways.md).

---

## 1. The four engines (rubric-type taxonomy)

| Engine | Rubric type | Status | Home |
|---|---|---|---|
| **1. Discrete/Analytical Text** | point-by-point analytic | **in production** (`evaluate-attempt`); router + deterministic symbolic/ECF path deployed to Production 2026-07-12 but scoped to only 5 seeded AP Stats `content_key`s — everything else still falls through to the single-call LLM grader unchanged (see §2, §7) | `supabase/functions/evaluate-attempt/`, `_shared/grading-router.ts` |
| **2. Holistic/Evaluative Text** | rubric-matrix essays | **deferred** (serves AP English/History, not in launch set) | rollout plan §Engine 2 |
| **3. Structured Multi-Modal** | equations/formulas + **ECF** | **built + verified** (typed); hand-drawn transcription validated on synthetic renders | `research/math_formula_grading_experiment_2026_07_08/`, `_shared/math-verifier.ts` |
| **4. Spatial Multi-Modal** | graphs/curves/diagrams | **research** (TASK-0011) | `research/DRAWN_RESPONSE_ARCHITECTURE_REVIEW.md`, `tasks/TASK-0011-...` |

Full readiness + gap analysis: [`grading_engine_rollout_plan_2026_07_08.md`](research/grading_engine_rollout_plan_2026_07_08.md).

## 2. TASK-0016 phase status

| Phase | Work | Status (2026-07-09) | Evidence |
|---|---|---|---|
| **A** | Router + deterministic checks + symbolic/ECF typed path | **DEPLOYED to Production 2026-07-12** (PR #37, commit `547bc21`; Production had it live independently since 03:19 UTC that day, git synced after the fact). Fires only for `content_key`s in `math-verifier.ts`'s `STATISTICS_ITEM_KEYS` map — currently 5 items (`APSTAT-MOD3-H001-INV`, `MOD5-H001-INV`, `MOD6-H001`, `MOD7-H001`, `MOD8-H001`). **Unverified whether it has ever actually fired on real traffic** — Production edge-function logs showed zero invocations as of the 07-12 sync; not re-checked since. Every other item (all Bio, all other Stats) still uses the unchanged single-call LLM grader. | `research/CODEX_TASK0016_PHASE_A_QA_FINDINGS_2026_07_08.md`; `_shared/{grading-router,math-verifier}.ts`; PR #37 |
| **B** | Hand-drawn transcription bake-off + AP Stats keys/ECF templates | **Keys 8/8 + ECF 3/3 done. Live bake-off executed** on synthetic renders (3 models, 9/9 faithful, 0 silent corruption). **Gate open:** real-handwriting run | `research/statistics_phase_b_2026_07_08/` (`bakeoff_report.md`) |
| **C** | Adjudicated AP Statistics gold set + content publish/corpus expansion | **In progress** (other sessions) | `prompts/CODEX_TASK0016_PHASE_C_*` (corpus expansion, publish packet, QA/remediation) |
| **D** | Engine 4 spatial (QR MVP) into shadow | Pending (longest pole) | TASK-0011 |
| **E** | Frontend: Statistics grading experience | In progress | `prompts/LOVABLE_GRADING_WIREUP_2026_07_14.md`, `LOVABLE_UX006_STUDENT_PRACTICE_GRADING.md` |
| **F** | Launch readiness review | Pending | — |

**Launch bar (AP Statistics beta gate, DECISION per APPROVAL-0033):** grade
100 MCQ + 100 FRQ + 10 investigative items at ≥95% criterion agreement, end-to-end
p50 ≤ 1000 ms (p90/p99 measured), cost ≤ $0.01/item.

## 3. Durable foundations (read before iterating)

- **Standard:** DECISION-0034 — boundary contracts, depth>breadth, deterministic
  layer, feedback quality, single-fast-grader default.
- **Canonical process:** [`GRADING_RESEARCH_CANONICAL_PROCESS.md`](research/GRADING_RESEARCH_CANONICAL_PROCESS.md).
- **Cross-subject lessons:** [`grading_cross_subject_takeaways.md`](research/grading_cross_subject_takeaways.md)
  (rubric-boundary precision dominates; escalation/ensembles are not the default;
  deterministic checks catch what the model can't; confidence ≠ trigger; measure
  feedback not just score; depth of adjudicated evidence gates launch).
- **Deterministic layer:** numeric checker (`research/deterministic_check_experiment_2026_07_08/`,
  100% specificity); symbolic + ECF (`research/math_formula_grading_experiment_2026_07_08/`).

## 4. Research index (by engine)

- **Text grading (Engine 1):** FRQ02/SP-1 investigation, primary-fallback,
  boundary-calibration, Kimi/DeepSeek arms, gold-set candidates — see
  `research/*grading*`, `research/apbio_*takeaways.md`, `research/*gold_set*`.
- **Formula/ECF (Engine 3):** `research/math_formula_grading_experiment_2026_07_08/`
  (`formula_checker.py` 62/62, `ecf_engine.py` 6/6, `hand_drawn_formula_assessment.md`),
  `research/statistics_phase_b_2026_07_08/` (Stats keys, bake-off, `bakeoff_report.md`),
  `research/AP_STATISTICS_VERIFICATION_PROFILE.json`.
- **Hand-drawn/Spatial (Engine 4):** `research/DRAWN_RESPONSE_ARCHITECTURE_REVIEW.md`,
  `research/hand_drawn_*`, TASK-0011.
- **Launch-gate / calibration:** `research/grading_launch_gate_audit_2026_07_08.md`,
  per-subject verification profiles (`AP_BIOLOGY_/AP_CHEMISTRY_/AP_PHYSICS_1_/AP_STATISTICS_VERIFICATION_PROFILE.json`).

## 5. Backend interface (what grading runs on)

The grading engines read/write Supabase Production `pcntajvbdfqhbeewmdry`
(`app.*` schema). The app's curated `public` interface over `app` (Phase 1 of the
backend consolidation) is **applied to Production**. Entry point for that
workstream: [`architecture/BACKEND_CONSOLIDATION_MIGRATION_PLAN_2026_07_08.md`](architecture/BACKEND_CONSOLIDATION_MIGRATION_PLAN_2026_07_08.md)
(+ `APP_SCHEMA_RECONCILIATION_2026_07_08.md`, `PHASE1_CURATED_INTERFACE_QA_FINDINGS_2026_07_09.md`).

## 6. Consolidation status (2026-07-09)

Grading work was **scattered across branches** (`claude/cramapple-grading-experiments-9lkjqc`,
`codex/five-subject-harness-and-content`, `claude/backend-migration-extract-6-files`,
`claude/cramapple-grading-mlr0o1`, …). This session **recovered the missing docs**
into the working tree from commits `e15d64b` / `a9e6ea4` / `a7438da` (rollout plan,
gate audit, TASK-0016, Phase-A QA findings, AP Stats profile, and the
`math_formula`/`statistics_phase_b` experiment folders — all verified current).

**Still open (Product Owner decision):** pick ONE canonical branch for grading and
gather everything onto it — including the Phase C prompts/artifacts that currently
live only on other branches. This hub is branch-agnostic; treat it as the map for
that gather.

## 7. How to continue

- **Phase B gate:** capture real hand-drawn formula photos (`statistics_phase_b_2026_07_08/capture_sheet.html`),
  re-run `bakeoff_runner.mjs` + `bakeoff_scorer.py` for the real silent-corruption number.
- **Phase C:** the adjudicated AP Statistics gold set is the launch gate; see Phase C prompts.
- **Frontend (E):** Lovable repoint onto the curated `public` interface + RPCs
  (per the backend plan) — needed before end-to-end Statistics grading is live.
- **Deterministic layer for Engine 1 is deployed** (2026-07-12) but only 5
  `content_key`s are seeded and real-traffic use is unverified (§2). Next steps
  before calling this done: (1) confirm via Supabase logs whether the path has
  ever actually fired, (2) confirm the 5 seeded `content_key`s correspond to
  live/published AP Statistics items in the DB (unverified — the seeded keys
  and the actual content bank have not been cross-checked against each other),
  (3) decide whether to seed more items or treat this as a narrow pilot.
