# Lovable Build Brief - Cramapple UX-001 Student Experience

## How To Use This File

Give this entire file to Lovable as the build prompt.

This is a frontend-only review prototype. Do not connect Supabase, deploy to
production, add authentication, or invent backend behavior. Use local mock
state so the founding team can click through and review the proposed
experience.

The canonical Cramapple source material for this draft is:

- `docs/product/STUDENT_PORTAL_INTERACTION_DESIGN.md`
- `docs/tasks/UX-001-INITIAL-PRODUCT-UX-DECISIONS.md`
- `prototypes/ux-001/index.html`

If any instruction below conflicts with an assumption Lovable would normally
make, follow this file.

---

## Goal

Build a polished, responsive, clickable draft of the Cramapple student
experience beginning immediately after account creation.

Cramapple is an AP score-optimization product. The initial product focuses on
AP Biology and helps students use limited study time to earn more exam points
through guided topic selection, efficient instruction, targeted practice, and
criterion-level feedback.

The prototype should let reviewers experience:

1. Post-account setup.
2. A transparent first-session plan.
3. Optional calibration or direct entry.
4. A multiple-choice attempt and feedback.
5. A free-response attempt, criterion feedback, repair, and retry.
6. Uncertainty and recheck states.
7. Session completion.
8. Returning Home and Progress.

This is a review artifact, not a production application.

## Product Posture

- Optimize for points gained per hour of remaining study time.
- Reach useful work quickly.
- Guide the learner while preserving choice.
- Explain recommendations instead of silently redirecting.
- Keep the learning loop predictable rather than chatty.
- Separate effort from demonstrated learning.
- Represent grading and content uncertainty honestly.
- Never imply one response determines an AP score.
- Never describe one repaired response as mastery.

## Routes

Create these frontend routes:

```text
/prototype/account-created
/prototype/setup/exam
/prototype/setup/goal
/prototype/setup/time
/prototype/setup/start
/prototype/first-plan
/prototype/topic
/prototype/check-work
/prototype/bring-question
/prototype/session/mcq
/prototype/session/frq
/prototype/session/uncertain
/prototype/session/complete
/prototype/home
/prototype/progress
```

The app should open at:

```text
/prototype/account-created
```

Add a small prototype-state switcher available to reviewers. On desktop it may
be a narrow left rail. On mobile it should become a horizontally scrollable
review menu. Label it clearly:

```text
UX-001 PROTOTYPE
Student portal states
```

This review switcher is not part of the proposed production student UI.

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
- Corners: rounded but not playful or childish.
- Typography: modern sans serif with strong editorial hierarchy.
- The interface should feel calm, credible, direct, and student-centered.
- Avoid a generic AI-chat appearance.
- Avoid childish school graphics, mascots, confetti, streaks, and excessive
  gamification.
- Avoid glossy marketing-page treatment inside the learning workflow.

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

- A compact top bar with the Cramapple wordmark.
- Context text on the right, such as `New account setup | Step 2 of 5`.
- A centered content column with a comfortable maximum width.
- One clear primary action per state.
- Secondary and tertiary actions that remain easy to find but do not compete.
- Responsive behavior for phone, tablet, and desktop.

For setup pages, show a five-segment progress indicator.

For learning-session pages, show:

1. Session context and progress.
2. Mode-appropriate orientation.
3. Question and attempt area.
4. Feedback, repair, retry, or completion state.

Do not show every state simultaneously.

## Implementation Shape

Use Lovable's standard React and TypeScript frontend stack. Tailwind and the
existing Lovable component system are acceptable.

Create reusable components rather than one oversized page. Suggested
components:

```text
PrototypeShell
PrototypeStateSwitcher
TopContextBar
SetupProgress
SelectableCard
PrimaryActionRow
SupportingNote
FirstSessionPlan
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

Use client-side routing for the prototype routes. Keep copy and mock scenario
data in small typed configuration objects where practical.

## Mock State

Use frontend-only local state.

Store:

```ts
type SetupState = {
  exam: "AP Biology";
  registrationStatus:
    | "registered"
    | "not_registered"
    | "unsure"
    | null;
  startingPoint:
    | "unsure"
    | "major_gaps"
    | "mixed"
    | "strong";
  intent:
    | "recommend"
    | "topic"
    | "check_work"
    | "bring_question";
  sessionMode: "Quick" | "Focused" | "Buckle Down";
  minutes: 15 | 30 | 60;
  startingMethod: "calibration" | "direct";
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

This is the dated prototype scenario already referenced by Cramapple's
canonical teaching design. Production work must resolve the current official
date from the active versioned exam specification rather than retaining this
mock fixture.

Persist state in `localStorage` only for prototype recovery.

Add a prototype-only `Reset demo` action.

Do not create database tables or Supabase calls.

## Page Behavior

### 1. Account Created

Route:

```text
/prototype/account-created
```

Header context:

```text
New account setup | Step 1 of 5
```

Copy:

```text
ACCOUNT CREATED

Now let’s make your first session useful.

Cramapple will use your exam timing, your goal today, and the time you have
right now to build a starting plan.
```

Show a confirmation card:

```text
Your Cramapple account is ready.

Setup takes about a minute. A full diagnostic is optional.
```

Primary action:

```text
Set up my first session
```

Secondary action:

```text
What happens next?
```

The secondary action opens a compact explanation:

```text
You will try a question, see where points were earned or missed, and practice
the smallest useful change.
```

### 2. Exam Context

Route:

```text
/prototype/setup/exam
```

Header context:

```text
New account setup | Step 2 of 5
```

Copy:

```text
YOUR EXAM

Are you registered for the AP Biology exam?

The official exam date comes from Cramapple's active AP Biology exam pack.
Confirm your registration so reminders and exam-day planning fit your
situation.
```

Show AP Biology as the selected exam pack and display:

```text
Official exam date
{{officialExamDate}}
```

`officialExamDate` is authoritative exam-pack data, not learner-entered state.
If the date is not present in the mock fixture, show `Official date not loaded`
and a prototype-data warning. Do not invent a date or ask the learner for it.

Inputs:

- Registration status as a required single-select control:
  - Yes, I’m registered.
  - Not yet.
  - I’m not sure.
- Starting-point select:
  - I’m not sure yet.
  - I have some major gaps.
  - I know some topics, not others.
  - I’m aiming to turn a good score into a great one.

Rules:

- Require an explicit registration-status selection.
- Do not block setup when the learner selects `Not yet` or `I’m not sure`.
- For those two selections, explain that AP exam registration happens through
  the learner's school or AP coordinator and that Cramapple does not register
  students for the exam.
- The self-described starting point is orientation only. Do not display it as
  measured readiness.

Supporting copy:

```text
You can change this later. We will not make a score prediction from setup
answers.
```

### 3. Immediate Goal

Route:

```text
/prototype/setup/goal
```

Header context:

```text
New account setup | Step 3 of 5
```

Copy:

```text
YOUR GOAL TODAY

What would feel most useful right now?

This sets the starting direction, not a permanent track. You stay free to
choose another topic or activity.
```

Show four selectable cards:

```text
Tell me what to work on
Start with the highest-value evidence Cramapple can gather.

Practice a topic
Choose a unit or skill you already have in mind.

Check my work
Start from an answer you have already attempted.

Bring a question
Type or paste something from class or practice.
```

Default selection:

```text
Tell me what to work on
```

Use `aria-pressed` or equivalent accessible selected-state semantics.

### 4. Time Available

Route:

```text
/prototype/setup/time
```

Header context:

```text
New account setup | Step 4 of 5
```

Copy:

```text
TIME AVAILABLE

How much time do you have?

Pick a starting point. You can stop cleanly or keep going if your time changes.
```

Show three selectable cards:

```text
Quick
Get one useful win.
About 15 min

Focused
Practice and repair a priority skill.
About 30 min

Buckle Down
Mix practice, repair, and due review.
About 60 min
```

Default:

```text
Focused
```

The primary button should update with the selected time:

```text
Continue with 15 minutes
Continue with 30 minutes
Continue with 60 minutes
```

### 5. Starting Method

Route:

```text
/prototype/setup/start
```

Header context:

```text
New account setup | Step 5 of 5
```

Copy:

```text
CHOOSE HOW TO BEGIN

Want a quick starting read?

Three short questions can help Cramapple avoid sending you to a topic just
because it is first in the curriculum.
```

Show two selectable cards:

```text
Start with a quick calibration
Three varied questions, then a recommendation you can accept or change.
Recommended · about 6 min

Skip calibration
Go straight to your chosen topic or activity.
You can calibrate later
```

Default:

```text
Start with a quick calibration
```

Supporting copy:

```text
This is not a full diagnostic. It is a small sample used to improve the first
recommendation.
```

Calibration must remain visibly optional.

### 6. First-Session Plan

Route:

```text
/prototype/first-plan
```

Header context:

```text
First-session plan | Ready to begin
```

Copy:

```text
YOUR FIRST SESSION

Here’s the plan. You can change it.
```

Build the plan dynamically from the mock setup state.

#### Intent copy

For `recommend`:

```text
Title: Find the best place to start
Practice step: Practice the best next opportunity
Detail: See why it was chosen, then accept it or choose something else.
Why: You asked Cramapple to recommend what to work on.
```

For `topic`:

```text
Title: Start with the topic you choose
Practice step: Practice your selected topic
Detail: Cramapple may suggest a short prerequisite check before you begin.
Why: You chose to begin with a topic already on your mind.
```

For `check_work`:

```text
Title: Use your own work as the starting point
Practice step: Check the answer you bring
Detail: Get criterion-level feedback, then practice the most useful missing
step.
Why: You chose to start from work you have already attempted.
```

For `bring_question`:

```text
Title: Start with the question you bring
Practice step: Classify and work through your question
Detail: Cramapple will ask for missing context rather than inventing it.
Why: You chose to begin with a question from class or practice.
```

#### Plan with calibration

Show:

```text
1. Quick calibration
Three cold questions across different skills.
~6 min

2. [Dynamic practice step]
~remaining practice time

3. Lock in the useful part
Finish with a fresh attempt and a clear next action.
~8 min
```

Add:

```text
[Dynamic why statement] A small sample gives the first plan some evidence
without forcing a long diagnostic.
```

#### Plan without calibration

Hide the calibration step and renumber the remaining steps:

```text
1. [Dynamic practice step]
2. Lock in the useful part
```

Add:

```text
[Dynamic why statement] You skipped calibration, so the first recommendation
will rely on your choice until Cramapple observes more evidence.
```

Actions:

```text
Start first session
Change plan
Finish later
```

`Finish later` saves mock state and displays:

```text
Your setup answers are saved. You can leave and resume from this plan.
```

### 7. Direct Topic Entry

Route:

```text
/prototype/topic
```

Use when the learner chose `Practice a topic` and skipped calibration.

Copy:

```text
CHOOSE A TOPIC

Where do you want to begin?

Pick the topic on your mind. Cramapple will preserve your choice while checking
whether a short prerequisite would save time.
```

Use a mock topic select with:

- Unit 3 · Cellular Energetics
- Unit 4 · Cell Communication and Cell Cycle
- Unit 6 · Gene Expression and Regulation
- Unit 7 · Natural Selection
- Browse all AP Biology topics

Supporting copy:

```text
Cramapple may suggest a brief prerequisite check, but it will explain why and
let you continue with your topic.
```

### 8. Check-My-Work Entry

Route:

```text
/prototype/check-work
```

Use when the learner chose `Check my work` and skipped calibration.

Copy:

```text
CHECK MY WORK

Bring the answer you already tried.

Include the full prompt when you can. Feedback is more reliable when the
question, response, and relevant visual are all present.
```

Required fields:

- Question or prompt.
- Your answer.

Show validation if either is empty:

```text
Add both the question and your answer before continuing.
```

After valid mock input, route to the FRQ draft.

### 9. Bring-A-Question Entry

Route:

```text
/prototype/bring-question
```

Use when the learner chose `Bring a question` and skipped calibration.

Copy:

```text
BRING A QUESTION

What are you working on?

Add the complete question and choose how much help you want.
```

Required field:

- Your question.

Mode select:

- Teach me the underlying concept.
- Give me a hint.
- Check my work.
- Walk me through a solution.

Supporting copy:

```text
If context is missing, Cramapple will ask for it rather than inventing details.
```

### 10. Returning Home

Route:

```text
/prototype/home
```

Show:

```text
WELCOME BACK, MAYA

Make your next 12 minutes useful.
```

Recommendation card:

```text
RECOMMENDED NEXT

Interpreting experimental controls

This has cost you points in more than one unit, and a short review is due.
About 12 minutes.
```

Actions:

```text
Start
Why this?
Choose something else
```

Supporting panel:

```text
1 review due
Cell communication

30 minutes available
Change session length

Bring a question
```

### 11. Multiple-Choice Attempt

Route:

```text
/prototype/session/mcq
```

This may represent a calibration item or ordinary practice.

Show:

```text
Cold attempt. Choose the best answer before seeing an explanation.
```

Use original placeholder content:

```text
Identify the experimental control

A researcher grows identical seedlings under three colors of light. All groups
receive the same soil, water, temperature, and light intensity. Which
comparison best isolates the effect of light color on growth?
```

Choices:

```text
Compare seedlings receiving different amounts of water.
Compare growth among the three light-color groups.
Compare seedlings grown in different soil types.
Compare plants measured on different days.
```

Actions:

```text
Submit answer
I need help
Move on and return later
```

Do not expose the correct answer before submit.

After submitting the correct answer, show:

```text
1 of 1 point

You isolated the variable being tested.

The groups differ by light color while soil, water, temperature, and intensity
stay constant.
```

### 12. Free-Response Attempt

Route:

```text
/prototype/session/frq
```

Copy:

```text
Cold attempt. Explain the biological mechanism in one or two sentences.

Explain a mechanism

A protein loses function after prolonged exposure to unusually high
temperature. Explain how the temperature change can alter the protein’s
function.
```

Prefill the prototype response:

```text
High heat causes the protein to lose its shape, so it can no longer do its job.
```

After submit, show:

```text
Estimated: 1 of 2 points

You named the shape change. Add the molecular mechanism.

Earned:
You connected protein shape to function.

Missing:
Explain how heat disrupts the interactions that maintain the protein’s
structure.
```

Actions:

```text
Get this point
Try a different approach
Request a recheck
```

### 13. Repair

`Get this point` opens a repair state on the FRQ route.

Copy:

```text
FIX THE MISSING STEP

What belongs in the gap?

High temperature [...] changes the protein’s three-dimensional shape, so its
function is reduced.

Name what happens to the interactions that stabilize the protein’s structure.
```

Input:

```text
Add the mechanism
```

Actions:

```text
Check this step
Choose another approach
Move on and return later
```

Submitting non-empty text leads to Session Complete.

### 14. Criterion Recheck

Use an accessible modal.

Copy:

```text
CRITERION RECHECK

What do you think the feedback missed?

Point to the criterion and explain what evidence in your response should count.
This prototype does not promise a human response time.
```

Required behavior:

- Focus moves into the modal.
- Escape closes it.
- Keyboard focus stays inside while open.
- Focus returns to `Request a recheck`.

### 15. Uncertainty

Route:

```text
/prototype/session/uncertain
```

Copy:

```text
SAFE FAILURE STATE

Useful feedback without false certainty.

I cannot present this score as reliable.

Something in the question, diagram, or scoring information may be incomplete
or inconsistent. This attempt will not count against your progress.
```

Actions:

```text
Add missing context
Try another question
Flag for review
```

Do not promise human review or a response time.

### 16. Session Complete

Route:

```text
/prototype/session/complete
```

Copy:

```text
SESSION COMPLETE

That point held up on a new question.

You completed an independent retry. We will bring this skill back before the
exam to see whether it sticks.
```

Actions:

```text
See progress
Return home
```

Do not say `mastered`.

### 17. Progress

Route:

```text
/prototype/progress
```

Copy:

```text
YOUR AP BIOLOGY WORK

Progress you can inspect.

Activity, supported performance, and independent evidence stay separate.
```

Show:

```text
Recommended next
Return to experimental controls
One delayed check is due tomorrow. About 8 minutes.

This week
3 independent points earned
Across fresh questions without help

2 supported repairs
Waiting for independent confirmation

Evidence by skill
Experimental design · Improving
Data analysis · Mixed
Mechanism explanations · Priority

Activity
64 minutes practiced
Across three sessions

11 questions attempted
Activity is not presented as mastery
```

Avoid percent mastery, dominant streaks, and score prediction.

## States

Handle these states in the frontend prototype:

- Default.
- Selected and unselected cards.
- Required-field validation.
- Registered, not registered yet, and unsure status.
- Missing official-date fixture warning.
- Interrupted setup recovery from local state.
- Calibration selected.
- Calibration skipped.
- Dynamic plan generation.
- Cold attempt.
- Submitted answer.
- Feedback.
- Repair.
- Recheck modal.
- Content or grading uncertainty.
- Finish later.
- Session complete.
- Responsive mobile navigation.

## Accessibility

Meet these expectations in the prototype:

- Complete keyboard operation.
- Visible focus.
- Semantic headings and landmarks.
- Real labels for every control.
- `aria-pressed`, radio, or equivalent semantics for selectable cards.
- No color-only distinction for selected, earned, or missed states.
- Live-region announcements for validation and saved-state messages.
- Modal focus entry, containment, Escape close, and focus return.
- Reduced-motion behavior.
- Touch targets at least 44 CSS pixels high where practical.
- No horizontal page overflow at 390 CSS pixels.
- Zoom and reflow without losing question, response, or feedback context.
- No drag-only interactions.

## Backend Calls

None.

This is a frontend-only review prototype.

Use mock local state and local placeholder content.

## Forbidden Behavior

Do not:

- Connect Supabase or another database.
- Add production authentication.
- Add service keys or environment secrets.
- Deploy to production.
- Write learner records.
- Calculate authoritative grades, mastery, readiness, or recommendations in
  the browser.
- Claim a human will review a disputed grade.
- Ask for a target AP score.
- Ask the learner to enter the official AP exam date.
- Claim that Cramapple registers learners for an AP exam.
- Turn self-reported confidence or starting point into proficiency.
- Make calibration mandatory.
- Reveal hidden criteria or answer-bearing concepts before a cold attempt.
- Use official College Board question text or protected assets.
- Use unapproved Cramapple candidate questions.
- Add a parent portal.
- Add payments, pricing, streaks, badges, leaderboards, or social sharing.
- Add a general-purpose chatbot.
- Rename internal teaching states into learner-facing labels such as `stuck`.
- Invent product policy when this brief is silent.

## QA Expectations

Before reporting the draft complete:

1. Test the complete recommended path:
   account created → exam → recommend → Focused → calibration → plan → MCQ.
2. Test direct topic entry:
   topic → Quick → skip calibration → plan → topic select → practice.
3. Test check-my-work validation:
   check work → skip calibration → plan → require prompt and answer.
4. Test bring-a-question validation and mode selection.
5. Test missing registration-status validation and all three registration
   paths. Confirm that `not registered yet` and `unsure` can continue.
6. Test that plan copy, duration, steps, numbering, and rationale change from
   the selected setup state.
7. Test recheck modal keyboard behavior.
8. Test uncertainty and finish-later messages.
9. Test at desktop and 390 by 844 mobile dimensions.
10. Confirm no horizontal overflow.
11. Confirm no network calls, Supabase setup, or secrets.
12. Confirm all question content is original placeholder content.

## Completion Output

When finished, report:

- Routes created.
- Components created.
- Mock state behavior.
- Branches tested.
- Accessibility checks performed.
- Any deviations from this brief.
- A link to the Lovable preview.

Keep the preview labeled as a proposed UX-001 draft for co-founder feedback.
