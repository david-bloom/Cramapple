# Cramapple Task Workflow

**Status:** Approved
**Owner / Product Owner:** David Bloom

## Standard Task Flow

1. David, a functional co-founder, or the Strategy Advisor identifies a need or decision.
2. Main conductor writes or updates task spec.
3. David approves task scope when required.
4. Implementation agent executes approved scope.
5. Implementation agent documents result.
6. QA agent or conductor performs review.
7. Implementation agent remediates if needed.
8. David reviews when required.
9. Task closes only after Done criteria are satisfied.

## Required Task Metadata

```text
Task ID:
Title:
Owner:
Status:
Priority:
Created Date:
Approved Date:
Product Goal:
Technical Scope:
Out of Scope:
Routes / Components / Systems Affected:
Data / Security / Integration Impact:
Acceptance Criteria:
QA Plan:
Implementation Summary:
Test Results:
Risks / Issues:
Approval State:
QA Result:
Done Decision:
```

## Status Values

Use one clear status at all times:

```text
Not Started
Spec Drafted
Awaiting Approval
Approved for Execution
In Progress
Blocked
Ready for QA
QA Blocked
QA Passed
Ready for Owner Review
Done
Do Not Do
```

## Approval Classes

### Standing Approval

Low-risk recurring work pre-approved in `STANDING_APPROVAL_LANES.md`.

### Batch Approval

A bounded package approved by the owner with clear approved/not-approved scope.

### Hard Gate

Requires explicit owner approval before proceeding.
