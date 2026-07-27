# TASK-0016 — Multi-Rubric Grading & Feedback Engine Rollout

**Task ID:** TASK-0016
**Title:** Build and deploy the grading/feedback engines for the four rubric
types, launching AP Statistics end-to-end first
**Owner:** Main Conductor
**Product Owner:** David Bloom
**Tier:** Hard-Gate
**Status:** Approved — Phase A In Progress
**Priority:** High
**Created Date:** 2026-07-08
**Approved Date:** 2026-07-08 (`APPROVAL-0033` — task opened + Phase A go-ahead)

## Product Goal

Stand up a unified grading pipeline that dispatches each question to the correct
evaluator engine by rubric type, so Cramapple can roll out any exam that relies
on those rubric types. Launch **AP Statistics end-to-end first** as the proving
subject, then reuse the same engines across the math-heavy subject family and,
later, the holistic-essay subjects.

The four engines (determinism-of-rubric taxonomy):

1. **Discrete/Analytical Text** — point-by-point analytic (in production today).
2. **Holistic/Evaluative Text** — rubric-matrix essays (confirmed goal, sequenced
   last; serves AP English/History, not in this launch).
3. **Structured Multi-Modal** — equations/formulas with Error-Carried-Forward.
4. **Spatial Multi-Modal** — graphs/curves/diagrams.

Grounding docs: `docs/research/grading_engine_rollout_plan_2026_07_08.md` (the
readiness + gap analysis and the RESOLVED owner decisions),
`docs/research/math_formula_grading_experiment_2026_07_08/` (symbolic checker +
`ecf_engine.py` reference + hand-drawn assessment),
`docs/research/deterministic_check_experiment_2026_07_08/` (numeric checker),
`docs/research/DRAWN_RESPONSE_ARCHITECTURE_REVIEW.md` + `TASK-0011` (spatial),
`docs/research/grading_cross_subject_takeaways.md` (binding lessons),
`supabase/functions/evaluate-attempt/`, `grade-frq/`.

## Resolved Decisions (Product Owner, 2026-07-08)

- **First launch subject:** AP Statistics.
- **Launch bar (Statistics beta gate):** grade a corpus of **100 MCQ + 100 FRQ +
  10 Investigative-Task** items at **≥95% accuracy** (criterion-level agreement
  with adjudicated labels), within the latency and cost ceilings below. Lighter
  than governance §12.2 by explicit owner decision.
- **Targets are ceilings — "stay under"** (confirmed 2026-07-08): a grader slower
  or costlier than the target fails the bar.
  - **Cost:** ≤ **$0.01/item** (reported, not a hard billing gate; BYOK is a CAC).
  - **Latency — measured end-to-end (student experience: from the student
    pressing submit to feedback fully rendered on their device), reported at
    p50 / p90 / p99, segmented per engine / input modality.** p50 ≤ 1000 ms is
    the confirmed ceiling (typical case). p90 and p99 are **measure-and-report
    first** to characterize "by when most students are done" (p90) and "how long
    the long tail runs" (p99); the Product Owner sets hard p90/p99 gates after
    the first observed distribution. See the QA Plan for the segment breakdown.
- **Minors' images:** approved (Ts&Cs cover PII; handwriting is not PII).
  Incidental identifying marks handled operationally (EXIF strip + name-region
  guidance).
- **Rollout mode:** shadow-first (100% human review, non-authoritative); limited
  release may run semi- or no human review.
- **Provider funding:** BYOK is a CAC; ceiling TBD; not launch-blocking.
- **Engine 3 input:** typed plain-text + parser is the Stats MVP (near-zero new
  frontend); structured equation editor is post-MVP.
- **Engine 3 ECF:** naked answer (no work shown) → no ECF **and trigger the
  "help"/scaffolding feature**.
- **Engine 4 MVP:** QR-handoff capture; other capture options post-MVP.
- **Engine 1:** AP Bio publishing authorized under the Statistics rules.
- **Rights:** no direct use of College Board content; permitted use is only to
  understand the exams and inform grading.

## Technical Scope

1. **Evaluator-strategy router.** Add a `rubric_type` / `evaluator_strategy`
   field to the question/content model and a dispatcher in the grading path that
   routes each item to the correct engine. One core pipeline; per-question config
   object; each engine a replaceable strategy.
2. **Engine 1 — wire the proven deterministic layer to production.** Run the
   numeric/structural deterministic checker + criterion-boundary contracts
   *before* the LLM grader; let deterministic checks own the criteria they can
   decide and abstain otherwise. Version-pin checker + boundary contract to the
   grading result.
3. **Engine 3 — symbolic + ECF.** Integrate the symbolic equivalence checker and
   the `ecf_engine.py` cascade (two-universe state machine, the four guardrails,
   per-part point-maximizing feedback, naked-answer→help). Typed path first.
4. **Engine 4 — spatial (QR MVP).** Advance `TASK-0011`: QR-handoff capture,
   observation bake-off, then dual-human gold + calibrated abstention + shadow.
5. **Gold sets (the launch gate).** Build the adjudicated AP Statistics gold set
   sized to the launch bar; depth over breadth.
6. **Frontend.** Lovable: expose the Statistics grading experience (typed answer
   submission already exists; add QR capture for graph items; render criterion +
   ECF feedback; wire the "help" trigger on naked answers).

## Out of Scope

- Engine 2 (Holistic) build — sequenced after this task.
- Structured equation-editor input, non-QR capture, and unit-correctness
  criteria — all post-MVP fast-follows.
- Production launch of subjects other than AP Statistics (engines are built to
  generalize, but only Statistics is driven to launch here).
- Any single-pass learner-facing automated score before shadow gates pass.

## Routes / Components / Systems Affected

- `supabase/functions/evaluate-attempt/index.ts`, `grade-frq/index.ts`
- New: deterministic + symbolic + ECF verification services; the router
- `app` content schema (add `rubric_type` / `evaluator_strategy`;
  `verification_profile` per-item keys + ECF templates)
- Capture/upload path (QR handoff, storage, signed retrieval) per TASK-0011
- Subject/practice frontend routes (Lovable)

## Acceptance Criteria

- [ ] Router dispatches each question to the correct engine by `rubric_type`;
      AP Biology/Statistics text grading is unchanged where already correct.
- [ ] Engine 1 runs deterministic checks + boundary contracts before the LLM
      grader in production, version-pinned to the result.
- [ ] Engine 3 grades typed formula answers with algebraic-equivalence + ECF,
      including the four guardrails and naked-answer→help; behavior matches the
      `ecf_engine.py` reference battery.
- [ ] Engine 4 QR-handoff capture prototype works end-to-end into shadow grading
      (no learner-facing authoritative score).
- [ ] An adjudicated AP Statistics gold set exists sized to the launch bar.
- [ ] The launch bar is measured and met on that gold set: ≥95% agreement,
      end-to-end p50 ≤ 1000 ms (per engine/modality), cost ≤ $0.01/item, plus
      feedback-quality metrics (Lesson 6); p90/p99 measured and reported.
- [ ] AP Statistics is gradeable end-to-end in a non-production environment in
      shadow mode.
- [ ] Delegations executed (below).

## QA Plan

- Regression: AP Biology/Statistics text grading unchanged after the router and
  deterministic wiring land.
- Deterministic layers: `formula_checker.py` (62/62) and `ecf_engine.py` (6/6)
  batteries run in CI as regression gates; extend with Statistics items.
- Calibration: measure the launch bar against the adjudicated gold set; report
  criterion agreement, feedback grounding, minimum-fix sufficiency, and cost.
- **End-to-end latency measurement (student experience).** Measure wall-clock
  from submit → feedback rendered, reported at **p50 / p90 / p99** and
  **segmented per engine / input modality** (typed-text vs. QR-photo distributions
  differ by ~an order of magnitude — a blended percentile hides the story, so
  they are reported separately, never only pooled). Also capture the **per-stage
  breakdown** so the tail is attributable: capture+upload (image paths), any
  extraction/transcription pass, deterministic checks, LLM grader call, and
  render. Interpretation: p50 = typical experience, p90 = "by when most students
  are done," p99 = long-tail length. Expected tail drivers to watch: image
  upload/vision calls (Engines 3-photo, 4) and any model-call retries. The
  deterministic-first architecture is the primary lever to hold p50 ≤ 1000 ms —
  MCQ and any criterion the deterministic layer owns return in ms with no model
  call. *Note: a single LLM criterion-grading call can itself exceed 1 s, so the
  p50 ceiling is aggressive for the FRQ engine specifically; the calibration run
  will show where we stand and whether routing/optimization is needed
  (quality > speed > cost priority).*
- Failure cases: typed-notation ambiguity (ABSTAIN, not false-flag), ECF chain
  breaks, coincidental-canonical, naked answers, capture-quality rejects.

## Implementation Notes — Delegation Plan

| Phase | Work | Delegate | Depends on | Status |
|---|---|---|---|---|
| **A** | Router + wire deterministic checker + boundary contracts (Engine 1); integrate symbolic + ECF typed path (Engine 3) | **Codex** (backend), **Orly/David** (boundary contracts) | — | **Handed off** — brief `prompts/CODEX_TASK0016_PHASE_A_GRADING_ROUTER_AND_ENGINES.md` (2026-07-08) |
| **B** | Engine 3 hand-drawn: transcription-fidelity bake-off; author `verification_profile` keys + ECF templates for Statistics | **Claude** (keys/protocol/corpus/runner/scorer + live run), **human** (real-handwriting capture) | A; gateway creds (obtained 2026-07-09) + real formula photos (for the gating run) | **Keys/profile DONE (8/8 + 3/3). Live bake-off EXECUTED 2026-07-09** on synthetic xkcd renders: gpt-5.5 / gemini-2.5-flash / claude-haiku-4-5 each **9/9 faithful, 0 silent corruption** (`bakeoff_report.md`) — validates the pipeline, sets an optimistic upper bound. **Remaining gate:** re-run on human-captured formula photos for the real silent-corruption number. |
| **C** | Adjudicated AP Statistics gold set to the launch bar; calibration run | **QA / Learning Quality** + tutors, **David** approval | A | Pending (the launch gate) |
| **D** | Engine 4 spatial (QR MVP) end-to-end into shadow | **Codex** + **Lovable**, per TASK-0011 | A; minor-image approval (granted) | Pending (longest pole) |
| **E** | Frontend: Statistics grading experience, QR capture, feedback + help rendering | **Lovable** | A–D | Pending |
| **F** | Launch readiness review | **David** | All above | Pending |
| — | Engine 2 (Holistic) | deferred | future English/History | Not in this task |

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate (production launch is a separate gate)
**Decision:** Pending Product Owner approval to open the task. Phase A needs no
further approvals (no gateway creds or image data required); Phases B/D need the
already-granted minor-image approval plus gateway credentials.

## Done Decision

**Decision:** Pending
**Date:** Pending
