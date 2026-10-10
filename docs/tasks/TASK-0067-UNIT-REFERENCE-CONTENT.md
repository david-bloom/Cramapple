# TASK-0067 — Unit Reference Content: Formulas, Vocabulary, Lists, and Diagrams (Companion to Memory Hooks)

**Status:** **Shipped to Production 2026-10-09** (`APPROVAL-0140`): migration, 102 entries + 3 hooks, Lovable publish of `71a9b751`. **Units 1-3 built in Development for nine subjects on 2026-10-10**: 25 batches, 786 entries + 6 hooks, controls 150/150, $37.80 — All 50 escalations are dispositioned (43 corrected and re-checked, 7 rejected as having no LO/EK basis). Development holds 1,076 entries and 13 hooks, of which 829 entries are this session's; the rest come from the pilot, PR #399's Chemistry Unit 1 batch and a concurrent Chemistry units 5-9 batch, so a Production approval must name batches rather than a row count (`docs/handoffs/REFERENCE_PACKS_UNITS_1_3_ALL_SUBJECTS_2026_10_10.md`). Production for those batches is an open Hard Gate; Calculus BC units 1-3 awaits the Product Owner. Done decision still pending the Product Owner's own look at the live surfaces. Approved 2026-10-08 (`DECISION-0105` / `APPROVAL-0137`).
**Tier:** Standard for schema design, Development apply, and authoring in Development; **Hard-Gate** for the Production migration, Production publish, and Lovable publish.
**Owner:** Claude session. **Product Owner:** David Bloom.
**Branch / PR:** `claude/task-0067-0066-phase-a` (shared with `TASK-0066`).
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

## Decisions (Product Owner, 2026-10-08: "Approve R1-R4 as recommended and open TASK-0067")

| # | Decision | Approved as |
| --- | --- | --- |
| R1 | Open this task and sequence it before `TASK-0066` Phase A (or run both Phase As in one migration) | Yes; one migration, two tables, hooks FK to entries. |
| R2 | Amend `TASK-0066` D3 so hooks require a `reference_entry_id` | Yes. |
| R3 | Extraction-first from fact packs with v0.6 checks, rather than fresh authoring | Yes. |
| R4 | Diagram entries ship text-only until `TASK-0006` renders them | Yes. |

## Approval state

Scope approved (`APPROVAL-0137`). The Production migration, the Production publish of pilot
entries, and the Lovable publish are each a separate Hard Gate.

## Implementation summary (2026-10-09)

- **Phase A:** migration `supabase/migrations/20261009003237_task0067_unit_reference_entries_and_memory_hooks.sql`
  (filename = the version Development recorded): `app.unit_reference_entries`, `app.topic_memory_hooks`
  (required `reference_entry_id`), RLS forced, publish guards, `public.unit_reference_entries` and
  `public.topic_memory_hooks` views in the same migration, `public.get_topic_point_guides` gains
  `reference[]` and `memoryHooks[]` only. Keyed as `topic_explainers` (TASK-0054's FK has not landed).
  QA script `scripts/qa/unit_reference_and_memory_hooks_qa.sql`.
- **Phase B:** batch `scripts/content-seed/task0067-reference-pilot-2026-10-09/` (README has provenance,
  method, results, cost). Extractor Claude Sonnet 5.5; checkers Gemini 3.5 Flash + GPT-6 Sol; reject-only
  veto Claude Opus 5.5. Loaded to Development: **79 Statistics Unit 1 entries, 22 Chemistry Unit 4 entries,
  2 hooks** (z-score formula sentence; OIL RIG). One Statistics entry escalated; SOCS hook not loaded
  (see README). $20.29.

## Test results

Development: QA checks pass (objects, RLS forced, no anon grants, RPC keys, triggers; zero orphans,
owner unit matches taxonomy, published hooks on published entries, `published_at` set, 101/2 via views,
registry subject keys). RPC probes for Stats 1.7, Stats Unit 1, Chem 4.9 and a subject with no entries
behaved as specified. Functional test of both guard triggers passed and was rolled back.

## Phase C (2026-10-09, Lovable preview, commit `71a9b751`)

`topic-content.ts` maps `reference[]`/`memoryHooks[]` (camel or snake, `[]` when absent);
`presentation.ts` fills the pane's Vocabulary from `vocabulary` entries, adds `rememberIt` and `lookUp`,
a "Remember it" summary in the Deep Dive, "Formulas and rules" / "Lists and sequences" full sections,
and a closing "Unit N reference" built from a second unit-level RPC call; `ReferencePane.jsx` renders
"Remember it" and "Look up"; the Learn More route shows the same two blocks as cards;
`deep-dive-export.ts` includes "Remember it" in Copy notes. A baseline fixture pins the pre-change output
so Production's current payload (no new keys) renders exactly as before. Tests: 770/770, `tsc` clean
(reported by the Lovable agent, 2026-10-09). Known limits: formulas display as LaTeX source in monospace
(no renderer in the app); a topic's "Look up" lists every entry the topic reuses (Stats 1.7 shows seven
formulas), so row limits may be wanted before publish.

## Resolved by the Product Owner (`DECISION-0107`)

Checker pick stands; SOCS loaded (CED names it); 1.13 owns "Scope of conclusions"; veto moves to Haiku 5.5.

## Hard Gates (all executed under `APPROVAL-0140`, 2026-10-09)

1. Production migration `20261009003237`: applied, ledgered under the same version, objects md5-identical to Development.
2. Production publish: 102 entries + 3 hooks loaded from the batch's generated SQL; data QA and RPC probes pass.
3. Lovable publish: `deploy_project` at `71a9b751` — triggered; confirm by opening the live app (no anonymous route exists to verify over HTTP).

## Next

- Product Owner look at the live Open Hand pane, Deep Dive and Learn More for Stats 1.6/1.7 and Chem 4.9 (first real memory hooks a student can see).
- Row limits for the pane's "Look up" block and a formula renderer are open design items.
- Units 2+ for Statistics and Chemistry, then the other subjects, as new batches with the Haiku 5.5 veto (`DECISION-0107`).

## QA result / Done decision

Not yet. Phase C unbuilt; Production untouched.
