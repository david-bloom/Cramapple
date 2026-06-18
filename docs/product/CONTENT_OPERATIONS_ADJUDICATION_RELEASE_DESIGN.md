# Content Operations, Adjudication, and Release Design

**Status:** Proposed for Product Owner, Learning Quality, operations,
accessibility, security, privacy, and rights review
**Related Task:** `UX-005`
**Owner:** Product Owner with Learning Quality Owner and Technical Owner
**Last Updated:** 2026-06-15

## 1. Purpose

This document defines the proposed internal experience for qualifying and
assigning reviewers, monitoring calibration, adjudicating disagreements,
verifying release gates, publishing immutable manifests, rolling back releases,
and coordinating quality incidents.

UX-002 remains the independent question-and-answer review carousel. UX-003
remains the authoring and revision workbench. UX-005 governs who may perform
those activities, resolves escalated evidence, and controls the path from
approved candidate versions to an active exam-pack release.

No interface action substitutes for required evidence or server enforcement.

## 2. Experience Principles

1. Show authority and scope before showing an action.
2. Keep qualification, entitlement, assignment, and decision separate.
3. Enforce conflicts and independence before work enters a queue.
4. Preserve blind reviews until the independent stage is locked.
5. Adjudicate evidence; do not overwrite prior decisions.
6. Make every release blocker inspectable and attributable.
7. Publish manifests atomically and preserve the prior active pointer.
8. Treat rollback as a controlled release action, not an undo button.
9. Open incidents from evidence and track containment through closure.
10. Use dashboards to direct attention, not to replace expert judgment.

## 3. Roles and Information Architecture

Primary roles:

- Learning Quality Owner;
- Validator Program Manager;
- Lead Teaching Validator;
- Lead Grading Validator;
- Release Approver;
- Rights Reviewer or Source Steward;
- Incident Commander;
- System Administrator with no educational approval authority.

Primary areas:

| Area | Purpose |
| --- | --- |
| Operations home | Queue health, blockers, expiring qualifications, releases, incidents |
| People and qualifications | Evidence, scope, renewal, calibration, suspension |
| Assignments | Conflict-aware workload creation and reassignment |
| Calibration | Qualification sets, drift checks, remediation, audit |
| Adjudication | Resolve locked teaching or grading disagreements |
| Release candidates | Inspect gate matrix and immutable manifest |
| Releases | Publish, monitor, compare, and roll back |
| Incidents | Triage, contain, investigate, correct, and close |
| Audit | Search protected decisions and administrative changes |

The interface must hide controls the active role is not entitled to use.
Disabled controls still explain the missing role, scope, evidence, or approval.

## 4. Operations Home

The home surface prioritizes exceptions and aging work:

- unfilled assignments;
- approaching due dates and queue-age breaches;
- calibration due or failed;
- qualifications and entitlements nearing expiration;
- adjudications awaiting a lead;
- release candidates with blocking gates;
- heightened-monitoring releases;
- open incidents by severity;
- source or rights records near expiration.

Counts link to filtered work. Red or amber status never stands alone without
text. Metrics are operational signals, not educational acceptance decisions.

## 5. Qualification and Entitlement

### 5.1 Qualification Record

Show:

- person and verified identity;
- qualification type;
- exam, school year, taxonomy, artifact, and environment scope;
- required evidence and training;
- qualification-set result;
- effective and expiration dates;
- calibration history;
- active, pending, suspended, expired, or revoked status;
- grant, renewal, exception, suspension, and remediation history.

Qualification does not itself provide access. An entitlement separately grants
actions such as view, annotate, score, adjudicate, approve, or release within a
bounded scope.

### 5.2 Grant and Renewal

The grant review presents each policy requirement as:

- passed with evidence;
- missing;
- exception requested;
- failed;
- not applicable.

The approving user sees a consequence preview before confirmation. Exceptions
require an approved policy path, rationale, expiration, and additional
authority. The prototype must not imply that administrators can self-grant
validator or release authority.

### 5.3 Suspension

Suspension immediately:

- prevents new assignments;
- disables dependent entitlements;
- identifies open work requiring reassignment;
- records the trigger and effective time;
- creates a remediation or revocation path.

Suspension does not delete completed decisions.

## 6. Assignment Operations

Assignment creation starts from required qualification and independence rules,
not from a free-form person picker.

The matching view shows:

- eligible reviewers;
- exact qualification and entitlement match;
- current workload and due dates;
- recent calibration status;
- prior authorship, editing, collaboration, family, gold-answer, or commercial
  conflicts;
- same-reviewer reuse and independence warnings;
- availability and optional compensation context.

Actions:

- assign;
- assign a balanced batch;
- replace a recused or suspended reviewer;
- extend due date;
- cancel;
- escalate an unfillable assignment.

The system blocks conflicted and out-of-scope reviewers. A manual override is
not available for mandatory independence.

## 7. Calibration Operations

Calibration surfaces:

- qualification and interim calibration sets;
- hidden key or locked adjudicated result;
- criterion and total-score agreement;
- severe-error review;
- teaching blocker outcomes;
- trend by archetype and criterion;
- expiring calibration;
- remediation assignments;
- suspension trigger status.

Independent calibration decisions remain blind until submission. A lead may
inspect disagreements only after the applicable pass is locked.

Calibration outcomes:

- passed;
- passed with monitored scope;
- remediation required;
- suspended pending requalification;
- qualification renewal recommended;
- evidence insufficient.

Metrics support the decision but do not silently grant or suspend authority.

## 8. Adjudication Workbench

An adjudication case includes:

- artifact, response, rubric, source, and version context;
- two or more locked independent decisions;
- exact disagreement by criterion or checklist item;
- cited evidence and reviewer rationales;
- applicable policy and qualification scope;
- conflict check for the adjudicator;
- downstream impact if the rubric or artifact is defective.

The lead adjudicator may:

- select the supported decision and explain why;
- record a new adjudicated outcome;
- mark the evidence insufficient;
- reopen the rubric or artifact;
- send the item to UX-003 for revision;
- create a calibration finding;
- escalate rights, privacy, scientific, or policy questions.

The adjudicated result is a new immutable record. Prior decisions remain
visible. A rubric defect invalidates affected cases instead of forcing a gold
label.

## 9. Release Candidate Workspace

Each candidate shows:

- release class and required authority;
- immutable manifest ID and semantic version;
- predecessor manifest;
- included artifact and policy versions;
- source and rights freshness;
- teaching and grading gate results;
- accessibility and security evidence;
- dependency and checksum checks;
- unresolved findings and approved exceptions;
- validation and production-like smoke-test results;
- rollback target and monitoring plan.

The gate matrix uses four states:

- `Passed`
- `Blocked`
- `Not applicable`
- `Awaiting evidence`

A missing decision, tie, expired source, invalid checksum, or prohibited rights
state can never display as passed.

## 10. Manifest Comparison and Publication

Manifest comparison groups changes by:

- questions and rubrics;
- teaching and feedback artifacts;
- grading policies or model configuration;
- sources and rights;
- taxonomy and exam specification;
- accessibility representation;
- removed, suspended, replaced, and newly active versions.

High-impact changes identify their revalidation class and evidence.

Publication confirmation requires:

1. frozen manifest and checksum verification;
2. all required gates passed;
3. authority and separation-of-duties check;
4. successful validation smoke tests;
5. explicit rollback target;
6. monitoring-owner acknowledgement;
7. typed manifest identifier or equivalent deliberate confirmation.

The success state says the active pointer changed atomically. It does not imply
that individual artifacts were mutated.

## 11. Rollback

Rollback is available from an active release or incident. Show:

- current active manifest;
- proposed prior approved manifest;
- affected exams, routes, graders, and learners;
- evidence and incident link;
- whether learner submissions require regrading;
- communications and monitoring actions;
- authorized executor.

Emergency rollback may be executed by the Incident Commander within policy and
immediately notifies the Product Owner. Other rollbacks follow the applicable
release authority. Partial manifest rollback is prohibited.

## 12. Incident Operations

Incident severities and exact response targets follow the approved governance
policy. The incident workspace includes:

- severity, status, commander, opened time, and trigger;
- affected manifest, artifact, source, grader, or learner scope;
- evidence timeline;
- containment checklist;
- rollback or suspension decision;
- rights, privacy, security, learning, and communications participants;
- correction and revalidation tasks;
- learner-impact and regrading assessment;
- closure criteria and post-incident review.

State progression:

```text
open
triaged
contained
correcting
revalidating
monitoring
closed
```

An incident can suspend affected versions without deleting evidence. Closure
requires containment, correction disposition, required revalidation, and
recorded follow-up owners.

## 13. Integration Boundaries

- UX-002 supplies immutable review decisions and difficulty discussions.
- UX-003 receives revision tasks and creates successor versions.
- UX-006 supplies disputes, low-confidence grading escalations, and regrading
  outcomes.
- UX-007 displays learner-facing consequences only after approved state
  updates.
- UX-008 supplies capture-quality and graph-review states while research-gated.

UX-005 does not expose protected holdout content to authors or unauthorized
operators.

## 14. Accessibility, Security, and Audit

- Full keyboard operation and visible focus.
- Tables provide responsive card or summary alternatives.
- Status, severity, diff, and gate meaning are not color-only.
- Protected evidence has clear access notices and no bulk reveal by default.
- Reauthentication is required for production-sensitive grants, publication,
  rollback, protected exports, and entitlement changes.
- Every grant, assignment, recusal, decision, adjudication, release, rollback,
  incident, export, and override is auditable.
- Optimistic UI never presents an unconfirmed authority change as complete.

## 15. Lovable Scope

The Lovable render should demonstrate, using frontend-only fixtures:

- operations dashboard;
- qualification review and suspension consequence preview;
- conflict-aware assignment;
- calibration result and remediation;
- criterion-level adjudication;
- blocked and ready release candidates;
- immutable manifest comparison;
- publication confirmation;
- rollback from an incident;
- incident timeline and closure checklist.

All consequential actions are simulations. No production records, secrets,
protected holdouts, or release operations are used.

## 16. Open Review Questions

- Which operations roles may view reviewer identity during blinded stages?
- Which qualification exceptions are permitted for the first launch?
- What queue-age targets trigger staffing escalation?
- Which release classes require dual approval in addition to policy minimums?
- What reauthentication and second-person confirmation apply to rollback?
- How are learner communications initiated without exposing private evidence?
- Which incident details may appear in a future public status surface?

