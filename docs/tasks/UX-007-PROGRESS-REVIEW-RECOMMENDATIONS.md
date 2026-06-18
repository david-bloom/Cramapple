# UX-007 - Progress, Review Queue, and Recommendations

**Task ID:** UX-007
**Title:** Progress, Review Queue, and Recommendations
**Owner:** Product Owner with Learning Quality Owner
**Product Owner:** David Bloom
**Status:** In Progress
**Priority:** High
**Created Date:** 2026-06-15
**Approved Date:** 2026-06-15 for design documentation and Lovable brief

## Product Goal

Design how learners understand activity, independent evidence, coached work,
due retrieval, recurring gaps, recommendation reasons, alternatives, overrides,
and recommendation history.

## Technical Scope

- Define Progress overview and evidence language.
- Define skill and criterion detail timelines.
- Define due, upcoming, deferred, waiting, and optional review queues.
- Define recommendation cards and explanation factors.
- Define learner alternatives, overrides, and adjusted-time behavior.
- Define recommendation history and outcome trace.
- Define misconception hypotheses and mixed-evidence states.
- Define dispute, regrade, sparse-evidence, and empty states.
- Produce a Lovable-ready render brief without a prototype.

## Out of Scope

- Final next-best-action algorithm or production recommendation engine.
- Stable-improvement, readiness, or mastery thresholds.
- Final Lock scheduling constants or notification policy.
- Official score prediction or guaranteed improvement.
- Parent progress experience.
- Detailed practice and grading controls owned by UX-006.

## Routes / Components / Systems Affected

- Returning Home.
- Review queue.
- Progress overview.
- Skill and criterion detail.
- Recommendation detail and alternatives.
- Recommendation history.
- Dispute and correction notices.

## Data / Security / Integration Impact

Production use depends on versioned attempt evidence, assistance level,
question variation, delay, confidence, grading state, recommendation inputs,
policy versions, learner overrides, and downstream outcomes. Detailed responses
must remain separated from summary projections and future parent entitlements.

## Acceptance Criteria

- [x] Activity and evidence of learning are distinct.
- [x] Coached, independent, delayed, mixed, and withheld evidence are explicit.
- [x] Review cards explain why and when a target returns.
- [x] Move On and deferred work are not framed as learner failure.
- [x] Recommendation factors and uncertainty are inspectable.
- [x] Learner overrides do not create negative proficiency evidence.
- [x] Recommendation history preserves original reasoning and later outcomes.
- [x] Misconceptions remain bounded hypotheses rather than learner labels.
- [x] Disputes and corrected grades safely rebuild projections.
- [x] New, sparse, and no-review states are defined.
- [x] Lovable-ready handoff is produced.
- [ ] Learning Quality, accessibility, privacy, security, and marketing review
  is completed.
- [ ] Product Owner approves, revises, or rejects the final UX.

## QA Plan

- Document QA: Verify evidence and recommendation language against UX-001 and
  the learning and stuck-state systems.
- Lovable QA: Walk returning, new, sparse, due-review, deferred, mixed-evidence,
  override, dispute, and corrected-grade scenarios.
- Regression areas: Activity presented as mastery, hidden recommendation logic,
  punitive overdue language, coerced recommendations, and uncertain grades
  affecting progress.
- Failure cases: No evidence, stale recommendation, pending regrade, unavailable
  content, expired due window, and unsupported target-score input.
- Privacy checks: No parent view or raw response exposure in summary fixtures.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate for implementation and learner-facing claims
**Decision:** Design documentation and Lovable brief approved; implementation
pending

## Implementation Notes

Primary records:

- `docs/product/PROGRESS_REVIEW_RECOMMENDATIONS_DESIGN.md`
- `prompts/LOVABLE_UX007_PROGRESS_REVIEW_RECOMMENDATIONS.md`

No prototype is authorized by this task.

## QA Review

Pending expert and Product Owner review.

## Done Decision

**Decision:** Pending
**Date:** Pending

