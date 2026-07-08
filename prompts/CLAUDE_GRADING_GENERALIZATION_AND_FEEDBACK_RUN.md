# Claude Execution Prompt - Grading Generalization and Feedback Run

Use the preregistered protocol in
`docs/research/grading_generalization_and_feedback_protocol_2026_07_08.md`
to evaluate both the cross-subject generalization hypothesis and the
feedback-quality hypothesis.

## Goal

Compare the winning architecture against the frontier-model control on the
three silver corpora, then score the feedback on every missed point for:

1. reason match;
2. minimum-fix sufficiency; and
3. grounding in the student response.

This is a pre-registered run. Do not rewrite the protocol while executing it.

## Required Inputs

- `docs/research/grading_generalization_and_feedback_protocol_2026_07_08.md`
- `docs/research/GRADING_RESEARCH_CANONICAL_PROCESS.md`
- `docs/research/grading_cross_subject_takeaways.md`
- AP Biology / Chemistry / Statistics silver package READMEs and manifests
- the relevant subject verification profiles
- the frozen control-model name recorded in the run manifest

## Execution Rules

- Use the approved multi-provider gateway path with OIDC/BYOK as configured.
- Respect the daily budget cap and burn known cost on failed or rejected calls.
- Keep the corpus, rubric, and boundary contracts frozen.
- Use the same response order, output schema, and scoring instructions for both
  arms.
- Keep AP Statistics `MOD8` isolated as a corpus defect rather than letting it
  contaminate the main agreement claim.

## What to Produce

### 1. Generalization report

Report pooled and per-subject:

- criterion exact agreement;
- total-point agreement where available;
- over-credit and under-credit counts;
- schema validity;
- p50 and p95 latency;
- average cost per response;
- any subject-specific regressions;
- any adjudication-queue items that look like rubric/label problems.

### 2. Feedback-quality report

For every missed criterion, record:

- the model feedback text;
- the corpus source-of-truth for the missed point;
- whether the stated withholding reason matches the source-of-truth;
- whether the minimum fix would actually earn the point;
- whether the feedback is grounded in the response text;
- a short note when the corpus itself is defective or ambiguous.

### 3. Output files

Write:

- a dated `*_report.md` in `docs/research/`;
- a `*_summary.json` if the run script emits machine-readable metrics;
- a short takeaways doc if a stable lesson emerges.

## Do Not

- Do not change the rubric or boundary contract mid-run.
- Do not use one arm's output to tune the other arm during the same run.
- Do not count corpus defects as model errors.
- Do not claim release readiness from this run alone.

## Success Criteria

- The report is written.
- The comparison is traceable to the frozen corpus versions.
- The feedback metrics are scored for every missed criterion.
- The budget rule is obeyed and documented.

