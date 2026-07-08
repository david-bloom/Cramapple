# AP Statistics Grading Experiment Runbook

**Purpose:** run grading experiments at scale against the AP Statistics bootstrap corpus and keep the results reproducible in Supabase and JSONL.

## What This Uses

- Corpus: [`docs/research/ap_statistics_frq_bootstrap_corpus_2026_07_07.json`](/Users/davidbloom/Documents/Cramapple/docs/research/ap_statistics_frq_bootstrap_corpus_2026_07_07.json)
- Draft prompt: [`prompts/GRADER_BOOTSTRAP_DRAFT_ROLE_PROMPT.md`](/Users/davidbloom/Documents/Cramapple/prompts/GRADER_BOOTSTRAP_DRAFT_ROLE_PROMPT.md)
- Migration: [`supabase/migrations/202607070004_grading_experiments.sql`](/Users/davidbloom/Documents/Cramapple/supabase/migrations/202607070004_grading_experiments.sql)
- Runner: [`scripts/run_ap_statistics_grading_experiment.py`](/Users/davidbloom/Documents/Cramapple/scripts/run_ap_statistics_grading_experiment.py)
- Report template: [`docs/research/ap_statistics_grading_experiment_report_template.md`](/Users/davidbloom/Documents/Cramapple/docs/research/ap_statistics_grading_experiment_report_template.md)

## Table Layout

The grading experiment schema stores:

- `app.grading_experiment_runs` for the run-level manifest
- `app.grading_experiment_cases` for one row per synthetic answer
- `app.grading_experiment_results` for one row per arm and case

All three tables are service-role-only.

## Recommended Execution Order

1. Run the boundary slice first.
2. Inspect agreement and schema validity on the long investigative-task items.
3. Run the full corpus only after the boundary slice is stable.
4. Compare the arms on exact criterion-vector agreement, confidence mix, and cost.
5. Promote only the arm changes that improve agreement without inflating over-credit.

## Boundary Phase

The boundary phase is the 10 long investigative-task items only.

Suggested command:

```bash
python3 scripts/run_ap_statistics_grading_experiment.py --phase boundary
```

## Full Phase

The full phase is all 100 FRQs and 220 synthetic responses.

Suggested command:

```bash
python3 scripts/run_ap_statistics_grading_experiment.py --phase full
```

## Default Arms

The runner compares three arms by default:

- `apstats_fast`
- `apstats_balanced`
- `apstats_strict`

These are meant to show the speed-quality tradeoff before any larger prompt redesign.
The fast arm now uses schema-enforced JSON output and a compact prompt payload.

## What To Look For

- Schema validity on every arm
- Boundary-item stability on the long investigative-task responses
- Exact criterion-vector agreement against the baseline arm
- Confidence mix drift
- Over-credit behavior on short items
- Latency and cost per call
- Route fit: short FRQs should stay on the fast path, while
  `codex.frq_subtype = investigative_task` or borderline responses should
  escalate to the strict path.

## Data Handling Rules

- Keep the full corpus in the repo.
- Store run metadata and results in Supabase under the experiment tables.
- Use `codex.frq_subtype = investigative_task` as the canonical AP Statistics long-form filter.
- Do not collapse the experiment into a single average score; keep per-case and per-arm rows.
