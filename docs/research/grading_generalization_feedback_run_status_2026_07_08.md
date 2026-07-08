# Grading Generalization & Feedback Run — Status & Readiness, 2026-07-08

**This is a status/readiness record, NOT a results report.** No generalization or
feedback numbers appear here because the live run was not executed. See "Blocker."

**Protocol:** `grading_generalization_and_feedback_protocol_2026_07_08.md` (preregistered; not modified)
**Related:** `grading_label_adjudication_queue_2026_07_08.md` (satisfies the "adjudication-queue items that look like rubric/label problems" reporting requirement)

## Blocker (evidence-based)

The protocol's Experiment A/B require live multi-provider gateway scoring
(winning fast-grader arm vs a frozen frontier control) via OIDC/BYOK. **This
session has no gateway credentials**, so the runners cannot execute:

- The runners (`scripts/vercel-gateway-check/*.mjs`) require one of
  `AI_GATEWAY_API_KEY`, `VERCEL_OIDC_TOKEN`, or `OPENAI_API_KEY` and `fail()` by
  design without them (e.g. `next_protocol.mjs:820`, `sp1_pilot.mjs:262`).
- Probe result this session: `VERCEL_OIDC_TOKEN` absent, `AI_GATEWAY_API_KEY`
  absent, no provider key present.
- No frozen run manifest / control-model name exists yet, which the protocol
  requires *before any scoring* (§Arms, §Provider and Auth Requirements).

Consequently the live-model agreement, latency, cost, and feedback-quality
metrics cannot be produced here. Per the canonical process and basic integrity,
**these numbers are not fabricated or estimated.** If Codex already executed the
run, point me at its output files and I will verify/analyze them against the
protocol's pass/fail logic instead.

## What is ready (frozen inputs verified)

All Experiment A/B inputs exist, are internally consistent, and are frozen:

| Input | Status |
| --- | --- |
| AP Biology silver package | present; 5 items / 20 responses / 88 judgments; L-009/a corrected |
| AP Chemistry silver package | present; variants `v2_wrong_reasoning_2026_07_08`; `injected_error` on all 200 wrong responses (clean reason-match signal) |
| AP Statistics silver package | present; MOD8 flagged as corpus defect to isolate |
| Verification profiles | `AP_BIOLOGY_/AP_CHEMISTRY_/AP_PHYSICS_1_VERIFICATION_PROFILE.json` |
| Deterministic checker (feedback reason-match + numeric scoring) | `deterministic_check_experiment_2026_07_08/checker.py` (100% specificity) |
| Adjudication / label queue | `grading_label_adjudication_queue_2026_07_08.md` |

## Turnkey scaffold to execute in the gateway environment

1. **Freeze the manifest.** Fill `grading_generalization_feedback_run_manifest_2026_07_08.json`
   (this folder) — set `control_model` (frontier) and `winning_arch.grader_model`
   (one fast model) before any scoring. Record any change to `control_model` in
   the manifest before examining output.
2. **Reuse an existing runner.** `next_protocol.mjs` / `sp1_pilot.mjs` already
   implement the two-arm gateway pattern, structured output, budget/cost logging,
   and the DECISION-0030 burn rule. Point them at the three silver corpora and
   the frozen manifest; keep response order, output schema, and scoring
   instructions identical across arms.
3. **Feedback arm.** Require the four feedback fields (withheld-point reason,
   minimum fix, improved answer, error classification) per missed criterion.
   Score reason-match against: Chemistry `injected_error`; Biology adjudication
   note + boundary contract; Statistics deterministic-check target / corpus-defect
   note. Score minimum-fix and grounding as `match|partial|mismatch|unable`.
4. **Isolate MOD8.** Exclude its value-specific claims from the main agreement
   number (corpus defect, item #2 in the adjudication queue).
5. **Report** to `docs/research/` per the protocol's Reporting Requirements
   (pooled + per-subject agreement, feedback metrics by subject and arm, cost,
   latency, exclusions, and the default-architecture recommendation).

## Cross-validation already done (no gateway needed)

The protocol asks the report to surface "adjudication queue items that look like
rubric/label problems rather than model failures." That analysis is complete and
independent of the model run: Codex's third-opinion review and the Claude
label-robustness re-grade **converge**, and the consolidated, ranked queue is in
`grading_label_adjudication_queue_2026_07_08.md`. The two passes agree on every
boundary item and on the MOD8 corpus defect, and both confirm the L-009/a
under-credit correction — strong evidence the silver labels are sound outside the
listed boundaries.

## Not claimed

- No generalization result, no feedback-quality result, no cost/latency — the
  live arms did not run.
- No release-readiness (the protocol forbids claiming it from this run anyway).
- No same-model regrade is treated as independent adjudication.
