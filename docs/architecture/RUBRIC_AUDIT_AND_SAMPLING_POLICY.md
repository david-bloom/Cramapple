# Rubric Audit and Sampling Policy

**Status:** Proposed for Product Owner and Learning Quality review  
**Owner:** Product Owner with Learning Quality Owner  
**Purpose:** Cron-friendly audit policy for periodically sampling released
question, rubric, and score data to detect rubric drift and boundary defects.

## 1. Purpose

This policy defines a periodic audit loop for authored content that is already
in the canonical question-and-rubric workflow. The goal is to detect rubric
ambiguity, boundary drift, over-credit risk, under-credit risk, answer leakage,
and recurrent disagreement patterns before they become entrenched.

This is an audit policy, not a live grading policy.

## 2. Scope

Include:

- newly authored questions;
- revised questions;
- released FRQ rubrics;
- released MCQ answer keys and distractor sets;
- criterion-level score records from production or preproduction runs;
- items with prior disagreement, drift, or human review flags.

Exclude:

- BYOQ intake unless a specific BYOQ item has been promoted into the canonical
  authored-content workflow;
- one-off learner attempts that are not part of a reusable canonical item;
- infrastructure-only failures with no rubric or score implications.

## 3. Audit Goals

Each audit run should answer four questions:

1. Did the rubric behave consistently on this sample?
2. Which criteria show repeated over-credit or under-credit?
3. Which question or answer elements need revision?
4. Which items should be escalated to Learning Quality or retained as-is?

The audit output is actionable rubric telemetry, not a quality score.

## 4. Audit Cadence

Use the following cron-friendly schedule:

- **Daily incremental audit:** run every day on recently changed or recently
  scored authored content.
- **Weekly stratified audit:** run once per week on a larger mixed sample.
- **Monthly deep audit:** run once per month on a broader stability sample with
  more stable items included.

Recommended default times:

- daily at `03:15` local production time;
- weekly on `Monday 04:00`;
- monthly on the first business day at `04:30`.

If only one schedule is available, use the daily incremental audit and expand
its sample size.

## 5. Sampling Rules

### 5.1 Sample strata

Each run should sample from these strata:

- new items;
- revised items;
- disputed items;
- high-volume items;
- stable random items.

### 5.2 Default sample sizes

Use the following starting point:

- daily incremental audit: 20 records;
- weekly stratified audit: 50 records;
- monthly deep audit: 100 records.

If the available population is smaller than the target sample, audit all
available records in that stratum.

### 5.3 Sample composition

For each run:

- 40% from new or revised items;
- 25% from disputed or historically unstable items;
- 20% from high-volume items;
- 15% from stable random items.

When a stratum is undersupplied, move the remainder into stable random items.

## 6. Audit Inputs

Each sampled record should include, when available:

- question prompt or stimulus;
- rubric text;
- answer key or canonical answer;
- criterion-level score outputs;
- human labels or adjudicated labels;
- disagreement history;
- revision history;
- model identifier and prompt version;
- release or review status.

## 7. Audit Procedure

For each sampled record:

1. Load the current question/rubric/score package.
2. Run the judge workflow on the criterion set or on a representative scored
   slice.
3. Compare judge output with the stored rubric and score behavior.
4. Record whether the disagreement is caused by:
   - rubric ambiguity;
   - double-barreled criteria;
   - answer leakage;
   - missing boundary language;
   - model misread of a clear rule;
   - stale or inconsistent score data.
5. Produce a recommended action:
   - no change;
   - tighten rubric wording;
   - split a criterion;
   - add an example or counterexample;
   - route to Learning Quality review;
   - reopen the item for revision.

## 8. Trigger Rules

Escalate an item into a higher-priority audit bucket if any of the following
occur:

- repeated disagreement on the same criterion across multiple runs;
- sudden increase in over-credit or under-credit for one question family;
- new rubric text with no prior audit history;
- a single criterion appears to absorb two different skills;
- a canonical answer or answer key appears to give away the score boundary;
- a revision changes the meaning of a previously stable criterion;
- any score output contradicts its own evidence quote or decision gate.

## 9. Output Contract

Each run should emit:

- run timestamp;
- sample counts by stratum;
- sampled record IDs;
- criterion-level disagreement counts;
- recurring issue clusters;
- suggested rubric fixes;
- suggested content fixes;
- items escalated to Learning Quality;
- items cleared with no change.

The output must be append-only and auditable.

## 10. Storage and Retention

Store audit results in an append-only audit log keyed by:

- run ID;
- record ID;
- question or rubric version;
- model version;
- prompt version;
- revision version;
- disposition.

Retain full audit history so drift trends can be compared across time.

## 11. Operational Safeguards

- Do not silently change production rubrics from audit output alone.
- Do not use audit runs to rewrite learner grades.
- Do not include BYOQ in this audit loop unless it has been promoted into the
  canonical authored-content workflow.
- Keep the audit report separate from human release decisions.
- If the audit cannot resolve a boundary, route it to Learning Quality.

## 12. Cron-Friendly Summary

If you are turning this into a scheduled job, the job should:

1. select the correct stratum(s) for the cadence;
2. fetch the sampled records and their current versions;
3. run the judge workflow;
4. write append-only audit results;
5. emit a compact summary for review;
6. raise a follow-up task when a trigger rule fires.

This policy is designed so a cron job can execute it without needing live
human direction for every run, while still surfacing the cases that need
review.
