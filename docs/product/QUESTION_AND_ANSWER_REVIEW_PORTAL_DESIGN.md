# Question and Answer Review Portal Design

**Status:** Proposed for Product Owner, Learning Quality, tutor, AP Reader,
accessibility, and security review
**Related Task:** `UX-002`
**Owner:** Product Owner with Learning Quality Owner
**Last Updated:** 2026-06-13

## 1. Purpose

This document defines the proposed reviewer workflow and interaction model for
independent tutor and AP Reader review of Cramapple question candidates and MCQ
answer options.

The portal decides candidate disposition. A candidate marked approved in this
workflow is not automatically published. Source, rights, teaching, grading,
accessibility, release, and exam-pack gates remain separately required.

## 2. Review Principles

1. Review one immutable artifact version at a time.
2. Keep the two tutor decisions independent and hidden from each other until
   both are submitted.
3. Make the score meaning visible wherever a reviewer scores.
4. Require a rationale for `Maybe` and `No`.
5. Never average difficulty labels into false agreement.
6. Treat edits as new versions that require reassessment.
7. Review MCQ answer options independently while preserving the whole-question
   context.
8. Prevent an incomplete or partially approved four-option MCQ from advancing.
9. Show reviewers what their decision will do before submission.
10. Keep submitted decisions immutable and auditable.

## 3. Score Definitions

### 3.1 Tutor Score

Each of two tutors independently assigns one score:

| Score | Label | Meaning |
| --- | --- | --- |
| 1 | Yes | Suitable to advance without substantive modification |
| 2 | Maybe | Plausible, but a specific issue requires modification or discussion |
| 3 | No | Unsuitable in the current version |

The **tutor aggregate** is the sum of the two locked scores:

| Aggregate | Possible votes | Disposition |
| --- | --- | --- |
| 2 | Yes + Yes | Advance to AP Reader review |
| 3 | Yes + Maybe | Reserve for modification and tutor reassessment |
| 4-6 | Yes + No, Maybe + Maybe, Maybe + No, or No + No | Exclude the current version |

The interface must say `Tutor aggregate` rather than only `Score` so reviewers
do not confuse an individual 1-3 decision with the combined 2-6 result.

### 3.2 AP Reader Score

The AP Reader assigns one score after a tutor aggregate of 2:

| Score | Label | Disposition |
| --- | --- | --- |
| 1 | Approve | Candidate passes this review stage |
| 2 | Edit and recycle | Create a new version and return it to two tutors |
| 3 | Exclude | Exclude the current version |

An AP Reader score of 2 does not permit editing and approval of the same
version. The edit creates a new immutable candidate version.

## 4. Question Workflow

```text
Question candidate version
  -> Tutor A independent review
  -> Tutor B independent review
  -> Aggregate tutor scores
       2 -> AP Reader review
              1 -> Question review approved
              2 -> New version -> two new tutor reviews
              3 -> Current version excluded
       3 -> Modification reserve -> new version -> two new tutor reviews
       4-6 -> Current version excluded
```

`Question review approved` means eligible for the next applicable content gate.
It does not mean production release.

## 5. Difficulty Label Workflow

Each assigned reviewer supplies one required difficulty label. Both tutors
label every question they review. The AP Reader supplies the third label only
for questions that reach AP Reader review:

1. Easy
2. Moderately easy
3. Medium
4. Hard
5. Very hard

Difficulty labels belong to the reviewed question version.

- If both tutor labels and the AP Reader label match exactly, the difficulty
  label is confirmed.
- A question that does not reach AP Reader review has no confirmed difficulty
  label from this workflow.
- If any label differs, the question enters `difficulty_discussion`.
- The portal does not average, round, or silently choose the median.
- A revised question receives fresh difficulty labels.
- Difficulty disagreement does not erase an approval decision, but it blocks a
  confirmed difficulty label until an authorized discussion is recorded.

The exact five label names remain proposed copy and should be tested with
reviewers.

## 6. MCQ Answer Workflow

Answer review begins only after the MCQ question passes question review.

The four answer options remain part of one versioned MCQ package:

- one designated correct answer;
- three designated distractors;
- question stem;
- rationale and option-specific review context.

Each answer option is reviewed independently by two tutors using the same
1-3 tutor scale.

```text
Answer option version
  -> Tutor A independent review
  -> Tutor B independent review
  -> Aggregate tutor scores
       2 -> AP Reader answer review
              1 -> Answer approved
              2 -> New answer/package version -> two tutor reviews
              3 -> Current MCQ package excluded
       3 -> Modification reserve -> new answer/package version -> two tutor reviews
       4-6 -> Current MCQ package excluded
```

All four answer options must be approved before the answer-review stage is
complete. If any answer is excluded, the current MCQ package is excluded.
Substantive answer changes trigger the dependency and revalidation rules in
the content-governance policy.

## 7. Reviewer Portal Information Architecture

### 7.1 Primary Areas

| Area | Purpose |
| --- | --- |
| My queue | Assigned question and answer reviews |
| In progress | Draft reviews not yet submitted |
| Submitted | Reviewer-owned immutable decisions |
| Discussion | Difficulty disagreements assigned to the reviewer |
| Reference | Current score definitions, checklists, and reviewer policy |

Administrative assignment, qualification, release, and authoring tools remain
outside the reviewer portal.

### 7.2 Queue Cards

Each queue item shows:

- artifact ID and version;
- question or answer review;
- MCQ or FRQ;
- tutor or AP Reader stage;
- due date;
- topic and intended difficulty;
- progress, such as `Question 4 of 12` or `Answer B, 2 of 4`;
- whether the review is independent and blinded;
- draft, ready, submitted, or recusal state.

Do not show the other tutor's identity, score, rationale, or difficulty label
before both tutor decisions are locked.

## 8. Carousel Review UX

### 8.1 Stable Layout

Desktop uses three regions:

1. **Queue rail:** filters, progress, and current assignment.
2. **Artifact stage:** question, answer options, rationale, visual, and version.
3. **Review panel:** score, difficulty, rationale, concerns, and submit action.

Mobile stacks the artifact before the review controls and keeps a sticky
`Review this item` action. The carousel must not rely on horizontal swiping;
visible Previous and Next controls remain available.

### 8.2 Question Review Card

Show:

- immutable candidate version;
- question stem and any governed stimulus;
- question form, topic, skill, and intended use;
- proposed answer or scoring target needed for review;
- source and rights status summary;
- author identity hidden during independent review where practical;
- `Report conflict / recuse` action.

The review panel requires:

- one tutor or AP Reader score;
- one difficulty label;
- concern codes;
- rationale for `Maybe`, `No`, `Edit and recycle`, or `Exclude`;
- optional note for `Yes` or `Approve`;
- a plain-language disposition preview;
- explicit `Submit and lock` confirmation.

### 8.3 Answer Review Card

Keep the full MCQ visible and highlight the answer under review. Show whether
the option is the proposed correct answer or a distractor.

The reviewer considers:

- correctness or incorrectness as intended;
- scientific accuracy;
- uniqueness of the correct answer;
- plausibility of the distractor;
- unintended clues or ambiguity;
- consistency with the stem and rationale.

Scoring remains one independent 1-3 decision per answer option.

### 8.4 Keyboard and Carousel Behavior

- `1`, `2`, and `3` select the score only while the review panel is active.
- Difficulty uses labeled buttons, not an unlabeled numeric shortcut.
- `Previous` and `Next` navigate only after the current draft is saved.
- `Submit and lock` is never triggered by a single keyboard shortcut.
- Leaving with unsaved changes opens a warning.
- Submission moves to the next eligible assignment and announces the result.

## 9. Outcome Views

### 9.1 Tutor Completion

After submission, show only:

- the reviewer's locked decision;
- submission timestamp;
- whether the second independent review is pending;
- the next assigned item.

After both tutor reviews are locked, authorized users may see the aggregate and
resulting queue destination.

### 9.2 AP Reader Context

The AP Reader may see the two locked tutor decisions, rationales, and concern
codes. The interface must distinguish evidence from the AP Reader's own score
and must not preselect a decision.

### 9.3 Difficulty Discussion

Show all three locked labels, version, and reviewer rationales. The discussion
records a confirmed label or a decision to revise the question. It does not
rewrite prior review decisions.

## 10. State Model

Question states:

```text
tutor_review_pending
tutor_review_partial
ap_reader_pending
modification_reserved
excluded
question_review_approved
difficulty_discussion
difficulty_confirmed
```

Answer and package states:

```text
answer_tutor_review_pending
answer_ap_reader_pending
answer_modification_reserved
answer_approved
mcq_package_excluded
mcq_answer_review_complete
```

Review decisions are append-only. Derived queue states are rebuildable from
artifact versions, assignments, and locked decisions.

## 11. Accessibility and Security

- Complete keyboard operation and visible focus.
- Semantic groups for score and difficulty choices.
- No color-only status meaning.
- Live announcements for draft save, validation, and submission.
- Minimum 44 CSS-pixel controls where practical.
- Reflow at 390 CSS pixels without horizontal page overflow.
- Reviewer role, qualification, assignment, and artifact scope enforced by the
  server in production.
- No service keys, protected held-out cases, or unrelated reviewer records in
  the browser.
- Session timeout and reauthentication policy require separate security design.
- Recusal and conflict reporting remain available from every review.

## 12. Prototype Scope

The UX-002 prototype should demonstrate:

- tutor question review;
- missing-field validation;
- score 1, 2, and 3 disposition previews;
- tutor aggregate outcomes of 2, 3, and 4 or more;
- AP Reader question review;
- exact difficulty agreement and disagreement;
- independent review of four MCQ answers;
- answer exclusion blocking the current MCQ package;
- edit-and-recycle creating a new version;
- responsive carousel behavior.

The prototype uses original placeholder content and frontend-only state. It
does not authenticate users, write production records, or publish content.

## 13. Open Review Questions

- Confirm the five difficulty label names.
- Decide who owns and records difficulty discussion outcomes.
- Decide whether AP Readers see tutor scores before recording an initial
  independent impression.
- Define standardized concern codes for questions and answers.
- Define which answer edits require full question reassessment.
- Define assignment batch size, due dates, and reviewer compensation behavior.
- Complete security, privacy, retention, and audit design before production.
