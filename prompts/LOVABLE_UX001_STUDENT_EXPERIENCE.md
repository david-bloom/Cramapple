# Lovable Build Brief - Cramapple Student Experience

## How To Use This File

Give this entire file to Lovable as the build prompt.

This is a frontend-first student experience build, not a `/prototype` route or
review-only sandbox. Use Supabase Auth/session as the source of truth when
available, and hydrate the student UI from the backend-composed
`runtime_context` returned by the session and grading functions. Fall back to
local preview state only when backend config is absent. Do not invent backend
behavior in the client. Remember missing backend config so the wiring can be
fixed later.

## Runtime Context Contract

The Lovable student experience must treat `runtime_context` as the single
runtime view of guidance, not as an extra optional payload.

- Bootstrap the active session by calling the session event function with
  `session_start` or `session_resume`, then store the returned
  `runtime_context`.
- Refresh the stored `runtime_context` after session saves, session end, and
  every grading response from `evaluate-attempt`.
- Render guided help, recommended next action copy, session framing, and the
  student-memory-aware help text from:
  - `runtime_context.subject_defaults`
  - `runtime_context.student_memory`
  - `runtime_context.session_state`
  - `runtime_context.effective_guidance`
- Do not recompute a parallel client-side recommendation engine or memory
  layer.
- If backend config is absent or a request fails in preview, use local preview
  state only as a visibly non-authoritative fallback.

Canonical Cramapple source material:

- `docs/product/STUDENT_PORTAL_INTERACTION_DESIGN.md`
- `docs/proposals/2026-06-29-year-aware-point-maximization.md`
- `docs/tasks/UX-001-INITIAL-PRODUCT-UX-DECISIONS.md`

If any instruction below conflicts with an assumption Lovable would normally
make, follow this file.

---

## Goal

Build the polished, responsive Cramapple student experience beginning
immediately after account creation.

Cramapple is an AP score-optimization product. The initial product focuses on
AP Biology and helps students use limited study time to earn more exam points
through guided topic selection, efficient instruction, targeted practice, and
criterion-level feedback.

The app should let students:

1. Complete one composed, recoverable post-account setup surface.
2. Start a transparent first-session plan quickly.
3. Adjust likely class position and available time.
4. Choose topic practice, check-my-work, or bring-a-question as secondary paths.
5. Complete a multiple-choice attempt and feedback.
6. Complete a free-response attempt, criterion feedback, repair, and retry.
7. See uncertainty and recheck states.
8. Finish a session and return to Home/Progress.

## Product Posture

- Optimize for points gained per hour of remaining study time.
- Work throughout the school year, not only during exam-season cramming.
- Reach useful work quickly.
- Guide the learner while preserving choice.
- Explain recommendations instead of silently redirecting.
- Keep the learning loop predictable rather than chatty.
- Separate effort from demonstrated learning.
- Represent grading and content uncertainty honestly.
- Never imply one response determines mastery, readiness, or an AP score.
- Never describe one repaired response as mastery.

## Routes

Use real app routes. Do not use `/prototype` anywhere.

```text
/account-created
/setup
/setup-paused
/topic
/check-work
/bring-question
/session/mcq
/session/frq
/session/uncertain
/session/complete
/home
/progress
/account
```

The app should open at:

```text
/account-created
```

Do not add a reviewer-only route rail, prototype switcher, or demo-state menu.
Navigation should match the student product surface. Use ordinary student
navigation only: Home, Review, Progress, Account.

## Visual Direction

Use a warm, focused academic visual system:

- Background: warm off-white or light parchment.
- Main ink: very dark green-black.
- Primary brand color: grounded dark green.
- Secondary highlight: restrained golden yellow.
- Success: calm green.
- Warning and uncertainty: warm amber.
- Errors: muted brick red.
- Cards: off-white with subtle borders and soft shadows.
- Corners: rounded but not childish.
- Typography: modern sans serif with strong editorial hierarchy.
- Calm, credible, direct, student-centered.
- Avoid generic AI-chat appearance, childish school graphics, mascots,
  confetti, streaks, and glossy marketing-page treatment inside the workflow.

Suggested design tokens:

```text
ink: #17231f
muted: #5f6f68
paper: #fffdf7
canvas: #f3f0e7
line: #d7d7cc
brand: #315f4b
brand-dark: #224737
brand-soft: #e6f0ea
accent: #d8a937
success: #276749
success-soft: #e7f4ec
warning: #8a5a12
warning-soft: #fff4d6
error: #9b3a34
error-soft: #fae9e7
```

## Shared Layout

Use:

- compact top bar with the Cramapple wordmark;
- student product navigation only;
- centered content column with comfortable maximum width;
- one clear primary action per state;
- secondary and tertiary actions that remain easy to find but do not compete;
- responsive behavior for phone, tablet, and desktop.

For setup, use one composed setup surface with recoverable sub-decisions. Do not
show five-step setup progress.

For learning-session pages, show:

1. Session context and progress.
2. Mode-appropriate orientation.
3. Question and attempt area.
4. Feedback, repair, retry, or completion state.

Do not show every state simultaneously.

## Implementation Shape

Use Lovable's standard React and TypeScript frontend stack. Tailwind and the
existing Lovable component system are acceptable.

Create reusable components rather than one oversized page. Suggested components:

```text
AppShell
TopContextBar
StudentNav
SetupSurface
CoursePositionPicker
TimeSelector
FirstSessionPlan
PrimaryActionRow
SupportingNote
SessionFrame
OrientationPanel
QuestionCard
ScorePanel
CriterionRow
RepairPanel
RecheckDialog
UncertaintyPanel
ProgressEvidenceCard
StatusToast
```

Use client-side routing for the app routes. Keep copy and mock scenario data in
small typed configuration objects where practical.

## Mock State

Use frontend-only local state when backend wiring is unavailable. This is
preview state only, not a second source of truth.

```ts
type SetupState = {
  exam: "AP Biology";
  officialExamDate: string;
  coursePosition: {
    unitId: string;
    unitLabel: string;
    source: "pacing_prior" | "learner_adjusted";
    positionEstimateConfidence: "low" | "medium" | "high";
    confirmedAt: string | null;
  };
  minutes: 15 | 30 | 60;
  firstIntent: "recommend" | "topic" | "check_work" | "bring_question";
  setupStatus: "not_started" | "in_progress" | "completed" | "deferred";
};
```

Keep authoritative exam data outside learner setup state:

```ts
const activeExamPack = {
  exam: "AP Biology",
  officialExamDate: "May 4, 2026",
  administration: "2026",
} as const;
```

Production work must resolve the official date from the active versioned exam
specification rather than retaining the mock fixture.

Persist setup state locally if backend storage is absent so a learner can pause
and resume. Do not create database tables or Supabase calls unless an existing
backend contract is already available.

## Page Behavior

### 1. Account Created

Route:

```text
/account-created
```

Purpose: confirm the account is ready and move directly into useful setup. The
guidance copy on this screen should be driven by `runtime_context` when
available so the student sees the current plan, not a hardcoded prompt.

Copy:

```text
ACCOUNT READY

Let’s make your first session useful.

Cramapple helps you use the time you have to earn more AP Biology points.
```

Primary action:

```text
Set up my first session
```

Secondary action:

```text
How Cramapple works
```

The secondary action opens a compact explanation:

```text
You will try a question, see where points were earned or missed, and practice
the smallest useful change.
```

### 2. One-Screen Setup

Route:

```text
/setup
```

This replaces all prior setup steps. Do not ask registration status. Do not ask
for a target AP score. Do not ask calibration vs. direct start.

Surface copy:

```text
START WITH A USEFUL SESSION

Here’s a short session based on where your AP Biology class probably is right
now. You can change anything before you begin.
```

Show AP Biology and official exam date as display-only system data:

```text
AP Biology
Official exam date: {{officialExamDate}}
```

If the date is unavailable:

```text
Official exam date not loaded.
```

Do not ask the learner to enter the exam date.

Course-position module:

```text
Your class is probably around Unit 3: Cellular Energetics.
```

Controls:

```text
That’s right
Change unit
I’m not sure
```

`That’s right` sets `source: "pacing_prior"`, `positionEstimateConfidence:
"high"`, and `confirmedAt`.

`I’m not sure` keeps Unit 3 but sets `positionEstimateConfidence: "low"`.

`Change unit` opens an accessible picker:

```text
Unit 1: Chemistry of Life
Unit 2: Cell Structure and Function
Unit 3: Cellular Energetics
Unit 4: Cell Communication and Cell Cycle
Unit 5: Heredity
Unit 6: Gene Expression and Regulation
Unit 7: Natural Selection
Unit 8: Ecology
```

Choosing any unit sets `source: "learner_adjusted"` and `confirmedAt`.

If the learner chooses a likely future unit, show soft copy:

```text
You can work ahead. If this feels too early, we’ll help you return to the
strongest covered next step.
```

Do not describe this as mastery or readiness.

Time module:

```text
How much time do you have?
```

Use real radio buttons or accessible segmented controls:

```text
15 min
30 min
60 min
```

Default to `15 min`.

Plan card:

```text
Recommended first session

{{selectedUnitLabel}}
About {{minutes}} minutes

You’ll try one question, see exactly where points were earned or missed, and
practice the smallest change most likely to help.

Why this?
We’re starting near where your AP Biology class probably is right now. You can
change the unit or time.
```

When backend runtime data is available, derive the plan card from
`runtime_context` instead of local heuristics. Use the runtime context to decide
the current session mode, session path, available minutes, and help copy.

Primary action:

```text
Start session
```

Secondary actions:

```text
Choose a topic
Check my work
Bring a question
Finish setup later
```

Routes:

- `Start session` -> `/session/mcq`
- `Choose a topic` -> `/topic`
- `Check my work` -> `/check-work`
- `Bring a question` -> `/bring-question`
- `Finish setup later` -> `/setup-paused`

### 3. Setup Paused

Route:

```text
/setup-paused
```

Copy:

```text
Setup paused.

Your plan is saved. You can come back and start from the same unit and time.
```

Primary action:

```text
Resume setup
```

Secondary action:

```text
Go to Home
```

### 4. Topic, Check-Work, And Bring-Question Routes

Keep these as real secondary product paths, not setup steps.

`/topic` should let the learner choose an AP Biology unit or skill.

`/check-work` should require both:

- the prompt/question;
- the learner’s attempted answer.

`/bring-question` should accept a pasted or typed class/practice question and
let the learner continue into a supported session.

Do not require prior calibration for any of these routes.

### 5. Learning Session

Routes:

```text
/session/mcq
/session/frq
/session/uncertain
/session/complete
```

The first practice item is ordinary useful practice and continuous evidence. Do
not call it a diagnostic test.

For cold attempts:

- do not reveal answer-bearing help before submission;
- make the response control accessible;
- show feedback only after submit;
- distinguish earned credit from the next repair step.

MCQ feedback should show:

- selected answer;
- correct answer after submission;
- why the choice earned or missed the point;
- one next repair or retry action.

FRQ feedback should show:

- criterion-level result;
- evidence from the learner response;
- bracket-marker repair for the highest-value missed criterion;
- retry path that preserves the original response.

Uncertainty state:

```text
We’re not confident enough to grade this fairly yet.

This will not count against your progress. You can try a fresh question or save
this for review.
```

Do not promise a human response time unless operational support exists.

Session complete:

```text
Session complete

You got useful evidence from this attempt. The next recommendation will update
as you keep working.
```

Do not say the student mastered the skill.

### 6. Home And Progress

Routes:

```text
/home
/progress
```

Home should show:

- incomplete setup or incomplete session if present;
- one recommended next action sourced from `runtime_context` when available;
- reason and time estimate;
- secondary options to choose another action.

Progress should separate:

- activity;
- independent evidence;
- coached work;
- due review;
- uncertain or withheld evidence.

When runtime data is present, use `runtime_context.student_memory` for the
evidence and help summary, and use `runtime_context.session_state` for the
current session framing. If the runtime context is missing, show the local
preview state clearly as a fallback.

Do not show a dominant composite mastery score or AP score prediction.

## Student-Facing Copy Constraints

Do not use these learner-facing terms:

- readiness score;
- mastery;
- diagnostic test;
- position-estimate confidence;
- decay;
- Lock.

Use plain student-facing language:

- where your class probably is;
- change this;
- start with a short useful session;
- choose another unit;
- we’ll adjust as you work.

## Accessibility Requirements

- Complete keyboard operation.
- Visible focus states.
- No color-only state.
- Course-position picker is real radio/selectable controls.
- If a modal is used, trap focus and restore focus on close.
- Time choices are real buttons/radios, not static cards.
- Mobile width around 390px has no horizontal overflow.
- Text does not overlap or truncate inside controls.
- Form controls have accessible names and selected states.

## Acceptance Criteria

- No `/prototype` routes exist.
- No reviewer-only prototype switcher exists.
- New learner can start a recommended first session from one setup surface.
- Course-position assumption is visible and adjustable.
- Time is adjustable with 15 minutes defaulted.
- Registration status is not asked in onboarding.
- Calibration/direct-start fork is gone.
- Topic/check-work/bring-question remain available as secondary routes.
- Setup can be paused and resumed with choices preserved.
- First practice item is framed as practice, not a diagnostic.
- One answer is never represented as mastery, readiness, or an AP score.
- Mobile and keyboard accessibility pass a basic manual QA walk.

## Do Not Do

- Do not use `/prototype` route prefixes.
- Do not add a prototype route switcher.
- Do not ask registration status during onboarding.
- Do not make calibration mandatory.
- Do not create a five-step setup sequence.
- Do not ask the learner to enter an official exam date.
- Do not expose internal labels such as readiness, mastery freshness,
  position-estimate confidence, decay, or Lock.
- Do not create production database schema unless an existing backend contract
  already requires it.
