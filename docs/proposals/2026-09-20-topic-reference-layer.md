# Topic Reference Layer — Vocabulary, Equations, and Visuals

**Status:** Draft — for review (nothing here is approved)
**Date:** 2026-09-20
**Author:** Strategy Advisor (with Product Owner)
**Product Owner:** David Bloom
**Curricular Owner:** Orly Bloom (correctness, scope, teaching value)
**Launch relevance:** Supporting — the reference rack rounds out a subject's
student-facing surface alongside practice, feedback, and canonical answers.

## Purpose of this document

This is an **exploration of existing capabilities and gaps**, plus the **plan**
for closing them. It documents the *need and shape* of the vocabulary-generation
prompt; it does **not** generate any vocabulary. Generating the reference content
from a quality, grounded prompt is a planned build step (see "The plan"), not
work done here.

## The need

Each topic needs a **reference rack**: the relevant equations, diagrams/graphs,
and vocabulary a student should have at hand — surfaced per topic, not as a dump
of every term or formula mentioned in a unit. The bar is *curated and
authoritative*, not *comprehensive*.

## What already exists (reuse this)

Exploration of the Supabase schema found more of the backbone already built than
expected. Reuse it rather than duplicating:

- **Topic/skill taxonomy — solid.** `app.taxonomy_units`, `taxonomy_topics`,
  `taxonomy_skills` (AP science practices), and `taxonomy_cells` (the topic×skill
  join), versioned under `taxonomy_source_versions`; items attach via
  `content_taxonomy_labels`. This is the spine the reference rack hangs off.
- **Topic-level teaching prose — solid.** `app.topic_point_briefs` and
  `app.topic_explainers` are keyed to `(subject_key, topic_code)`, published-
  gated, RLS'd, and already hold structured per-topic content (core idea, how
  points are earned, answer move, common point loss, worked weak-vs-full example).
  These are the proven pattern to mirror.
- **Visuals — storage and delivery solved, at item scope.**
  `app.content_asset_metadata` (Supabase Storage bucket + path, `alt_text`,
  `long_description`, approval-gated student visibility) plus
  `content_item_versions.stimulus_image_path`, the `artifact_versions` types
  `stimulus`/`asset`, and the Visual Stimulus & Rendering system.
- **CED fact packs — the authoritative source.** `docs/product/AP_*_CED_FACT_PACK.md`
  carry, per topic, the College Board's Learning Objectives (LO) and Essential
  Knowledge (EK) statements. This is where curated vocabulary and formulas already
  live in authoritative form.

## The gaps

1. **No structured store for vocabulary.** No glossary/term table exists; vocab is
   embedded in brief/explainer prose today.
2. **No structured store for equations.** The only `formula` column lives on
   `provenance_claims` (a grading-derivation field, not a reference library).
   Equations are embedded in prose.
3. **Visuals are item-scoped, not topic-scoped.** `content_asset_metadata` is keyed
   to a `content_item_version_id` — a diagram belongs to one question. There is no
   way to maintain "the diagram for this topic" and reuse it across items without
   re-uploading. This scoping gap matters more than the two missing tables.

## Scoping decision: topic, not topic×skill

Vocabulary (and equations) should be **topic-scoped**, matching how
`topic_point_briefs`/`topic_explainers` are keyed — not scoped to the topic×skill
cell. Reason: the CED prints Essential Knowledge per *topic*, so the authoritative
source is already topic-grained. Adding a skill dimension to vocab would invent
structure the source does not support and multiply maintenance for no gain. Drop
the topic×skill idea for the reference rack.

## The source: CED Essential Knowledge, not model memory

The relevant vocabulary for a topic is the set of terms **named inside that
topic's EK statements** in the fact pack. Because EK is the College Board's own
"essential knowledge," the set is inherently curated (~5–12 terms per topic) and
each term arrives with a one-line, CED-grounded definition. Example — AP Biology
topic 1.1 (Structure of Water) yields: polarity, hydrogen bonding, cohesion,
adhesion, surface tension, specific heat capacity, heat of vaporization — each
already defined in its EK line.

### Why grounding is non-negotiable (the cautionary result)

A quick ungrounded experiment (asking a general model for "AP Stats 1.8
vocabulary") returned a fluent, well-organized list — **for the wrong topic.** In
the current 2027 CED, topic 1.8 is *Graphical Representations of Summary
Statistics* (five-number summary, boxplots, skew); the model answered with
*linear regression* content (LSRL, correlation, residuals) that lives in Unit 5 of
this CED, using a pre-redesign course layout from its training data. It also
asserted a hand-computation slope formula as "on the AP Formula Sheet," which this
CED explicitly does not provide (technology-computed only).

The failure mode is the dangerous one: **fluent, every-term-real, confidently
scoped to the wrong curriculum** — output that survives casual review. The fix is
not a cleverer prompt alone; it is **grounding the prompt in the topic's actual EK
block from the versioned fact pack**, turning the task from "recall from memory"
into "extract and define from this authoritative source." That also makes every
term auditable back to an EK code and a CED version.

## The plan

Closing the vocabulary and equation gaps is a **grounded generation + independent
validation** job — the same draft-then-validate architecture proposed for
canonical answers, and exactly the "one AI drafts, another validates" pattern.

1. **Generate (grounded draft).** For each topic, feed the model that topic's
   LO/EK block from the fact pack and have it extract the key terms and any
   CED-sheet formulas, with a one-line definition per term. Grounded in the pack,
   not model memory. *(Prompt shape documented below; not run in this session.)*
2. **Validate (independent pass).** A second, independent pass confirms every term
   and formula traces to an EK statement in the pack, nothing out-of-scope slipped
   in (respect the pack's "beyond exam scope" exclusions), and the output meets the
   size/format spec.
3. **Human curation gate.** Curricular Owner confirms the shortlist per topic
   before publish — the model proposes, a human ratifies.
4. **Store and serve.** Persist to a small topic-scoped store that reuses the
   `topic_point_briefs` pattern and the taxonomy backbone (see "Storage").

## Prompt shape (to build, not run)

Documented here as a contract so the build has a target. The vocabulary itself is
generated later, from this shape.

**Generation prompt — input contract**
- The topic's identity: `subject_key`, `topic_code`, `topic_title`.
- **The topic's verbatim LO/EK block** from the corresponding
  `AP_*_CED_FACT_PACK.md`, including any inline "beyond exam scope" exclusions.
- The CED fact-pack version/date, carried through as provenance.

**Generation prompt — output contract (per topic)**
- A list of terms; for each term:
  - `term` — the concept name as the CED uses it.
  - `definition` — one line, grounded in the EK statement (no outside embellishment).
  - `source_ek` — the EK code(s) the term derives from.
  - `formula` — present **only** when the CED puts it on the formula sheet or states
    it; otherwise omitted (do not invent hand formulas).
- Shape illustration (defines structure, not a deliverable):
  `{ "term": "hydrogen bonding", "definition": "Attraction between water molecules that produces cohesion, adhesion, and surface tension.", "source_ek": "1.1.A.2", "formula": null }`

**Generation prompt — constraints**
- Terms must be **named or directly implied by the EK block**; do not import terms
  the CED does not carry for this topic.
- Respect exclusion statements as authoritative scope boundaries.
- **Right-size:** roughly 5–12 terms per topic; curated, not exhaustive. No
  unit-wide word dumps.
- No formula asserted as "on the formula sheet" unless the pack confirms it.

**Validation prompt — checks (independent model/human)**
- Every `term`/`formula` traces to a real EK in the pack for *this* topic and CED
  version.
- No out-of-scope or excluded content.
- Count and definition length within spec; definitions faithful to the EK, not
  drifted.
- Fail → escalate to the Curricular Owner, do not silently retry into existence.

## Storage (reuse-first)

Two moves, no parallel system:

1. **Vocabulary + equations:** a small topic-scoped table mirroring
   `app.topic_point_briefs` — keyed `(subject_key, topic_code)`, published-gated,
   same RLS and `service_role`/`authenticated` grants — or the same content carried
   as `artifact_type`s in the existing `app.artifact_versions` store (its type list
   already includes `exam_fact`, `explanation`, `asset`). Source-tag each row to the
   CED fact-pack version for traceability.
2. **Topic-scoped visuals:** generalize the asset link so an asset
   (`content_asset_metadata` or an `artifact_versions` `asset`) can attach to a
   **taxonomy node**, not only a `content_item_version_id`. One diagram, reused
   across every item on that topic — reusing the existing storage, alt-text, and
   approval machinery.

## What this needs from owners

- **Product Owner (David):** confirm the reference rack is topic-scoped, and
  confirm the reuse-first storage direction (mirror `topic_point_briefs` /
  generalize the asset link) before any schema work.
- **Curricular Owner (Orly):** own the per-topic curation gate — ratify each
  topic's vocabulary/equation shortlist and adjudicate validation failures.

## Scope guardrails

- **Exploration + plan only.** No vocabulary, equations, or images are generated
  in this session; generation from the grounded prompt is a later, planned step.
- **Additive, not a rebuild.** Reuse taxonomy, the `topic_point_briefs` pattern,
  and existing asset/Storage/RLS machinery. Prefer one small table or existing
  `artifact_versions` types over new subsystems.
- **Grounded or not at all.** No reference content is authored from model memory;
  the CED fact pack is the source of record, carried with its version.
- **Topic-scoped.** Not topic×skill.

## Open questions

1. **Equations coverage.** Some subjects (math, physics) lean heavily on formulas;
   others (biology) barely. Does the reference rack need a distinct equation
   treatment per subject, or does "formula field on a vocab/term row" suffice?
2. **Fact-pack freshness.** The packs are point-in-time extractions from the CED
   PDF (e.g., Biology re-extracted 2026-08-04). What re-verification cadence keeps
   the reference layer aligned when the College Board revises a CED?
3. **Cross-topic terms.** Some terms recur across topics (e.g., "residual" in AP
   Stats 5.3/5.4). One canonical definition reused, or per-topic phrasing?
4. **Visual sourcing.** Vocabulary and equations extract cleanly from text;
   diagrams do not. Are topic-scoped visuals authored, sourced under the existing
   rights workflow, or generated — and is that a separate track from this plan?
