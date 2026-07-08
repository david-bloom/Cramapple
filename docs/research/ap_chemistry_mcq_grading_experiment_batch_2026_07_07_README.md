# AP Chemistry MCQ Grading Experiment Batch — 2026-07-07

**Status:** Development test corpus for grading experiments; not a gold set, not a governed pilot batch, not publish-ready content.
**Related Task:** `TASK-0014`
**File:** `ap_chemistry_mcq_grading_experiment_batch_2026_07_07.jsonl` (100 items, one JSON object per line)

## Purpose

100 original AP Chemistry MCQs authored for grading-pipeline experiments, at David's request, following the numeric distribution he specified:

- **Difficulty:** Easy 22, Medium 33, Hard 28, Very Hard 17 (scaled proportionally from an initial 20/30/25/15 = 90 to match the 100-item module total, per his direction).
- **Module:** Units 1, 2, 4, 5, 6, 7, 9 at 7 items each (49); Unit 3 at 30; Unit 8 at 21. Matches the 9-unit placeholder scaffold in `docs/research/AP_CHEMISTRY_TAXONOMY.json`.

## Sourcing — rights posture

David initially asked for these items to be generated after "familiarizing" with the official AP Chemistry Course and Exam Description and a College Board Chief Reader report (containing real exam questions and scoring guidelines). That was declined: it conflicts with `CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md`'s Controlling Decision #1 ("official question text, scoring material, and identifiable official question structures do not enter authoring prompts, examples, adaptation workflows, or model inputs") and `TASK-0014`'s Out of Scope. None of the four URLs David provided were fetched.

Per David's confirmed direction, this batch was instead authored from general chemistry curriculum knowledge — standard topics taught in essentially every general/AP chemistry course (stoichiometry, atomic structure, bonding, intermolecular forces, kinetics, thermodynamics, equilibrium, acids/bases, electrochemistry) — with no College Board material as input, exemplar, or reference during generation.

## What this is / is not

- **Is:** a development test corpus for exercising the grading pipeline (MCQ answer-checking, difficulty stratification, module tagging) at volume, in the same spirit as `ap_statistics_frq_bootstrap_corpus_2026_07_07`.
- **Is not:** a governed pilot content batch (that's `TASK-0014` Phase 4, under `APPROVAL-0028`'s tutor-authored-base-package model, requiring Orly's originality/scientific/teaching review); not calibrated against a human gold set; not rights-cleared for publishing to students.
- Every choice's `rationale` field explains why that option is correct or incorrect — useful for grading-pipeline QA (e.g., checking whether a grader's stated reasoning aligns with the actual misconception a distractor targets), not intended as student-facing explanation text without review.

## Validation performed

All 100 items were checked programmatically: exactly 4 choices each, exactly 1 `is_correct: true` per item, and the difficulty/module counts match the target distribution exactly (verified via `python3 -c "..."` against the file — see commit history for the check).

## Known limitation

This is single-pass authored content, not independently reviewed. Numeric answers were hand-calculated during authoring; before using this corpus for anything beyond internal grading-pipeline testing, spot-check a sample of the quantitative items (particularly the Hard/Very Hard tier calculations in Units 3, 6, 7, 8, and 9) against independent computation.
