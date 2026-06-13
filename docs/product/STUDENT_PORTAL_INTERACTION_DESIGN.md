# Student Portal Interaction Design

**Status:** Proposed for Product Owner, Learning, Marketing, and accessibility
review
**Related Task:** `UX-001`
**Owner:** Product Owner with Learning and Marketing owners
**Last Updated:** 2026-06-13

## 1. Purpose

This document translates Cramapple's approved vision and proposed learning
behavior into a testable student-portal interaction model.

It defines interaction structure, state transitions, proposed copy, and
prototype requirements. It does not approve production implementation, final
visual design, grading behavior, recommendation logic, or legal policy.

## 2. Experience Principles

1. **Reach useful work quickly.** A student should not complete a long profile
   before beginning.
2. **Show one clear primary action.** Secondary choices remain available
   without competing with the recommended next step.
3. **Explain recommendations.** The portal states why an action is suggested
   and lets the learner override it.
4. **Keep the loop recognizable.** Orientation, attempt, feedback, repair, and
   retry use stable screen regions across question types.
5. **Do not expose internal labels.** The learner does not see system terms
   such as `stuck`, `Sideways`, `Apart`, `Down`, or `content_uncertain`.
6. **Protect cold evidence.** Before a cold attempt, the interface does not
   reveal answer-bearing concepts, hidden criteria, formulas, or trends.
7. **Separate effort from learning evidence.** Activity can be celebrated
   without being presented as mastery.
8. **Represent uncertainty honestly.** A plausible model response is not
   presented as an authoritative grade when confidence is insufficient.
9. **Preserve agency without abandoning guidance.** Move On, choose another
   approach, and choose another topic remain available.
10. **Design accessibility as task equivalence.** Access must preserve the
    operation being assessed rather than silently replacing it with an easier
    task.

## 3. Proposed Information Architecture

### Primary Student Areas

| Area | Purpose | Primary action |
| --- | --- | --- |
| Home | Resume, start, or accept the next recommendation | Continue |
| Session setup | Set available time and learning intent | Start session |
| Learning session | Attempt, receive feedback, repair, and retry | Contextual |
| Review queue | Complete due Lock retrieval | Start review |
| Progress | Inspect effort, evidence, gaps, and next action | Practice next |
| Bring a question | Enter an outside question and choose a mode | Continue |
| Account | Exam registration, accessibility, privacy, and account controls | Save |

The MVP navigation should remain small. Home, Review, Progress, and Account are
the proposed persistent destinations. "Bring a question" may be a prominent
Home action rather than a permanent navigation destination.

## 4. Entry Flows

### 4.1 First Session

```text
Account created
  -> Confirm account readiness and explain the one-minute setup
  -> Show the official AP Biology exam date, confirm registration, and ask broad starting point
  -> Ask the learner's immediate goal
  -> Ask available time
  -> Offer optional three-question calibration or direct start
  -> Show the proposed first-session plan and why it was selected
  -> Start the first cold attempt or requested activity
```

#### Proposed onboarding explanation

> Cramapple helps you use the time you have to earn more AP Biology points.
> You will try a question, see exactly where points were earned or missed, and
> practice the smallest change most likely to help.

The explanation should appear once in a compact format, with an optional
"How it works" expansion. It should not lead with methodology names or a long
tour.

#### Post-account setup sequence

The setup uses five short screens. Each screen asks for one category of
information and explains why it matters.

1. **Account ready.** Confirm that setup takes about one minute and that a full
   diagnostic is optional.
2. **Exam context.** Confirm AP Biology, display the official exam date from
   the active exam specification, ask whether the learner is registered, and
   ask for a broad self-described starting point. The starting point is
   orientation, not proficiency evidence.
3. **Immediate goal.** Let the learner choose recommendation, topic practice,
   check-my-work, or bring-a-question entry.
4. **Available time.** Present Quick, Focused, and Buckle Down as adjustable
   time commitments rather than fixed curricula.
5. **Starting method.** Offer a recommended three-question calibration or
   direct entry into the requested activity.

The final setup screen shows the proposed plan before beginning. It states:

- session duration;
- whether calibration is included;
- the requested or recommended activity;
- how the session is expected to close; and
- why those elements were selected.

The learner may change the plan, finish setup later, or proceed.

#### Required first-session inputs

- AP exam and registration status. The official exam date comes from the
  active versioned exam specification and is not learner-entered data.
- Time available now.
- Immediate intent:
  - Tell me what to work on.
  - Practice a topic.
  - Check my work.
  - Bring a question.
- Optional confidence or uncertainty.

A full diagnostic is optional. The student may skip calibration and begin.

#### Setup rules

- Do not ask for a target AP score until the product decision on target-score
  use is resolved.
- Do not convert self-reported starting point into mastery or readiness.
- Do not require a full profile before the first useful attempt.
- Save completed setup steps so an interrupted learner resumes at the next
  incomplete step.
- Explain why each question affects the first plan.
- Keep calibration optional and distinguish it from a full diagnostic.
- Never ask the learner to enter an official exam date already defined by the
  active exam specification.
- Require an explicit `registered`, `not registered yet`, or `unsure`
  confirmation. A learner who is not registered or is unsure may continue
  learning; Cramapple should explain that registration happens through the
  learner's school or AP coordinator.
- If the official date is unavailable from the active exam specification,
  show a system-data warning and avoid inventing or asking the learner to
  supply the date.
- When calibration is selected, begin with a cold calibration item before the
  requested activity.
- When calibration is skipped, route directly to topic selection,
  question-and-answer intake, or user-question intake as appropriate.
- Final consent, age-gating, and required notices remain governed by their
  separate legal and product decisions.

### 4.2 Returning Session

```text
Open Home
  -> Show incomplete work and due review
  -> Show one recommended next action with reason and time estimate
  -> Continue, choose another action, or change available time
```

Proposed recommendation card:

> **Recommended: interpreting experimental controls**
>
> This has cost you points in more than one unit, and a short review is due.
> About 12 minutes.

Primary action: `Start`

Secondary actions: `Why this?`, `Choose something else`

The portal must recover interrupted onboarding and incomplete sessions.

## 5. Session Mode Presentation

The initial prototype should test two presentations.

### Variant A - Named Cards

| Mode | Student-facing promise | Time |
| --- | --- | ---: |
| Quick | Get one useful win | About 15 min |
| Focused | Practice and repair a priority skill | About 30 min |
| Buckle Down | Mix practice, repair, and due review | About 60 min |

### Variant B - Time First

Ask "How much time do you have?" with 15, 30, and 60 minute choices. Show the
mode name only after selection.

### Test Questions

- Do students understand the difference without reading explanatory copy?
- Does "Buckle Down" feel motivating or burdensome?
- Do named modes improve commitment compared with a time-only choice?
- Can a learner change the duration without losing the recommendation?
- Does the mode overpromise a fixed amount of work when item duration varies?

The modes are planning hypotheses. The session may end early or offer a clean
continuation when evidence collection, grading latency, or learner choice
changes the plan.

## 6. Stable Learning-Session Frame

Every question screen uses four stable regions:

1. **Session context:** progress through the current session, time guidance,
   exit, and accessibility controls.
2. **Orientation:** only the information permitted by cold, coached, or exam
   mode.
3. **Attempt:** question stimulus and response controls.
4. **Response state:** feedback, repair, retry, or completion.

Only the active response state should dominate the screen. The interface should
not present the full feedback package, intervention menu, and next question at
the same time.

### 6.1 Cold Attempt

Show:

- Question and approved stimulus.
- Visible command language.
- Response controls.
- Optional confidence prompt when its value exceeds the interruption cost.
- `Submit answer`.
- `I need help` and `Move on` as secondary actions.

Do not show:

- Hidden rubric criteria.
- Tested concept labels when identifying the concept is part of the task.
- Correct formulas, trends, mechanisms, or distractor explanations.
- Predicted score impact.

### 6.2 Feedback

After submission, replace the submit action with a Score panel.

Recommended disclosure order:

1. Points or criteria earned, with confidence qualification where required.
2. What the learner did that earned credit.
3. The highest-value missed criterion.
4. Evidence from the learner's response.
5. The smallest useful next change.
6. A single recommended repair action.

The complete nine-element FRQ feedback remains available, but progressive
disclosure should prevent the initial panel from becoming a wall of text.

Primary action: `Get this point`

Secondary actions: `Try a different approach`, `Move on`, `Request a recheck`
when that capability is available.

### 6.3 Repair and Retry

Student-visible repair choices use plain outcomes rather than internal route
names:

| Internal behavior | Proposed student label |
| --- | --- |
| Tighten | Fix the missing step |
| Show | See how this works |
| Sideways | Try a different angle |
| Apart | Break it into parts |
| Down | Review a prerequisite |
| Move On | Move on and return later |
| Park | Leave this for a better time |

The system recommends one route and briefly explains why. The learner may
choose another available route. An override is not negative evidence.

Every repair ends with a fresh independent attempt before the interaction can
be presented as a provisional success.

### 6.4 Completion and Lock

After the retry:

- Distinguish supported success from independent transfer.
- Avoid saying "mastered" after one repaired response.
- State whether and approximately when the skill will return.
- Offer the next session action.

Proposed language:

> You earned this point on a new question without help. We will bring this skill
> back before the exam to see whether it sticks.

For supported success:

> This worked with support. We will try it again on a fresh question so it can
> count as independent evidence.

## 7. Feedback Treatment Experiment

### Variant A - Bracket Marker Only

Show the learner's sentence with a marker at the precise missing step:

> Higher temperature [...] changes the protein's function.

Then ask one focused question about the missing mechanism.

### Variant B - Bracket Marker Plus Criterion Highlighting

Use the same bracket marker, with restrained sentence-level treatment showing
which text supported credit and where evidence was missing.

### Evaluation Criteria

- Time to identify the missing step.
- Correctness of the learner's revision.
- Ability to explain why the revision earns the point.
- Visual comprehension and cognitive load.
- Screen-reader clarity.
- Whether color or decoration creates answer leakage.

The bracket marker is the baseline pattern. Broader highlighting must show
measurable benefit without turning feedback into visual noise.

## 8. Coaching Copy

Behavioral signals may prompt coaching but do not prove cheating, authorship,
effort, or ability.

### Proposed paste-event prompt

> This answer appeared all at once. You can still get feedback, but it may not
> tell us what you can do on exam day.

Actions:

- `Use it and do not count it toward my progress`
- `Rewrite it in my own words`
- `Cancel`

### Copy Rules

- Do not accuse the learner of cheating or using AI.
- Do not block feedback solely because of a behavioral signal.
- Explain the learning consequence, not a moral judgment.
- Let the learner correct the situation.
- Do not expose behavioral details to a parent or other user without a
  separately approved policy.

Marketing review is required before this becomes final student-facing copy.

## 9. Uncertainty, Escalation, and Disagreement

### 9.1 Grading Uncertainty

> I can give you useful feedback on this response, but I am not confident enough
> to present the score as reliable.

The screen may show supported observations while withholding an authoritative
total. The attempt must not create negative proficiency evidence solely from
an uncertain grade.

### 9.2 Content or Question Uncertainty

> Something in this question, diagram, or scoring information may be incomplete
> or inconsistent. It will not count against your progress.

Actions may include `Add missing context`, `Try another question`, or `Flag for
review`, depending on implemented capability.

### 9.3 Disputed Grade

> Think the feedback missed something in your answer? Point to the criterion
> you disagree with and tell us why.

The prototype should support criterion-specific disagreement rather than a
generic thumbs-down action. It must not promise a response time or human review
unless that service is operationally available.

### 9.4 Temporary Failure

> Your answer is saved, but feedback is taking longer than expected.

Actions: `Try again`, `Continue later`, and `Leave session`.

Retry must not create a duplicate attempt.

## 10. Progress and Home

Progress should answer four questions:

1. What work have I completed?
2. What evidence shows improvement?
3. What still needs attention?
4. What should I do next?

Proposed sections:

- Recommended next action.
- Due review.
- Recent independent evidence.
- Criteria or skills improving.
- Recurring gaps.
- Activity summary.

Avoid:

- Streaks as the dominant success measure.
- Unsupported percent mastery.
- Converting one answer into an AP score.
- Combining coached and independent performance without disclosure.
- Causal claims about why the learner struggles.

## 11. Accessibility Requirements

The prototype must support:

- Complete keyboard operation with visible focus.
- Logical heading and landmark order.
- Screen-reader names, states, errors, and status announcements.
- No color-only distinction for earned and missed criteria.
- Zoom and reflow without loss of question, response, or feedback context.
- Reduced-motion behavior for sliding or animated panels.
- Sufficient target size and spacing for touch.
- Accessible validation and error recovery.
- Time guidance that does not force completion before a timer expires.
- Equivalent access to tables, charts, and diagrams under `TASK-0006`.
- A non-drag alternative for every required interaction.

Accessibility review is a release gate for the UX decision, not a final polish
step.

## 12. Prototype Scope

The first low-fidelity clickable prototype should cover:

1. New learner onboarding.
2. Returning Home with one recommendation and a due review.
3. Session-mode selection.
4. One MCQ cold attempt and feedback.
5. One FRQ cold attempt, criterion feedback, bracket-marker repair, and retry.
6. One alternate repair choice.
7. Move On and return-later behavior.
8. Content uncertainty.
9. Disputed-grade entry.
10. Session completion and Progress.

Use original placeholder content that does not reproduce official questions or
unapproved candidate material.

Initial prototype:

- `prototypes/ux-001/index.html`

## 13. Research Plan

Initial moderated tests should ask learners to complete realistic tasks without
being taught the interface.

Measure:

- Time to first useful attempt.
- Session-mode comprehension.
- Recommendation comprehension and trust.
- Ability to distinguish earned credit from the next repair.
- Ability to find override, Move On, and recheck actions.
- Understanding of supported versus independent success.
- Comprehension of uncertainty language.
- Accessibility task completion.
- Qualitative sense of control, pressure, and credibility.

Do not treat preference alone as validation. Where possible, pair stated
preference with task completion, comprehension, and revision quality.

## 14. Decisions Required

The first Product Owner decision packet should address:

1. Named session cards versus time-first selection.
2. The minimum first-session explanation.
3. The four-region learning-session frame.
4. Progressive disclosure order for criterion feedback.
5. Student-facing repair labels and override behavior.
6. Bracket marker alone versus additional sentence-level treatment.
7. Coaching posture and paste-event options.
8. Uncertainty and disputed-grade language.
9. MVP navigation and Progress hierarchy.

Learning Quality review is required for items 2 through 6. Marketing review is
required for naming and student-facing copy. Accessibility review applies to
the complete prototype.
