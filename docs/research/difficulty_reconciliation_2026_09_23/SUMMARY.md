# Work order J.0 — Biology difficulty regeneration and DECISION-0065 resume

## Outcome

**Proposal emitted for Claude QA; no Production write made.**

The original J.0 run correctly stopped because the committed method had no continuous
`attainment_ratio` rule. DECISION-0065 supplied the missing rules on 2026-09-24, so this resume kept
the historical `DISCREPANCY.md` intact and added the ratio proposal artifacts in this same directory.

The existing categorical method still reproduces every one of its 81 task-verb bands against the
current Production snapshot, with no band drift. The resumed ratio method computes a ratio for 71 of
those 81 task-verb items. The remaining 10 task-verb items stay null because the two-model CRR verb
verification left their needed exact verbs without agreed rows, and those verbs are not eligible for
the approved zero-CRR tier fallback. The 37 judgment-basis items remain null by design.

## Resume results

| Measure | Result |
| --- | ---: |
| Approved CRR verification scope | 87 rows |
| Two-model agreements / disagreements | 50 / 37 |
| Agreement rate | 57.5% |
| Current latest-published AP Biology items | 118 |
| Task-verb / judgment basis | 81 / 37 |
| Task-verb ratios computed | 71 |
| Task-verb ratios unavailable | 10 |
| Judgment ratios unavailable by design | 37 |
| Proposal rows emitted | 118 |
| Computed proposal split | 60 all-exact / 6 mixed / 5 all-tier-fallback |
| Verb contributions | 107 exact-verb / 12 tier-fallback / 24 unresolved |
| Cut-point band vs. committed categorical band | 49 same / 22 different / 47 unavailable |
| Production writes | **0** |

## Method notes

`verb_verification.csv` records both model answers for every row in
`docs/research/apbio_j0_ratio_decision_2026_09_24/crr_rows_to_verify.csv`. Rows with model
disagreement have blank `verified_verb` and contribute no ratio.

`compute_attainment_ratio.py` then applies DECISION-0065 mechanically:

- exact-verb rows are normalized as `AP Biology mean + (source ratio - source subject mean)`, clipped
  to `[0, 1]`, using the subject means in
  `docs/research/apbio_difficulty_calibration_2026_09_22/README.md` section 2;
- multiple verified rows for the same verb are averaged into that verb's exact contribution;
- approved zero-CRR verbs use tier fallback only when no exact contribution exists, averaging
  same-tier exact verb-level ratios;
- item `attainment_ratio` is the mean of its contributing detected verbs;
- categorical Easy/Medium/Hard labels are not changed.

Each proposal row's `contributing_verbs` JSON records the per-verb ratio, `ratio_source`, source
rows, and any cross-subject normalization formula. That field is the per-item normalization audit
trail for QA.

## Cut-point comparison findings

The computed ratio's informational cut-point band differs from the committed categorical band on 22
items:

| Item | Ratio | Ratio band | Committed band | Basis |
| --- | ---: | --- | --- | --- |
| APBIO-FRQ-L-016 | 0.521444 | Medium | Hard | all_exact |
| APBIO-FRQ-L-019 | 0.484167 | Hard | Medium | all_exact |
| APBIO-FRQ-L-031 | 0.707778 | Medium | Hard | all_exact |
| APBIO-FRQ-L-036 | 0.580833 | Medium | Hard | all_exact |
| APBIO-FRQ-S-028 | 0.660286 | Medium | Easy | all_exact |
| APBIO-FRQ-S-036 | 0.559000 | Medium | Easy | all_exact |
| APBIO-FRQ-S-038 | 0.659000 | Medium | Easy | all_exact |
| APBIO-FRQ-S-045 | 0.698353 | Medium | Hard | all_exact |
| APBIO-FRQ-S-063 | 0.581269 | Medium | Easy | mixed |
| APBIO-FRQ-S-064 | 0.660286 | Medium | Easy | all_exact |
| APBIO-FRQ-S-068 | 0.660286 | Medium | Easy | all_tier_fallback |
| APBIO-FRQ-S-080 | 0.559000 | Medium | Easy | all_exact |
| APBIO-FRQ-S-084 | 0.559000 | Medium | Easy | all_exact |
| APBIO-FRQ-S-085 | 0.659000 | Medium | Hard | all_exact |
| APBIO-FRQ-S-095 | 0.559000 | Medium | Easy | all_exact |
| APBIO-HDG-2026-GRAPH-003 | 0.660286 | Medium | Easy | all_exact |
| APBIO-MCQ-022 | 0.633192 | Medium | Hard | all_tier_fallback |
| APBIO-MCQ-026 | 0.660286 | Medium | Easy | all_tier_fallback |
| APBIO-MCQ-064 | 0.243000 | Hard | Medium | all_exact |
| APBIO-MCQ-074 | 0.759000 | Easy | Hard | all_exact |
| APBIO-MCQ-088 | 0.759000 | Easy | Hard | all_exact |
| APBIO-MCQ-099 | 0.660286 | Medium | Easy | all_exact |

These are not re-bands. They record that the continuous attainment ratio and the committed modal
task-verb tier measure related but non-identical signals.

## Unavailable task-verb items

The following 10 task-verb items remain unavailable after the two-model gate:

APBIO-FRQ-S-046, APBIO-FRQ-S-070, APBIO-FRQ-S-071, APBIO-FRQ-S-081, APBIO-FRQ-S-086,
APBIO-FRQ-S-087, APBIO-FRQ-S-089, APBIO-FRQ-S-090, APBIO-FRQ-S-097,
APBIO-HDG-2026-GRAPH-002.

## Files

- `packet.jsonl` — model-neutral live inputs used by the classifier: item/version identity, stem,
  and learner-facing criteria.
- `j0_reproduction.csv` — per-item band reproduction and original ratio-derivability verdict.
- `verb_verification.csv` — two-model CRR verb verification, including disagreements.
- `compute_attainment_ratio.py` — deterministic DECISION-0065 ratio proposal script.
- `attainment_ratio_proposal.csv` — 118-row proposal for Claude QA and later M3 load.
- `attainment_ratio_run_metadata.json` — run counts and aggregation choices.
- `DISCREPANCY.md` — historical evidence explaining why the original run stopped.
- `run_metadata.json` — original J.0 snapshot, hashes, branch, model, and zero-write record.

## Scope note

The approved 87-row CRR CSV scope was used exactly. A prose count in
`apbio_j0_ratio_decision_2026_09_24/README.md` says Biology's task-verb rows contain 23 distinct
base verbs and 15 reachable verbs; the current `j0_reproduction.csv` normalizes to 22 base verbs,
and the approved 87-row CSV contains 14 stored `verb_auto` values. The row-level scope still matches
the work order exactly, so this was recorded rather than used to expand or shrink the scope.
