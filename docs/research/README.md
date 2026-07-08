# Research Index

This folder holds the project’s experiment records, calibration corpora,
protocols, run reports, takeaways, and packet bundles.

## How To Use This Folder

When adding or reviewing research material:

1. start with the folder README for the relevant family;
2. look for the protocol first, then the corpus or packet, then the report;
3. check for a summary file when the report contains metrics;
4. treat takeaways as the durable lesson layer;
5. leave raw inputs in place, even when a run is superseded;
6. never assume a report is authoritative if the protocol or corpus version is
   missing.

## Canonical Process

See [Grading Research Canonical Process](./GRADING_RESEARCH_CANONICAL_PROCESS.md)
for the standard improvement loop and organization rules.

## File Types

Prefer these conventions for new work:

- `*_protocol.md` for preregistered methods and stop conditions;
- `*_report.md` for interpreted results;
- `*_summary.json` for machine-readable metrics;
- `*_takeaways.md` for durable lessons;
- `README.md` for folder-level orientation;
- `manifest.json`, `manifest.jsonl`, or `benchmark_manifest.json` for package
  inventories;
- `*.jsonl`, `*.json`, `*.csv`, and `images/` for source data and derived
  artifacts;
- `scripts/` for generation and validation code that produced the package.

## Maintenance Rules

- Keep family-specific materials grouped together when a package has more than
  one artifact.
- Use subject-first names with date suffixes for new families.
- Keep development, calibration, holdout, challenge, and sentinel sets separate
  unless a report explicitly documents why they were mixed.
- Do not rely on chat history as the source of truth for what a research run
  found.
- Promote a repeated lesson into a task, architecture, or governance doc when
  it is stable enough to influence production behavior.

## Major Research Families

- AP Biology grading and reference-layer experiments
- AP Statistics grading experiments, calibration, and packet bundles
- AP Chemistry and AP Physics launch-support experiments
- Hand-drawn graph and HDR response corpora
- Grading protocol and reporting standards
- Supporting verification and runbook documents

## Suggested Entry Points

- [Grading Research Canonical Process](./GRADING_RESEARCH_CANONICAL_PROCESS.md)
- [Grading Cross-Subject Takeaways](./grading_cross_subject_takeaways.md) — durable lesson layer (boundary primacy, single-grader default, deterministic checks, feedback quality, gold-set depth)
- [Gold-Set Candidates Build Report 2026-07-08](./grading_gold_set_candidates_2026_07_08_report.md) — three calibration-tier candidate packages (Bio/Stats/Chem), adjudication-ready
- [Deterministic Numeric-Check Experiment 2026-07-08](./deterministic_check_experiment_2026_07_08/report.md) — $0 checker, 100% specificity, catches the numeric-error class
- [Label-Robustness Cross-Check 2026-07-08](./label_robustness_crosscheck_2026_07_08/report.md) — 0 confirmed label errors on checkable dimensions; independence is the remaining gap
- [Grading Generalization and Feedback Protocol 2026-07-08](./grading_generalization_and_feedback_protocol_2026_07_08.md) — preregistered cross-subject generalization test plus feedback-quality measurement
- [Grading Packet Backlog 2026-07-07](./grading_packet_backlog_2026_07_07.md)
- [Grading Test Packet Requirements](./grading_test_packet_requirements.md)
- [AP Statistics Grading Experiment Report Template](./ap_statistics_grading_experiment_report_template.md)
- [Bio Reference Layer Reporting Standard](./bio_reference_layer_reporting_standard.md)

## Notes

This index is intentionally lightweight. Existing research files stay where
they are; new work should follow the conventions above so the folder stays
searchable by both humans and AI.
