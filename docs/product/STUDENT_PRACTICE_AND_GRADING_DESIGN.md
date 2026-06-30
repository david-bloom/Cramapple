# Student Practice and Grading Design

**Status:** Proposed for Product Owner, Learning Quality, grading,
accessibility, security, privacy, and academic-integrity review
**Related Task:** `UX-006`
**Owner:** Product Owner with Learning Quality Owner and Grading Lead
**Last Updated:** 2026-06-17

## 1. Purpose

This document defines the detailed learner experience for attempting, saving,
submitting, grading, repairing, disputing, and regrading MCQ, FRQ, quantitative,
data-analysis, and mixed-representation practice.

It extends the stable learning-session frame in UX-001. It does not approve an
automated grader for learner-facing use. Validated scoring combinations,
confidence and abstention policy, human-review operations, and release gates
remain governed by `TASK-0010` and UX-005.

## 2. Experience Principles

1. Protect cold attempts from answer-bearing help.
2. Preserve learner work before grading begins.
3. Distinguish correctness, criterion evidence, score, and interpretation.
4. Ground every feedback claim in the learner response and applicable rule.
5. Display grading confidence and source without theatrical precision.
6. Withhold authoritative totals when the evidence is insufficient.
7. Make the smallest useful repair the primary next action.
8. Preserve immutable submissions and append regrades.
9. Let learners dispute a specific criterion without promising unavailable
   human service.
10. Never let a technical failure create duplicate attempts or negative
    evidence.

## 3. Stable Practice Frame

Every practice route uses:

1. **Session context:** time guidance, progress, mode, save state, exit.
2. **Orientation:** visible command, permitted context, accessibility controls.
3. **Attempt:** question, stimulus, response, work, confidence, help.
4. **Response state:** submitted, grading, feedback, uncertainty, escalation,
   repair, retry, or completion.

The attempt area remains stable while controls adapt to question form.

## 4. Attempt Conditions

Each attempt visibly identifies:

- `Independent`
- `Coached`
- `Exam practice`

The learner can inspect what the label means. Receiving a hint, worked example,
visible rubric criterion, or answer-bearing correction changes subsequent work
on that item to coached. It does not erase the original submission.

Autosave is distinct from submission. Submission freezes the response version
used for grading.

## 5. MCQ Practice

Show:

- stem and approved stimulus;
- four answer options or active exam-pack configuration;
- single-choice control;
- optional confidence prompt;
- optional brief `Why?` field only when the interruption is useful;
- `I need help`, `Move on`, and `Submit answer`.

Before submission, do not reveal:

- tested concept when identifying it is part of the task;
- distractor misconception labels;
- option rationales;
- correct answer;
- predicted score impact.

### 5.1 MCQ Feedback

Correct:

- state that the selected answer is supported;
- explain the decisive evidence or reasoning;
- optionally contrast the strongest distractor;
- distinguish independent from coached success;
- offer a fresh transfer or next action.

Incorrect:

- preserve the selected option;
- explain why it fails using the question evidence;
- explain why the best answer succeeds;
- name a misconception only as a hypothesis supported by the option design;
- recommend one repair action.

Content or key uncertainty enters `content_uncertain`, does not count against
progress, and offers another question or review flag.

## 6. FRQ Practice

### 6.1 Response Composer

Support:

- multi-part prompt navigation;
- persistent stimulus and data;
- plain-text response fields by part;
- optional calculation workspace;
- accessible table and equation entry;
- visible word or character guidance only when pedagogically justified;
- save and resume;
- one final submission summary.

The cold composer does not show hidden criterion checklists or sample answers.

### 6.2 Criterion Feedback

After grading, present:

1. score status and confidence;
2. criterion-by-criterion observed result;
3. response evidence and decision-gate result that supported or failed each
   criterion;
4. contradiction or ambiguity where applicable;
5. highest-value missed criterion;
6. minimum fix;
7. one recommended repair.

Each criterion card uses:

- `Earned`
- `Not yet earned`
- `Unable to determine`
- `Not applicable`

`Unable to determine` is not displayed as zero. Total points are withheld or
qualified when unresolved criteria make the total unreliable.

The complete response, rubric version, grading time, and assistance state remain
inspectable without overwhelming the first feedback view.

### 6.3 Grader Evidence Contract

For each model-supported FRQ criterion, the internal grading result should
include:

- exact response evidence quote, or an empty quote when no evidence supports
  the point;
- criterion-boundary contract version;
- decision gate: `pass`, `fail`, or `unable_to_determine`;
- status: `earned`, `not_earned`, or `unable_to_determine`;
- rationale;
- minimum fix.

The grading contract should enforce:

- empty evidence quote cannot earn the criterion;
- failed decision gate cannot earn the criterion;
- correct topic vocabulary does not earn a criterion when the criterion
  requires a specific causal, comparative, or justification step;
- malformed output or gate/status contradiction triggers bounded retry,
  qualified result, or human review according to policy.

If reviewer labels, rubric wording, and model behavior expose a boundary
conflict, treat it as a rubric-quality issue. Do not tune the prompt to match
an unstable label silently.

### 6.4 Rubric Calibration Workflow

Use a two-step calibration workflow for new or changing FRQ rubrics before
they are treated as production-ready:

1. Run the primary rubric scorer on the released question and rubric using
   `gpt-4o-mini` as the baseline calibration model.
2. If the criterion is new, revised, disputed, or appears in a disagreement
   cluster, run a secondary audit model on the same response set.
3. Use the disagreement set to tighten the rubric boundary or route the item
   to Learning Quality review.
4. Do not use the secondary model as a silent production fallback scorer for
   stable learner attempts.

For BYOQ and other user-provided questions, the dual-model pass is the
default calibration path before release. The goal is boundary diagnosis, not
ensemble voting.

### 6.5 Rubric Improvement Loop

Every new question introduced into the product should pass through a rubric
improvement loop before it is treated as release-ready content:

1. **Reasoning agent:** review the question, rubric, answer key, and a sample
   of representative student responses for boundary pressure, hidden
   assumptions, and edge cases.
2. **Rule-following agent:** score the same material with a literal rubric
   reading to expose over-credit and under-credit risk.
3. **Judge agent:** reconcile disagreements, assign the final criterion-level
   call for each disputed row, and emit a rubric-debug note.
4. **Learning Quality review:** if the disagreement reflects rubric ambiguity,
   double-barreled criteria, answer leakage, or missing boundary language,
   revise the question or rubric before tutor review.

The output of this loop is not a generic quality score. It is a concrete list
of rubric defects, boundary clarifications, and whether the item can move
forward unchanged, needs revision, or should be rejected.

Use this loop by default for:

- newly authored questions;
- revised questions;
- new FRQ rubrics;
- MCQ distractor sets and answer keys;

Do not use it on every learner attempt. It is a content-governance workflow,
not a live grading requirement.

## 7. Quantitative and Data-Analysis Practice

The response may contain:

- numeric answer;
- unit;
- intermediate work;
- equation or relationship;
- table interpretation;
- graph-derived estimate;
- written justification.

Deterministic checks should distinguish:

- arithmetic;
- unit;
- sign;
- rounding;
- transcription;
- setup or formula selection;
- interpretation.

A wrong final number with a supported setup is different from a correct number
with unsupported or contradictory work. The UI shows which component was
observed rather than reducing all errors to `Incorrect`.

Where an unsupported representation is submitted, use human review or
abstention according to policy rather than silently converting it.

## 8. Grading States

```text
draft_saved
submitted
grading
graded_high_confidence
graded_qualified
low_confidence
content_uncertain
human_review_pending
regrade_pending
regraded
grading_failed
```

### 8.1 High Confidence

Available only for released question, rubric, grader, and confidence-policy
combinations. Show criterion result and total with the approved qualification,
not as an official College Board score.

New BYOQ items or rubric revisions remain `qualified` or `content_uncertain`
until the calibration workflow has been completed and reviewed.

### 8.2 Qualified Result

Use when the system can support observations and likely criteria but a precise
total requires qualification. Name the source, such as a validated Cramapple
rubric or an inferred rubric pattern.

### 8.3 Low Confidence

Copy pattern:

> I can give useful feedback on parts of this response, but I am not confident
> enough to present the score as reliable.

Show:

- supported observations;
- unresolved criteria;
- reason category without exposing model internals;
- whether the attempt affects progress;
- available next actions.

Do not display a pseudo-precise total beside this message.

### 8.4 Content Uncertain

Use when question, stimulus, source, rubric, answer key, or grading information
may be defective. Save the response, withhold negative evidence, and allow:

- try another question;
- add missing context when applicable;
- flag for review;
- continue later.

### 8.5 Technical Failure

The response remains saved. Retry uses the same idempotent submission. The
learner may leave and resume without duplicate attempts.

## 9. Repair and Retry

The feedback surface recommends one:

- fix the missing step;
- see how this works;
- try a different angle;
- break it into parts;
- review a prerequisite;
- move on and return later.

The learner can choose another available route. Any substantive support marks
the interaction as coached.

Repair operates on a copy or clearly labeled revision workspace. The immutable
original response stays visible. After repair, use a fresh aligned item for
independent evidence; do not relabel the repaired response as cold.

## 10. Disputes

`Request a recheck` opens a criterion-specific form:

- select criterion or answer-key concern;
- show the exact decision and cited evidence;
- optionally highlight or quote overlooked response text;
- explain the disagreement;
- disclose whether automated recheck or human review is operational;
- state that the original result remains visible during review.

Do not require the learner to restate the whole answer. Do not use a generic
thumbs-down as the dispute record.

The learner sees:

- submitted;
- queued;
- under review;
- corrected;
- upheld;
- insufficient evidence;
- closed.

No response-time promise appears unless the service level is approved and
operational.

## 11. Regrading and Correction

A regrade creates a new result linked to the immutable submission and prior
grade. It never overwrites history.

The comparison view shows:

- prior and current criterion decisions;
- prior and current total, when available;
- reason for change;
- rubric, grader, policy, or human-review version;
- whether learner evidence and progress projections were rebuilt;
- apology or correction notice when Cramapple was wrong.

An upheld grade explains the supporting response evidence and criterion. A
rubric defect routes the content to UX-005 and may suspend the affected
combination.

## 12. Escalation and Human Review

Human review may be required for:

- low-confidence or conflicting grading passes;
- learner dispute;
- ambiguous, novel, or unsupported response;
- handwritten graph or image;
- severe-error signal;
- content uncertainty;
- limited-release or monitoring sample.

The learner-facing interface says `Human review` only when a staffed service is
actually active. Otherwise use `Saved for quality review` or another approved
truthful state.

Internal reviewers receive the compact evidence package through UX-005, not a
learner-visible transcript dump.

## 13. Evidence Consequences

Each result explains whether it contributes as:

- cold independent evidence;
- coached attempt;
- immediate independent transfer;
- exam-practice evidence;
- excluded due to uncertainty or technical failure.

Paste, time, or typing signals may qualify evidence and trigger neutral
coaching. They do not prove cheating or determine correctness.

Low-confidence and content-uncertain results do not create negative learner
evidence solely from the uncertain grade.

## 14. Accessibility and Trust

- Complete keyboard operation and visible focus.
- Semantic grouping for answer options and criterion cards.
- Accessible math, tables, charts, and data.
- Error summaries that move focus to the relevant field.
- No color-only earned, missed, uncertain, or changed status.
- Saved, submitted, grading, and regraded states announced.
- Time guidance does not force completion.
- Reduced motion for panel transitions.
- Learner response text remains readable in grade and dispute comparisons.

## 15. Lovable Scope

The Lovable render should demonstrate:

- MCQ cold attempt and correct/incorrect feedback;
- short FRQ composer and criterion feedback;
- long FRQ multi-part navigation;
- quantitative answer with setup, unit, and interpretation checks;
- high-confidence, qualified, low-confidence, and content-uncertain results;
- temporary grading failure and resume;
- criterion-specific dispute;
- pending review and corrected regrade;
- repair and fresh independent retry boundary.

No prototype or working grader is authorized by this design task.

## 16. Open Review Questions

- Which confidence labels and detail improve trust without confusing learners?
- Which MCQ attempts should ask for optional reasoning?
- When is a provisional total useful versus harmful?
- Which disputes receive automated recheck, human review, or quality sampling?
- What service-level language can be promised for staffed review?
- How should long-FRQ autosave and final submission handle partial parts?
- Which quantitative work formats are required for MVP accessibility?
