# AP Calculus AB Tier 3 Labels + Difficulty Report — 2026-09-25

## Outcome

Completed the AP Calculus AB Tier 3 serving-label and difficulty writes in Production.

- Production project ref confirmed: `pcntajvbdfqhbeewmdry` (`Cramapple - Production`).
- Serving-label model run: `serving-units-mcp-2026-09-25-20260926030346`.
- Difficulty proposal run: `apcalcab_tier3_difficulty_2026_09_25`.
- Production access is through the Supabase MCP connection only; no local Supabase CLI write is used.

## Required dry-run artifact

### Live baseline and serving-label target

“Current” means `label_scope='serving'`, `superseded_by is null`, on the one non-retired AP Calculus AB pack version.

- Live-pack items: 128.
- Pack version: `826c8cf1-bc1b-4f2a-bd33-61a758e1487d`, `published`, `retired_at is null`.
- Current status counts: 34 no row, 16 `held`, 46 `legacy_unvalidated`, 6 `provisional_model`, 17 `stale`, 9 `validated`.
- Duplicate-current-serving-label items: 0.
- Broad label target before status filtering: 97.
- Strict published-item/latest-published-version label target: 93.
- Excluded as non-published: `apcalcab-frq-014`, `apcalcab-frq-029`, `apcalcab-mcq-048`, `apcalcab-mcq-049` (each item and latest version are `changes_requested`).
- The 16 existing `held`, 6 existing `provisional_model`, and 9 existing `validated` rows are untouched.

Label target keys (93):

- apcalcab-frq-003
- apcalcab-frq-004
- apcalcab-frq-005
- apcalcab-frq-007
- apcalcab-frq-008
- apcalcab-frq-009
- apcalcab-frq-010
- apcalcab-frq-011
- apcalcab-frq-012
- apcalcab-frq-015
- apcalcab-frq-016
- apcalcab-frq-017
- apcalcab-frq-018
- apcalcab-frq-019
- apcalcab-frq-020
- apcalcab-frq-022
- apcalcab-frq-024
- apcalcab-frq-025
- apcalcab-frq-026
- apcalcab-frq-030
- apcalcab-frq-031
- apcalcab-frq-032
- apcalcab-frq-033
- apcalcab-frq-034
- apcalcab-frq-035
- apcalcab-frq-036
- apcalcab-frq-np2-001
- apcalcab-frq-np2-002
- apcalcab-frq-np2-003
- apcalcab-frq-np2-004
- apcalcab-frq-np2-005
- apcalcab-frq-np2-006
- apcalcab-frq-np2-007
- apcalcab-frq-np2-008
- apcalcab-frq-np2-009
- apcalcab-frq-np2-010
- apcalcab-frq-u13-001
- apcalcab-frq-u13-002
- apcalcab-frq-u13-004
- apcalcab-frq-u13-005
- apcalcab-frq-u13-006
- apcalcab-frq-u13-008
- apcalcab-frq-u13-010
- apcalcab-frq-u13-011
- apcalcab-frq-u13-012
- apcalcab-frq-u13-015
- apcalcab-frq-u13-017
- apcalcab-frq-u13-018
- apcalcab-frq-u13-019
- apcalcab-frq-u13-020
- apcalcab-mcq-005
- apcalcab-mcq-007
- apcalcab-mcq-008
- apcalcab-mcq-012
- apcalcab-mcq-016
- apcalcab-mcq-019
- apcalcab-mcq-020
- apcalcab-mcq-021
- apcalcab-mcq-022
- apcalcab-mcq-024
- apcalcab-mcq-025
- apcalcab-mcq-026
- apcalcab-mcq-027
- apcalcab-mcq-028
- apcalcab-mcq-030
- apcalcab-mcq-031
- apcalcab-mcq-032
- apcalcab-mcq-033
- apcalcab-mcq-034
- apcalcab-mcq-035
- apcalcab-mcq-036
- apcalcab-mcq-037
- apcalcab-mcq-038
- apcalcab-mcq-039
- apcalcab-mcq-040
- apcalcab-mcq-041
- apcalcab-mcq-042
- apcalcab-mcq-043
- apcalcab-mcq-044
- apcalcab-mcq-045
- apcalcab-mcq-046
- apcalcab-mcq-047
- apcalcab-mcq-050
- apcalcab-mcq-np2-001
- apcalcab-mcq-np2-002
- apcalcab-mcq-np2-003
- apcalcab-mcq-np2-004
- apcalcab-mcq-np2-005
- apcalcab-mcq-np2-006
- apcalcab-mcq-np2-007
- apcalcab-mcq-np2-008
- apcalcab-mcq-np2-009
- apcalcab-mcq-np2-010

### Generated labels

- Generated row count: 93.
- Status split: 64 `provisional_model`, 29 `held`.
- Held-reason split: 17 `model_unit_disagreement`, 5 `rubric_preflight_failure`, 3 `empty_required_units`, 3 `ab_bc_only_content`, 1 `other`.
- Model-call failures: 0.
- No generated row has `label_status='validated'`.
- The packet key set and generated result key set both exactly match the 93 independently derived targets.
- Batch plan: 3 label batches of 31 rows.

### Difficulty target and method

- Strict published-item/latest-published-version target: 122.
- Existing difficulty rows before load: 0.
- CSV coverage: 122/122; no coverage gap.
- Distribution: 12 Easy, 99 Medium, 11 Hard.
- By item type: FRQ 4 Easy / 53 Medium / 5 Hard (62); MCQ 8 Easy / 46 Medium / 6 Hard (60).
- Basis split: 109 `calculus_regex_cue`, 13 `judgement`.
- Batch plan: 4 difficulty batches of 31, 31, 30, and 30 rows.

Difficulty target keys (122):

- apcalcab-frq-001
- apcalcab-frq-002
- apcalcab-frq-003
- apcalcab-frq-004
- apcalcab-frq-005
- apcalcab-frq-006
- apcalcab-frq-007
- apcalcab-frq-008
- apcalcab-frq-009
- apcalcab-frq-010
- apcalcab-frq-011
- apcalcab-frq-012
- apcalcab-frq-015
- apcalcab-frq-016
- apcalcab-frq-017
- apcalcab-frq-018
- apcalcab-frq-019
- apcalcab-frq-020
- apcalcab-frq-022
- apcalcab-frq-023
- apcalcab-frq-024
- apcalcab-frq-025
- apcalcab-frq-026
- apcalcab-frq-027
- apcalcab-frq-028
- apcalcab-frq-030
- apcalcab-frq-031
- apcalcab-frq-032
- apcalcab-frq-033
- apcalcab-frq-034
- apcalcab-frq-035
- apcalcab-frq-036
- apcalcab-frq-np2-001
- apcalcab-frq-np2-002
- apcalcab-frq-np2-003
- apcalcab-frq-np2-004
- apcalcab-frq-np2-005
- apcalcab-frq-np2-006
- apcalcab-frq-np2-007
- apcalcab-frq-np2-008
- apcalcab-frq-np2-009
- apcalcab-frq-np2-010
- apcalcab-frq-u13-001
- apcalcab-frq-u13-002
- apcalcab-frq-u13-003
- apcalcab-frq-u13-004
- apcalcab-frq-u13-005
- apcalcab-frq-u13-006
- apcalcab-frq-u13-007
- apcalcab-frq-u13-008
- apcalcab-frq-u13-009
- apcalcab-frq-u13-010
- apcalcab-frq-u13-011
- apcalcab-frq-u13-012
- apcalcab-frq-u13-013
- apcalcab-frq-u13-014
- apcalcab-frq-u13-015
- apcalcab-frq-u13-016
- apcalcab-frq-u13-017
- apcalcab-frq-u13-018
- apcalcab-frq-u13-019
- apcalcab-frq-u13-020
- apcalcab-mcq-001
- apcalcab-mcq-003
- apcalcab-mcq-005
- apcalcab-mcq-006
- apcalcab-mcq-007
- apcalcab-mcq-008
- apcalcab-mcq-009
- apcalcab-mcq-010
- apcalcab-mcq-011
- apcalcab-mcq-012
- apcalcab-mcq-013
- apcalcab-mcq-014
- apcalcab-mcq-015
- apcalcab-mcq-016
- apcalcab-mcq-017
- apcalcab-mcq-018
- apcalcab-mcq-019
- apcalcab-mcq-020
- apcalcab-mcq-021
- apcalcab-mcq-022
- apcalcab-mcq-023
- apcalcab-mcq-024
- apcalcab-mcq-025
- apcalcab-mcq-026
- apcalcab-mcq-027
- apcalcab-mcq-028
- apcalcab-mcq-029
- apcalcab-mcq-030
- apcalcab-mcq-031
- apcalcab-mcq-032
- apcalcab-mcq-033
- apcalcab-mcq-034
- apcalcab-mcq-035
- apcalcab-mcq-036
- apcalcab-mcq-037
- apcalcab-mcq-038
- apcalcab-mcq-039
- apcalcab-mcq-040
- apcalcab-mcq-041
- apcalcab-mcq-042
- apcalcab-mcq-043
- apcalcab-mcq-044
- apcalcab-mcq-045
- apcalcab-mcq-046
- apcalcab-mcq-047
- apcalcab-mcq-050
- apcalcab-mcq-060
- apcalcab-mcq-070
- apcalcab-mcq-080
- apcalcab-mcq-090
- apcalcab-mcq-np2-001
- apcalcab-mcq-np2-002
- apcalcab-mcq-np2-003
- apcalcab-mcq-np2-004
- apcalcab-mcq-np2-005
- apcalcab-mcq-np2-006
- apcalcab-mcq-np2-007
- apcalcab-mcq-np2-008
- apcalcab-mcq-np2-009
- apcalcab-mcq-np2-010

## Difficulty methodology and spot-check

The generic task-verb list was not used unchanged. The 15-item preflight showed that Calculus phrasing is dominated by `find`, `what is`, `evaluate`, declarative rubric criteria, and routine differentiation/integration. The generic list omits `find` and makes `calculate` Hard, which would leave common Calculus tasks uncued or overstate routine algorithmic work.

The implemented Calculus-specific Method A variant preserves criterion-level modal tiering and upward tie-breaking:

- Easy: direct theorem/definition recognition, read-off, identify/state/select, or direct substitution.
- Medium: routine Calculus operations such as find, determine, solve, evaluate, differentiate, integrate, set up, write, graph, or approximate. In this subject-specific deviation, “evaluate an integral” is routine rather than argumentation.
- Hard: explicit justification/proof/argumentation or identified non-routine multi-stage MCQ mechanics.
- Unmatched MCQs are recorded as `judgement`, not silently treated as measured.

The hand spot-check covered seven FRQs and eight MCQs: `apcalcab-frq-003` (Medium), `apcalcab-frq-015` (Medium), `apcalcab-frq-018` (Medium), `apcalcab-frq-np2-004` (Hard), `apcalcab-frq-u13-005` (Medium), `apcalcab-frq-u13-012` (Medium), `apcalcab-frq-u13-020` (Medium), `apcalcab-mcq-005` (Medium), `apcalcab-mcq-016` (Medium), `apcalcab-mcq-025` (Medium), `apcalcab-mcq-035` (Medium), `apcalcab-mcq-045` (Hard), `apcalcab-mcq-050` (Hard), `apcalcab-mcq-np2-004` (Easy), and `apcalcab-mcq-np2-009` (Medium). These placements matched the manual reading of direct recognition vs routine operation vs explicit argumentation/non-routine work.

### CRR check

The calibration file contains 54 AP Calculus AB scored points (mean 0.439; Hard ≤ 0.36; Easy ≥ 0.54), but those rows identify 2025 CRR question/point labels rather than Cramapple content keys. No defensible item-to-CRR criterion mapping exists for this 122-item corpus, so an item-level agreement percentage or Cohen’s kappa cannot be computed without fabricating correspondences. The CSV’s `verb_auto` and `attr_method` fields were not used, consistent with the calibration README’s warning that they are unverified automated extraction. The CRR evidence was used qualitatively: its `find`, `state`, `use`, and `evaluate` points span all three empirical bands, supporting the decision not to map routine Calculus verbs mechanically to a single universal tier.

## Pre-write safety checks

Each migration includes transaction-local checks for:

- the exact expected batch row count;
- idempotency (no prior label row for the model run, or no prior difficulty row for the version);
- membership in the live, non-retired AP Calculus AB pack;
- item and latest-version `published` status;
- exact latest `content_item_version_id` matching.

The label source was split programmatically with parenthesis- and SQL-quote-aware tuple extraction. All batches passed the `),\s*,\s*\(` double-comma check. Each local migration file is the exact SQL planned for its corresponding `apply_migration` call.

## Applied migrations

Serving labels:

- `20260925220100_apcalcab_serving_labels_batch_01.sql` — 31 rows; cumulative verification 31 (16 provisional, 15 held).
- `20260925220200_apcalcab_serving_labels_batch_02.sql` — 31 rows; cumulative verification 62 (43 provisional, 19 held).
- `20260925220300_apcalcab_serving_labels_batch_03.sql` — 31 rows; cumulative/final verification 93 (64 provisional, 29 held).

Difficulty:

- `20260925221100_apcalcab_difficulty_batch_01.sql` — 31 rows; cumulative verification 31.
- `20260925221200_apcalcab_difficulty_batch_02.sql` — 31 rows; cumulative verification 62.
- `20260925221300_apcalcab_difficulty_batch_03.sql` — 30 rows; cumulative verification 92.
- `20260925221400_apcalcab_difficulty_batch_04.sql` — 30 rows; cumulative/final verification 122.

All seven names are present in Production migration history. Each local file is the exact SQL submitted for that call.

## Final Production verification

### Serving labels

The final current serving-label counts across all 128 live-pack items are:

- `provisional_model`: 70 (the prior 6 plus 64 from this run).
- `held`: 45 (the prior 16 plus 29 from this run).
- `validated`: 9 (untouched).
- `legacy_unvalidated`: 3 (the excluded `changes_requested` items).
- no current row: 1 (the fourth excluded `changes_requested` item).
- `stale`: 0.

Current held-reason totals are:

- `model_unit_disagreement`: 31.
- `rubric_preflight_failure`: 6.
- `empty_required_units`: 4.
- `ab_bc_only_content`: 3.
- `other`: 1.

The new run has exactly 93 current rows: 64 `provisional_model`, 29 `held`, 0 `validated`. Its held-reason split matches the generated dry run. No new row falls outside the current published AP Calculus AB target.

One pre-existing held row is a concrete follow-up candidate, not changed here: `apcalcab-mcq-015` is held for `empty_required_units`, but inspection of its stem (“Evaluate ∫ 2x/(x²+5) dx”) makes Unit 6 substitution/antidifferentiation directly identifiable. It should be re-reviewed case-by-case rather than blanket-rerun with the other holds.

### Difficulty

- Final coverage: 122/122 strict published-item/latest-published-version items.
- Bands: 12 Easy, 99 Medium, 11 Hard.
- By type: FRQ 4/53/5 and MCQ 8/46/6 (Easy/Medium/Hard).
- Database basis: 109 `calibrated_task_verb`, 13 `calibrated_judgement`.
- Coverage gaps: none.
- Contamination: 0.
- `attainment_ratio` and `ratio_source` are intentionally null because the CRR rows cannot be defensibly mapped to these content IDs; no ratio was fabricated.

## Ready for cross-QA

Ready for independent cross-QA. The exact 93 content items with new label rows and 122 content items with new difficulty rows are the key lists above. The label sample should include provisional rows plus each held-reason class; the difficulty sample should cover both item types, all three bands, and both database basis values.

After Claude’s AP Precalculus half lands, Codex should independently review a sample of that output in return, using the paired plan or PR list to locate it. That reciprocal cross-QA was not started here, and this task did not self-grade its own output or proceed to Pair 3.
