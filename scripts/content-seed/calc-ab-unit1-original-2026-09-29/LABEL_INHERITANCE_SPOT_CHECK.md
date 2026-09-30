# Do variants inherit their original's labels? 10-pair spot check (2026-09-30)

**Question:** can a variant take the topic, required units, skill and difficulty of its original?
**Model:** `google/gemini-3.5-flash`, blind (no key, no rationales, not told which item is the original), 2 samples per item, 20 items (10 pairs). **Script:** `scripts/vercel-gateway-check/apcalcab_unit1_label_probe.mjs`. **Raw:** `label_probe_results.jsonl`, pairs in `label_probe_pairs.json`.
Pairs: 8 MCQ + 2 FRQ across topics 1.1 to 1.15; the variant in each pair was chosen at random (OS entropy).
Taxonomy given to the model: the 8 AB units, the 81 AB topics, the 23 skills (3 marked NOT ASSESSED and excluded), and a written Easy/Medium/Hard rubric.

| Label | Same item, 2 samples | Original vs variant (4 sample pairs x 10) |
|---|---:|---:|
| Required units | 20/20 | **40/40** |
| Difficulty | 20/20 | **40/40** |
| Primary topic | 18/20 | 36/40 |
| Skill | 15/20 | 26/40 |

## Reading

- **Units and difficulty: variants matched their originals every time**, and the model was fully self-consistent on both. But difficulty is low-resolution: the model called almost everything Medium (only 2 Easy in 40 labels) and matched my authored difficulty on 12 of 20 originals, so this agreement is weak evidence about calibration.
- **Topic:** original-vs-variant agreement (90%) equals the model's agreement with itself (90%), so a variant is no less stable than the original. But the model matched **my authored topic** on only 11 of 20 originals: topic tags must come from the labeling pipeline, not from author intent.
- **Skill: not stable even within one item** (75% self-agreement), so a single-pass skill cannot be inherited reliably. Skill needs the protocol's multi-model consensus on the originals; variants can inherit it after a cheap per-variant agreement check.
- **Flag: topic 1.1 vs 2.1.** Both samples of both items in the 1.1 pair (MCQ 002 and its variant, an instantaneous rate estimated from shrinking average-rate intervals) were labeled topic 2.1, unit 2. That is a defensible reading and would change the item's required unit. Run the full labeling pipeline on every 1.1 item (001 and 002 and their variants) before trusting their unit labels.

## Limits

10 pairs is a small sample, and one model labeled both items of each pair, so shared bias inflates agreement. It does not test units for variants that changed function family more radically than these ten.
