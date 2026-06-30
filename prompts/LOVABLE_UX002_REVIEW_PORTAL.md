# Lovable Build Brief - UX-002 Question and Answer Review Portal

Build a polished, responsive Cramapple reviewer portal from this brief. The
result should run in mock mode when backend config is absent, but when
Supabase config and session are available it must read the live review queue
and write reviewer decisions through the approved content review endpoints.

## Purpose

Reviewers work through assigned question candidates and MCQ answer options in
a carousel. The prototype must make independent scoring, candidate disposition,
difficulty labeling, version recycling, and whole-MCQ validity easy to
understand.

Approval in this portal is candidate-stage approval only. It does not publish
content or replace source, rights, teaching, grading, accessibility, release,
or exam-pack gates.

Use Supabase Auth/session as the source of truth for reviewer identity. When
backend config is missing, the UI should visibly stay in mock mode and preserve
that absence so the wiring can be fixed later.

## Visual Direction

- Serious, calm editorial workbench rather than a student study interface.
- Warm off-white canvas, deep green navigation, white review cards, restrained
  amber and red warning states.
- Strong readable typography and generous spacing.
- Desktop: queue rail, central artifact carousel, sticky review panel.
- Mobile: stacked artifact and review controls with visible Previous and Next.
- No gamification, confetti, streaks, leaderboards, or playful scoring.

## Prototype Routes

```text
/prototype/review
/prototype/review/questions/:assignmentId
/prototype/review/answers/:assignmentId
/prototype/review/difficulty/:discussionId
```

Client-side routing is acceptable.

## Roles

Prototype two role contexts:

```ts
type ReviewerRole = "tutor" | "ap_reader";
```

Show reviewer name, role, AP Biology qualification scope, and independent or
assigned-review context in the header.

## Score Contract

Tutor decisions:

```ts
type TutorScore = 1 | 2 | 3;
// 1 = Yes
// 2 = Maybe
// 3 = No
```

Two locked tutor scores create an aggregate:

```text
2     -> AP Reader review
3     -> modification reserve and new version
4-6   -> exclude current version
```

AP Reader decisions:

```ts
type APReaderScore = 1 | 2 | 3;
// 1 = Approve
// 2 = Edit and recycle to two tutors
// 3 = Exclude
```

Always label the combined value `Tutor aggregate`, never just `Score`.

## Difficulty Contract

Both tutors label every assigned question. The AP Reader supplies the third
label only for questions that reach AP Reader review:

```ts
type Difficulty =
  | "Easy"
  | "Moderately easy"
  | "Medium"
  | "Hard"
  | "Very hard";
```

- Exact agreement across both tutors and the AP Reader confirms the label.
- Any difference creates a difficulty-discussion item.
- A question that does not reach AP Reader review has no confirmed difficulty
  label from this workflow.
- Do not average, round, or choose a median automatically.
- Answer options do not receive separate difficulty labels.

## Question Workflow

```text
Question version
  -> Tutor A
  -> Tutor B
  -> aggregate 2: AP Reader
       -> 1: candidate-stage approved
       -> 2: new version and two new tutor reviews
       -> 3: current version excluded
  -> aggregate 3: modification reserve and new version
  -> aggregate 4-6: current version excluded
```

Submitted decisions are immutable. Editing always creates a new version.

## MCQ Answer Workflow

Answer review begins only after the MCQ question passes question review.

Show the full question and all four options while highlighting the answer under
review. Clearly identify the proposed correct answer and each distractor.

Each answer receives two independent tutor scores and, after aggregate 2, one
AP Reader score.

```text
Tutor aggregate 2 -> AP Reader answer review
Tutor aggregate 3 -> modification reserve and new answer/package version
Tutor aggregate 4-6 -> exclude current MCQ package

AP Reader 1 -> answer approved
AP Reader 2 -> new answer/package version and two tutor reviews
AP Reader 3 -> exclude current MCQ package
```

All four answers must be approved. If one answer is excluded, the current MCQ
package is excluded. Do not display a state in which the remaining three
answers form an approved MCQ.

## Queue

Create queue tabs or filters:

- My queue
- In progress
- Submitted
- Difficulty discussion
- Reference

Queue cards show:

- artifact ID and version;
- question or answer;
- MCQ or FRQ;
- tutor or AP Reader stage;
- due date;
- topic and intended difficulty;
- progress;
- independent/blinded state;
- draft, ready, submitted, or recused.

Before both tutor reviews are locked, do not show the other tutor's identity,
score, rationale, or difficulty label.

## Carousel

Provide:

- visible Previous and Next buttons;
- current position and assignment count;
- local prototype draft-save indicator;
- unsaved-work warning;
- no swipe-only navigation;
- no submit-on-keyboard shortcut.

Desktop stable regions:

1. Queue rail.
2. Artifact stage.
3. Review panel.

## Question Review Screen

Artifact stage shows:

- candidate ID and immutable version;
- question stem and governed stimulus placeholder;
- question form, topic, skill, intended use, and intended difficulty;
- proposed answer or scoring target needed for review;
- source and rights status summary;
- original-placeholder warning;
- conflict/recusal action.

Review panel requires:

- score;
- difficulty;
- selectable concern codes;
- rationale;
- disposition preview;
- `Submit and lock`.

Require rationale for tutor `Maybe` and `No`, and AP Reader `Edit and recycle`
and `Exclude`.

## Answer Review Screen

Keep all four options visible and highlight the assigned option.

Show a compact checklist:

- correct or incorrect as intended;
- scientifically accurate;
- one uniquely correct answer;
- distractor plausibility;
- no ambiguity or unintended clue;
- consistent with stem and rationale.

Score each answer independently. Hide the difficulty control.

## AP Reader Screen

Show the two locked tutor decisions and rationales as evidence, without
preselecting the AP Reader score.

Disposition preview:

- `1 Approve`: candidate stage passes.
- `2 Edit and recycle`: new immutable version; two tutor reviews reset.
- `3 Exclude`: current question version or MCQ package is excluded.

## Difficulty Discussion

Show all three locked difficulty labels and their rationales.

Allow an authorized discussion outcome:

- confirm one label; or
- revise the question.

Prior decisions and labels remain visible as immutable history.

## Mock State

Use typed frontend-only fixtures:

```ts
type ReviewDecision = {
  assignmentId: string;
  artifactVersionId: string;
  role: ReviewerRole;
  score: 1 | 2 | 3 | null;
  difficulty: Difficulty | null;
  concernCodes: string[];
  rationale: string;
  status: "draft" | "submitted" | "recused";
};

type CandidateState =
  | "tutor_review_pending"
  | "ap_reader_pending"
  | "modification_reserved"
  | "excluded"
  | "question_review_approved"
  | "difficulty_discussion"
  | "difficulty_confirmed";
```

Persist draft prototype state in `localStorage`. Add `Reset demo`.

## Accessibility

- Full keyboard operation.
- Visible focus.
- Semantic fieldsets or groups for score and difficulty.
- `aria-pressed` or radio semantics for selectable cards.
- Live regions for validation, draft-save, and submission.
- No color-only score or status meaning.
- Touch targets at least 44 CSS pixels where practical.
- Reflow without horizontal page overflow at 390 CSS pixels.
- Reduced-motion support.

## Security and Data Boundaries

Do not:

- connect Supabase or any database;
- add production authentication;
- create service keys or secrets;
- write reviewer or content records;
- expose one tutor's review before both are locked;
- allow authors to approve their own work;
- mutate a submitted decision;
- edit and approve the same artifact version;
- imply candidate approval publishes content;
- use official College Board question text or protected assets;
- use unapproved Cramapple candidate content;
- add student data.

Use original placeholder biology content only.

## Required Prototype States

1. Tutor question review with missing-score validation.
2. Missing-difficulty validation.
3. Missing-rationale validation for score 2 or 3.
4. Tutor aggregate 2, 3, and 4-or-more outcomes.
5. AP Reader question scores 1, 2, and 3.
6. Tutor review of one correct answer and one distractor.
7. AP Reader answer scores 1, 2, and 3.
8. One answer exclusion blocking the MCQ package.
9. Four answers approved.
10. Exact difficulty agreement.
11. Difficulty disagreement and discussion.
12. Recusal.
13. Desktop and 390-by-844 mobile layouts.

## Completion Report

Report:

- routes and components;
- mock-state behavior;
- validation behavior;
- all tested scoring branches;
- accessibility checks;
- responsive checks;
- confirmation that there are no backend calls or protected content.
