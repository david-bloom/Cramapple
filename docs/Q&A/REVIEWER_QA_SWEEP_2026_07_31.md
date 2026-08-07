# Reviewer QA sweep — 2026-07-31

## Scope

- Production project: `pcntajvbdfqhbeewmdry`
- Review window: `2026-07-30 03:31:05+00` through the sweep
- Window rule: the later of 24 hours before the sweep and the end of the prior documented QA sweep
- Included activity: human `subject_review` decisions at the `tutor_question` stage
- Active reviewers: reviewers with at least one included submission

The window contained 164 decisions by five reviewers across 151 distinct
question versions: 62 MCQ versions and 89 FRQ versions.

## Integrity and content QA

Automated checks found:

- no reviewer/assignment mismatches;
- no decision/version mismatches;
- no stage mismatches;
- no submitted decisions attached to unsubmitted assignments;
- no missing stems or stimuli required by the stored item;
- every reviewed MCQ had four distinct, nonblank choices, exactly one keyed
  answer, and complete rationales; and
- every reviewed FRQ had scoring criteria with positive point values and
  nonblank criterion, evidence, and minimum-fix text.

All approvals were checked for mathematical or scientific correctness and AP
relevance. All edit and disapproval notes were checked for technical accuracy
and actionability. Six decisions referred to versions that had already been
retired after a corrected successor was created; each successor was present and
in the expected approved or published state.

## Defects corrected

The guarded remediation is recorded in
`scripts/content-seed/reviewer-qa-remediation/20260731_last_24h_reviewer_qa.sql`.
Original reviewer decisions were not changed or deleted.

### Workflow state

Three current Biology versions had been retired even though one member of a
genuine blind pair was still pending. The versions were restored to `assigned`
with `tutor_review_pending`:

- `APBIO-FRQ-S-017`
- `APBIO-FRQ-S-026`
- `APBIO-FRQ-S-064`

### AP Statistics

Three incorrectly approved items were excluded and retired:

- `STATS-MOD9-VH001`: nonparametric testing, including Mann–Whitney, is outside
  the AP Statistics Course and Exam Description.
- `STATS-MOD9-VH002`: bootstrap confidence intervals are outside the AP
  Statistics Course and Exam Description.
- `APSTATS-HDG-2026-GRAPH-006`: asks the student to copy a supplied curve and
  read a value already present in the table without defining or assessing a
  statistical concept.

Each exclusion has an immutable owner-QA decision that supersedes, but does not
erase, the original approval.

### AP Chemistry

Four corrected version-2 successors were created and independently QA-approved:

- `apchem-frq-l-013`: added the required deionized-water wash and drying steps
  so the recovered calcium carbonate is actually uncontaminated and dry.
- `apchem-frq-l-014`: replaced the kinetic-energy explanation with the correct
  endothermic-dissolution equilibrium reasoning and clarified that a
  supersaturated solution requires cooling without nucleation.
- `apchem-mcq-026`: removed the outdated d-orbital explanation of hypervalency.
- `apchem-mcq-029`: replaced an invalid universal force-strength hierarchy with
  a controlled boiling-point comparison among specified substances.

The four successor versions are `reviewed_approved`; each has a complete rubric
or four MCQ choices with exactly one correct answer. Pending assignments tied to
retired predecessors were marked `skipped`.

## Reviewer performance

### Abdul Hanan

- Completed 24 Precalculus reviews: 16 approvals and 8
  `approve_with_edits` decisions. Independent QA found the approvals correct and
  the eight edit requests accurate.
- His strongest work was distractor diagnosis: the notes often identified the
  exact misconception represented by an option and supplied a precise repair.
- Calibration opportunity: topic selection was empty on all 24 submissions and
  his difficulty label differed from the authored label on 15. Exact and
  approval-boundary agreement on 24 comparable second reads was 54.2%.

### Jill Schmidlkofer

- Completed 26 AP Statistics reviews: 16 approvals, 6
  `approve_with_edits`, and 4 disapprovals. Her edit and disapproval notes were
  specific and technically sound.
- Three approvals missed relevance defects: two topics outside the AP course
  scope and one graphing task that did not assess a defined statistical
  concept. The graph approval was also inconsistent with her disapproval of
  closely analogous graph-copying items.
- Difficulty calibration was strong, with only 2 mismatches, but topic
  selection was empty on all 26 submissions. No independent peer decision was
  available for a meaningful agreement rate in this window.

### Muhammad Saood

- Completed 75 reviews across Calculus BC, Chemistry, and Physics C Mechanics:
  17 approvals, 50 `approve_with_edits`, and 8 disapprovals. All 17 approvals
  checked as correct.
- His correction notes were the strongest technically in the window: they
  supplied exact calculations, equations, physical assumptions, and rubric
  repairs. He independently caught two Chemistry defects that another reviewer
  had approved.
- Calibration opportunity: topic selection was empty on all 75 submissions,
  and 22 difficulty labels differed from the authored label. The median interval
  between submissions was 1.13 minutes; despite good accuracy, that pace merits
  monitoring. Approval-boundary agreement was 52.0% on 50 comparable reads,
  largely because he was more stringent than the paired reviewer.

### Muhammad Zeeshan

- Completed 27 AP Chemistry reviews: 18 approvals and 9
  `approve_with_edits`. His quantitative chemistry work was generally careful,
  and his median interval between submissions was 19.44 minutes.
- Four approvals missed substantive defects: incomplete recovery of pure
  calcium carbonate, incorrect equilibrium language for crystallization,
  outdated d-orbital language for hypervalency, and an invalid universal
  intermolecular-force hierarchy.
- Topic selection was empty on all 27 submissions, and 12 difficulty labels
  differed from the authored label. Approval-boundary agreement was 46.2% on 13
  comparable second reads; targeted calibration with Saood’s notes would be
  useful.

### Sarah Sohail

- Completed 12 AP Biology reviews: 11 `approve_with_edits` decisions and 1
  disapproval. Her notes consistently identified missing directives, bundled
  point criteria, ambiguous evidence thresholds, and scientifically acceptable
  variants.
- She was the strongest reviewer on metadata discipline: all 12 submissions
  included topic selections and none changed the authored difficulty label.
- Approval-boundary agreement was 88.9% on 9 comparable second reads. Her exact
  three-way decision agreement was 44.4%, reflecting that she frequently chose
  `approve_with_edits` where the peer used another non-approval category.

## Post-remediation verification

- The three Biology items are assigned and each has one active paired-review
  assignment.
- The three Statistics items are retired with `review_status=excluded` and no
  active assignments.
- The four Chemistry successors are version 2, `reviewed_approved`, and have no
  active remediation assignments.
- The two corrected Chemistry MCQs each have four choices and exactly one keyed
  answer.
- The two corrected Chemistry FRQs each retain 10 total rubric points.
