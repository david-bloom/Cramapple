# AP Chemistry Independent Reviewer Bake-off

Date: 2026-10-09  
Scope: Small smoke test only; no unit-wide or course-wide review was run.

## Question

Can an inexpensive independent model make a binary approve/reject decision on AP Chemistry text and diagrams without initiating a model-to-model debate?

## Models

- `google/gemini-3.5-flash`
- `anthropic/claude-haiku-5.5`

Both models received the same compact, primary-source-derived Unit 4 CED excerpt and the same nine cases in one multimodal request.

## Sample

| Case | Medium | Ground truth | Defect when rejected |
|---|---|---|---|
| T1 | Text | Approve | Correct physical-change definition |
| T2 | Text | Reject | Retains spectator ions and denies atom conservation |
| T3 | Text | Approve | Correct equivalence-point/endpoint distinction |
| T4 | Text | Reject | Contradicts the explicit oxidizing/reducing-agent exclusion |
| T5 | Text | Approve | Correctly says physical processes may have balanced equations |
| T6 | Text | Reject | Changes “possible evidence” into proof of chemical change |
| I1 | Image | Approve | Correct limiting-reactant particle diagram |
| I2 | Image | Reject | Caption contradicts the particle counts |
| I3 | Image | Reject | One product-side particle is missing, violating atom conservation |

## Results

| Model | Content verdicts | Text | Images | False approvals | False rejections | Latency | Gateway cost |
|---|---:|---:|---:|---:|---:|---:|---:|
| Gemini 3.5 Flash | 9/9 | 6/6 | 3/3 | 0 | 0 | 11.13 s | $0.0224880 |
| Claude Haiku 5.5 | 9/9 | 6/6 | 3/3 | 0 | 0 | 9.73 s | $0.0018331 |

Total test cost: **$0.0243211**.

Gemini returned the correct nine decisions but nested the case array under an extra `required_output` object. The harness now normalizes that wrapper. Haiku returned the requested top-level shape directly.

Both models:

- approved every clean case;
- rejected every planted error;
- distinguished “possible evidence” from proof;
- enforced the explicit CED exclusion;
- read the particle counts in the images;
- identified the missing particle as an atom-conservation error; and
- supplied a minimal correction rather than stylistic rewriting.

## Haiku confirmation round

A second, fresh Haiku-only calibration used 12 harder cases drawn from CED Topics 2.2, 2.7, 5.3, 7.3, 7.10, 8.1, 8.7, and 9.8:

- eight text/equation claims covering bond order, hybridization angle, first-order half-life, second-order linearization, Q/K expressions, equilibrium disturbances, pH/pKa, and temperature-dependent neutral pH;
- two clean images: integrated rate-law plots and a Zn/Cu galvanic cell; and
- two visually altered images: an incorrect second-order slope sign and a reversed electron-flow arrow.

The image prompts did not disclose which visuals contained errors.

| Model | Content verdicts | Text | Images | False approvals | False rejections | Latency | Gateway cost |
|---|---:|---:|---:|---:|---:|---:|---:|
| Claude Haiku 5.5, round 2 | **12/12** | 8/8 | 4/4 | 0 | 0 | 10.05 s | $0.0022545 |

Haiku identified both visual defects precisely while approving the clean versions. Its requested fixes were minimal: restore `slope = +k` for the second-order plot and reverse electron flow to run from the Zn anode to the Cu cathode.

### Two-round Haiku aggregate

| Measure | Result |
|---|---:|
| Total cases | **21/21** |
| Text cases | **14/14** |
| Image cases | **7/7** |
| False approvals | **0** |
| False rejections | **0** |
| Combined latency | 19.78 s |
| Combined gateway cost | **$0.0040876** |

## Recommendation

Use **Claude Haiku 5.5** as the default independent approval model for AP Chemistry reference-content production. Across two independent samples it reached 21/21, including seven image judgments, while following the binary approve/reject workflow and providing specific minimum corrections.

This remains a calibration result rather than proof of universal reliability. Preserve per-entry provenance and spot-audit each production unit, but a second general model or model-to-model debate is not justified by the measured result. The full 91-topic inventory was not reviewed in either test.

## Reproduction

```bash
/Users/davidbloom/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/bin/node scripts/content-seed/ap-chem-reviewer-bakeoff-2026-10-09/render_fixtures.mjs
python3 scripts/content-seed/ap-chem-reviewer-bakeoff-2026-10-09/run_bakeoff.py
python3 scripts/content-seed/ap-chem-reviewer-bakeoff-2026-10-09/run_round2.py
```

The harness performs external model calls and writes `results.json`; it does not write to the application database or publish content.
