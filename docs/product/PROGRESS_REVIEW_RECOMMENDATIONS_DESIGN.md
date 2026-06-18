# Progress, Review Queue, and Recommendations Design

**Status:** Proposed for Product Owner, Learning Quality, accessibility,
security, privacy, and marketing review
**Related Task:** `UX-007`
**Owner:** Product Owner with Learning Quality Owner
**Last Updated:** 2026-06-15

## 1. Purpose

This document defines the learner experience for understanding recent work,
independent evidence, coached practice, recurring gaps, due retrieval, deferred
skills, recommendation reasons, recommendation history, and learner overrides.

It extends the Home and Progress direction in UX-001. It does not finalize the
next-best-action algorithm, stable-improvement thresholds, Lock intervals,
target-score use, or readiness claims.

## 2. Experience Principles

1. Answer what happened, what it means, what remains uncertain, and what to do
   next.
2. Separate activity from evidence of independent performance.
3. Keep coached and cold attempts visibly distinct.
4. Show improvement only at the evidence strength actually observed.
5. Use due review to test retention, not punish lateness.
6. Explain recommendations with inspectable factors and limitations.
7. Let the learner override, defer, or choose another goal without penalty.
8. Record recommendation outcomes without assigning a fixed learner type.
9. Never convert one answer into mastery, readiness, or an AP score.
10. Treat disputed, low-confidence, and content-uncertain grades carefully.

## 3. Information Architecture

Primary student surfaces:

| Area | Purpose |
| --- | --- |
| Home recommendation | One clear next action with reason and time |
| Review queue | Due and upcoming independent retrieval |
| Progress overview | Evidence, activity, recurring gaps, and next priorities |
| Skill detail | Attempt timeline and evidence conditions |
| Recommendation detail | Factors, alternatives, and expected tradeoff |
| Recommendation history | Accepted, overridden, deferred, and completed actions |

The MVP persistent navigation remains Home, Review, Progress, and Account.

## 4. Progress Overview

Progress answers:

1. What have I done?
2. What can I currently do independently?
3. What has improved but still needs confirmation?
4. What still needs attention?
5. What should I do next?

Recommended sections:

- next recommended action;
- due review;
- recent independent evidence;
- supported or coached work;
- skills with provisional improvement;
- recurring criteria or misconception hypotheses;
- deferred or parked targets;
- activity summary;
- grading disputes or uncertain evidence that may change the picture.

Avoid one dominant composite score.

## 5. Evidence Language

Use evidence states:

| State | Learner-facing meaning |
| --- | --- |
| Supported success | You completed this with help |
| Independent success now | You completed a fresh attempt without answer-bearing help |
| Review due | It is time to see whether the improvement holds |
| Retained evidence | You completed a delayed, varied attempt independently |
| Mixed evidence | Recent attempts do not yet tell a stable story |
| Needs attention | Multiple useful attempts show a recurring gap |
| Evidence withheld | A grading or content uncertainty prevents interpretation |

Do not use `Mastered` unless a separately approved evidence threshold exists.
Do not collapse a supported repair into independent success.

## 6. Skill and Criterion Detail

Each detail page shows:

- assessable skill target in learner-readable language;
- representation and task type;
- why it matters for AP Biology;
- recent attempt timeline;
- item variation and delay;
- assistance level;
- criterion outcomes;
- confidence and grading status;
- disputes or corrections;
- recommended next check;
- related prerequisite or representation gap only as a supported hypothesis.

The timeline explains evidence without exposing a raw failure counter or
internal stuck-state label.

## 7. Review Queue

Queue groups:

- Due now
- Due soon
- Deferred by you
- Waiting for grading or recheck
- Optional review

Each review card shows:

- learner-readable target;
- why it is returning;
- evidence state before review;
- approximate time;
- question form or representation;
- whether the review will be independent;
- due window, not punitive overdue language;
- `Start review`;
- `Why now?`;
- `Later`;
- `Choose another review`.

### 7.1 Due Review

The explanation may say:

> You earned this criterion on a fresh question two days ago. This review checks
> whether it still holds without help.

It must not reveal the prior question answer or hidden rubric criteria.

### 7.2 Deferred and Parked Work

Show:

- when and why work was deferred;
- proposed return timing;
- available alternative;
- whether automatic resurfacing is paused because content or intervention is
  unavailable;
- learner control to review now, reschedule, or leave deferred.

Do not frame Move On as failure or noncompliance.

## 8. Recommendation Card

Every recommendation includes:

- action;
- learner-readable target;
- reason;
- estimated time;
- expected evidence type;
- important uncertainty or dependency;
- primary `Start`;
- `Why this?`;
- `Choose something else`;
- adjust available time.

Example:

> **Practice interpreting experimental controls**
>
> This has cost you points in more than one unit, and an independent review is
> due. About 12 minutes.

The card does not claim a causal diagnosis or guaranteed score gain.

## 9. Recommendation Explanation

Show the factors used, not a hidden opaque score:

- exam value;
- recent independent evidence;
- due review;
- recurring criterion gap;
- evidence confidence;
- demonstrated improvability;
- time cost;
- learner goal;
- available time;
- fatigue or frustration only as a user-controlled planning consideration;
- content and grading availability.

Use plain language and disclose missing or uncertain inputs.

Target score does not appear until the Product Owner approves how it affects
recommendations.

## 10. Alternatives and Override

The alternatives view supports:

- same priority, shorter or longer activity;
- another due review;
- practice a chosen topic;
- continue incomplete work;
- bring or check a question;
- move on from the recommended target;
- end or shorten the session.

When a learner overrides:

- ask for no reason by default;
- optionally capture `Not now`, `I want another topic`, `Too long`, or
  free-form feedback;
- do not create negative proficiency evidence;
- record the choice and later outcome;
- keep the original recommendation in history.

Repeated overrides may improve future presentation only when outcomes support
the change; they do not define a personality or learning style.

## 11. Recommendation History

Each record shows:

- recommendation and timestamp;
- factors and policy version;
- available-time assumption;
- accepted, changed, deferred, or dismissed;
- selected alternative;
- completion and evidence outcome;
- later independent or delayed outcome;
- whether a grade correction changed the recommendation.

History supports trust and debugging. It is not a scorecard judging learner
compliance.

## 12. Misconceptions and Recurring Gaps

Present misconceptions as tentative when inferred:

- `A pattern to check`
- evidence from multiple relevant attempts;
- where the pattern did not appear;
- recommended discriminating question or contrast;
- confidence in the interpretation.

Do not label a learner globally. Keep the pattern attached to a specific skill,
task, and representation.

## 13. Disputes and Uncertain Evidence

Progress projections must react safely to UX-006 states:

- pending disputes remain visible but do not silently change the record;
- corrected regrades rebuild affected projections and show a notice;
- low-confidence and content-uncertain grades do not create negative evidence;
- technical failures and interrupted attempts appear as activity, not
  performance;
- human-review-pending results are clearly provisional.

When the recommendation may change after review, say so.

## 14. Activity Summary

Activity may show:

- sessions completed;
- independent and coached attempts;
- time spent as approximate;
- due reviews completed;
- topics and question forms practiced;
- recommendation acceptance and override.

Activity is never titled or visualized as mastery. Streaks do not dominate the
experience.

## 15. Empty, New, and Sparse Evidence States

New learner:

- explain that recommendations are based on goals, time, and a small amount of
  evidence;
- offer optional calibration or chosen-topic entry;
- avoid an empty dashboard full of zeroes.

Sparse evidence:

- state that the picture is early;
- show observed work;
- recommend a short evidence-gathering activity;
- avoid percentages that imply statistical confidence.

No due review:

- explain that nothing is due;
- offer a high-value next action or chosen topic.

## 16. Accessibility and Privacy

- Complete keyboard operation and visible focus.
- Charts always have equivalent tables or summaries.
- No color-only evidence status.
- Avoid dense radar charts and unlabeled progress rings.
- Time and review windows are not countdown pressure.
- Learner can inspect what data supports a recommendation.
- Detailed response text stays out of general progress summaries.
- Future parent access is out of scope and cannot reuse this screen without
  separate consent and entitlement design.

## 17. Lovable Scope

The Lovable render should demonstrate:

- returning Home with recommendation and due review;
- Progress overview with evidence and activity separated;
- skill-detail evidence timeline;
- due, upcoming, deferred, waiting, and optional review queues;
- recommendation explanation and alternatives;
- learner override and adjusted-time behavior;
- recommendation history;
- mixed evidence and misconception hypothesis;
- dispute pending and corrected-regrade projection update;
- new learner, sparse evidence, and no-review states.

No algorithm, prototype, parent view, or authoritative readiness score is
authorized.

## 18. Open Review Questions

- What minimum evidence supports each progress phrase?
- Which Lock intervals and review windows should be displayed?
- How many simultaneous recommendations are useful?
- Which recommendation factors should be learner-adjustable?
- When should a recurring gap be named as a misconception hypothesis?
- How should exam proximity change detail, urgency, and Move On language?
- What notification behavior is acceptable after privacy and consent review?

