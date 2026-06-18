# Lovable Build Brief - UX-006 Student Practice and Grading

Build a polished, responsive, frontend-only Cramapple student-practice and
grading experience. Cover MCQ, FRQ, quantitative work, criterion feedback,
uncertainty, disputes, and regrading.

Do not connect a database, authentication, production grader, model provider,
uploads, or human-review service. Use original placeholder AP Biology content
and simulated state.

## Product Boundary

- UX-001 supplies the overall student portal and learning-loop frame.
- UX-006 supplies detailed practice and grading interactions.
- Scores are Cramapple practice results, not official College Board scores.
- A low-confidence result must not look like an authoritative grade.
- Human review may be named only in fixtures explicitly labeled as an active
  simulated service.

## Visual Direction

- Calm, focused study workspace.
- Warm neutral canvas, deep green navigation, white question and feedback cards.
- Feedback should feel precise and humane, not celebratory or punitive.
- Use restrained status colors with text and icons.
- No confetti, streaks, ranking, countdown pressure, or fake mastery meters.

## Suggested Routes

```text
/prototype/practice/mcq/:attemptId
/prototype/practice/frq/:attemptId
/prototype/practice/quantitative/:attemptId
/prototype/attempts/:attemptId/result
/prototype/attempts/:attemptId/dispute
/prototype/attempts/:attemptId/regrade
```

## Stable Frame

Keep four recognizable regions:

1. Session context.
2. Orientation.
3. Attempt.
4. Response state.

Show save state, assistance condition, time guidance, progress through the
current activity, accessibility controls, Move on, and Exit.

Attempt conditions:

- Independent
- Coached
- Exam practice

Provide an explainer for the evidence consequence of each condition.

## MCQ Scenario

Build one cold MCQ with:

- stem and stimulus;
- four radio-button answers;
- optional confidence;
- optional `Why?` field;
- I need help;
- Move on;
- Submit answer.

Before submission, hide concept labels, answer rationales, misconception labels,
and predicted impact.

Create both result variants:

- correct independent result;
- incorrect result with selected answer preserved, decisive evidence,
  distractor explanation, and one recommended repair.

Do not state that one result proves mastery.

## FRQ Composer

Build:

- multi-part prompt rail;
- persistent stimulus;
- separate response field per part;
- optional calculation workspace;
- save and resume;
- final submission review.

The cold view does not expose hidden rubric criteria or samples.

## Criterion Feedback

Create criterion cards with:

- Earned
- Not yet earned
- Unable to determine
- Not applicable

Each card includes:

- criterion in learner-readable language;
- exact response evidence;
- why the evidence did or did not satisfy it;
- contradiction or ambiguity;
- minimum fix.

Progressively disclose details. Lead with the highest-value missed criterion and
one primary repair action.

## Quantitative Scenario

Create a response with:

- numeric final answer;
- unit;
- equation or setup;
- intermediate work;
- interpretation.

Show separate checks for arithmetic, unit, sign, rounding, setup, and
interpretation. Demonstrate a wrong final number with a correct setup and a
correct number with contradictory work.

## Grading States

Provide scenario controls for:

- Grading
- High-confidence result
- Qualified result
- Low-confidence result
- Content uncertain
- Human review pending
- Regrade pending
- Corrected regrade
- Technical failure

### Low Confidence

Use:

> I can give useful feedback on parts of this response, but I am not confident
> enough to present the score as reliable.

Show supported observations and unresolved criteria. Do not show a precise
total.

### Content Uncertain

Explain that the question, stimulus, answer key, or rubric may be incomplete or
inconsistent. The attempt does not count against progress.

Actions:

- Try another question
- Add missing context
- Flag for review
- Continue later

### Technical Failure

Use:

> Your answer is saved, but feedback is taking longer than expected.

Actions:

- Try again
- Continue later
- Leave session

Explain that retry will not create a duplicate submission.

## Repair and Retry

Show the immutable original response beside or above a clearly labeled repair
draft.

Recommended actions:

- Fix the missing step
- See how this works
- Try a different angle
- Break it into parts
- Review a prerequisite
- Move on and return later

Once substantive help appears, label the work coached. After repair, route to a
fresh aligned question for independent evidence.

## Dispute

`Request a recheck` opens a criterion-specific form:

- choose criterion or answer-key concern;
- show current decision and cited evidence;
- allow the learner to highlight overlooked response text;
- ask for a short explanation;
- explain the simulated review path;
- preserve the original result while pending.

Status timeline:

```text
Submitted
Queued
Under review
Corrected or upheld
Closed
```

Do not promise a review time.

## Regrade Comparison

Show prior and corrected criterion decisions side by side, including:

- changed criterion;
- prior and current total when reliable;
- reason for change;
- rubric, grader, policy, or human-review source;
- whether progress evidence was rebuilt;
- concise correction notice.

History remains visible. Do not overwrite the original grade.

## Required Scenarios

- MCQ correct and incorrect.
- Short FRQ criterion feedback.
- Long FRQ multi-part save and submit.
- Quantitative component checks.
- High-confidence and qualified results.
- Low-confidence result with no total.
- Content uncertainty excluded from progress.
- Saved technical failure and idempotent retry.
- Criterion-specific dispute.
- Pending review.
- Corrected regrade.
- Coached repair followed by fresh independent retry.

## Accessibility and Safety

- Full keyboard operation and visible focus.
- Semantic radio groups, parts, criteria, status, and errors.
- Accessible equations, data tables, and charts.
- No color-only correctness, uncertainty, or grade change.
- Announce save, submit, grading, failure, and regrade states.
- Reflow at 390 CSS pixels without losing stimulus or response context.
- Respect reduced motion.
- No official questions, real learner data, real review promises, production
  scores, or provider claims.

