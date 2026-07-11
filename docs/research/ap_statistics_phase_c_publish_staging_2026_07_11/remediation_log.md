# TASK-0016 Phase C Publish Packet Remediation Log

Date: 2026-07-11  
Scope: R1-R3 response to `qa_review.md`; no staging or publish action executed

This log records implementation evidence only. It does not certify the packet
as stage-ready; that determination remains with independent QA and the Product
Owner.

## R1: Self-Contained Inputs

All nine generator inputs were absent from `main`; none existed there under an
alternate path. Each is now committed to PR #36 at the exact path consumed by
the generator.

| generator input | resolution and provenance |
| --- | --- |
| `ap_statistics_gold_set_candidate_2026_07_09/provisional_labels.json` | Committed from the tracked Phase C source branch, then corrected at source for R2/R3. |
| `ap_statistics_gold_set_candidate_2026_07_09/manifest.json` | Committed unchanged from the tracked Phase C source branch. |
| `ap_statistics_mcq_launch_bank_2026_07_09/ap_statistics_mcq_launch_bank_2026_07_09.json` | Committed byte-for-byte from the local research artifact used to build the original packet. |
| `ap_statistics_phase4_mcq_smoke_batch_2026_07_01/ap_statistics_mcq_smoke_batch.json` | Committed unchanged from the tracked Phase C source branch. |
| `ap_statistics_phase4_mcq_smoke_batch_2026_07_01/ap_statistics_frq_batch_2026_07_01.json` | Committed unchanged from the tracked Phase C source branch. |
| `statistics_phase_b_2026_07_08/statistics_item_keys.json` | Committed from the local research artifact and corrected for R2's sample-SD key. |
| `AP_STATISTICS_VERIFICATION_PROFILE.json` | Committed byte-for-byte from the newer local profile used by the original packet; the older tracked profile was rejected because it regenerated stale `unkeyed` dispositions. |
| `ap_statistics_phase_c_calibration_dryrun_2026_07_11/summary.json` | Committed unchanged from the tracked Phase C source branch. |
| `ap_statistics_gold_set_candidate_2026_07_09/adjudication_queue.csv` | Committed unchanged from the tracked Phase C source branch. |

The required validator is also committed. Its actual local dependencies,
`math_formula_grading_experiment_2026_07_08/ecf_engine.py` and
`formula_checker.py`, are included so the command is runnable rather than
merely present.

Detached reproducibility command:

```text
git worktree add --detach /private/tmp/task0016-remediation-repro HEAD
node scripts/build_task0016_phase_c_publish_packet.mjs
node -e '<semantic deep-equality comparison of both bulk_import_payload.json files>'
```

Result: generator exit `0`; semantic comparison exit `0`; regenerated payload
contains the same 200 items and field values as the committed payload. The
detached worktree is the separate temporary output directory, so the committed
packet was not overwritten by this test.

## R2: Sample Standard Deviation

`APSTAT-MOD5-M001` is corrected throughout the source pipeline:

- Mean: `20`.
- Squared-deviation sum: `250`.
- Wrong population calculation: `sqrt(250/5) = sqrt(50) = 7.071068`.
- Correct sample calculation: `sqrt(250/(5-1)) = sqrt(62.5) = 7.905694`,
  reported as approximately `7.91`.

The upstream rubric, fully-correct synthetic response, deterministic target
note, deterministic formula, part id, and canonical value now agree. The
regenerated payload carries `7.91`; no payload-only patch was used.

Corpus scan covered every FRQ whose question text says `sample` and whose item
contains `standard deviation`/`SD`, plus the MCQ bank for population-versus-
sample denominator language. No additional defect required correction.
`STATS-MOD1-M002` already correctly uses `40/(5-1)` and `sqrt(10) = 3.16`.
Other matches use a supplied sample SD to calculate a standard error or
confidence interval and do not compute SD with an n-versus-n-1 denominator.

Validator command and result:

```text
python3 docs/research/statistics_phase_b_2026_07_08/validate_keys.py
```

Exit `0`: `44/44` keys internally consistent; `7/7` ECF templates behave
correctly; `ALL CHECKS PASS`.

## R3: Eight Answerability Fixes

| content key | option | resolution |
| --- | --- | --- |
| `APSTAT-MOD4-M004` | B | Rewrote the stem to state the upward, roughly linear, moderate-to-strong pattern and absence of outliers; rubric and fully-correct response use only those supplied facts. |
| `APSTAT-MOD5-M003` | A | Added five histogram-bin counts and keyed an approximately symmetric, unimodal distribution centered in the 70s. |
| `APSTAT-MOD6-M004` | B | Replaced the graph reference with a text-only CLT problem specifying a right-skewed population and `n = 50`; rubric now requires shape, center, and `sigma/sqrt(50)`. |
| `APSTAT-MOD6-H004` | A | Added a precise residual-plot description: random around zero, constant spread, no curve or isolated outlier. |
| `APSTAT-MOD6-H002-INV` | B | Replaced the missing raw data/plots with supplied summaries, regression equation, R-squared, observed range, and residual description; asks for interpretation and model assessment rather than impossible reconstruction. |
| `APSTAT-MOD8-M003` | A | Added `y-hat = 10 + 2.5x`, observed range `0-20`, and new `x = 12`; keyed prediction is `40` with an interpolation/uncertainty limitation. |
| `STATS-MOD3-H009` | A | Added six test-score histogram-bin counts and keyed the resulting left-skewed, high-score-concentrated interpretation. |
| `STATS-MOD4-H014` | A | Added all four cells of a 2 x 2 tutoring-frequency by practice-type factorial design; rubric requires factors, levels, main effects, interaction, and random assignment. |

No item was deleted, so the payload remains 100 MCQ + 100 FRQ. MCQ payload
content was unchanged: its pre/post-regeneration semantic SHA-256 remained
`800a3c3edd0727090a4a97f4b048c9af0a1d3a5eb1f1e3f3e8c6ccf8163e9901`.

## Post-Remediation Checks

`node scripts/build_task0016_phase_c_publish_packet.mjs` exited `0`: 200 items,
100 MCQ, 100 FRQ, 18 known collisions renamed, zero duplicate staged keys,
and zero unresolved known collisions.

The same fail-closed checker used by QA was rerun:

```text
node /private/tmp/task0016_qa_checks.mjs \
  docs/research/ap_statistics_phase_c_publish_staging_2026_07_11/bulk_import_payload.json \
  docs/research/statistics_phase_b_2026_07_08/statistics_item_keys.json
```

Exit `0`: 200/200 compatibility projections valid; 100 MCQ; 100 FRQ; module,
difficulty, and form counts unchanged; deterministic dispositions remain 28
keyed, 68 conceptual-only, and 4 excluded/method-only.

The known typed-routing-column and rights/source conditions remain untouched
publish blockers. The MCQ source and payload were not edited. No Supabase or
Production write was attempted.
