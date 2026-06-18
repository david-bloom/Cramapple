# Lovable Build Brief - UX-007 Progress, Review Queue, and Recommendations

Build a polished, responsive, frontend-only Cramapple Progress, review-queue,
and recommendation experience.

Do not connect a database, learner model, recommendation algorithm,
notifications, authentication, or production grading. Use simulated evidence
that does not make mastery, readiness, score-prediction, or causal claims.

## Product Boundary

- UX-001 owns the overall student portal.
- UX-006 supplies attempt and grading outcomes.
- UX-007 explains evidence, due review, and recommended next actions.
- Activity is not mastery.
- Coached work is not independent evidence.
- A recommendation is guidance the learner may override.
- Parent access is out of scope.

## Visual Direction

- Calm and credible rather than data-heavy.
- Warm neutral background, deep green navigation, white cards.
- Use simple timelines, evidence chips, and small charts with text summaries.
- Avoid dominant streaks, radial mastery meters, fake precision, or red
  punishment for overdue review.
- Recommendations should be visually primary but not coercive.

## Suggested Routes

```text
/prototype/home
/prototype/review
/prototype/progress
/prototype/progress/skills/:skillId
/prototype/recommendations/:recommendationId
/prototype/recommendations/history
```

## Returning Home

Show:

- one recommended next action;
- why it is recommended;
- estimated time;
- due review count;
- incomplete work;
- adjust-time control;
- Start;
- Why this?;
- Choose something else.

Example:

> Practice interpreting experimental controls
>
> This has cost you points in more than one unit, and an independent review is
> due. About 12 minutes.

Do not promise score gain.

## Progress Overview

Create separate sections for:

- Recent independent evidence
- Work completed with support
- Review due
- Provisional improvement
- Recurring gaps to check
- Deferred work
- Activity summary
- Grades under review

Use evidence states:

- Supported success
- Independent success now
- Review due
- Retained evidence
- Mixed evidence
- Needs attention
- Evidence withheld

Do not use `Mastered`.

## Skill Detail

Show one learner-readable assessable target with:

- why it matters;
- representation and task type;
- attempt timeline;
- item variation and delay;
- independent or coached status;
- criterion result;
- confidence and grading status;
- dispute or correction;
- proposed next check.

Do not show a raw miss counter or the internal word `stuck`.

## Review Queue

Tabs:

- Due now
- Due soon
- Deferred by you
- Waiting for grading
- Optional review

Each card shows:

- target;
- why it is returning;
- evidence state;
- approximate time;
- question form;
- independent-review label;
- due window;
- Start review;
- Why now?;
- Later;
- Choose another review.

Use neutral due language. A late review is not a moral failure.

## Deferred Work

Show when the learner chose Move On, the proposed return time, and available
alternatives.

Actions:

- Review now
- Reschedule
- Keep deferred
- Choose another target

Explain when automatic resurfacing is paused because validated content is
unavailable.

## Recommendation Explanation

Create an inspectable `Why this?` drawer with:

- exam value;
- recent independent evidence;
- due review;
- recurring criterion gap;
- evidence confidence;
- demonstrated improvability;
- time cost;
- learner goal;
- available time;
- content availability;
- uncertainty or missing inputs.

Use sentences, not an opaque weighted score.

Do not include target score as an input.

## Alternatives and Override

Offer:

- Same priority, shorter activity
- Same priority, longer activity
- Another due review
- Choose a topic
- Continue incomplete work
- Bring a question
- Move on from this target
- End session

Do not require an override reason. Offer optional choices such as `Not now`,
`Too long`, or `I want another topic`.

After override, show that the choice is saved as preference and outcome context,
not negative performance evidence.

## Recommendation History

Each record includes:

- original recommendation;
- timestamp;
- reason factors and policy version;
- available-time assumption;
- accepted, changed, deferred, or dismissed;
- chosen alternative;
- completion;
- independent or delayed outcome;
- correction when a regrade changed the recommendation.

Use history to explain what changed, not to judge compliance.

## Misconception Hypothesis

Create a bounded card titled `A pattern to check`, showing:

- specific skill and task;
- evidence from more than one relevant attempt;
- where the pattern did not appear;
- confidence;
- next discriminating question.

Avoid global labels such as `You do not understand...`.

## Dispute and Regrade

Show:

- a grade under review that does not yet change progress;
- a corrected regrade notice;
- before and after evidence projection;
- recommendation recalculation explanation.

Low-confidence and content-uncertain grades cannot create negative evidence.

## Empty States

Create:

1. New learner with optional quick calibration or chosen-topic start.
2. Sparse evidence with an honest `early picture` message.
3. No review due with a useful next action.
4. Recommendation unavailable because content or grading is under review.

Do not fill empty states with zero-percent charts.

## Required Scenarios

- Returning learner with due review.
- New learner.
- Sparse evidence.
- Independent versus coached evidence.
- Retained and mixed evidence.
- Due and deferred review.
- Recommendation explanation.
- Adjusted time.
- Learner override.
- Recommendation history.
- Recurring-gap hypothesis.
- Pending dispute.
- Corrected regrade rebuild.
- No review due.

## Accessibility and Privacy

- Full keyboard operation and visible focus.
- Every chart has a text summary or table.
- No color-only evidence or due status.
- Reflow at 390 CSS pixels.
- Time estimates are guidance, not forced timers.
- No raw learner response text in overview cards.
- No parent, teacher, classroom, or public-sharing view.
- No official score prediction, mastery percentage, guaranteed gain, or
  production recommendation claim.

