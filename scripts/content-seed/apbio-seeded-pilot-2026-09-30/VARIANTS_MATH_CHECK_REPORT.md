# AP Biology Units 1-2: variants, round 1 content check (2026-10-01)

14 class-A variants (2 each from seeds 005, 008, 014, 016, 018, 021, 022; seed 023 waits on its repair), written by Claude Sonnet 5.5, checked by
`google/gemini-3.5-flash` and `deepseek/deepseek-v4-pro` (blind solve + rationale audit), run by the Product Owner on 2026-10-01. Raw: `out_variants/results.jsonl`.
Biology has no deterministic recompute, so these two models are the only independent content check at this stage; CED conformance and the label probe follow.

## Before the models
Mechanical checks passed on all 14: word-level Jaccard against the seed and the sibling at most 0.56 (limit 0.7); correct answer under 1.4 times the distractor length
(the repo's `checkAnswerLengthParity` threshold; the first draft had 6 over it and was rewritten before any check); correct letters drawn at random (A:2, B:4, C:4, D:4).

## Result
| | Biology variants | Biology seeds (S0a) | Calc AB pilot variants |
|---|---|---|---|
| Calls succeeded, structured output | 56 of 56 | 32 of 32 | 96 of 96 |
| Blind-solve disagreements with key | **0 of 28** | 0 of 16 | 0 of 48 |
| Auditor says key is not the correct answer | **0** | 0 | n/a |
| Rationale judgements flagged | **2** (+1 stimulus note), all DeepSeek only | 2 (both models) | 1 of 16 variants had 2 defects |
| Variants with a verified defect | **2 of 14** (14%) | 1 of 8 seeds | 1 of 16 (6%) |
Cost $0.344 (Gemini $0.242, DeepSeek $0.103). Median 7.9 s and 8.0 s per call.

## Defects, each re-derived by hand (not by vote)
All three were raised by DeepSeek only; Gemini flagged nothing. They were real, so a single-model flag was again worth more than a vote count.
1. `apbio-mcq-sv-018-v1`, rationale of the "endosomes fill with transferrin" choice: said transferrin "is never internalized". Too absolute: cells take up a little by nonspecific fluid-phase endocytosis. Receptor-mediated uptake is what is missing. Rewritten.
2. `apbio-mcq-sv-018-v1`, stimulus: said iron "is released into the cytoplasm" in the acidic endosome. Iron is released from transferrin inside the endosome and then transported into the cytoplasm. Corrected.
3. `apbio-mcq-sv-021-v2`, rationale of the "degraded by the proteasome" choice: said "only misfolded or damaged proteins are routinely tagged for degradation". False: regulated normal proteins (cyclins, for example) are also degraded. Rewritten.

The keys were never in question. As in Calc, the defects are in explanatory text.

## Patch handling (protocol: a patched item is a new draft)
Only the two edited items changed; the other 12 are byte-identical (verified by diff; letters are seeded per key and no choice text changed), so their results stand.
`variants_recheck_items.json` holds the two patched items for a full re-check by both models (next step, then CED and labels for all 14).

## A note on the seeds
The published seed `APBIO-MCQ-018` choice D has the same "never enters the cell at all" overstatement as defect 1, and its stimulus says cholesterol is "liberated in the cytoplasm".
Neither model flagged the seed. It is minor, and I have not changed it; it is a candidate for the same owner-remediation path if you want it tightened.

## Re-check of the two patched items (2026-10-01)
`apbio-mcq-sv-018-v1` and `apbio-mcq-sv-021-v2`, full blind solve + rationale audit by both models (`out_recheck/results.jsonl`): **8 of 8 calls succeeded; both models solved both items to the key; 0 rationale flags and 0 other defects from either model.**
No regression from the patches (Unit 1 had 3 patch-introduced defects; this round had none). All 14 variants have now passed the content check by both models.
Still to run before any variant is eligible for review: CED conformance (two model families, Biology fact pack) and the label-inheritance probe, on all 14.
