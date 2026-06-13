# TASK-0009 — Schema and Governance Reconciliation

**Task ID:** TASK-0009
**Title:** Reconcile Content Schema Proposals with Approved Governance
**Owner:** Technical Owner / Main Conductor
**Product Owner:** David Bloom
**Status:** Proposed
**Priority:** High
**Created Date:** 2026-06-13
**Approved Date:** Pending

## Product Goal

Translate the approved logical governance contracts into a coherent conceptual
data model before any physical Supabase or Postgres design is proposed.

## Technical Scope

- Inventory useful entities and relationships from the rejected v1.2 and v1.3
  schema proposals.
- Map every proposed field to the canonical logical governance records.
- Replace mutable question rows with stable artifact identities and immutable
  artifact versions.
- Replace approval booleans with append-only review decisions, adjudication,
  lifecycle events, and release-manifest evidence.
- Separate authoritative events from rebuildable projections such as current
  status, use count, empirical difficulty, and queue state.
- Model reusable immutable stimulus packages, datasets, visual components, and
  accessible representations.
- Model multiple parallel taxonomy schemes by subject and exam pack.
- Preserve source, rights, dependency, calibration, release, rollback,
  retention, and audit requirements.
- Produce a gap and contradiction report before physical DDL begins.

## Out of Scope

- Executing DDL or migrations.
- Selecting indexes, triggers, Supabase functions, or RLS implementation.
- Importing the stale schema files as canonical documents.
- Weakening immutability, reviewer independence, or atomic release for
  implementation convenience.

## Acceptance Criteria

- [ ] Entity-to-governance mapping is complete.
- [ ] Every learner-visible content payload is immutable and versioned.
- [ ] Reviews and state transitions are append-only.
- [ ] Current-state and count fields are identified as projections rather than
  authoritative mutable evidence.
- [ ] Stimulus packages support ordered text, datasets, visuals, assets, and
  accessibility alternatives.
- [ ] Taxonomy design supports multiple schemes per subject and exam year.
- [ ] Deletion, retirement, withdrawal, and rollback semantics are explicit.
- [ ] Atomic exam-pack manifest resolution is represented.
- [ ] Security, privacy, retention, and RLS requirements are handed off to the
  physical-design task.
- [ ] Product Owner approves the conceptual model before physical DDL.

## QA Plan

- Walk through authoring, revision, review, adjudication, publication, learner
  use, suspension, retirement, source withdrawal, and rollback scenarios.
- Confirm historical evidence remains reconstructable after every scenario.
- Confirm no mutable boolean can independently authorize publication.
- Confirm no cascade deletion can erase required audit evidence.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate
**Decision:** Pending

## Done Decision

**Decision:** Pending
**Date:** Pending
