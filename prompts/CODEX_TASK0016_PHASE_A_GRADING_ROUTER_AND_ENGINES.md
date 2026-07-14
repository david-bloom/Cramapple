# Codex Execution Prompt — TASK-0016 Phase A: Evaluator-Strategy Router + Wire Deterministic (Engine 1) + Symbolic/ECF Typed Path (Engine 3)

**Cleared to execute** (`APPROVAL-0033`, 2026-07-08). Phase A needs **no gateway
credentials and no student-image data** — everything here is router plumbing,
deterministic logic, and typed-text formula grading. Production launch remains a
separate Hard Gate; nothing here ships a learner-facing authoritative score
(shadow-first only).

## Read first (do not skip — these are the spec and the reference code)

1. `docs/tasks/TASK-0016-GRADING-ENGINE-ROLLOUT.md` — the task, resolved owner
   decisions, acceptance criteria, and the launch bar.
2. `docs/research/grading_engine_rollout_plan_2026_07_08.md` — the four-engine
   readiness/gap analysis and the "Decisions RESOLVED" section.
3. `docs/research/grading_cross_subject_takeaways.md` — the binding lessons.
   Lessons 1–4 in particular: deterministic-before-model, single fast grader as
   default, boundary contracts are the dominant quality lever, self-reported
   confidence is not a trigger.
4. **Reference implementations built this session (the logic you are integrating,
   not inventing):**
   - `docs/research/deterministic_check_experiment_2026_07_08/checker.py` — the
     numeric-presence checker (100% specificity).
   - `docs/research/math_formula_grading_experiment_2026_07_08/formula_checker.py`
     — symbolic algebraic-equivalence checker (expression / antiderivative-with-C
     / numeric / conceptual-ABSTAIN; 62/62 dev battery).
   - `docs/research/math_formula_grading_experiment_2026_07_08/ecf_engine.py` —
     the Error-Carried-Forward state machine (6/6 dev battery). **This is your
     ECF reference; match its verdict set and chain-of-custody logic.**
   - **Phase B payload (real content to grade against, not a stub — authored +
     validated 2026-07-08):**
     `docs/research/AP_STATISTICS_VERIFICATION_PROFILE.json` (the subject profile
     + key schema) and
     `docs/research/statistics_phase_b_2026_07_08/statistics_item_keys.json` (per-
     item deterministic keys + ECF templates for the 5 gold items), validated by
     `docs/research/statistics_phase_b_2026_07_08/validate_keys.py` (8/8 canonical
     integrity, 3/3 ECF). Use this as the concrete `verification_profile` payload
     shape — do NOT invent one.
5. `scripts/misattribution-check/checker.py` — the repo's standalone-deterministic
   module pattern (stdin JSONL → stdout JSONL verdicts, no LLM). Follow this shape
   for any new deterministic module; do not invent a new protocol.
6. `supabase/functions/evaluate-attempt/index.ts` and `grade-frq/index.ts` — the
   current production grader (single-model, criterion-by-criterion, text-only).

## Context

Today the production grader is one text-only LLM path. Everything proven in
research — the numeric checker, the symbolic + ECF checkers, boundary contracts —
is **not wired into production** (zero references to `verification_profile` /
deterministic / ECF in `supabase/functions/`). Phase A closes that gap for the
first launch subject, **AP Statistics**, and builds the connective tissue that
lets any subject route to the right engine.

## Goal

Three deliverables, sequenced:

1. an **evaluator-strategy router** that dispatches each question to the correct
   engine by a `rubric_type` field;
2. **Engine 1** wired so deterministic checks + boundary contracts run **before**
   the LLM grader and own the criteria they can decide;
3. **Engine 3** integrated for **typed** formula answers: algebraic-equivalence +
   ECF, using the reference logic above.

## Scope

### A1 — Evaluator-strategy router

1. Add a `rubric_type` / `evaluator_strategy` field to the question/content model
   (propose the migration; do not apply to production without Phase-2-style
   sign-off — state the shape and assumptions if the schema is uncertain).
   Strategy values at minimum: `discrete_text` (Engine 1), `structured_formula`
   (Engine 3), `mcq` (deterministic exact/near match), `spatial` (Engine 4 —
   **route to a human/shadow placeholder for now**, do not build), `holistic`
   (Engine 2 — placeholder, deferred).
2. Build the dispatcher in the grading path. It must be **extensible** — Engines
   2 and 4 slot in later without rework — and must **route unsupported/uncertain
   types to human/shadow review, never error or silently pass**.
3. Keep the router a thin dispatch layer; each engine stays a replaceable
   strategy behind one contract (per-question config object in, criterion results
   out).

### A2 — Engine 1: wire the deterministic layer + boundary contracts

1. Run deterministic checks **before** the LLM grader. A criterion the
   deterministic layer can decide (e.g. a keyed numeric answer, an MCQ) is
   returned without a model call; everything else falls through to the LLM
   criterion grader. This is the primary lever for the p50 ≤ 1000 ms end-to-end
   ceiling (MCQ + deterministic-owned criteria return in ms).
2. Version-pin the deterministic checker version + criterion-boundary-contract
   version to each grading result, alongside the existing prompt/model pinning.
3. Preserve current Biology/Statistics text-grading behavior where it is already
   correct (regression safety is an acceptance criterion).

### A3 — Engine 3: symbolic + ECF for typed answers

1. Integrate the `formula_checker.py` equivalence logic and the `ecf_engine.py`
   cascade for criteria whose answers are formulas/derivations. Match the
   reference verdict set: `CORRECT` / `CORRECT_VIA_ECF` / `CONCEPTUAL_COLLAPSE` /
   `COINCIDENTAL` / `NAKED_ANSWER` / `INCORRECT`, and the chain-of-custody logic
   (decide on the student's own declared inputs, not by re-comparing recomputed
   floats — this is what makes it robust to intermediate rounding; `REL_TOL` is a
   per-item knob).
2. **Naked answer (no work shown) → do NOT apply ECF AND emit the "help"
   trigger** (owner decision 2026-07-08). Surface this as a distinct result the
   frontend can act on, not a plain zero.
3. **Notation-ambiguity rule (critical):** on typed input the checker must
   **ABSTAIN to the LLM/human on ambiguous or unparseable input, never
   false-FLAG** (e.g. the `3t^2/2t` flat-fraction hazard documented in the
   experiment's `report.md`). Preserve the 100%-specificity property — a false
   flag on correct work is the worst outcome.
4. Typed path only in Phase A. Hand-drawn transcription is Phase B and must not be
   assumed here; Engine 3 receives already-typed expressions.
5. Grade against the real Statistics payload above (`statistics_item_keys.json` +
   `AP_STATISTICS_VERIFICATION_PROFILE.json`), including the MOD3/MOD6/MOD7 ECF
   cascades, so the integration is exercised on validated content, not a stub.
   The two open boundary-contract questions in the profile
   (`open_boundary_contract_questions`) are Learning Quality's to resolve — do not
   hard-code a z-vs-t choice; read the accepted value(s) from the key payload.

### Key architectural decision to resolve and document

The production grader is **TypeScript (Deno edge functions)**; the reference
checkers are **Python**, and the symbolic layer depends on **SymPy**, which has
no mature TS equivalent. Decide and document the integration shape — e.g. the
numeric/MCQ deterministic checks ported to TS in the edge function, with the
**symbolic + ECF** layer served by a Python verification service the edge
function calls. Propose the deployment shape (separate Python Supabase function /
external service / Pyodide-WASM) with a short rationale; do not silently pick one.
State the latency implication for the end-to-end p50/p90/p99 budget.

## Out of Scope (Phase A)

- Any hand-drawn / image path, transcription, or OCR (Phase B/D).
- Engine 4 (spatial) build and Engine 2 (holistic) build — router placeholders
  only.
- Unit-correctness criteria and the structured equation-editor frontend
  (post-MVP; keep units model-owned for now).
- The adjudicated AP Statistics gold set and the calibration run (Phase C).
- Applying any migration to production or shipping a learner-facing automated
  score.
- Gateway/model-provider selection.

## Required Evidence on Completion

- The router + both engine integrations, with the reference batteries
  (`formula_checker.py` 62/62, `ecf_engine.py` 6/6) runnable in CI as regression
  gates, plus new tests covering router dispatch (including the
  unsupported-type → human/shadow path) and the ABSTAIN-on-ambiguity behavior.
- A short note on the TS/Python integration decision and its latency implication.
- A short note on the assumed `rubric_type` schema shape and what changes if the
  applied migration differs.
- Confirmation that Biology/Statistics text grading is unchanged (regression).

## Do Not Touch

- Production environment, secrets, or deployment config.
- Applying migrations to live `app.*` schema without separate sign-off.
- Any learner-facing authoritative scoring (shadow-first only).

## Next Expected Output

A PR against `main`, branch-prefixed `codex/...`, referencing `TASK-0016` and
`APPROVAL-0033`, ready for the repo's standard independent QA pattern
(fresh-context review, claims verified from source, Pass/Fail with file:line
findings — no self-certification).
