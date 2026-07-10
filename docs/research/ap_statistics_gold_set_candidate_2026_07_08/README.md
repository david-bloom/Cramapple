# AP Statistics Gold-Set Candidate — 2026-07-08

**Corpus tier:** `calibration` (silver) — NOT governance `adjudicated_gold`
**Status:** Adjudication-ready package with AI provisional labels
**Related:** DECISION-0034 (Option B); `../grading_cross_subject_takeaways.md`;
`../../architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md` §12

**Calibration note:** the 2026-07-09 100-item package supersedes this 5-item
slice for calibration runs; keep this package as a historical/smoke-test slice.

## What this is / is not

- **Is:** a locked candidate response set with criterion-level provisional
  labels and a blind dual-scoring harness for two human Grading Validators.
- **Is not:** `adjudicated_gold`. Labels are AI provisional judgments against the
  rubric; they become gold only after human dual-blind scoring + Lead
  adjudication (§12.1).

## Run metadata

| Field | Value |
| --- | --- |
| Source corpus | `../ap_statistics_frq_bootstrap_corpus_2026_07_07.json` |
| Selection | deterministic spread across modules 3/5/6/7/8, hard/very-hard |
| Items / responses / criterion judgments | 5 / 20 / 68 |
| Read tier | Directional (20 responses) |
| Label authority | AI provisional vs rubric; human adjudication pending |

## Composition

20 responses = 5 each of `fully_correct` / `partially_correct` / `borderline` /
`subtly_wrong`, spanning sampling bias + inference, correlation-vs-causation,
two-sample t-test, Bayes' theorem, and regression. Long investigative-task items
(MOD3, MOD5) are included and are the highest-value boundary cases.

**Gaps:** no equivalent-language variants; no explicit abstention cases; HDR
(hand-drawn) responses are handled separately in the AP Stats HDR packages.

## Provisional label distribution

| Label | Count |
| --- | ---: |
| earned | 43 |
| partially_earned | 14 |
| not_earned | 11 |
| unable_to_determine | 0 |

## Deterministic-check targets (2) — the highest-value finding

Statistics is where the deterministic layer earns its keep. Two `subtly_wrong`
responses fail on **checkable arithmetic**, not judgment:

- **APSTAT-MOD3-H001-INV / subtly_wrong / ci_calculation** — computes standard
  error as `120/30 = 4` instead of `120/√30 ≈ 21.9`, producing CI (842, 858)
  instead of (807, 893). A unit-aware calculation check catches this before the
  LLM ever judges it, and the wrong interpretation + wrong hypothesis conclusion
  both cascade from it.
- **APSTAT-MOD6-H001 / subtly_wrong / test_calculation** — miscomputes the
  two-sample t as ≈1.86 (p≈0.065) instead of ≈2.06 (p≈0.043), flipping the
  conclusion from reject to fail-to-reject.

These are the concrete calibration cases for the AP Statistics calculation
checker the assessment recommended (and the Chemistry README flagged Stats had
already prototyped). Build the checker so it flags these two at zero API cost.

## Adjudication queue (7 items)

Highest-value flags:

- **APSTAT-MOD5-H001-INV / borderline / experimental_conclusion** — conclusion
  in context but only ONE assumption stated; rubric wants ≥2. Boundary on
  assumption-count strictness.
- **APSTAT-MOD6-H001 / partially_correct / conclusion** and **APSTAT-MOD7-H001 /
  partially_correct** — both read as *full credit* despite the `partially_correct`
  source label. Calibration signal: tests whether the grader over-penalizes
  concise-but-complete answers (a real product risk — students who write tersely
  should not lose points).
- **APSTAT-MOD8-H001 / subtly_wrong / interpretation** — intercept stated
  uncritically; weak differentiation from the other tiers. Separate from the
  corpus defect below (item-design note, not a data issue).

## Corpus defect — resolved 2026-07-09

- **APSTAT-MOD8-H001 supplies no dataset.** Responses fabricate r ≈ 0.75–0.82,
  so correlation/regression *values* cannot be graded for correctness.
  **Resolution (Product Owner approved):** scope the rubric to
  method-only/self-consistency grading rather than sourcing a real dataset —
  `correlation_calculation` grades formula-application steps, and
  `regression_equation` grades `b=r(sy/sx)` applied correctly to the response's
  own asserted `r`/`sy`/`sx`, regardless of whether those values are real. See
  `../AP_STATISTICS_MOD3_MOD6_BOUNDARY_CONTRACTS_2026_07_09.md` §3 and the
  `grading_note` fields on the item's rubric in `provisional_labels.json` and
  the bootstrap corpus.

## How to upgrade to `adjudicated_gold`

Same procedure as the Biology package README (blind dual-score → adjudicate →
revise boundary contract on ambiguity → re-tier and record). Additionally: wire
the two deterministic-check targets into the Statistics verification profile and
confirm they flag before human scoring.

## Files

- `manifest.json`, `provisional_labels.json`, `blind_scoring_template.csv`
