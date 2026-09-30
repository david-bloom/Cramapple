# Labeling the 34 originals, then per-variant inheritance (2026-09-30)

**Nothing here is in a database.** Serving labels are `provisional_model` at best; `validated` promotion (DECISION-0066) has not happened. The packets used placeholder ids, so `write_labels.sql` from the run cannot be applied as generated.
**Files:** `labels_proposed.csv` (all 136 items, each dimension with its source), `label_consensus_originals.json`, `label_inheritance_variants.json`, `serving_label_pipeline_originals.jsonl` + `serving_label_pipeline_report.md`, `label_probe_originals_3models.jsonl`, `label_probe_variants_3models.jsonl`, `LABEL_INHERITANCE_SPOT_CHECK.md` (earlier 10-pair check).

## Method

1. **Originals, serving labels (units).** `scripts/taxonomy/extend_serving_labels_mcp.mjs --subject=ap_calculus_ab` (cold-label mode, rubric preflight for FRQs), packets built offline from `items.py` in the shape of `fetch_serving_label_packets.sql`, choices shuffled with OS entropy. Models `openai/gpt-5.5` + `google/gemini-3.5-flash`. **Deviation:** the script hard-codes `gemini-2.5-flash`; I added `--models=` and `--report=` overrides and used 3.5 Flash. The default pair is unchanged.
2. **Originals, topic / skill / difficulty.** Three blind runs (`apcalcab_unit1_label_probe.mjs`): `openai/gpt-5.5`, `google/gemini-3.1-pro-preview`, `anthropic/claude-opus-5`. A value is agreed when at least 2 of 3 give it (DECISION-0085's shape). **Deviations:** DECISION-0085 names `gemini-2.5-pro`, replaced by 3.1 Pro (the Pro-tier successor); difficulty used my own written Easy/Medium/Hard rubric (the repo's Calc AB classifier cannot discriminate MCQs, all 116 came out Medium), not Method A.
3. **Variants.** The same three models labeled each variant blind (102 x 3 = 306 calls, 0 failures). A variant inherits a dimension from its original only if at least 2 of 3 of its own labels equal the original's agreed value.

## Originals

- Serving pipeline: **33 `provisional_model`, 1 `held`** (MCQ 001, unit disagreement). 32 items require Unit 1 only; MCQ 002 was given Unit 2.
- Topic: 24 unanimous, 10 majority. Consensus matched my authored topic on 25 of 34, so nine authored tags were wrong.
- Skill: 24 unanimous, 7 majority, **3 no consensus (MCQ 003, 007, 017)**.
- Difficulty: 21 unanimous, 13 majority. Consensus Medium 22, Easy 11, Hard 1 versus my authored 20 / 8 / 6. The models almost never say Hard, so treat difficulty as coarse.
- **The 1.1 items (MCQ 001, 002) are Unit 2 content** (topic 2.1, "Defining Average and Instantaneous Rates of Change at a Point"): all three models said 2.1. The models split on units between [2] and [1, 2], and the serving pipeline gave 001 a hold and 002 a Unit 2 label. Their units are unresolved.

## Variants (per-variant agreement check)

| Dimension | Inherit | Held (variant disagrees with original) | Original had no consensus |
|---|---:|---:|---:|
| Required units | 99 | 3 | 0 |
| Topic | 92 | 10 | 0 |
| Skill | 87 | 6 | 9 |
| Difficulty | 85 | 17 | 0 |

- **Unit failures: the three variants of MCQ 001**, the unresolved 1.1 family.
- **Topic failures (10)** are all neighbouring-topic drift inside Unit 1 (1.5/1.6/1.7, 1.10/1.11/1.13, 1.2/1.5), on originals whose own topic consensus was only a majority: variants of 004, 007, 011, 012 (all three) and 014. Topic is not a serving gate; the unit is.
- **Skill** is the least stable label (as in the spot check), and difficulty holds on 17 variants mainly where models split Easy/Medium.

## Bottom line

**91 of 136 items have all four labels and a settled unit** (24 original MCQ, 5 original FRQ, 50 variant MCQ, 12 variant FRQ). 128 items require Unit 1 only. The other 45 are missing at least one label or have the unit unresolved: the eight 1.1-family items (001, 002 and their variants), the three originals with no skill consensus (and 9 variants of them), and variants where topic, skill or difficulty did not agree. None is wrong; they need a decision, a rerun, or a human tag.

## Decision recorded in-session (2026-09-30, Product Owner)

- **MCQ 001, 002 and their six variants: relabel as topic 2.1, Unit 2.** Applied to `labels_proposed.csv`. Their content keys still carry the `u1` batch prefix.
  Unit 1 now holds 26 originals and 78 variants; Unit 2 holds the 8 relabeled items.
