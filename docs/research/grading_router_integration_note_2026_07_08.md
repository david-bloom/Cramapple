# Grading Router Integration Note - 2026-07-08

This note captures the Phase A integration shape for the grading and feedback
rollout so the implementation and the research plan stay aligned.

## Decision

- The TypeScript edge function remains the router and the owner of the current
  production MCQ/discrete-text flow.
- `rubric_type` and `evaluator_strategy` live on `app.content_item_versions`.
  When they are absent, the router falls back to the legacy `item_type`
  behavior so the existing Biology and Statistics text-grading path stays
  stable.
- Structured-formula grading is implemented in the Deno edge function as a
  shared TypeScript verifier module for this phase. The Python reference
  implementations remain the source of truth for the regression batteries and
  the future deployment split.
- Spatial and holistic items still route to shadow review instead of receiving
  a guessed automated score.
- AP Statistics items can now carry the subject verification profile through
  the grading response and the student-memory event trail, so feedback can be
  traced back to the declared key/ECF contract.
- The prototype UI now reads `feedback_preview` as the display target for the
  student-facing grading card, keeping the explanatory copy stable while the
  preview updates with the graded response.

## Why This Shape

- It keeps the router thin and keeps the fast MCQ/text paths in the edge
  function.
- It avoids pretending that SymPy exists inside the TS runtime.
- It preserves the existing grading behavior for launch subjects while making
  the future engine split explicit in data.

## Phase A implementation note

- For the typed-input launch path, the edge function now uses a shared
  TypeScript verifier module that ports the reference symbolic/ECF logic
  needed for born-digital formulas and AP Statistics key payloads.
- The Python reference implementations remain the source of truth for the
  regression batteries and for any future service split, but the first
  shipping boundary is in-process so the verifier can run without a second
  network hop.
- Latency implication: deterministic typed-formula checks stay in the same
  request budget as the existing edge function paths, so the p50 impact is
  expected to remain sub-second for verifier-owned criteria. The p90/p99 tail
  is still dominated by the LLM path when unresolved criteria fall through.
