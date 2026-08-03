# AP Chemistry Gold-Set Candidate — 2026-07-08 (v2, defect resolved)

**Corpus tier:** `calibration` (silver) — NOT governance `adjudicated_gold`
**Status:** Adjudication-ready package; the v1 truncation defect has been resolved
**Related:** DECISION-0034 (Option B); APPROVAL-0032; `../grading_cross_subject_takeaways.md`;
`../../architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md` §12

## v2 update — truncation defect fixed

The v1 build of this package flagged a blocking corpus defect: the source
corpus's non-canonical variants were truncations of the canonical answer
(`partially_correct` ≡ `borderline` byte-for-byte; zero partial-credit
judgments), so it could only test incompleteness, not wrong reasoning.

**That defect is now resolved.** The source corpus
(`../ap_chemistry_frq_grading_experiment_batch_2026_07_07/…json`, variants
version `v2_wrong_reasoning_2026_07_08`) has been rewritten so every
non-canonical response is a hand-authored, genuinely-wrong-reasoning answer that
injects **one specific, identifiable misconception** (recorded in each response's
`injected_error` field) and is presented confidently and completely. The v1
truncation variants are preserved at
`…_truncation_variants_backup.json`. All 100 canonical answers are unchanged.

Evidence the defect is gone: this package's label distribution now contains
**5 `partially_earned`** judgments (v1 had zero — the fingerprint of the
truncation defect), and no `borderline`/`partially_correct` pair is identical.

## What this is / is not

- **Is:** a locked candidate set that now tests wrong-reasoning detection,
  confidently-wrong-but-complete responses, and genuine boundary judgment, with
  criterion-level AI provisional labels and a blind dual-scoring harness.
- **Is not:** `adjudicated_gold`. Labels are AI provisional; human dual-blind
  adjudication (§12.1) upgrades them to gold.

## Run metadata

| Field | Value |
| --- | --- |
| Source corpus | `../ap_chemistry_frq_grading_experiment_batch_2026_07_07/…json` (v2 variants) |
| Selection | 5 long items spanning modules 1, 3, 4, 7, 8 (Easy→Hard) |
| Items / responses / criterion judgments | 5 / 20 / 68 |
| Read tier | Directional (20 responses) |
| Label authority | AI provisional vs rubric; human adjudication pending |

## Composition & label distribution

20 responses = 5 each of `fully_correct` / `borderline` / `partially_correct` /
`subtly_wrong`. Label distribution: 38 earned, 5 partially_earned, 25 not_earned.
The `subtly_wrong` responses are now confidently-wrong-but-complete cases (e.g.,
L-011 uses Celsius for T and ignores the van't Hoff factor; L-021 multiplies mass
by molar mass; L-031 reverses Le Chatelier). **Gaps:** no equivalent-language
variants, no explicit abstention cases, no HDR/image responses in this slice.

## Adjudication queue (22 items)

Every non-`earned` judgment carries the injected-misconception note, so the
adjudication queue doubles as an answer key of what each wrong response is
testing. Highest-value boundary flags are the `borderline` near-misses (one
subtle reasoning gap while the rest is correct) — e.g., L-011 borderline earns
the two osmotic-pressure calcs and the van't Hoff explanation but the sensitivity
explanation is thin.

## Broader corpus

The full 100-item source corpus (50 short + 50 long) was rewritten, not just
these 5 sampled items — all 200 non-canonical responses are now genuine
wrong-reasoning answers. This package samples 5 long items; the rest of the
corpus is now equally usable for wrong-reasoning experiments.

## How to upgrade to `adjudicated_gold`

Blind dual-score `blind_scoring_template.csv` → adjudicate disagreements →
revise the criterion-boundary contract on any ambiguity → re-tier and record.
Wire the Chemistry calculation/unit/sign checks
(`../AP_CHEMISTRY_VERIFICATION_PROFILE.json`) so they flag the numeric
`subtly_wrong` cases before human scoring.

## Files

- `manifest.json`, `provisional_labels.json` (with `injected_error` per response), `blind_scoring_template.csv`
