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
11. Run a Codex pre-review before tutor assignment so obvious relevance,
    answer-key, rubric, or leakage problems are edited out before human review.

## 3. Review Decisions

**Model (updated by `DECISION-0038`, 2026-07-14).** The earlier numeric 1–3 score
is replaced by an explicit categorical decision — the numeric scale's
lower-is-better polarity and the individual-vs-aggregate confusion were a repeated
source of reviewer error (raised by Jill, AP Statistics tutor). Difficulty is a
separate attribute handled by Agree/Propose (§5), never mixed with the decision.

### 3.1 Tutor Decision

Each of two tutors independently records one decision:

| Decision | Meaning | Rationale required |
| --- | --- | --- |
| Approve | Suitable to advance as-is | no (optional note) |
| Approve with edits | Good, but specific edits are needed | yes |
| Disapprove | Not suitable in this version | yes |

The two locked tutor decisions resolve to a disposition (no numeric aggregate):

| Combination | Disposition |
| --- | --- |
| Approve + Approve | Advance to AP Reader review |
| At least one Approve-with-edits, no Disapprove | Edit and recycle — new version returns to two tutors |
| Any Disapprove | Exclude the current version (author may submit a revision) |

Note this changes the prior model: two "Maybe/Approve-with-edits" decisions now
route to edit-and-recycle, not exclusion.

### 3.2 AP Reader Decision

After a tutor disposition of Advance, the AP Reader records one decision, using
the same vocabulary:

| Decision | Disposition |
| --- | --- |
| Approve | Candidate passes this review stage |
| Approve with edits | Create a new version and return it to two tutors |
| Disapprove | Exclude the current version |

Approve-with-edits does not permit editing and approving the same version; the
edit creates a new immutable candidate version.

## 4. Question Workflow

```text
Question candidate version
  -> Codex pre-review
       pass -> Tutor A independent review
                 -> Tutor B independent review
       edit_needed -> Revision task in UX-003
  -> Resolve tutor decisions
       Approve + Approve -> AP Reader review
              Approve            -> Question review approved
              Approve with edits -> New version -> two new tutor reviews
              Disapprove         -> Current version excluded
       >=1 Approve-with-edits, no Disapprove -> Edit and recycle -> new version -> two new tutor reviews
       Any Disapprove -> Current version excluded
```

`Question review approved` means eligible for the next applicable content gate.
It does not mean production release.

Items routed to modification or `Edit and recycle` open an author revision task
in the UX-003 Content Authoring and Revision Workbench. UX-002 preserves the
locked decisions and triggering comments; UX-003 creates the successor version
and returns it to the required independent reassessment queue.

## 5. Difficulty Agree/Propose Workflow

**Model (updated by `DECISION-0038`).** Reviewers no longer cold-label difficulty.
Each item carries an author-supplied **intended difficulty** on the five-level
scale (Easy, Moderately easy, Medium, Hard, Very hard). Each assigned reviewer
takes one action against it:

- **Agree** — accepts the intended difficulty.
- **Propose** — selects a different level from the five-level scale.

Rules:

- Difficulty is **confirmed** (`validated_difficulty` = intended) only when every
  assigned reviewer **Agrees**.
- If any reviewer **Proposes**, the question enters `difficulty_discussion`, which
  shows the intended level and each proposed level.
- The portal does not average, round, or silently choose the median.
- A revised question resets to the new version's intended difficulty and fresh
  agree/propose actions.
- A difficulty proposal does not erase a suitability decision, but it blocks a
  confirmed difficulty label until an authorized discussion is recorded.
- `difficulty_action` (`agree`|`propose`) and, when proposing, `difficulty_label`
  are recorded per reviewer (see migration `202607140001`).

The five label names remain proposed copy and should be tested with reviewers.

## 6. MCQ Answer Workflow

Answer review begins only after the MCQ question passes question review and
Codex has cleared the question for tutor review.

The four answer options remain part of one versioned MCQ package:

- one designated correct answer;
- three designated distractors;
- question stem;
- rationale and option-specific review context.

Each answer option is reviewed independently by two tutors using the same
categorical decision (Approve / Approve with edits / Disapprove).

```text
Answer option version
  -> Tutor A independent review
  -> Tutor B independent review
  -> Resolve tutor decisions
       Approve + Approve -> AP Reader answer review
              Approve            -> Answer approved
              Approve with edits -> New answer/package version -> two tutor reviews
              Disapprove         -> Current MCQ package excluded
       >=1 Approve-with-edits, no Disapprove -> new answer/package version -> two tutor reviews
       Any Disapprove -> Current MCQ package excluded
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
outside the reviewer portal. Authoring and recycled revision work is designed
in UX-003.

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
- imported batches can appear in the queue after a validated intake upload and
  Codex pre-review.

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

Before a question enters the tutor queue, Codex should screen the imported
candidate for:

- relevance to the requested skill and topic;
- stem clarity and completeness;
- answer-key correctness;
- distractor plausibility for MCQs;
- rubric alignment and boundary precision for FRQs;
- duplicate, leaked, or answer-giving wording.

Items that fail screening should route to revision, not tutor review.

The review panel requires:

- one tutor or AP Reader score;
- one difficulty label;
- one or more module and subtopic labels for question reviews;
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

Scoring remains one independent categorical decision (Approve / Approve with
edits / Disapprove) per answer option.
Each answer card should also support an explicit approve action and an explicit
propose-change action so the reviewer does not have to infer the available
outcome from a generic note field.

### 8.4 Keyboard and Carousel Behavior

- The Approve / Approve-with-edits / Disapprove decision uses labeled buttons
  (each with a text label and icon, not color alone); no numeric score shortcut.
- Difficulty Agree/Propose uses labeled buttons; Propose reveals the five-level
  picker.
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

After both tutor reviews are locked, authorized users may see the combined
disposition and resulting queue destination.

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
- Approve / Approve-with-edits / Disapprove disposition previews;
- tutor combination outcomes (both Approve; edit-and-recycle; any Disapprove);
- difficulty Agree/Propose, including a proposal opening difficulty discussion;
- AP Reader question review;
- exact difficulty agreement and disagreement;
- independent review of four MCQ answers;
- explicit question and answer approve/change actions;
- required module and subtopic tagging on question reviews;
- answer exclusion blocking the current MCQ package;
- edit-and-recycle creating a new version;
- batch upload parsing with a downloadable intake template;
- responsive carousel behavior.

The prototype uses original placeholder content and frontend-only state. It
does not authenticate users, write production records, or publish content.

## 13. Open Review Questions

- **Reviewer feedback (Jill, AP Statistics tutor, 2026-07-14) → `DECISION-0038`:**
  the numeric 1–3 score was confusing, so it was **replaced** by the categorical
  Approve / Approve-with-edits / Disapprove model (§3), and difficulty moved to
  Agree/Propose (§5). The content-artifact schemas track `intended_difficulty` vs
  `validated_difficulty` (`CONTENT_COVERAGE_BRIEFS.md` §4.2,
  `FACT_PACKS_AND_QUESTION_SETS.md` §5.4). Open follow-ups: (a) a post-exposure
  empirical difficulty layer that can open review to revise a confirmed label;
  (b) confirm split-decision (Approve + Disapprove) handling — currently excludes.
- Confirm the five difficulty label names.
- Decide who owns and records difficulty discussion outcomes.
- Decide whether AP Readers see tutor scores before recording an initial
  independent impression.
- Define standardized concern codes for questions and answers.
- Define which answer edits require full question reassessment.
- Define assignment batch size, due dates, and reviewer compensation behavior.
- Complete security, privacy, retention, and audit design before production.
