# Cramapple Standing Approval Lanes

**Status:** Approved
**Owner / Product Owner:** David Bloom

## Purpose

Define which recurring work is pre-approved, which work can be batch-approved, and which work remains a hard gate.

## Lane 1: Standing Approvals

Approved without separate Product Owner review, provided no hard gate is triggered:

- Reading and syncing source-of-truth documents.
- Read-only market, product, pedagogy, technical, legal-issue, and competitive research.
- Drafting strategy recommendations, task specifications, handoff packets, prompts, plans, and review checklists.
- Documentation-only updates that accurately record an already approved decision.
- Read-only repository, tool, and service checks.
- Spawning read-only side agents.
- QA planning and non-destructive QA.
- Formatting and regenerating approved documents without changing their substance.

Standing approval does not authorize implementation, deployment, migration, spending, legal conclusions, QA pass decisions, task closure, risk acceptance, Done decisions, or launch.

## Lane 2: Batch Approvals

Use:

```text
Decision:
Scope:
Approved:
Not approved:
Applies to:
Expires / review trigger:
```

## Lane 3: Hard Gates

David's explicit approval is required before:

- Material product scope, priority, positioning, or pricing changes.
- Architecture decisions with material security, privacy, cost, or vendor-lock-in consequences.
- Implementation not already covered by an approved task.
- Database migrations or destructive data operations.
- Deployments, production configuration, environment variables, or secrets changes.
- Payment live-mode actions.
- Contracts, paid commitments, or material spending.
- Use or licensing of copyrighted content, official questions, or scoring materials.
- Student-data, parent-access, privacy-policy, age-gating, or legal-risk decisions.
- Public performance claims.
- Expert-quality gate acceptance.
- Risk acceptance.
- Production launch.
- Done decisions and closing tasks or issues as complete.

When classification is unclear, treat the action as a hard gate.
