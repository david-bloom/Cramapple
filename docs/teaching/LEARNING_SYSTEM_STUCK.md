# Cramapple Stuck-State and Escalation Protocol

**Canonical planning draft | June 10, 2026 | v0.2**

## Document Status

This document defines how Cramapple responds when ordinary evaluation, teaching, and retry cycles are not producing reliable progress on a specific skill and task type. It is a companion to `LEARNING_SYSTEM.md` and uses the same unified learning-state model. A stuck state is an escalation state within that model, not a separate teaching system and not a label applied to the student.

`LEARNING_SYSTEM.md` remains authoritative for the ordinary learning loop, grading, student-provided questions, retrieval, and data posture. This document is authoritative for escalation evidence, intervention selection, Move On, Park, and return scheduling.

Statements labeled **Decision** reflect approved direction. Statements labeled **Working policy** are rational starting rules that require calibration. Statements labeled **Open** remain unresolved.

**Changelog.** v0.2 replaces the deterministic three-miss and Sideways-first protocol with evidence-weighted entry, discriminating probes, skill-and-task-specific intervention effectiveness, independent transfer checks, schedule-aware Park timing, Move On, and explicit anonymous use of student responses to improve Cramapple.

## 1. Premise

Repeated failure is evidence, but raw miss count is not enough. Three misses on the same item, three failures on varied independent tasks, and three assisted attempts do not mean the same thing. Cramapple therefore treats stuckness as an evidence threshold, not as a counter.

The protocol has four jobs:

1. Decide whether ordinary teaching should continue or an escalation is warranted.
2. Distinguish among plausible causes using short, discriminating probes.
3. Select a reversible intervention without pretending to know the learner's hidden cause precisely.
4. Confirm that any apparent success transfers independently and, when time permits, survives delay.

**Decision.** State is tracked at a specific skill-and-task key, not at the whole-student or whole-subject level. A learner may need escalation on interpreting confidence intervals in an experimental FRQ while progressing normally on the same biology content in MCQs.

## 2. Unit of State

The state key should be specific enough to support useful diagnosis without fragmenting every question into a unique skill:

- exam pack and course;
- content concept or learning objective;
- task operation, such as identify, calculate, justify, predict, or evaluate;
- representation, such as prose, graph, table, model, or equation;
- rubric criterion or question family where applicable.

The key is not merely an AP unit plus Science Practice. Those categories are too coarse to distinguish a content gap from a representation or response-construction gap.

Related keys may share evidence, but only with an explicit relationship such as prerequisite, component, parallel representation, or transfer variant.

## 3. Evidence-Weighted Entry

### 3.1 Attempt Evidence

Each failed encounter contributes evidence according to how informative it is:

| Attempt evidence | Failure weight |
| --- | ---: |
| Independent failure on a varied item after a delay | 1.00 |
| Independent failure on a varied item in the same session | 0.65 |
| Failure on the same item or a nearly identical surface form | 0.35 |
| Heavily assisted, incomplete, off-task, or interrupted attempt | 0.00 |
| Source, rubric, or grading uncertainty | 0.00; route to `content_uncertain` |

Weights are not probabilities. They are an auditable policy for distinguishing stronger from weaker evidence while Cramapple gathers calibration data.

### 3.2 Escalation Candidate

**Working policy.** A skill-and-task key becomes an escalation candidate when all of the following are true:

- cumulative failure evidence is at least 1.65;
- evidence includes at least two independent attempts;
- the attempts use at least two distinct items, contexts, or surface forms;
- at least one appropriate ordinary teaching intervention followed by an independent retry did not transfer.

Examples:

- One delayed independent failure plus one same-session varied failure reaches 1.65.
- Three repeated attempts on the same item reach only 1.05 and do not qualify.
- An assisted failure contributes no entry evidence.

### 3.3 When Stuck State Is Warranted

An escalation candidate enters stuck state when at least one additional condition holds:

- a targeted probe identifies a likely prerequisite, integration, misconception, or representation gap;
- two materially different ordinary intervention classes have failed to produce independent transfer;
- an immediate independent success is followed by a delayed failure;
- the learner chooses Move On because continued work is producing overload or frustration.

Low diagnostic confidence alone does not make the learner stuck. If the uncertainty is about the question, source, rubric, or grader, Cramapple enters `content_uncertain`, withholds negative learner-model updates, and creates validator-review evidence.

**Decision.** The learner can request Move On before the system threshold is reached. Agency is part of the protocol, not an exception to it.

## 4. Diagnosing the Failure Pattern

Cramapple diagnoses competing hypotheses, not a single hidden cause. It selects a next action by asking which short probe would most clearly distinguish among plausible explanations.

| Observed pattern or probe | Supported hypothesis | Preferred move | Confidence |
| --- | --- | --- | --- |
| Prerequisite probe fails | Required foundation is unavailable | Step Down | High |
| Atomic components pass but recomposed task fails | Integration or working-memory load | Step Apart | High |
| Prerequisites and components pass; response follows a coherent wrong rule or changes with framing | Misconception or surface-framing sensitivity | Step Sideways | Moderate |
| Same operation succeeds in prose but fails in a graph, table, model, or equation | Representation gap | Sideways using a representation bridge | Moderate to high |
| A similar task succeeds under coaching but fails cold | Cue dependence or response-construction gap | Fade support, then independent retry | Moderate |
| Evidence remains mixed after a short probe | Cause unresolved | Reversible Sideways or learner choice | Low |
| Official source, rubric, or scoring evidence conflicts | Content or grading uncertainty | `content_uncertain` | High |

### 4.1 Viability of Sideways Versus Down

It is viable to choose reliably enough for product use when Cramapple has a direct discriminating probe:

- If the prerequisite itself fails, Down is justified.
- If the prerequisite succeeds and a reframed parallel case exposes or corrects a coherent misconception, Sideways is justified.
- If both signals are weak, the system should not manufacture precision. It should use a reversible Sideways probe or let the learner choose between "break it down" and "show me the foundation."

The reliability target is correct route selection often enough to improve transfer and reduce wasted effort, not perfect inference about cognition. Route accuracy must be evaluated by subsequent independent and delayed performance.

### 4.2 Evidence Qualifiers

Time-on-task, typing patterns, paste signals, self-reported confidence, and frustration may adjust confidence in an interpretation. They do not independently select Sideways, Apart, or Down. In particular, a fast wrong answer may reflect guessing, fluency with a misconception, distraction, or a simple slip.

## 5. The Three Escalation Moves

### 5.1 Step Sideways

Use the same skill and level from a different angle: a contrasting case, alternative context, counterexample, or representation bridge.

Use Sideways when the student appears to hold a coherent but incorrect rule, is sensitive to surface framing, or can perform the operation in one representation but not another. Sideways should create information: the next attempt must help distinguish a misconception from a prerequisite or integration gap.

### 5.2 Step Apart

Decompose the task into atomic components, confirm each component independently, then recompose them on a parallel problem.

Use Apart when the learner can perform components in isolation but loses accuracy when coordinating them. Passing the isolated pieces is not success on the original skill; recomposition is required.

### 5.3 Step Down

Teach and test an identified prerequisite before returning to the original task.

Use Down when a targeted prerequisite probe fails. The prerequisite must be represented in the content graph, and the return to the original task must be explicit. A generic review of "foundations" is not a valid Step Down.

### 5.4 Selection Policy

**Decision.** There is no universal move order.

1. Use a direct probe when it can materially distinguish the options.
2. Route Down on failed prerequisite evidence.
3. Route Apart when components pass and integration fails.
4. Route Sideways for coherent misconceptions, framing sensitivity, or representation gaps.
5. When evidence remains ambiguous, offer a reversible Sideways case or learner choice.
6. Record the route, support level, and outcome so later decisions can use demonstrated effectiveness.

## 6. Support Budget and Learner Choice

Escalation should not become an endurance test.

**Working policy.** After ordinary teaching fails, Cramapple may use at most two escalation moves on the same skill-and-task key in one session, normally within six to ten minutes. A direct diagnostic probe does not count as a move if it is brief and does not teach the answer.

After each move, the learner receives a fresh independent transfer attempt. The learner may choose:

- **Try another approach:** use the next supported intervention;
- **Move on and return later:** defer the skill while continuing the session;
- **Move on for now:** continue without an automatic same-session retry;
- **End the session:** preserve progress and the return plan.

Move On is a learner-facing choice. Park is the system's deferred state after support is exhausted, utility is low, or the learner chooses to stop working on the skill.

## 7. Confirmation Ladder

Intervention performance and durable learning are different states:

| State | Required evidence | System interpretation |
| --- | --- | --- |
| Supported success | Correct with hints, decomposition, worked example, or visible rubric cues | Intervention helped; do not claim mastery |
| Immediate independent transfer | Correct on a fresh item without answer-bearing support | Provisional progress; schedule confirmation |
| Confirmed retention | Correct on a delayed, varied item without answer-bearing support | Strong evidence of retained and transferable performance |

**Decision.** A successful Sideways, Apart, or Down interaction does not immediately credit the original skill as mastered. It must be followed by an independent transfer attempt. When enough time remains before the exam, Cramapple also schedules a delayed check.

If the delayed check fails, the learner model records fragile or unconfirmed progress rather than erasing the earlier success. The new failure becomes strong evidence for renewed diagnosis.

## 8. Park and Return Scheduling

### 8.1 Park Conditions

Cramapple parks a skill-and-task key when:

- the per-session support budget is exhausted;
- the learner selects Move On or return later;
- expected benefit is lower than the cost of continuing now;
- no validated content exists for the next intervention;
- the remaining exam schedule makes an automatic return unhelpful.

Park removes the skill from the current sequence, preserves the evidence history, and selects a return time and fresh surface form when useful.

### 8.2 Schedule-Aware Formula

The return policy must account for recovery time, exam proximity, and expected exam utility.

Let:

- `H` = hours remaining until the exam;
- `F` = current frustration or exhaustion estimate from 0 to 1;
- `U` = normalized expected exam utility of revisiting this skill from 0 to 1;
- `R = 12 + 36F` = minimum reset interval in hours;
- `P = 48 - 24U` = priority interval in hours;
- `L = max(0, H - 18)` = latest useful automatic return, preserving the final 18 hours for sleep, logistics, and optional light review.

Then:

`return_delay_hours = min(L, max(R, P))`

Interpretation:

- higher frustration lengthens the reset interval;
- higher expected exam utility brings the target return closer;
- the return never lands inside the protected final 18-hour window;
- if `L < 12`, Cramapple does not automatically resurface the skill and instead offers an optional concise review.

This is a reliable policy formula in the engineering sense: deterministic, explainable, bounded, and testable. It is not claimed as a scientifically optimal formula. The constants must be validated against completion, transfer, frustration, and exam-proximity outcomes.

### 8.3 Return Conditions

On return, Cramapple uses:

- a fresh item or surface form;
- cold mode unless the learner requests coaching;
- retained prior evidence without displaying a failure counter;
- a validator-reviewed intervention path where prior content uncertainty existed.

Two Park events for the same skill-and-task key should create a content and prerequisite-map review signal. Automatic resurfacing should pause when the system lacks a credible new intervention.

## 9. Demonstrated Intervention Effectiveness

Cramapple tracks effectiveness by:

- learner;
- skill-and-task key;
- intervention class;
- representation and question type;
- support level;
- immediate independent-transfer outcome;
- delayed-retention outcome;
- relevant context, including time until exam.

The system does not infer a general preference for "foundations," "pieces," visual learning, or another learning style. It may bias a route only when comparable prior evidence shows that the intervention improved independent or delayed performance for this learner on this kind of task.

Biases must remain transparent and reversible. A learner can always choose a different approach.

## 10. Validator and Content-Uncertainty Workflow

Validators need a compact evidence package rather than a transcript dump. A review item should include:

- question and authoritative source;
- rubric or scoring guideline version;
- anonymized student response;
- grader decision and criterion-level rationale;
- competing diagnosis hypotheses and probes;
- teaching intervention shown;
- independent and delayed outcomes where available;
- reason for escalation, disagreement, or uncertainty.

Validator actions are:

- confirm;
- correct grading;
- correct diagnosis or routing;
- revise content or prerequisite mapping;
- mark insufficient evidence;
- hold the item from automated use.

Validator corrections become versioned evaluation examples and may update prompt, rubric, content, or routing policies after review.

## 11. Data and Improvement

Cramapple uses anonymous or deidentified student responses and associated outcome traces to improve Cramapple's grading, teaching, content, evaluation sets, model configurations, and intervention-routing policies.

Internal improvement use is separate from public publication. A response or student-provided question may be used anonymously for internal evaluation without becoming a public landing page. Public publication requires the separate quality and identity checks in `LEARNING_SYSTEM.md`.

Names, account identifiers, payment information, and parent identifiers are excluded from improvement datasets. Before any public publication, Cramapple runs a deterministic sweep for the signed-in user's full proper name and reasonable first-name, last-name, and combined-name variants. Matches are removed or held for review.

Terms and Conditions prohibit submission of personal or confidential information and govern residual edge cases. Legal language and age-related consent requirements remain counsel-owned.

## 12. UX Expression

The learner should experience an adaptive teacher, not a diagnostic label.

Suggested transition:

> That approach did not make this stick yet. We can try a different angle, break it into parts, review the prerequisite, or move on and return later.

The interface should not show:

- the word "stuck" as a learner label;
- a failure counter;
- unsupported claims about why the learner failed;
- a mastery claim after supported success.

It should show:

- why a next action is suggested in plain language;
- the available alternatives;
- when a deferred skill is expected to return;
- evidence of later improvement when independent or delayed performance supports it.

## 13. Research Posture

The moves are informed by conceptual-change research, cognitive-load and worked-example research, mastery learning, retrieval practice, and metacognition. Those bodies of work support testing prerequisites, decomposing integrated tasks, using contrasting cases, fading support, and confirming learning through retrieval.

They do not justify a universal Sideways-first order, a fixed three-miss rule, a generic learning-style preference, or a claim that one observed behavior reveals the student's internal cause. Cramapple's exact thresholds and route policies are product hypotheses to validate with expert review and student outcome data.

## 14. Open Items

- Calibrate the 1.65 entry threshold and evidence weights by skill and exam pack.
- Define the minimum sample and effect threshold before prior intervention outcomes may bias routing.
- Determine whether the final 18-hour protected window should vary by exam time and learner preference.
- Define frustration estimation without using it as a hidden diagnosis.
- Specify validator sampling rates for Park events and repeated route failures.
- Define how parent progress access summarizes deferred skills without exposing private response text.

## 15. Operating Implications

- The learner-state store needs versioned attempt evidence, state keys, support levels, routes, outcomes, Park timing, and content-uncertainty states.
- The content system needs explicit prerequisite, component, parallel-representation, and transfer-item relationships.
- The next-best-action engine needs the schedule-aware return formula and a protected final-exam window.
- The validator console needs the compact evidence package and correction actions in Section 10.
- Analytics must report immediate transfer and delayed retention separately.
- Content authors must create diagnostic probes and fresh transfer items, not only explanations.

*End of document. Version 0.2, June 2026.*
