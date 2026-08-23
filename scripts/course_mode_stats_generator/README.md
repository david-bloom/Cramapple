# Course-Mode AP Statistics Generator (pilot, drift-safe subset)

Built 2026-08-23 on branch `course-mode/stats-generator-pilot`. Implements the
**drift-safe** portion of `docs/teaching/COURSE_MODE_PILOT_BUILD_PLAN.md`:
F1 (registry) + the computational generator (Track A) + one Practice-4 slot-frame
(Track B). The DB integration (F2/F4/A6/A7 serving) is intentionally NOT built —
it sits on tables that are out of sync Dev↔Prod (`content_item_versions`,
`grading_results`, `exam_pack_versions` differ; `content_taxonomy_labels` missing
in Dev). See `project_task0027_schema_convergence_status`.

Synthetic tooling. Generated items are NOT official College Board content and are
emitted `release_status: unreleased_generated_pending_review` — they require the
CM-D19 template-release + review gate (David reviewer of record) before any serving.

## Files
- `statlib.py` — stdlib-exact stats primitives (normal via erf; Acklam inverse; regression; proportion inference). Verified against known values.
- `cells.py` — F1 skill taxonomy + 131-cell registry (topic × skill) from fact pack §3. `python3 cells.py` prints invariants.
- `generator.py` — Track A: 5 computational procedures × scenario × form, misconception-tagged distractors, item-package emission, property harness. `python3 generator.py` runs checks; `emit` writes samples.
- `slot_frames.py` — Track B: authored 4.B slot-frame (cell 1.9 × 4.B), observational-only scenarios. `python3 slot_frames.py` runs checks; `emit` writes samples.
- `f1_build.py` — emits `out/f1_cell_registry_seed.json` + `f1_migration_DRAFT.sql` (DRAFT, not applied).
- `out/` — sample emitted item-packages + F1 seed.

## What is validated
- Registry: 55 topics, 131 cells (U1:28 U2:21 U3:42 U4:30 U5:10); skills/practice P1:1 P2:5 P3:5 P4:7.
- Track A: 5 procedures — one-proportion z-interval (3.3×3.E), two-proportion z-test (3.13×3.E), LSRL predict (5.3×3.B), normal probability (2.11×3.C), summary statistics (1.7×3.B). Default `python3 generator.py` = 400 instances / 3,040 per-instance invariant checks + 5 meta-property tests, all pass; every MCQ has 1 key + 3 distinct misconception-tagged distractors with enforced key/distractor separation (>2× grading tolerance); emission is gated (resample until valid); deterministic_checks populated. Hardened 2026-08-23 per Fable QA (impossible predictions, throwaway/degenerate distractors, cell over-tagging, ungated emission all fixed; a real LSRL predict argument-order bug was caught by the property harness).
- Track B: 1 frame, 60 instances / 360 checks pass; scenarios observational; each distractor a tagged misconception.

## Scope / deferred (for morning review)
- t- and χ²-based procedures need special functions → a **scipy dependency decision** (env is stdlib-only). Procedures currently cover the normal/proportion/regression/descriptive computational cells.
- The generator emits its own draft package schema (`schema_version: course-mode-generated-0.1`). Mapping to the exact production item-package + DB ingestion is part of the deferred F4 (drifted tables).
- F1 migration is DRAFT and NOT applied to Dev. taxonomy_* are in sync, so it is safe to apply after review.
- Track B is n=1 frame family; it confirms the mechanism and gives an authoring-cost estimate (≈1 frame family per P4 skill), not full P4 coverage.

## Run everything
```
python3 cells.py && python3 generator.py && python3 slot_frames.py && \
python3 generator.py emit && python3 slot_frames.py emit && python3 f1_build.py
```
