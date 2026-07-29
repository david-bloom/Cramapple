# Cross-Subject Content Remediation Pilot

**Date:** 2026-07-27  
**Status:** Published under single-qualified-review plus AI-QA policy; second
qualified review is follow-up  
**Population:** 21 questions selected from the 164 latest versions that remain
`changes_requested`

## Purpose

This packet tests one reusable remediation workflow across subjects before the
remaining queue is revised in bulk.

The Production execution and verification outcome is recorded in
`PRODUCTION_REPAIR_REPORT.md`.

It contains:

| Repair class | Count |
|---|---:|
| Rubric-point restructuring | 8 |
| Missing/incorrect assumption or convention | 6 |
| Substantive rewrite or reviewer-finding adjudication | 6 |
| Already-correct no-change control | 1 |
| **Total** | **21** |

Subjects represented:

- AP Biology
- AP Chemistry
- AP Statistics
- AP Physics 1
- AP Physics 2
- AP Physics C: Electricity and Magnetism
- AP Physics C: Mechanics

## Files

- `repair_manifest.json` is the frozen selection and repair contract.
- `AUTHOR_PROMPT.md` is the handoff prompt for the qualified revision author.
- `source_snapshot.sql` resolves the complete latest Production artifact,
  active tutor finding, choices, and rubric rows for the frozen keys.

## Selection Principles

The packet deliberately includes:

- simple criterion separation;
- cases where point totals may need to change;
- cases where a criterion can be narrowed without changing total points;
- sign, phase, geometry, labeling, and initial-condition assumptions;
- experimental-design rewrites;
- course-level simplification;
- a reviewer finding that may itself be incorrect; and
- one item whose requested wording is already present.

This prevents the pilot from succeeding only on one easy repair pattern.

## Required Workflow

Policy update on 2026-07-27: one qualified human review plus documented AI QA
is sufficient for testing and Production. The second qualified human review is
tracked as an urgent follow-up and no longer blocks release. The steps below
describe the stricter preregistered pilot workflow and are retained as
historical context.

1. Resolve and freeze the latest Production source version for every key.
2. A qualified subject author proposes the successor package.
3. A second qualified subject expert checks scientific and AP-course validity.
4. Run deterministic package checks.
5. Create an immutable successor version; never overwrite the reviewed source.
6. Return the successor to two independent qualified tutors. The revision
   author cannot review their own work.
7. If the normal workflow requires it, advance a two-tutor approval to AP
   Reader review.
8. Only the reviewed successor may become `reviewed_approved`.
9. Publication remains a separate decision.

## Cross-Subject Repair Rules

### Rubric restructuring

- Every independently requested task must be visible in the rubric.
- One piece of evidence cannot earn two points unless the prompt explicitly
  assesses two distinct uses of that evidence.
- Total points may remain fixed only when the existing point budget can assess
  the prompt fairly. Otherwise the qualified author must propose and justify a
  new total.
- Each criterion needs learner-facing text, evidence requirements, accepted
  variants, and a minimum fix.
- Error-carried-forward behavior must be explicit when later work depends on an
  earlier result.

### Assumptions and conventions

- Put consequential assumptions in the student-visible stimulus or prompt, not
  only in the rubric.
- Define sign, direction, phase, geometry, axis, or initial condition once and
  use it consistently.
- Update the canonical answer, criteria, explanations, and distractors
  together.
- Recalculate affected results and check whether another answer remains
  defensible.

### Substantive rewrites

- Preserve the intended assessed construct unless the author records a
  construct-change decision.
- Rewrite the smallest coherent unit, but rebuild every dependent artifact.
- For MCQs, retain exactly one best answer and four complete rationales.
- For FRQs, align prompt tasks, canonical response, rubric criteria, accepted
  variants, and minimum fixes.
- If the reviewer finding appears wrong, adjudicate it; do not distort correct
  content merely to satisfy the comment.

## Pilot Exit Criteria

The packet is successful only if:

- all 21 receive an explicit disposition: revised, verified-no-change, or
  excluded;
- every revision has an immutable successor and field-level change summary;
- all point totals and prompt-to-criterion mappings reconcile;
- all calculations and units pass;
- all MCQs retain one best answer and unique choices;
- each revised item receives independent reassessment;
- no revision author self-reviews;
- unresolved reviewer findings remain visible; and
- no item is published by the remediation operation.

After the pilot, record:

- first-pass author completion rate;
- independent-review approval rate;
- number of second revisions required;
- defects introduced during remediation;
- median author and reviewer time per item; and
- which repair rules generalized across subjects.
