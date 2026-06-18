# Lovable Build Brief - UX-004 Student-Provided Question Intake

Build a polished, responsive, frontend-only prototype for a signed-in
Cramapple student who brings an outside question by typing, pasting,
photographing, or uploading it.

Do not connect Supabase, a database, production authentication, OCR, file
storage, model providers, or deployment. Photo and document behavior must use
local mock fixtures only.

## Goal

The student should be able to:

1. add a complete question;
2. verify what Cramapple captured;
3. resolve missing context or possible personal information;
4. confirm the proposed subject and topic match;
5. choose Teach, Hint, Check My Work, or Solution;
6. understand confidence and academic-integrity limits;
7. review the intake before beginning.

## Routes

```text
/prototype/bring-question
/prototype/bring-question/confirm
/prototype/bring-question/match
/prototype/bring-question/help
/prototype/bring-question/review
```

Use client-side routing or equivalent prototype state.

## Visual Direction

- Reuse the warm, focused Cramapple student visual language.
- Off-white canvas, deep green primary actions, white cards, restrained amber
  and red warnings.
- Keep the experience reassuring, direct, and academically serious.
- Avoid a chat-first interface.
- Desktop may use a compact step rail. Mobile must stack cleanly.

## Five-Stage Flow

### 1. Add Question

Input tabs:

- Type or paste
- Photo or screenshot
- Document

Copy:

```text
BRING A QUESTION

Add the complete question.

Include answer choices and any graph, table, diagram, passage, or earlier
subpart the question refers to.
```

Safety note:

```text
Remove personal information.

Do not include names, faces, school details, contact information, or anything
personal or confidential.
```

Do not claim Cramapple can detect every identifier.

Text entry uses a large multiline field. Photo and document entry use simulated
local fixtures with preview, replace, rotate/retake where relevant, and remove.
Do not actually upload files.

### 2. Confirm Capture

Show side by side on desktop and stacked on mobile:

- Original submission
- Cramapple captured

The original preview is distinct from the correctable extraction.

Completeness checklist:

- question text;
- answer choices;
- graph, table, diagram, or passage;
- earlier subpart or shared stimulus;
- learner answer when Check My Work is requested.

#### Missing Context

Example:

```text
This question mentions a graph that is not included.

Add the graph or describe what it shows. Cramapple will ask once rather than
inventing the missing information.
```

Actions:

- Add context
- Continue with a limitation
- Replace input

Continuing with a limitation must lower the mock confidence and disable
authoritative scoring language.

#### Possible Personal Information

Example:

```text
This may include personal information.

Review and remove the possible name and school information before continuing.
Cramapple may not detect everything.
```

Actions:

- Review and remove
- Use another image/input
- Cancel

Do not provide `Continue anyway` in this prototype.

#### Extraction Failure

Show the failed region and allow:

- correct extraction;
- retake;
- replace;
- switch to typing.

Never invent missing text.

### 3. Confirm Match

Show:

- subject;
- AP exam;
- unit/topic;
- skill or archetype;
- confidence.

High confidence may continue directly with correction available.

Moderate confidence requires confirmation:

```text
This looks like an AP Biology cellular energetics question about limiting
factors. Does that seem right?
```

Actions:

- Yes, continue
- Choose a different topic
- Add context
- This is not AP Biology

Supporting copy:

```text
Your confirmation helps routing. It does not create an official rubric or make
the uploaded question approved content.
```

Low confidence or unresolved missing context permits qualified conceptual help
only. Avoid precise scoring.

Unsupported subject:

- politely decline;
- do not improvise;
- show a disabled or clearly policy-blocked future waitlist action;
- explain that contact collection requires approved age and consent handling.

### 4. Choose Help

Four selectable cards:

#### Teach Me

Explain the concept, use a worked example where helpful, then offer a fresh
independent attempt.

#### Give Me a Hint

Give one bounded cue. Explain that subsequent work on the original question is
coached, not cold evidence.

#### Check My Work

Require the learner's answer or work.

- Validated match may support criterion-level feedback.
- Partial match evaluates supported elements and identifies unverified ones.
- No validated match gives formative reasoning feedback without an
  authoritative score.

#### Walk Through the Solution

Show the reasoning, then offer a related independent attempt. Explain that this
provides the most support and least cold-performance evidence.

### Assessment Context

Ask:

```text
Where is this question from?
```

Choices:

- Practice, homework, or studying
- A quiz or test I am taking right now
- I am not sure

For the prototype, choosing an active quiz or test:

- keeps Teach Me and Give Me a Hint available;
- disables Check My Work and Walk Through the Solution;
- shows that this is a conservative proposed behavior pending final
  academic-integrity policy.

Do not present this as final legal or product policy.

### 5. Review and Begin

Summary:

- input method;
- confirmed capture completeness;
- subject/topic/archetype;
- confidence;
- help mode;
- assessment context;
- learner answer present or absent;
- known limitations.

Primary action changes by mode:

- Start teaching
- Give me a hint
- Check my work
- Walk through the solution

Secondary actions:

- Edit question
- Change help
- Finish later

## Data Explanation

Display direct provisional copy:

```text
Your question stays part of your private learning activity. Cramapple may use
anonymous or deidentified questions and responses to improve its teaching and
grading. Making anything public is a separate reviewed process.
```

Also make clear:

- submission does not add the question to the canonical library;
- public publication is not automatic;
- publication never changes private grade, progress, or access;
- final consent, retention, deletion, and age-specific language require
  counsel approval.

Do not imply that submission grants publication rights.

## Mock State

```ts
type InputMethod = "text" | "photo" | "document";
type MatchConfidence = "high" | "moderate" | "low";
type HelpMode =
  | "teach"
  | "hint"
  | "check_work"
  | "solution";
type AssessmentContext =
  | "practice_or_homework"
  | "active_assessment"
  | "unsure";

type IntakeState = {
  inputMethod: InputMethod;
  originalSubmission: string;
  confirmedExtraction: string;
  includedParts: {
    questionText: boolean;
    answerChoices: boolean;
    visualOrPassage: boolean;
    priorContext: boolean;
    learnerAnswer: boolean;
  };
  possiblePersonalInformation: boolean;
  clarificationUsed: boolean;
  matchConfidence: MatchConfidence;
  subject: string | null;
  topic: string | null;
  archetype: string | null;
  helpMode: HelpMode | null;
  assessmentContext: AssessmentContext;
  learnerAnswer: string;
};
```

Persist mock drafts only in `localStorage`. Add a `Reset demo` action.

## Required Scenarios

1. Empty typed input validation.
2. Complete typed/pasted question.
3. Simulated clear photo.
4. Simulated document and page selection.
5. Possible personal-information warning and removal.
6. Missing graph and one clarification round.
7. Extraction failure and typed fallback.
8. High-confidence AP Biology match.
9. Moderate-confidence confirmation.
10. Low-confidence qualified guidance.
11. Unsupported-subject decline.
12. Each of the four help modes.
13. Check My Work missing-answer validation.
14. Active-assessment limitation.
15. Review-and-begin summary.
16. Finish-later recovery.

## Accessibility

- Full keyboard operation and visible focus.
- Semantic tabs or equivalent input-method controls.
- Real labels for every field.
- Live announcements for extraction, validation, save, and scenario changes.
- No drag-only upload.
- Text alternatives for image controls.
- No color-only status meaning.
- Touch targets at least 44 CSS pixels where practical.
- No horizontal overflow at 390 CSS pixels.
- Reduced-motion support.

## Forbidden Behavior

Do not:

- connect a backend;
- upload files;
- include credentials or secrets;
- use official College Board question text or protected assets;
- use unapproved Cramapple content;
- claim OCR or personal-information detection is complete;
- fabricate missing question material;
- present low-confidence grading as authoritative;
- add a student submission to canonical content;
- publish a submission;
- imply submission grants public-use rights;
- collect waitlist contact details before age and consent policy approval;
- present the active-assessment prototype rule as final policy.

## Completion Report

Report:

- routes and components;
- mock input behavior;
- validation and clarification behavior;
- confidence states;
- help-mode behavior;
- active-assessment behavior;
- responsive and accessibility checks;
- confirmation that no files, network calls, or protected content were used.
