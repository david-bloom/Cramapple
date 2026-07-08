# Calibration Artifact Set Runbook

**Purpose:** keep a small, queryable calibration artifact set in Supabase for content testing, grader bootstrap experiments, and rubric calibration.

## What was added

- A new service-role-only table: [`app.calibration_sets`](/Users/davidbloom/Documents/Cramapple/supabase/migrations/202607070002_calibration_sets.sql)
- A seed row for the AP Statistics FRQ bootstrap corpus: [`supabase/seed/calibration_sets.sql`](/Users/davidbloom/Documents/Cramapple/supabase/seed/calibration_sets.sql)

## Why this shape

- The table is intentionally compact.
- The full corpus stays in the repo as the source artifact.
- Supabase stores the queryable summary, hashes, and manifest metadata.
- The row is restricted to `service_role`, so it is not exposed to learners or the public Data API.

## Current corpus

- Dataset version: `ap_statistics_frq_v1_2026_07_07`
- Subject: `ap-statistics`
- Exam pack version ref: `548f06be-ccf4-426d-b82b-b424137a4438`
- Item count: `100`
- HDR-marked items: `30`

Source files:

- [`docs/research/ap_statistics_frq_bootstrap_corpus_2026_07_07.json`](/Users/davidbloom/Documents/Cramapple/docs/research/ap_statistics_frq_bootstrap_corpus_2026_07_07.json)
- [`docs/research/ap_statistics_frq_bootstrap_corpus_2026_07_07_README.md`](/Users/davidbloom/Documents/Cramapple/docs/research/ap_statistics_frq_bootstrap_corpus_2026_07_07_README.md)

## Intended use

1. Load the seed row into Supabase.
2. Use the corpus metadata to drive grader bootstrapping and calibration runs.
3. Keep generated answers, scores, and model comparisons in separate evaluation tables or logs.
4. Expand with new calibration manifests only when we have a distinct testing need.

For AP Statistics scale runs, use the dedicated runbook:

- [`docs/runbooks/AP_STATISTICS_GRADING_EXPERIMENT_RUNBOOK.md`](/Users/davidbloom/Documents/Cramapple/docs/runbooks/AP_STATISTICS_GRADING_EXPERIMENT_RUNBOOK.md)

## FRQ Storage Convention

When this calibration set is used to generate or store item-level rows, tag AP Statistics Question 6-style prompts as:

- `frq_type = frq`
- `frq_form = long`
- `frq_subtype = investigative_task`

That keeps the AP Statistics investigative task distinct from generic long FRQs while still grouping it inside the long-form family for shared tooling, rubrics, and dashboards. Prefer `codex.frq_subtype` when the boolean flag and subtype disagree.

## Guardrails

- Do not expose the table to `authenticated` or `anon`.
- Do not replace the full corpus with only summary statistics if the test needs item-level inspection.
- Keep calibration sets small and purpose-built so they remain easy to audit.

## Follow-up options

- Add a companion table later for item-level calibration cases if we need per-question joins.
- Mirror additional subject-specific corpora the same way once the AP Statistics workflow is stable.
