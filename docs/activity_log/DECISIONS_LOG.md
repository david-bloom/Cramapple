# Decisions Log

This log records product, architecture, operating, security, design, and workflow decisions.

## Decision Format

```markdown
## DECISION-0000 — Decision Title

**Date:** YYYY-MM-DD
**Decision Owner:** David Bloom
**Status:** Proposed / Approved / Superseded
**Related Task:** TASK-0000 / N/A
**Area:** Product / Architecture / Security / Design / Operations / Integration

### Context

### Decision

### Rationale

### Consequences

### Risks / Follow-ups
```

## DECISION-0001 — Use GitHub as Cramapple's Durable Source of Truth

**Date:** 2026-06-09
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0001
**Area:** Operations

### Context

Cramapple planning has begun in chat and in speculative blueprint documents. Durable project state needs a consistent home and operating workflow.

### Decision

Use the AI Project Operating Kit and store canonical documents, tasks, approvals, decisions, and activity records in `david-bloom/Cramapple`.

### Rationale

This prevents chat-only decisions, establishes approval boundaries, and allows human and AI collaborators to reorient from the same records.

### Consequences

GitHub documents override unrecorded chat memory. Earlier `Blueprint_*` files remain speculative inputs unless promoted through an approved decision.

### Risks / Follow-ups

The operating workflow may need simplification after practical use.

## DECISION-0002 — Product and Strategy Authority

**Date:** 2026-06-09
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0001
**Area:** Operations

### Context

The project needs explicit authority for product decisions and a role for strategic planning.

### Decision

David Bloom is Product Owner and final approver. Add Strategy Advisor to work with David and the co-founders on plans and business decisions.

### Rationale

The team benefits from strong strategic challenge and planning support while preserving one clear final product authority.

### Consequences

The Strategy Advisor may recommend, draft, analyze, and challenge. The role may not independently approve product scope, execution, risk, Done decisions, or launch.

### Risks / Follow-ups

The named person or agent filling the Strategy Advisor role may vary and should be recorded when assigned.

## DECISION-0004 — High-Level Architecture Boundaries

**Date:** 2026-06-09
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0003
**Area:** Architecture

### Context

Cramapple needs a durable architecture before detailed teaching, grading, data, and implementation designs. Earlier root-level blueprints move too quickly into preliminary schemas and provider-specific model routing.

### Decision

Adopt a high-level architecture organized around managed presentation and application services, Supabase as the proposed durable system of record, replaceable task-specific AI providers, versioned canonical content, durable learner evidence, separate teaching and grading responsibilities, first-class validator operations, and event-based marketing interoperability.

### Rationale

This establishes stable ownership and trust boundaries before committing to detailed schemas or vendors. It supports grading and teaching quality, low-code maintainability, cross-session learning, and additional AP exams.

### Consequences

- Detailed teaching and grading designs will be separate canonical documents.
- Student attempts remain durable while mastery, recommendations, and progress are derived and rebuildable.
- Validators require scoped entitlements and version-specific approval workflows.
- Marketing integrations receive approved events rather than sensitive learning content.
- User-provided questions remain isolated from canonical content.
- Parent progress is a future paid entitlement with separate relationship, consent, billing, and visibility checks.

### Risks / Follow-ups

- Detailed data, security, teaching, grading, and integration designs remain open.
- Managed-service boundaries must be tested against latency, cost, privacy, and seasonal load.
- Legal review is required for minors, uploads, official materials, and parent access.
