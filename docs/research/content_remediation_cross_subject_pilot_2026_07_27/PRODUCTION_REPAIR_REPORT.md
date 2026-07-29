# Cross-Subject Pilot Production Repair Report

**Applied:** 2026-07-27  
**Production project:** `pcntajvbdfqhbeewmdry`  
**Repair migration:** `20260728013916_repair_cross_subject_pilot_and_chemistry_labels.sql`  
**Release migration:** `20260728024242_publish_ai_qa_pilot_and_run_second_packet.sql`

## Outcome

All 21 frozen pilot questions now have immutable successor versions published
in Production.

- 19 successors contain the governed repair defined by the packet.
- `APSTAT-MOD8-M004` and `apchem-mcq-050` have content-identical successors
  returned to `draft` for a second qualified review.
- All 21 predecessor versions are `retired`.
- All 21 successors passed documented AI QA.
- All 21 have an approval record under the Product Owner policy that one
  qualified human review plus AI QA is sufficient for testing and Production.
- All 21 successor versions and parent items are `published`.
- A second qualified human review is recorded as follow-up, not a release gate.

## Repairs Applied

### Rubric-point restructuring

- `apphy1-frq-013`
- `apphy1-frq-034`
- `apphy2-frq-018`
- `apphy2-frq-024`
- `apphy2-frq-028`
- `apphycem-frq-024`
- `apphycm-frq-019`
- `apphycm-frq-028`

### Assumptions and conventions

- `apphy2-frq-013`
- `apphy2-frq-016`
- `apphycem-frq-002`
- `apphycem-frq-029`
- `apphycm-frq-021`
- `apphycm-mcq-004`

### Substantive rewrites

- `APBIO-HDG-2026-GRAPH-006`
- `APBIO-MCQ-069`
- `apphy1-frq-009`
- `apphy2-frq-009`
- `apphycem-frq-011`

### Second-review controls

- `APSTAT-MOD8-M004`
- `apchem-mcq-050`

The Chemistry calorimetry content was not changed: the existing dimensional
analysis supports specific heat capacity and the tutor's proposed heat-capacity
change requires independent adjudication. The Statistics wording was also
preserved because it already contains the tutor's requested sentence.

## Chemistry Historical Label Repair

Exactly 12 superseded AP Chemistry FRQ versions had a real active tutor outcome
but retained `review_status='tutor_review_pending'`.

- Four `approve` outcomes now have
  `review_status='question_review_approved'`.
- Eight `approve_with_edits` outcomes now have
  `review_status='modification_reserved'`.
- All 12 versions are `retired` because each has a newer successor.
- No latest version or parent item was relabeled by this historical repair.

## Verification

Initial post-repair reconciliation found the draft state documented below.
The later release reconciliation found 21/21 successors published with
`review_status='question_review_approved'`, an approval basis of
`single_qualified_review_plus_ai_qa`, and
`second_human_review_status='follow_up_pending'`.

- 21/21 latest pilot successors in `draft`;
- 21/21 successor parent items in `draft`;
- 21/21 successor versions with no review decision;
- 21/21 predecessor versions retired;
- 17/17 substantively repaired FRQs with rubric-point totals matching
  `prompt_json.total_points`;
- 3/3 MCQs with four unique choices and exactly one correct answer;
- both second-review controls content-identical to their predecessors; and
- 12/12 Chemistry historical review outcomes mapped correctly.

## Second-Reviewer Follow-up

Production currently has no second actively qualified reviewer for either:

- AP Statistics other than the original reviewer, Jill Schmidlkofer; or
- AP Chemistry other than the original reviewer, Muhammad Zeeshan.

The Product Owner subsequently changed the release policy: a single qualified
review plus AI QA is sufficient for testing and Production. The two controls
were therefore published with the rest of the packet. A qualified second review
is still required as follow-up and the original reviewers must not review their
own work.
