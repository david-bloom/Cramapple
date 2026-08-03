# Claude Execution Prompt - TASK-0013 Phase 6: AP Statistics Calibration Run

Use the AP Statistics calibration protocol to produce an evidence-backed grader-agreement report for the pilot batch.

## Goal

Run the AP Statistics calibration protocol described in `docs/research/AP_STATISTICS_PHASE6_CALIBRATION_PROTOCOL.md` and produce a report with documented agreement/confidence numbers, disagreement clusters, and a recommendation on whether the deterministic calculation verifier should be wired into live grading.

## Required Inputs

- Published AP Statistics pilot content with blind tutor scores already recorded.
- The Phase 3 deterministic calculation verifier.
- The existing AP-agnostic reviewer tables (`content_review_assignments`, `content_review_decisions`).
- Cross-credentialed reviewers only; no new tutor pool assumptions.

## What To Measure

1. Agreement between `evaluate-attempt` and blind tutor scores at the criterion level.
2. Agreement specifically on criteria covered by the deterministic calculation verifier.
3. Difference between LLM-alone agreement and LLM+verifier agreement.
4. Any disagreement clusters that need Learning Quality adjudication.
5. A confirmation that MCQ grading does not require special AP Statistics calibration beyond lookup correctness.

## Output

Write a report in `docs/research/` named `ap_statistics_phase6_calibration_report_<date>.md` that includes:

- the sample size used;
- agreement numbers and confidence notes;
- verified boundary-conflict examples;
- the verifier comparison;
- a plain-language recommendation on whether the verifier is ready for live use;
- any caveats about batch size or missing tutor coverage.

## Do Not Do

- Do not change grading logic during the calibration run.
- Do not treat synthetic test cases as the gold-set substitute.
- Do not make the final launch decision; report evidence only.

## Success Criteria

- The report is written.
- The report cites real tutor-scored data.
- The report is clear enough to support a launch-readiness discussion without extra reconstruction.
