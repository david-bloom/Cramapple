# Grading Launch Gate Audit - 2026-07-08

**Scope:** TASK-0016 grading and feedback rollout, audited against the current
worktree and the rollout spec.

This note is intentionally conservative. It records what is actually proven in
the repo right now, what is partially proven, and what remains open before the
launch gate can be considered met.

## Evidence summary

### 1. Router dispatch by `rubric_type`

Status: **proven for Phase A routing behavior**

Evidence:
- `supabase/functions/_shared/grading-router.ts`
- `supabase/functions/_shared/grading-router_test.ts`
- `supabase/functions/evaluate-attempt/index.ts`

What is proven:
- `mcq` routes to the deterministic exact-match path.
- Legacy FRQ items continue to the text grader.
- `structured_formula`, `spatial`, `holistic`, and unsupported metadata route to
  shadow review rather than guessing.

What remains open:
- Engine 3 is still shadow-only in production; the router is correct, but the
  symbolic verifier boundary is not yet deployed.

### 2. Engine 1 deterministic checks before the LLM

Status: **proven for the AP Statistics deterministic prefilter**

Evidence:
- `supabase/functions/_shared/statistics-verifier.ts`
- `supabase/functions/_shared/statistics-verifier_test.ts`
- `supabase/functions/evaluate-attempt/index.ts`
- `docs/research/AP_STATISTICS_VERIFICATION_PROFILE.json`

What is proven:
- The AP Statistics keyed numeric targets are checked deterministically.
- Canonical responses pass, known wrong responses flag, and conceptual/corpus
  defect items abstain.
- The deterministic path can build an uncertain scaffold fallback without
  calling the model.

What remains open:
- The launch gate still requires a broader adjudicated gold set and calibration
  against the required corpus size.
- Boundary-contract decisions for MOD3 and MOD6 remain open in Learning Quality.

### 3. Engine 3 typed formula grading with ABSTAIN-on-ambiguity

Status: **proven as a typed-input safety layer, not yet as a deployed full
verifier**

Evidence:
- `supabase/functions/_shared/formula-notation.ts`
- `supabase/functions/_shared/formula-notation_test.ts`
- `docs/research/math_formula_grading_experiment_2026_07_08/formula_checker.py`
- `docs/research/math_formula_grading_experiment_2026_07_08/ecf_engine.py`

What is proven:
- Ambiguous typed formulas are detected conservatively.
- The hint vocabulary normalizes to scaffold/review actions.
- The reference symbolic and ECF batteries are documented and validated in
  research.

What remains open:
- The production service boundary for symbolic+ECF is not wired in.
- Typed formula answers route to shadow review in the production edge function
  rather than full automated grading.

### 4. Engine 4 spatial/QR flow

Status: **not yet launched**

Evidence:
- `docs/research/grading_engine_rollout_plan_2026_07_08.md`
- `docs/research/DRAWN_RESPONSE_ARCHITECTURE_REVIEW.md`
- `docs/tasks/TASK-0011` references

What is proven:
- The spatial engine is scoped and researched.

What remains open:
- QR capture prototype, observation bake-off, and shadow operation are still
  pending.

### 5. Gold set and launch bar

Status: **partially prepared, not yet satisfied**

Evidence:
- `docs/research/ap_statistics_gold_set_candidate_2026_07_08/README.md`
- `docs/research/ap_statistics_gold_set_candidate_2026_07_08/provisional_labels.json`
- `docs/research/statistics_phase_b_2026_07_08/README.md`
- `docs/research/statistics_phase_b_2026_07_08/statistics_item_keys.json`

What is proven:
- A calibration-ready AP Statistics candidate corpus exists.
- Deterministic keys and ECF templates are authored for the highest-value
  launch-candidate items.

What remains open:
- The corpus is not yet adjudicated gold.
- The 100 MCQ + 100 FRQ + 10 investigative-task launch bar has not been measured
  against the adjudicated set.

### 6. Phase A integration contract

Status: **documented**

Evidence:
- `docs/research/grading_router_integration_note_2026_07_08.md`
- `prototypes/ux-001/index.html`
- `supabase/functions/_shared/evaluate-attempt-response.ts`
- `supabase/functions/evaluate-attempt_test.ts`
- `supabase/functions/_shared/student-memory.ts`
- `supabase/functions/_shared/student-memory_test.ts`
- `prototypes/ux-001/index.html`

What is proven:
- The TypeScript edge function remains the router.
- Structured-formula grading is expected to live behind a separate verifier
  boundary rather than inside the Deno function.
- Deterministic-check provenance is now surfaced in the prototype's uncertain
  state and repair panel, so the feedback path is visible end to end instead of
  stopping at the backend payload.
- The final evaluate-attempt response envelope now has a dedicated regression to
  keep `deterministic_check`, `feedback_preview`, and `runtime_context`
  together in the returned JSON object.
- The final result assembly now has a dedicated regression that proves a
  flagged deterministic check still yields scaffold/repair guidance even when
  the graded payload itself does not provide those hints.
- The final result assembly also has a conservative regression for non-flagged
  deterministic checks, proving the builder does not invent scaffold guidance
  or repair text and instead falls back to the rubric gap.
- The final result assembly now also proves explicit grader hints outrank the
  deterministic fallback, so review_context and custom repair text are not
  flattened away when the model already supplied them.
- The grading runtime context now preserves the learner-facing feedback trail,
  including preview text, action hint, repair hint, and deterministic-check
  provenance, so later sessions can inherit the same guidance that was shown.
- The evaluate-attempt call sites now thread that same feedback trail into the
  runtime context on both the MCQ and non-MCQ grading paths, so the persisted
  session state matches the live feedback envelope.
- The student-memory event writer now stores the same feedback trail fields in
  `event_payload`, so the persisted event record contains the preview, hints,
  and deterministic-check provenance alongside the session memory snapshot.
- The prototype home and progress views now surface the latest feedback preview,
  hint, repair text, and deterministic-check provenance from the runtime
  context, so the session’s feedback history is visible in the running portal.
- The uncertain state now also shows the remembered feedback trail from runtime
  context, so the safe-failure view and the persistent session memory stay in
  sync for the current attempt.
- The completion screen now also shows the remembered feedback trail from
  runtime context, so session end preserves the latest learner-facing guidance
  instead of dropping back to a generic completion card.
- The prototype now uses a shared feedback-trail formatter across the runtime-
  context views, keeping the remembered preview, hints, and check provenance
  consistent on home, progress, uncertain, and completion screens.
- The preview runtime context now seeds the same feedback-trail shape as the
  live context, so the offline/demo prototype shows the same remembered feedback
  behavior instead of falling back to a generic summary-only state.
- The runtime-context summary helper now also reads remembered feedback summary
  fields directly, so the preview/offline memory note matches the same grading
  trail even when the backend is absent.
- The MCQ and FRQ attempt cards now also display the remembered feedback trail
  after grading, so the live attempt result cards and the runtime-context memory
  note point at the same persisted guidance.
- The live runtime-context loader now preserves the feedback trail into
  `effective_guidance`, so the persisted snapshot and the rendered portal use
  the same remembered preview, hint, repair, and deterministic-check fields.

### 7. Current blockers to full completion

Still open:
- Adjudicated AP Statistics gold set.
- Calibration against the launch bar.
- Engine 4 spatial capture and shadow pipeline.
- Production launch readiness review.

## Bottom line

The repository now has a real Phase A routing contract, AP Statistics
deterministic evidence, typed-formula ambiguity handling, and learner-facing
feedback that preserves deterministic provenance through the prototype and the
returned edge-function envelope. That is meaningful progress, but it is not the
full TASK-0016 end state yet because the gold set, calibration, and spatial
engine remain incomplete.
