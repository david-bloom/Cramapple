# TASK-0067 — Unit Reference Content: Formulas, Vocabulary, Lists, and Diagrams (Companion to Memory Hooks)

**Status:** PROPOSED, 2026-10-08. Not approved. Drafted because `TASK-0066` cannot run without it.
**Tier:** Standard for schema design, Development apply, and authoring in Development; **Hard-Gate** for the Production migration, Production publish, and Lovable publish.
**Owner:** Claude session (proposed). **Product Owner:** David Bloom.
**Branch / PR:** none.
**Source:** David, 2026-10-08: "Task 0066 only works if we have the formula, diagrams, lists, etc to accompany them."
**Related:** `TASK-0066` (memory hooks), `TASK-0054` (reference content on the taxonomy), `TASK-0006` (visual stimulus and rendering), `TASK-0021` (Biology prompt visuals), `TOPIC_BRIEFS_AND_LEARN_MORE_PRODUCTION_PROTOCOL.md` (unit reference, Phase 0), `COURSE_HOMEWORK_CONSOLIDATION_PLAN.md` §3 (skill scaffolds), `docs/new_design/CONTENT_AND_PEDAGOGY.md` (reference materials: topic, skills, vocabulary).

## Why this exists

A memory hook is a device for recalling a thing. Checked on 2026-10-08, the things do not exist as
student content:

| Companion content | What exists today | Where |
| --- | --- | --- |
| Formulas | No structured store. Formulas appear inline in explainer prose and in the 1.7 pilot HTML. The only `formula` column in the schema is on `app.provenance_claims`, which is not student content. The parsed 1.7 pilot packet does carry a `factPack.formulas` list, derived locally from the fact pack. | `supabase/migrations`, `AP_STATS_1_7_DEEP_DIVE_PARSED_PILOT.json` |
| Vocabulary | No store. "Key vocabulary" is proposed in the skill-scaffold package (§3) and the design doc names "vocabulary" as the third reference-pane section, but nothing structured feeds it. | §3; `CONTENT_AND_PEDAGOGY.md` line 35 |
| Lists and sequences | None as content. A hook's `expands_to` would carry the list itself, so pure list hooks are self-contained, but the list is then owned by the hook rather than by the reference. | — |
| Diagrams | Item-level only: `stimulus_image_path` on content items (prompt visuals). `TASK-0006` (visual stimulus system) is Ready for Owner Review; `TASK-0021` built 7 of 8 Biology prompt visuals, reviewer-visible, student delivery not started. No topic- or unit-level diagram library. | `TASK-0006`, `TASK-0021` |
| Unit reference surface | Scoped in the protocol ("shared formulas, vocabulary, representation guidance, cross-topic traps, and unit notes"); the 1.7 pilot page says it "is the next Phase 1 surface". Not built. | protocol; pilot HTML |

So `TASK-0066` as approved would attach hooks to nothing. The dependency has to be built first,
or at least together.

## Product goal

Give every unit a structured, reviewed reference: the formulas, vocabulary, lists and sequences,
sign and direction conventions, and CED-required diagrams a student may look up, owned by the
topic that introduces them and rolled up to the unit. The Deep Dive, the unit reference page,
and the Open Hand reference pane all read from it. Memory hooks attach to its entries.

## Proposed shape

`app.unit_reference_entries`

```
reference_entry_id  uuid pk
subject_key         text      -- same checks as topic_explainers
unit_number         integer
owner_topic_code    text      -- where the student first needs it
topic_codes         text[]    -- includes owner; later topics that reuse it
kind                text      -- formula | vocabulary | list_sequence | convention | diagram
title               text      -- "Sample standard deviation", "Five-number summary"
body                text      -- LaTeX for formula; definition for vocabulary; one line for convention
items               jsonb     -- ordered [{"label","meaning"}] for list_sequence and diagram parts
visual_asset_ref    text null -- diagram only; an existing visual-stimulus asset (TASK-0006 lane)
caution             text null -- CED-language note where the reference wording is not the answer wording
status, source_note, published_at, created_at, updated_at
```

- Keyed exactly as `topic_explainers` until `TASK-0054` settles the taxonomy FK; convert together.
- Public view in the same migration; `get_topic_point_guides` returns `reference[]` for a topic and a
  unit variant returns the whole unit, grouped by `kind` then owner topic.
- **Memory hooks attach here.** Proposed amendment to `TASK-0066` D3: `app.topic_memory_hooks`
  gains `reference_entry_id` (required) and drops its own `topic_codes[]`, inheriting scope from
  the entry. A hook with nothing to point at cannot exist.

## Authoring

- First pass is **extraction, not authoring**: formulas and vocabulary from the approved CED fact
  packs, which already list them per topic (the 1.7 parsed packet shows the shape). Provenance per
  row (`source_note` = fact pack, pack version, extraction date), per the protocol's Phase 0 rules.
- Second pass applies protocol v0.6 §0 checks: two checker families verify each entry against the
  CED PDF, the owner topic, and the inclusion rule (CED-required, not textbook completeness).
- Diagrams: only through `TASK-0006`'s governed-diagram lane; no new rendering. If an entry's
  diagram cannot be rendered yet, the entry ships with `items` (the labelled parts) as text.
- Pilot: AP Statistics Unit 1 and AP Chemistry Unit 4, the same units as the hooks pilot, so one
  review covers both.

## Out of scope

Representation guidance and cross-topic traps (keep in the Deep Dive prose for now); student
notes; any change to `topic_explainers` fields; a diagram-rendering system (that is `TASK-0006`).

## Acceptance criteria

- Development: migration applied, zero-orphan QA passes, RPC returns `reference[]` for a pilot
  topic and the unit list for Unit 1 / Unit 4.
- Every pilot entry has fact-pack provenance and two checker passes recorded.
- Lovable preview: Unit reference page and Deep Dive read from the RPC for one Statistics and one
  Chemistry topic; the Open Hand reference pane's vocabulary section is populated from it.
- `TASK-0066` hooks attach to entries and render beside them.

## Decisions needed (Product Owner)

| # | Decision | Recommendation |
| --- | --- | --- |
| R1 | Open this task and sequence it before `TASK-0066` Phase A (or run both Phase As in one migration) | Yes; one migration, two tables, hooks FK to entries. |
| R2 | Amend `TASK-0066` D3 so hooks require a `reference_entry_id` | Yes. |
| R3 | Extraction-first from fact packs with v0.6 checks, rather than fresh authoring | Yes. |
| R4 | Diagram entries ship text-only until `TASK-0006` renders them | Yes. |
