# Label-Robustness Cross-Check — Report, 2026-07-08

**Experiment:** #2 of the post-silver-packet battery
**Status:** Completed, reproducible
**Related:** DECISION-0034, APPROVAL-0032, `../grading_cross_subject_takeaways.md`, `../deterministic_check_experiment_2026_07_08/`

## Purpose

A second, independent pass over the three silver (calibration) gold-set-candidate
label sets, hunting the two failure modes flagged in the assessment: (i) a
wrong-typed response that is **accidentally fully credited**, and (ii) a
**confident label that conflicts with an independent signal**.

## Method

Four automated checks (reproducible in `crosscheck.py`) plus an adversarial
re-grade (F):

- **A. Canonical integrity** — every `fully_correct` response must earn all criteria.
- **B. Accidentally-right** — any wrong-typed response earning ALL criteria.
- **C. Deterministic vs label** — for the 9 numeric criteria across the Chem and
  Stats gold slices, compare the label to the Experiment-#1 checker's
  number-right/number-wrong verdict. This is **fully independent of grading
  judgment**: over-credit = number wrong but `earned`; under-credit = number
  right but `not_earned`.
- **E. Distribution sanity** — `subtly_wrong`/`incorrect` responses should skew
  away from `earned`.
- **F. Adversarial re-grade** — read each flagged response and a reverse sample
  of `not_earned` labels, trying to overturn them.

Scope: 60 responses, 224 criterion judgments (Bio 5 items, Stats 5, Chem 5).

## Integrity gate

- [x] Check C reuses the Experiment-#1 checker; one Check-C hit was investigated and traced to a checker artifact (see below), not a label error, then the extractor was hardened and the check re-run.
- [x] Independence stated honestly: only the 9 numeric criteria are verified by a judgment-independent signal; the other 215 rest on single-model judgment (see Limitations).

## Results

| Check | Flags | Verdict after review |
| --- | ---: | --- |
| A. Canonical integrity | 0 | clean |
| B. Accidentally-right (high sev: incorrect/subtly_wrong earning all) | 0 | clean |
| B. Accidentally-right (low sev: borderline/partially earning all) | 8 | see below |
| C. Over-credit (number wrong but earned) | 0 | clean |
| C. Under-credit (number right but not_earned) | 0* | *1 raised, dismissed as checker artifact |
| E. Distribution | 0 | clean |

**Zero confirmed errors in the provisional criterion labels** on every dimension
checked.

### The one high-severity flag was a checker artifact, not a label error

Check C initially flagged `APSTAT-MOD3 / subtly_wrong / ci_calculation` as
under-credit ("correct CI bound 807 present but labeled not_earned"). The
response computes the CI as `(842, 858)` — genuinely wrong — so the `not_earned`
label is **correct**. The checker had matched `807` to `-800` inside the
expression `(850-800)` in a later part. Fixed by excluding binary operands; the
flag disappeared on re-run. (This bug fix also carried back into Experiment #1.)

### The 8 low-severity flags decompose cleanly

- **Bio borderline ×3** (L-001, L-017, L-025) and **Stats borderline ×2** (MOD3,
  MOD6, MOD7): these `borderline` responses genuinely earn every criterion —
  they are informal-but-correct by construction. Correct labels; they are the
  "does the grader over-penalize informal-but-correct writing" test cases. Worth
  a human glance, not errors.
- **Stats `partially_correct` ×2** (MOD6, MOD7): re-graded and confirmed —
  MOD6 gives correct hypotheses, `t = 2.06`, `p < 0.05`, and a correct
  conclusion; MOD7 gives the correct Bayes setup and `0.65`. The criterion labels
  (all earned) are **correct**. The genuinely questionable thing is the *source
  bootstrap corpus's* `partially_correct` **type tag**, which overstates these
  responses' wrongness. This is a Learning-Quality note about the AP Statistics
  source corpus (already in the gold-set adjudication queue), not a grading-label
  defect.

### Reverse spot-check (F)

Sampled `not_earned` labels on `subtly_wrong` responses (e.g., Bio L-017, which
asserts insulin signals through cAMP throughout): all confirmed well-founded — no
under-credit. `subtly_wrong`/`incorrect` label distributions skew strongly to
`not_earned`, as expected.

## Judgment-layer blind re-grade (Check F, full)

The automated battery only reaches the 9 numeric criteria independently. To probe
the conceptual labels, all **45 debatable judgments** (32 `partially_earned` +
20 adjudication-flagged, deduped) were blind re-graded — the verdict re-derived
from the rubric evidence and the response text, then diffed against the
provisional label.

Result: **~41/45 agree.** The exceptions:

- **1 clear correction (under-credit), applied.** `APBIO-FRQ-L-009 /
  subtly_wrong / a` was `not_earned`, but the rubric awards "1 pt for correct
  efficiency calculations" and the response computes both efficiencies correctly
  (42/500 = 8.4%, 4.2/42 = 10%); only the tuna calc and loss explanation are
  wrong. Corrected to `partially_earned` (recorded in the label file with
  rationale). This is a rubric-application fix, not a re-judgment — the automated
  checks could not catch it because it is a conceptual sub-point.
- **1 genuine boundary disagreement, routed to adjudication (not auto-changed).**
  `APBIO-FRQ-L-001 / subtly_wrong / b`: labeled `not_earned`; the response has a
  correct electron-flow statement (1 of the 2 required elements) but reverses the
  proton-pumping direction. Whether a correct electron-flow claim earns a point
  when the coupled proton mechanism is garbled is a real grader judgment call —
  the re-grade leans `partially_earned`; a human may reasonably hold `not_earned`.
  Flagged for the human pass.
- **A soft cluster on the defective item `APSTAT-MOD8`.** Several MOD8
  `correlation_calculation` labels sit between `earned` and `partially_earned`
  only because the item supplies no dataset, so "shows correct method" cannot be
  cleanly assessed. These are contaminated by the known item defect, not label
  noise; MOD8 should be excluded (or given data) before it is used as gold.

Net: one real conceptual under-credit found and fixed, one boundary case routed
to humans, and a confirmation that the remaining conceptual labels are sound
where the item itself is sound.

## Limitations (important)

- **Independence is partial.** Only 9 of 224 judgments (the numeric ones) are
  checked against a judgment-independent signal. The other **215 conceptual/
  judgment labels rest on single-model (author) judgment** and are NOT cleared by
  this cross-check. A genuinely independent pass — a *different* model, and
  ultimately human dual-blind adjudication (§12.1) — is still required before any
  of these labels back a quality claim. This cross-check reduces the risk of
  gross/self-inconsistent errors; it does not establish gold.
- Check C's independence depends on the Exp-#1 checker, which had two extraction
  bugs found during this work; treat its verdicts as strong but not infallible.

## Claims supported / not supported

**Supported:** no canonical-integrity failures; no wrong-typed response is
accidentally fully credited (high severity); no over- or under-credit on any of
the 9 independently-checkable numeric criteria; the provisional labels are
internally consistent and, on the checkable dimension, robust. One actionable
finding: a few AP Statistics `partially_correct` source responses are effectively
full-credit (type-tag overstates wrongness).

**Not supported:** any claim that the 215 conceptual labels are correct — they
need an independent grader. No release/gold claim. No claim that a same-model
re-grade substitutes for human adjudication.

## Recommended follow-through

1. Route the 8 low-severity flags + the AP Stats type-tag finding into the
   human adjudication pass as pre-triaged items.
2. Run the still-missing **independent conceptual pass** — a different model over
   the 215 judgment labels — as the cheap next step before human adjudication
   (this is experiment #4-adjacent and the real gap this cross-check exposes).
