# TASK-0016 Phase C Publish Packet QA Review

Review date: 2026-07-11  
Scope: PR #36, repository-only independent pre-staging QA

## Deterministic Sample (Recorded Before Content Inspection)

Selection followed the v2 QA prompt exactly: eligible content keys were sorted
lexicographically and the first 15 of each item type were selected after the
specified exclusions.

### FRQ

1. `APSTAT-MOD3-E001`
2. `APSTAT-MOD3-E002`
3. `APSTAT-MOD3-E003`
4. `APSTAT-MOD3-E004`
5. `APSTAT-MOD3-E005`
6. `APSTAT-MOD4-M001`
7. `APSTAT-MOD4-M002`
8. `APSTAT-MOD4-M003`
9. `APSTAT-MOD4-M005`
10. `APSTAT-MOD5-M001`
11. `APSTAT-MOD5-M002`
12. `APSTAT-MOD5-M003`
13. `APSTAT-MOD5-M005`
14. `APSTAT-MOD6-H002`
15. `APSTAT-MOD6-H003`

### MCQ

1. `APSTATS-MCQ-019`
2. `APSTATS-MCQ-020`
3. `APSTATS-MCQ-021`
4. `APSTATS-MCQ-022`
5. `APSTATS-MCQ-023`
6. `APSTATS-MCQ-024`
7. `APSTATS-MCQ-025`
8. `APSTATS-MCQ-026`
9. `APSTATS-MCQ-027`
10. `APSTATS-MCQ-028`
11. `APSTATS-MCQ-029`
12. `APSTATS-MCQ-030`
13. `APSTATS-MCQ-031`
14. `APSTATS-MCQ-032`
15. `APSTATS-MCQ-033`

## Review Results

### Proposed Verdict: Fail

Do not run the Production `bulk_import`. The fresh sample contains an
incorrect canonical answer and an item that cannot be answered without its
missing histogram. The clean-branch rebuild also fails because none of the
generator's nine source inputs are present on PR #36.

### Findings

1. **Staging blocker — the packet is not reproducible from PR #36.**
   `scripts/build_task0016_phase_c_publish_packet.mjs:15-23` reads nine source
   artifacts, but all nine are absent from the clean `main`-based branch. In a
   detached checkout of PR #36, the required rebuild exits `1` at the first
   missing input, `provisional_labels.json`. The requested key validation also
   exits `2` because `statistics_phase_b_2026_07_08/validate_keys.py` is absent.

2. **Staging blocker — `APSTAT-MOD5-M001` has an incorrect canonical sample
   standard deviation.** The stem says "this sample" but the payload stages
   `7.07` (`bulk_import_payload.json:14800`), which is the population SD.
   Independently: mean = 20, sum of squared deviations = 250, and sample
   SD = `sqrt(250 / 4) = 7.905694`. Relative error of staged `7.07` is
   `|7.07 - 7.905694| / 7.905694 = 10.5708%`, well above the 2% band.

3. **Staging blocker — eight FRQs require absent visual/data stimuli.** Each
   has `stimulus: ""` while its stem and rubric require properties that are not
   supplied: `APSTAT-MOD4-M004` (scatterplot direction/strength/outliers),
   `APSTAT-MOD5-M003` (histogram shape/center/spread), `APSTAT-MOD6-M004`
   (sampling-distribution graph), `APSTAT-MOD6-H004` (residual pattern),
   `APSTAT-MOD6-H002-INV` (raw data, regression, and residual plot),
   `APSTAT-MOD8-M003` (regression line and new x-value), `STATS-MOD3-H009`
   (histogram shape/center/spread), and `STATS-MOD4-H014` (diagram factors and
   levels). Representative payload locations are lines 14378, 15036, 15821,
   16445, 17457, 19873, 22708, and 23630. `APSTAT-MOD5-M003` was in the fixed
   fresh sample; the remaining seven were found by the required failure-shape
   scan.

4. **Publish blocker — typed routing fields and rights/source acceptance.**
   These are the already-recorded pre-publish conditions, not newly discovered
   staging defects: populate typed `rubric_type`/`evaluator_strategy` fields
   and explicitly accept the rights/source gate before any publish action.

No follow-up-only findings were identified.

### Fresh Sample Results

- MCQ: 15/15 staged answer keys matched independent derivation.
  Numeric checks were exact (0% relative error): `APSTATS-MCQ-020` z = 1,
  `APSTATS-MCQ-021` mean increase = 1, `APSTATS-MCQ-025` upper fence = 48,
  and `APSTATS-MCQ-029` residual = -5.
- FRQ: 13/15 were answerable and matched independent derivation.
  Exact numeric checks (0% relative error) were `APSTAT-MOD3-E003` z = 2,
  `APSTAT-MOD3-E004` range = 9, `APSTAT-MOD4-M002` count = 140, and
  `APSTAT-MOD6-H003` power = 0.90. `APSTAT-MOD3-E001` correctly uses the
  empirical-rule approximation of 68%. `APSTAT-MOD5-M001` failed at 10.5708%
  relative error; `APSTAT-MOD5-M003` was unanswerable without its histogram.
- No sampled item introduced a z*-versus-t* error or an unresolved directional
  sign convention. The corpus scan did expose the missing-input cases above.

### Mechanical Evidence

- PR scope: `git diff --name-status origin/main...HEAD` showed exactly the four
  packet documents plus the generator before this QA report was added;
  `git merge-base --is-ancestor origin/main HEAD` exited `0`.
- Clean rebuild: `git worktree add --detach /private/tmp/task0016-qa-rebuild HEAD`,
  then `node scripts/build_task0016_phase_c_publish_packet.mjs`; exit `1`,
  `ENOENT` for
  `docs/research/ap_statistics_gold_set_candidate_2026_07_09/provisional_labels.json`.
- Fail-closed shape/count check:
  `node /private/tmp/task0016_qa_checks.mjs docs/research/ap_statistics_phase_c_publish_staging_2026_07_11/bulk_import_payload.json`.
  The checker exits nonzero for a root/item-count error, any missing or mistyped
  projection field, invalid MCQ choice subfield, invalid FRQ criterion subfield,
  unsupported item type, or non-positive criterion points. Result: exit `0`,
  200/200 valid (100 MCQ, 100 FRQ).
- Independent recomputation from `compatibility.prompt_json` matched the packet:
  18 `-CAL` keys; MCQ module counts 11 each for 1-8 and 12 for 9; MCQ
  difficulties 12/42/43/3 Easy/Hard/Medium/Very Hard; FRQ module counts
  11/1/15/16/6/16/15/10/10; FRQ difficulties 15/40/30/15
  easy/hard/medium/very_hard; forms 10 long/90 short; dispositions 28
  deterministic, 68 conceptual-only, and 4 excluded/method-only.
- Required validation:
  `python3 docs/research/statistics_phase_b_2026_07_08/validate_keys.py`;
  exit `2` because the script is absent. Therefore the claimed 44/44 + 7/7
  result was **not independently verified in this pass**.
- Draft safety: `admin-content/index.ts:891-910` maps `bulk_import` rows to
  `create_draft`; lines 533 and 553 write `draft`. `evaluate-attempt/index.ts:
  875-880` rejects unless the item, version, and exam-pack version are all
  `published`.
- Publish-path scan:
  `rg -n -i "operation.{0,10}publish|supabase|fetch\\(|https?://|createClient|invoke\\(" scripts/build_task0016_phase_c_publish_packet.mjs docs/research/ap_statistics_phase_c_publish_staging_2026_07_11/bulk_import_payload.json`.
  No executable publish operation or Supabase client call exists. The generator
  only contains a `curl` command as README text; it does not execute it.

Files directly inspected included the payload, generator, approval packet,
verification log, `admin-content/index.ts`, and `evaluate-attempt/index.ts`.
The boundary-contract and deterministic-key source artifacts named by the QA
prompt are absent from PR #36, so they could not be independently read here.

### Repository-Only Limits

The live collision result and published exam-pack-version identity were not
independently verified in this pass — they require live DB access. No live DB
or Supabase write was attempted.

### Required Remediation Before Staging

1. Make the generator self-contained on PR #36 by committing its source inputs
   (including `validate_keys.py` and `statistics_item_keys.json`) or by changing
   the generator to consume committed, available inputs; then demonstrate a
   clean temporary rebuild with semantic equality to the committed payload.
2. Correct `APSTAT-MOD5-M001` to the sample SD, approximately `7.91`, in both
   source and generated payload.
3. Supply the actual visual/data stimuli for the eight listed items or rewrite
   each stem and rubric so it is fully answerable from included text.
4. Regenerate the packet, rerun the full compatibility/count checker and key
   validator, and repeat a focused QA pass on all remediated content before
   calling `bulk_import`.
