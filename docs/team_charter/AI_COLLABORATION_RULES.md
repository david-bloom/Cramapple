# Cramapple AI Collaboration Rules

**Status:** Approved
**Owner / Product Owner:** David Bloom
**Canonical Folder:** `docs/team_charter/`

## Purpose

This document defines how humans and AI agents collaborate on Cramapple.

GitHub documentation is the source of truth. Chat is useful for discussion, but durable project state must be written into GitHub.

## Roles

### Product Owner / Final Approver

David Bloom holds this role.

Owns:

- Product direction.
- Scope decisions.
- Priority decisions.
- Task approval.
- Risk acceptance.
- Done decisions.
- Launch/deployment decisions unless delegated.

### Functional Co-Founders

- Orly Bloom owns learning, curriculum, teaching design, and expert-validation leadership.
- Micah Bloom owns marketing, brand, user acquisition, and go-to-market leadership.

Functional ownership does not replace Product Owner approval where a hard gate applies.

### Strategy Advisor

Owns:

- Working with David and the co-founders to develop plans.
- Challenging assumptions and identifying alternatives.
- Supporting market, product, operating, and business decisions.
- Recording recommendations, rationale, risks, and unresolved questions.

The Strategy Advisor is advisory. The role does not independently approve scope, implementation, spending, risk acceptance, Done decisions, or launch.

### Main Conductor

Owns:

- Source-of-truth orientation.
- Approval boundaries.
- Agent coordination.
- Final QA verdicts.
- GitHub publishing.

### Implementation Agent

Owns:

- Execution against approved scope.
- Implementation notes.
- Test results.
- Deviation reports.
- Remediation.

### QA Agent

Owns:

- Proposed findings.
- Evidence review.
- Blocking/non-blocking risk separation.
- Proposed verdict only.

The QA Agent must not approve, close, publish final decisions, deploy, migrate, or mark tasks passed as final.

## Source-of-Truth Rule

If it is not written in GitHub, it does not exist for operating purposes.

Every project document retained in the local workspace must also be committed
and pushed to `david-bloom/Cramapple`. A document change is not durably complete
while it exists only on one machine.

Agents must:

- include new and modified project documents in the relevant Git commit;
- push the commit to GitHub before reporting synchronization complete;
- verify the remote branch contains the commit;
- report any local document that could not be pushed;
- exclude temporary renders, caches, editor files, and operating-system
  metadata unless they are intentional project artifacts.

Relevant records may include:

- Task files.
- Issues.
- PRs.
- Activity logs.
- Approval logs.
- Decision logs.
- Architecture docs.
- Feature docs.
- QA notes.

## Universal Document Format Rule

Markdown (`.md`) is the default and canonical medium for project documents.
Agents should create and maintain durable plans, requirements, policies,
architecture, teaching documents, decisions, logs, and task records as Markdown
in GitHub unless a different format is required by the artifact itself.

Google Docs is the preferred secondary format when live human collaboration,
comments, suggestion mode, or a cloud backup copy is useful. A Google Doc is not
the project source of truth. Accepted changes must be incorporated into the
canonical Markdown file and committed to GitHub. When practical, the Google Doc
should identify or link to its canonical Markdown source.

Word (`.docx`) should be avoided unless a specific external recipient,
submission requirement, printing need, or layout-fidelity requirement makes it
necessary. When a Word document is necessary:

- derive it from the canonical Markdown or another canonical structured source;
- do not maintain it as an independent competing source;
- state which Markdown file governs if the versions differ; and
- regenerate it only when the specific Word deliverable must be updated.

Existing Word snapshots may remain for historical reference or an active
external need, but agents must not create or refresh them by default.

## Optional Manual Sync Handshake

Projects may define a short manual trigger that tells an agent to re-sync from the source of truth before continuing.

Recommended example:

```text
C / c
```

When the owner sends the configured trigger, the agent should:

- Re-read current GitHub source-of-truth docs, task files, issues, and activity/approval logs relevant to the active work.
- Report current task or issue state, approval state, blockers, and next recommended action.
- Produce or refresh a handoff packet when execution, QA, frontend handoff, or side-agent coordination is next.
- Treat the trigger as a sync/review instruction only.

The manual sync handshake does not authorize implementation, deployment, migration, secret changes, task closure, QA pass decisions, Done decisions, risk acceptance, or production launch. Those actions still require the normal approval path.

## Startup Rule

At session start, agents should read relevant current GitHub docs before execution.

If the task is unclear or broad, orient from:

```text
docs/team_charter/
docs/tasks/
docs/activity_log/
docs/prd/ or product docs, if present
docs/architecture/, if present
docs/features/, if present
docs/flows/, if present
```
