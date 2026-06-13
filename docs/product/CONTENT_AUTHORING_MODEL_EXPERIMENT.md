# Content Authoring Model Experiment

**Status:** Approved to design; validation-only execution pending gates
**Owner:** Learning Quality Owner with Main Conductor
**Product Owner:** David Bloom
**Related Task:** `TASK-0007`
**Last Updated:** 2026-06-13

## 1. Question

Can an AI-led authoring model produce complete AP Biology question packages at
equal or better validated quality, originality, diversity, speed, and cost than
the approved paid-tutor-first model?

The experiment tests the business model. It does not presume that the cheaper
or faster arm should become production policy.

## 2. Arms

| Arm | Base-package author | Human involvement before validation |
| --- | --- | --- |
| A - Tutor first | Paid qualified tutor | Tutor authors and attests to the complete package |
| B - AI first, tutor revision | AI from a blank governed brief | A paid tutor revises, completes, and accepts authorship accountability |
| C - AI first, validator only | AI from a blank governed brief | No tutor coauthor; paid independent validators review the candidate |

All arms receive the same abstract coverage brief, approved factual sources,
output contract, and prohibited-input rules. None receives official question
text, an adaptation description, or a rejected question.

Arm C remains validation-only unless separately approved after the experiment.

## 3. Initial Sample

The initial study uses:

- six AP Biology topics across at least three units;
- varied conceptual, quantitative, experimental, and visual demands;
- 30 MCQ packages per arm;
- 12 short-FRQ prompts per arm; and
- no long FRQ until the first MCQ and short-FRQ analysis is complete.

Assignment of briefs to arms is balanced by topic, skill, representation, and
intended difficulty. Validators are blind to authoring arm.

The initial sample is a decision pilot, not proof of broad equivalence. A
production change requires replication across more topics and inclusion of long
FRQs.

## 4. Controls

- Authors and validators are separate.
- The same validators and rubrics are distributed across all arms.
- Model, prompt-build manifest, and parameters are locked for a cohort.
- Tutor time is measured for both original writing and revision.
- Rejected candidates remain in the denominator.
- Every package receives source, rights, similarity, scientific, teaching,
  grading, accessibility, and completeness review.
- Experimental outputs cannot count toward the 964-item production target.
- No arm may use the independent evaluation holdout as an authoring example.

## 5. Outcomes

### Primary Quality Outcomes

- proportion passing preflight without revision;
- proportion passing teaching validation;
- proportion passing grading-package validation;
- blocker defects per package;
- major revisions per accepted package;
- originality and similarity findings;
- validator agreement; and
- representation and reasoning diversity.

### Operating Outcomes

- total paid human minutes per accepted package;
- elapsed cycle time;
- model and tooling cost;
- accepted packages per author or operator hour;
- number of revision rounds; and
- abandonment rate.

### Downstream Outcomes

After a separate limited-pilot approval and sufficient learner exposure:

- ambiguity and challenge reports;
- unexpected distractor behavior;
- grading disagreement;
- delivery-mode effects;
- item-performance review signals; and
- suspension or retirement rate.

Statistical signals open human review and do not automatically change item
state.

## 6. Decision Rule

No alternative arm advances if it has:

- any confirmed rights or firewall violation;
- a higher severe scientific or grading-defect rate;
- lower teaching-gate pass rate by more than five percentage points;
- materially lower validator agreement;
- narrower representation or reasoning diversity; or
- savings that depend on shifting uncompensated work to validators.

An alternative may advance to a larger validation cohort when:

- all blocker categories are zero after adjudication;
- quality is non-inferior within the pilot's stated uncertainty;
- median paid human time per accepted package improves by at least 25%;
- cycle time improves by at least 20%; and
- the Learning Quality Owner recommends continuation.

The Product Owner decides whether to replicate, revise, stop, or propose a
production-policy change. Pilot results alone do not alter the approved
tutor-first production model.

## 7. Required Report

The experiment report must include:

- package counts and disposition by arm;
- all exclusions and protocol deviations;
- validator blinding failures;
- quality and operating metrics with uncertainty;
- failure-card distribution;
- examples summarized without reproducing protected or rejected material;
- tutor and validator workload;
- recommendation and dissenting expert views; and
- explicit limits on generalization.
