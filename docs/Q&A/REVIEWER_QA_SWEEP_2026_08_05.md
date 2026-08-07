# Reviewer QA sweep — 2026-08-05

## Fresh execution addendum — 2026-08-05 21:14 UTC

Protocol execution refreshed against Production project `pcntajvbdfqhbeewmdry`
at `2026-08-05 21:14:52+00`, using the same read-only Management API query
runner. The refreshed review window was `2026-08-04 21:14:52+00` through the
run time, so it is a later rolling-24-hour slice than the original `13:41 UTC`
snapshot below.

Refreshed artifacts:

- Aggregate JSON: `/private/tmp/reviewer_qa_sweep_20260805_fresh.json`
- Follow-up quality JSON: `/private/tmp/reviewer_qa_followup_20260805_fresh.json`

Refreshed aggregate result:

- 109 included tutor-question `subject_review` decisions.
- 5 active reviewers.
- 104 distinct question versions.
- 61 MCQ decisions and 48 FRQ decisions.
- Automated integrity checks found 0 reviewer mismatches, 0 decision/version
  mismatches, 0 stage mismatches, 0 unsubmitted assignments with submitted
  decisions, 0 missing content versions, and 0 missing stems.
- Automated structure checks found 0 reviewed MCQ versions with invalid choice
  structure and 0 reviewed FRQ versions with missing/incomplete criteria.

Refreshed volume by reviewer:

| Reviewer | Decisions | Approve | Approve with edits | Disapprove | Notes | Topic selections | Median gap |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Abdul Hanan | 50 | 16 | 33 | 1 | 34 | 0 | 95.95s |
| Adil Abbasi | 24 | 4 | 20 | 0 | 23 | 24 | 176.95s |
| Muhammad Saood | 21 | 10 | 10 | 1 | 21 | 0 | 83.57s |
| Sarah Sohail | 13 | 4 | 2 | 7 | 10 | 13 | 459.82s |
| Shazia Fazal | 1 | 1 | 0 | 0 | 0 | 0 | n/a |

Refreshed main QA signals:

1. `APBIO-MCQ-008` is the clearest routing/adjudication item. Sarah approved
   while explicitly saying one edit is needed: trim Option B's rationale to
   remove named thermodynamic terminology outside CED depth. Adil separately
   marked the same item `approve_with_edits` and identified a stimulus/choice
   handoff issue plus a distractor replacement request.
2. `APBIO-MCQ-011` has a boundary disagreement: Sarah disapproved as outside AP
   scope because the item uses quantitative Michaelis-Menten parameters, while
   Adil marked `approve_with_edits` with the same scope concern and a proposed
   replacement using plain-language relative rate.
3. `APBIO-MCQ-014`, `APBIO-MCQ-016`, and `APBIO-MCQ-026` have Sarah approval
   versus Adil `approve_with_edits` disagreements. Adil's notes identify weak
   distractor discrimination, a plant-cell isotonicity/content issue, and CED
   signaling-vocabulary alignment respectively. These should be owner-checked
   before treating the approvals as clean.
4. The known watchlist query returned no hits in the refreshed window.
5. Topic-selection compliance remains split: Adil and Sarah supplied topics on
   all refreshed submissions, while Abdul and Saood submitted 71 combined
   decisions with 0 topic selections. Shazia's single refreshed decision also
   had no topic selections.
6. Difficulty-label disagreement remains concentrated in math reviewers:
   Abdul differed from authored difficulty on 39/50 submissions with authored
   labels; Saood differed on 14/21; Shazia differed on 1/1. Adil and Sarah had
   no authored difficulty metadata in the refreshed Biology slice.

Refreshed follow-ups:

- Owner-adjudicate `APBIO-MCQ-008` first because both reviewer notes point to a
  concrete CED/stimulus-rationale edit despite one clean approval label.
- Owner-adjudicate `APBIO-MCQ-011` as an AP-scope boundary case, not merely an
  edit-severity disagreement.
- Review Adil/Sarah disagreement set for AP Biology calibration:
  `APBIO-MCQ-014`, `APBIO-MCQ-016`, and `APBIO-MCQ-026`.
- Continue enforcing topic-selection expectations for Abdul and Saood before
  their next math review packet.

## Scope

- Production project: `pcntajvbdfqhbeewmdry`
- Sweep time: `2026-08-05 13:41:44+00`
- Review window: `2026-08-04 13:41:44+00` through the sweep
- Window rule: the later of 24 hours before the sweep and the prior documented full-sweep marker (`2026-07-31 03:31:05+00`)
- Included activity: human `subject_review` decisions at the `tutor_question` stage
- Active reviewers: reviewers with at least one included submission
- Mode: read-only Production queries; no content records or reviewer decisions were modified

The window contained 127 decisions by six reviewers across 119 distinct question versions: 42 MCQ decisions and 85 FRQ decisions.

## Volume by reviewer

| Reviewer | Decisions | Approve | Approve with edits | Disapprove | Notes | Topic selections | Median gap |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Abdul Hanan | 52 | 33 | 19 | 0 | 26 | 0 | 88.74s |
| Gulgeldi Darrynow | 28 | 23 | 5 | 0 | 12 | 0 | 221.14s |
| Shazia Fazal | 24 | 23 | 1 | 0 | 2 | 24 | 208.58s |
| Muhammad Saood | 21 | 10 | 10 | 1 | 21 | 0 | 83.57s |
| Adil Abbasi | 1 | 0 | 1 | 0 | 1 | 1 | n/a |
| Sarah Sohail | 1 | 0 | 1 | 0 | 1 | 1 | n/a |

## Subject mix

| Subject | Type | Decisions | Versions | Approve | Approve with edits | Disapprove |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| AP Biology | FRQ | 1 | 1 | 0 | 1 | 0 |
| AP Biology | MCQ | 1 | 1 | 0 | 1 | 0 |
| AP Calculus AB | FRQ | 15 | 14 | 8 | 7 | 0 |
| AP Calculus AB | MCQ | 8 | 8 | 2 | 6 | 0 |
| AP Calculus BC | FRQ | 18 | 13 | 14 | 4 | 0 |
| AP Calculus BC | MCQ | 6 | 5 | 5 | 1 | 0 |
| AP Chemistry | FRQ | 12 | 12 | 9 | 3 | 0 |
| AP Chemistry | MCQ | 16 | 16 | 14 | 2 | 0 |
| AP Precalculus | FRQ | 19 | 18 | 9 | 9 | 1 |
| AP Precalculus | MCQ | 7 | 7 | 5 | 2 | 0 |
| AP Statistics | FRQ | 20 | 20 | 19 | 1 | 0 |
| AP Statistics | MCQ | 4 | 4 | 4 | 0 | 0 |

## Integrity and structure checks

Automated checks found:

- no reviewer/assignment mismatches;
- no decision/version mismatches;
- no stage mismatches;
- no submitted decisions attached to unsubmitted assignments;
- no missing content versions or missing stems;
- no reviewed MCQ versions with invalid choice count, keyed-answer count, blank choice text, or blank rationale; and
- no reviewed FRQ versions missing criteria, positive point values, learner-facing criterion text, evidence requirements, or minimum-fix text.

## Quality signals

### Main risks to adjudicate

1. `apprecalc-frq-u12-001` has a paired-reader conflict: Muhammad Saood disapproved while Abdul Hanan approved. Saood's note identifies a substantive flaw: the table values support selected secant-slope comparisons but do not prove increasing-at-an-increasing-rate/concavity claims, and the extrapolation beyond `x=8` is unsupported without an explicit assumption.

2. `apcalcbc-frq-u13-014` has a paired-reader conflict: Muhammad Saood requested edits while Abdul Hanan approved. Saood's note says the Part C reasoning should use EVT or otherwise supply missing logic; MVT on adjacent intervals alone does not rigorously guarantee the stated local maximum.

3. Gulgeldi Darrynow filed multiple plain approvals with note text that asks for edits. These are currently `reviewed_approved`, so the notes do not enter an edit workflow:
   `apchem-sfrq-033`, `apchem-sfrq-035`, `apchem-sfrq-037`, `apchem-frq-l-027`, `apchem-sfrq-026`, `apchem-sfrq-031`, and `apchem-sfrq-027` v2. Most look like formatting/style requests, but the workflow pattern is still a calibration issue: requested changes should be `approve_with_edits` or omitted from approval notes.

4. Watchlist key `apchem-mcq-038` appeared again. This submission was for version 2, not the known defective version 1, and was approved note-free by Gulgeldi. No immediate false-clear finding from the watchlist query, but this item should remain on owner QA's radar because version 1 has recurred across prior sweeps.

### Other paired disagreements

The window had six paired-reader disagreements, all between Abdul Hanan and Muhammad Saood:

- `apcalcab-frq-u13-002`: Saood `approve_with_edits`, Abdul `approve`.
- `apcalcbc-frq-u13-010`: Abdul `approve`, Saood `approve_with_edits`.
- `apcalcbc-frq-u13-014`: Saood `approve_with_edits`, Abdul `approve`.
- `apcalcbc-frq-u13-018`: Abdul `approve`, Saood `approve_with_edits`.
- `apcalcbc-mcq-026`: Abdul `approve`, Saood `approve_with_edits`.
- `apprecalc-frq-u12-001`: Saood `disapprove`, Abdul `approve`.

Exact-match agreement on the comparable paired reads was 2/8; approval-boundary agreement was also 2/8. The denominator is small and concentrated in one reviewer pair, so this should be treated as a calibration signal rather than a global reviewer score.

## Reviewer performance notes

### Abdul Hanan

- Highest volume in the window: 52 decisions across Calculus AB, Calculus BC, and Precalculus.
- Strong pattern of detailed mathematical verification in edit notes, especially on FRQ answer keys and rubric sufficiency.
- Calibration risks: 52/52 topic selections empty; 38/52 difficulty labels differ from the authored difficulty. One approval conflicts with a substantive Saood disapproval on `apprecalc-frq-u12-001`.

### Gulgeldi Darrynow

- Completed 28 Chemistry reviews: 23 approvals and 5 edit requests.
- Known watchlist item `apchem-mcq-038` was version 2 and approved note-free.
- Calibration risk remains decision routing: seven plain approvals carry edit language, repeating the approve-with-note pattern documented in the prior Gulgeldi QA.
- Topic selections empty on all 28 submissions.

### Shazia Fazal

- Completed 24 AP Statistics reviews: 23 approvals and 1 edit request.
- Metadata discipline was strongest in the window: 24/24 topic selections present.
- The one edit note on `apstats-frq-u12-005` is specific and actionable: a modified boxplot cannot be drawn from only the five-number summary because the highest non-outlier value is not identifiable.
- Difficulty labels differed from authored labels on 12 of 20 decisions with authored difficulty metadata.

### Muhammad Saood

- Completed 21 reviews across Calculus AB, Calculus BC, and Precalculus: 10 approvals, 10 edit requests, and 1 disapproval.
- Notes remain technically dense and actionable, with exact calculations and theorem-level reasoning.
- The disapproval on `apprecalc-frq-u12-001` appears substantive and should be owner-adjudicated against Abdul's approval.
- Topic selections empty on all 21 submissions; difficulty labels differed from authored labels on 14/21.

### Adil Abbasi

- One AP Biology MCQ edit request. The note is specific about AP focus, distractor quality, and CED vocabulary risk.

### Sarah Sohail

- One AP Biology FRQ edit request. The note is detailed and consistent with prior Sarah strengths: bundled criteria, ambiguity, and minimum-evidence gaps.

## Follow-ups

- Owner-adjudicate `apprecalc-frq-u12-001` and `apcalcbc-frq-u13-014` before publication reliance.
- Decide whether Gulgeldi's seven plain approvals with edit-language notes should be remediated as style-only owner edits or treated as misrouted `approve_with_edits` decisions.
- Continue enforcing topic-selection expectations: Abdul, Gulgeldi, and Saood submitted 101 combined decisions with 0 topic selections.
- Use the next calibration conversation to distinguish "approval note for audit trail" from "edit request that must block approval."

## Artifacts

- Query runner: `/private/tmp/reviewer_qa_sweep.mjs`
- Exact aggregate JSON: `/private/tmp/reviewer_qa_sweep_20260805.json`
- Follow-up quality slices: `/private/tmp/reviewer_qa_followup.mjs`
