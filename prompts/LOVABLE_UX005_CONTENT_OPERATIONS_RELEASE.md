# Lovable Build Brief - UX-005 Content Operations, Adjudication, and Release

Build a polished, responsive, frontend-only Cramapple content-operations
console. It coordinates reviewer qualifications, assignments, calibration,
adjudication, release gates, immutable manifests, rollback, and incidents.

Do not connect authentication, Supabase, databases, uploads, notifications,
production release infrastructure, or protected validation sets. All actions
are simulated fixtures.

## Product Boundary

- UX-002 owns independent reviewer scoring.
- UX-003 owns authoring and revision.
- UX-005 owns authority, assignment, adjudication, and release operations.
- A dashboard signal never substitutes for required expert evidence.
- Administrators cannot self-grant educational or release authority.

## Visual Direction

- Serious operational control room without looking militarized.
- Warm neutral background, deep evergreen navigation, white evidence panels.
- Restrained blue information, amber risk, red blocker, and green passed states.
- Dense tables should become readable cards on narrow screens.
- No gamification or decorative charts without operational meaning.

## Suggested Routes

```text
/prototype/ops
/prototype/ops/people
/prototype/ops/qualifications/:id
/prototype/ops/assignments
/prototype/ops/calibration
/prototype/ops/adjudications/:id
/prototype/ops/releases
/prototype/ops/releases/:manifestId
/prototype/ops/incidents/:incidentId
/prototype/ops/audit
```

## Global Navigation

- Operations
- People
- Assignments
- Calibration
- Adjudication
- Releases
- Incidents
- Audit

Show the current role and authority scope in the header. Hide unavailable
actions and explain missing authority when relevant.

## Operations Dashboard

Create actionable cards for:

- unfilled assignments;
- overdue reviews;
- calibration due or failed;
- expiring qualifications;
- adjudications awaiting a lead;
- release blockers;
- releases under heightened monitoring;
- open incidents;
- expiring source or rights evidence.

Each count opens a filtered queue. Use text and icons in addition to color.

## Qualification Record

Show:

- person and verified role;
- qualification type and exact scope;
- evidence and training checklist;
- qualification-set metrics;
- calibration history;
- effective and expiry dates;
- status and decision history;
- dependent entitlements and open assignments.

Actions:

- recommend grant;
- renew;
- request evidence;
- assign remediation;
- suspend;
- revoke.

Before suspension, show which entitlements stop and which assignments require
replacement. Never offer self-grant.

## Assignment Workspace

Start with the required qualification, artifact scope, review stage, due date,
and independence rules.

Eligible-reviewer rows show:

- qualification match;
- entitlement;
- workload;
- calibration status;
- availability;
- conflict result;
- recent use on related artifact families.

Block authors, editors, collaborators, prior gold-answer viewers, and other
mandatory conflicts. Support balanced batch assignment, reassignment after
recusal, due-date extension, cancellation, and unfillable escalation.

## Calibration

Create:

- due-calibration queue;
- hidden-key qualification-set card;
- criterion agreement and severe-error summary;
- teaching blocker checklist;
- trend by criterion and archetype;
- outcome panel.

Outcomes:

- Passed
- Monitored scope
- Remediation required
- Suspend pending requalification
- Evidence insufficient

Metrics inform the authorized decision; they do not automatically change
access.

## Adjudication

Show one grading disagreement with:

- immutable response and rubric versions;
- two locked independent criterion decisions;
- cited response evidence;
- rationales;
- exact disagreement;
- applicable policy;
- adjudicator conflict check.

Actions:

- record supported outcome;
- mark insufficient evidence;
- reopen rubric;
- send artifact to UX-003 revision;
- create calibration finding;
- escalate policy, scientific, rights, or privacy issue.

Prior decisions remain visible. The adjudication creates a new record.

## Release Candidate

Show release class, semantic version, immutable manifest ID, predecessor,
included-version summary, and gate matrix.

Gate states:

- Passed
- Blocked
- Awaiting evidence
- Not applicable

Include source, rights, teaching, grading, accessibility, security, dependency,
checksum, smoke-test, exception, rollback, and monitoring rows.

Create one blocked candidate and one ready candidate.

## Manifest Comparison

Compare candidate to active manifest by:

- questions and rubrics;
- teaching artifacts;
- grading and policy configuration;
- sources and rights;
- taxonomy and exam specification;
- accessibility;
- additions, replacements, suspensions, and removals.

Highlight revalidation class and high-impact changes without color alone.

## Publication Confirmation

Require:

- all gates passed;
- exact authority and independence check;
- smoke tests passed;
- rollback target selected;
- monitoring owner acknowledged;
- deliberate manifest-ID confirmation.

Success copy:

```text
Manifest BIO-2026.3 is active.
The prior manifest remains available for atomic rollback.
Heightened monitoring has started.
```

This is simulation only.

## Rollback and Incident

Create an S1 grading incident with:

- timeline;
- affected manifest and rubric family;
- severity and commander;
- containment tasks;
- learner-impact and regrading assessment;
- rollback candidate;
- correction and revalidation owners;
- monitoring and closure checklist.

Rollback confirmation must explain that the full active manifest pointer
changes atomically. Do not offer partial rollback.

Incident states:

```text
Open
Triaged
Contained
Correcting
Revalidating
Monitoring
Closed
```

## Required Scenarios

- Expiring validator qualification.
- Suspended reviewer with open assignments.
- Unfillable conflict-aware assignment.
- Failed interim calibration.
- Criterion-level grading adjudication.
- Rubric defect that invalidates cases.
- Release blocked by expired rights evidence.
- Ready manifest publication.
- Smoke-test failure and atomic rollback.
- Incident closure with follow-up actions.

## Accessibility and Safety

- Full keyboard operation and visible focus.
- Responsive alternatives to wide tables.
- No color-only status, severity, gate, or diff.
- Confirm destructive or production-sensitive simulations at the final step.
- Do not include real people, protected holdouts, secrets, learner responses,
  or production identifiers.
- Label every grant, publish, rollback, export, and incident action as a
  prototype simulation.

