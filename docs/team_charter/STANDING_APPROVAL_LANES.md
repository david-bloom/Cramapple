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
- Any `Micro`-tier task (see `AGENT_OPERATING_MODEL.md`, Task Tiers) — reversible, local, low blast radius.

Standing approval does not authorize implementation, deployment, migration, spending, legal conclusions, QA pass decisions, task closure, risk acceptance, Done decisions, or launch.

## Lane 2: Batch Approvals

Recorded in `docs/activity_log/APPROVALS_LOG.md` — there is no separate index; the per-entry record is the only authoritative list. Agents who need to know which batch approvals are currently in force grep the log for `Decision: Approved (Batch)` and evaluate the per-entry `Expires` and `Status` fields.

```text
## APPROVAL-NNNN — Batch Title

**Date:**
**Approved By:**
**Related Task:**
**Decision:** Approved (Batch)
**Applies To:**
**Expires / Review Trigger:**
**Status:** Active / Expired / Superseded

### Approved Scope
### Not Approved
### Notes
```

**Expiration semantics.** `Expires` is end-of-day inclusive in America/New_York. If today is after `Expires` but `Status` still reads `Active`, treat the approval as expired regardless of the recorded status — the date wins; flag the stale record in the next commit. `Status: Superseded` overrides date-based validity even before expiration. A named condition (e.g., "when TASK-0012 closes") may substitute for a date.

**Silence-is-consent SLA for `Standard`-tier approvals.** A `Standard`-tier item awaiting Product Owner sign-off default-approves after the window stated in its `Expires` field (24h unless the task states otherwise) if the Owner has not objected. This reuses the same `Expires`/`Status` machinery as any other batch approval — it is not a separate mechanism. Does not apply to `Hard-Gate`-tier items.

**Per-task citation.** A task invoking a batch approval (including an SLA default-approval) cites the `APPROVAL-NNNN` ID in its `Approval State` block.

## Lane 3: Hard Gates

David's explicit approval is required before, **or** clearance from the relevant Delegated Domain Approver (see `AI_COLLABORATION_RULES.md`, Functional Co-Founders) when the decision stays entirely inside their domain and does not touch money, legal, privacy, production, or a second domain:

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
- Material changes to `docs/team_charter/` documents — the operating model itself.

**Delegated domain-approver decisions** are recorded the same way as a batch approval, with `Decision: Approved (Domain)` and a `Decided By:` field naming the domain approver. Do not record a domain approval as plain `Approved`, which would obscure who actually made the call.

**Ambiguity does not automatically mean Hard Gate.** If classification is unclear:
- ambiguous, reversible, and low blast radius → ask one clarifying question and proceed under Standing Approval;
- ambiguous and irreversible, or high blast radius → treat as a Hard Gate.
