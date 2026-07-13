# TASK-0009 — Schema and Governance Reconciliation

**Task ID:** TASK-0009
**Title:** Reconcile Content Schema Proposals with Approved Governance
**Owner:** Technical Owner / Main Conductor
**Product Owner:** David Bloom
**Status:** In Progress
**Priority:** High
**Created Date:** 2026-06-13
**Approved Date:** 2026-07-13 (scope only; `DECISION-0038`). The conceptual model + gap report return for the final Hard-Gate approval before any physical DDL.
**Related:** `TASK-0017` (approved v1 consumer constraints; does not supersede this task)

## Product Goal

Translate the approved logical governance contracts into a coherent conceptual
data model before any physical Supabase or Postgres design is proposed.

## Technical Scope

- Inventory useful entities and relationships from the rejected v1.2 and v1.3
  schema proposals.
- Map every proposed field to the canonical logical governance records.
- Map the "stable identity + immutable version" concept directly onto the
  existing `content_items` (stable identity) and `content_item_versions`
  (immutable, numbered version) records. `content_item_versions.id` is the v1
  canonical version identifier per `DECISION-0037`/`TASK-0017`.
- Produce an explicit compatibility/migration decision for the legacy
  `artifact_versions` model and `artifact_version_ids` references. This work
  must not resurrect `artifact_versions` as a parallel canonical record.
- Replace approval booleans with append-only review decisions, adjudication,
  lifecycle events, and release-manifest evidence.
- Separate authoritative events from rebuildable projections such as current
  status, use count, empirical difficulty, and queue state.
- Model reusable immutable stimulus packages, datasets, visual components, and
  accessible representations.
- Model multiple parallel taxonomy schemes per `exam_pack_version`, preserving
  historical schemes and allowing an annual revision to coexist with its prior
  exam pack.
- Preserve source, rights, dependency, calibration, release, rollback,
  retention, and audit requirements.
- Produce a gap and contradiction report before physical DDL begins.

## Authority Boundary with TASK-0017

`TASK-0017` does not supersede this task. TASK-0017 defines approved v1 consumer and onboarding constraints, including `content_item_versions.id` as the current canonical serving/review/grading identifier, deprecation of the misleading `artifact_version_ids` manifest name, a typed validation-suite registry, and an immutable content-clearance-exception record. TASK-0009 retains conceptual schema and governance authority and must ratify, reconcile, and incorporate those constraints into the coherent model before related physical DDL is approved.

If TASK-0009 identifies a conflict, it must return an explicit compatibility/migration decision to TASK-0017 rather than creating a second canonical record or silently diverging.

## Fast-Track Deliverables for TASK-0017

These two bounded conceptual slices are sequenced ahead of the broader model so
the AP Statistics August staging path is not blocked by unrelated TASK-0009
work:

1. **Immutable item-package and archetype identity:** map SubjectPackage/
   ItemPackage identity, versioning, archetype references, structured parts,
   criteria, stimuli, and canonical `content_item_versions.id` persistence
   targets without introducing a parallel artifact-version identity.
2. **Multi-scheme taxonomy per exam-pack version:** define scheme identity,
   immutable scheme versions, nodes and relationships, content-version
   assignments, coexistence with the prior nine-unit AP Statistics pack, and
   supersession/retirement semantics.

Each slice must include its entity/relationship model, compatibility mapping,
open gaps, and explicit handoff constraints for TASK-0017 H1/H2. Acceptance of
these slices permits a separate physical-design proposal for those slices only;
it does not approve DDL or waive the final TASK-0009 Hard Gate.

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
- [x] Taxonomy design supports multiple schemes per `exam_pack_version` while
  preserving historical exam-pack/taxonomy resolution.
- [x] The fast-track immutable item-package/archetype slice is delivered with
  an explicit TASK-0017 H1 handoff.
- [x] The fast-track multi-scheme taxonomy-per-`exam_pack_version` slice is
  delivered with an explicit TASK-0017 H2 handoff.
- [ ] Deletion, retirement, withdrawal, and rollback semantics are explicit.
- [ ] Atomic exam-pack manifest resolution is represented.
- [ ] Security, privacy, retention, and RLS requirements are handed off to the
  physical-design task.
- [x] The `content_item_versions` ⇄ `artifact_versions` identity question is
  resolved with an explicit compatibility/migration decision (Condition 1), not
  a second canonical record.
- [ ] Product Owner approves the conceptual model before physical DDL.

## QA Plan

- Walk through authoring, revision, review, adjudication, publication, learner
  use, suspension, retirement, source withdrawal, and rollback scenarios.
- Confirm historical evidence remains reconstructable after every scenario.
- Confirm no mutable boolean can independently authorize publication.
- Confirm no cascade deletion can erase required audit evidence.

## Approval Conditions (2026-07-13, `DECISION-0038`)

Scope/approach approved to proceed. Two conditions bind the deliverable:

1. **Canonical-identity reconciliation is directional and explicit.** The "stable
   identity + immutable version" concept must map onto the existing
   `content_items` / `content_item_versions` records (the v1 canonical choice in
   `DECISION-0037`/`TASK-0017`). The model must NOT re-legitimize `artifact_versions`
   (0 rows in Production) as a parallel canonical record; if a conflict is found,
   return an explicit compatibility/migration decision to TASK-0017.
2. **Fast-track the two slices the AP Statistics rebuild depends on.** Because
   this task gates TASK-0017's related DDL, carve out and prioritize (a) the
   immutable item-package / archetype identity and (b) multi-scheme taxonomy per
   `exam_pack_version` — the two things `TASK-0017` H1/H2 need to stage AP Stats
   Q1–Q4 — so the broader conceptual-model work does not become the long-pole
   blocker on the August rebuild.

This approves the **scope only**. The conceptual model + gap report return for the
final Hard-Gate approval before any physical DDL.

## Fast-Track Implementation Summary

The two DECISION-0038 fast-track conceptual slices and M0 compatibility/gap
inventory are delivered in
`docs/architecture/TASK0009_M0_FAST_TRACK_CONCEPTUAL_MODEL_2026_07_13.md`.
They map ItemPackage/archetype identity directly to
`content_items`/`content_item_versions`, prohibit new question writes to
`artifact_versions`, and define versioned taxonomy schemes and assignments per
exact `exam_pack_version`/`content_item_version`. Each slice includes an explicit
TASK-0017 H1/H2 handoff and physical-design blockers.

No DDL was authored or applied. The broader TASK-0009 conceptual model remains
open after review of these fast-track slices.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate
**Decision:** Scope approved with conditions — 2026-07-13, David Bloom (`DECISION-0038`). Fast-track slice ratification: Pending Product Owner review. No physical DDL approved.

## Done Decision

**Decision:** Pending
**Date:** Pending
