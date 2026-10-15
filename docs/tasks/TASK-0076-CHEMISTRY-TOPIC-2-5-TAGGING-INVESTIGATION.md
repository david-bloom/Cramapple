# TASK-0076 — AP Chemistry Topic 2.5 Tagging Investigation

> Number chosen as the next free `TASK-` id on `main` at 2026-10-15 (last is TASK-0075). Confirm it is still free before merging.

**Task ID:** TASK-0076
**Title:** Investigate AP Chemistry Topic 2.5 (Lewis Diagrams) question tagging
**Owner:** Codex investigation conductor; David Bloom for content rulings
**Product Owner:** David Bloom
**Tier:** Standard (investigation only). Any change to Production question metadata is Hard-Gate and needs its own approval.
**Status:** In Progress
**Priority:** Medium
**Created Date:** 2026-10-15
**Approved Date:** Pending

> October15 investigation findings: [priority audit and per-question CED ruling packet](../qa/MORE_HELP_TOPIC_TAGGING_PRIORITY_2026_10_15.md). Four expanded-octet items are currently practice eligible; retire/rewrite ruling recommended. No tags/content changed. The81 Chemistry no-selected-topic count is distinct from102 with no primary validated cell. Independent semantic/source-family review remains open.

## Product Goal

Every AP Chemistry question tagged to Topic 2.5 should be a question the CED actually places in 2.5, so More help grounds it in the right reference entries and the student sees help that matches what the CED requires. Today eight published questions are tagged 2.5, and at least four may belong elsewhere.

## Background (what is already known)

- Topic 2.5 has one essential-knowledge statement, 2.5.A.1: "Lewis diagrams can be constructed according to an established set of principles." It does not print the principles.
- The 2.7.A.3 Exclusion Statement says that when an atom has more than four pairs of electrons around the central atom, "students are only responsible for the shape of the resulting molecule." Expanded-octet Lewis diagrams are therefore not required content in 2.5 or 2.7.
- Before 2026-10-15 neither database had any reference entry for 2.5, so More help refused all eight 2.5 questions (`reference_unavailable`). `PR #462` added one entry, "Principles for constructing a Lewis diagram" (owner 2.5, `topic_codes` = 2.5 only), by Product Owner override. It deliberately does not cover expanded octets.
- The eight published questions with a primary, unsuperseded 2.5 cell in Production (content keys):
  - expanded octet: `apchem-mcq-026`, `apchem-mcq-sv-026-v1`, `apchem-mcq-sv-026-v2`, `apchem-mcq-sv-026-v3`
  - Lewis-diagram construction / electron count: `apchem-oht-2.5` (PO4^3- valence electrons; cell status `authored`, not `validated`), `apchem-frq-u13g-2-5`, `apchem-mcq-078` (OH-), `apchem-mcq-sv-078-v1` (NH2-)
- Cell sources seen: `apchem_variants_topic_2026_10_02`, `apchem_topic_probe_2026_10_02:6/6`, `task0065_oht_generated_2026_10_06`, `frq_u13_gap_fill_2026_10_09:6/6`, `task0065_chem_u2_2026_10_08:topic`.

## Technical Scope

Read-only investigation in Development and Production (`app.content_item_cells`, `app.taxonomy_topics`, `app.content_items`, `app.content_item_versions`, `app.unit_reference_entries`). Questions to answer:

1. **Expanded-octet four.** For each of the four, does the CED place it in 2.5, in 2.7, or nowhere (excluded)? What does the stem/key require a student to know? Which topic's essential knowledge would it map to if re-tagged to 2.7, and would the existing 2.7 reference entries (geometries, VSEPR) be useful help for it?
2. **Tagging provenance.** How did the four get a validated 2.5 cell (the `apchem_variants_topic` and `apchem_topic_probe` runs)? Was the topic chosen by a model probe, a human, or inherited from the parent item? Is there a systematic pattern (other Chemistry items tagged by the same sources) that should be re-checked?
3. **`apchem-oht-2.5`.** Its 2.5 cell is only `authored`. Is it included in served lists as intended, and does More help treat it like the validated ones?
4. **Other 2.5-adjacent drift.** Are there published Chemistry questions about Lewis diagrams tagged to 2.1, 2.6 or 2.7 (or untagged) that should be 2.5, and vice versa? Check `held` cells and the 81 published Chemistry items with no primary validated cell at all (they get no reference entries).
5. **Same pattern elsewhere.** Which other topics have a single thin EK and zero reference entries (Production audit of 2026-10-15 found only Chemistry 2.5 within units 1-3)? Note any whose questions may be tagged for content their EK does not cover.
6. **Help effect.** For each proposed re-tag, state which reference entries the question would receive afterwards and whether More help would ground it.

## Out of Scope

- Changing any tag, question, entry, or the app. Findings and a proposed re-tag list go to the Product Owner first.
- Writing new reference entries (a separate Hard-Gate batch).
- Any decision to retire or rewrite the four questions; that is a content ruling for the Product Owner.

## Routes / Components / Systems Affected

None changed. Read-only against `app.*` tables in Development `wmgjsdkphcyhngaffbqf` and Production `pcntajvbdfqhbeewmdry`; CED `docs/teaching/ap-chemistry-course-and-exam-description.pdf`.

## Data / Security / Integration Impact

None for the investigation. A later re-tag would change `app.content_item_cells` rows on live questions (Hard-Gate), should supersede rather than delete cells, and should record `source`/approval in the cell.

## Acceptance Criteria

- [ ] A findings document under `docs/qa/` answers questions 1-6 above with CED citations (LO/EK code or Exclusion Statement text) per question.
- [ ] A proposed re-tag table: content key, current cell, proposed cell, reason, resulting reference entries, and expected More help behaviour.
- [ ] Any item whose content the CED excludes is flagged separately for a keep / retire / rewrite ruling.
- [ ] The Production count of published questions with no primary validated cell, by subject, is recorded as an adjacent finding.
- [ ] No Production or Development write is made without a recorded approval.

## QA Plan

- Manual QA: spot-check three proposed re-tags against the CED text and the stems; open one affected question in the app after any approved change.
- Automated tests: none for the investigation; a re-tag batch reuses the existing cell QA queries.
- Regression areas: served question lists for Chemistry Units 2, session `reference` payload, mastery/cell state (`app.student_cell_state`) for students who already answered a re-tagged item.
- Failure cases: a re-tagged question loses its reference coverage; a student's recorded cell state attributes to the old topic.
- Security/data/integration checks: confirm no answer-key data enters findings or entries.

## Approval State

**Approval Required:** Yes, for any write. The investigation itself needs none.
**Approval Type:** Hard Gate (Production metadata change)
**Decision:** Pending

## Implementation Notes

Starting facts and the 2.5 entry batch are in `scripts/content-seed/ap-chemistry-reference-u2-topic-2-5-2026-10-15/README.md` and `docs/activity_log/APPROVAL-0177_CHEMISTRY_TOPIC_2_5_REFERENCE_ENTRY_2026_10_15.md` (PR #462).

## QA Review

**QA Verdict:** Pending

## Done Decision

**Decision:** Pending
**Date:** YYYY-MM-DD
