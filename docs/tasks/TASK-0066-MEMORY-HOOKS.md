# TASK-0066 — Memory Hooks: Schema, Pilot Authoring, and Student Surfaces

**Status:** Approved, not started (2026-10-08).
**Tier:** Standard for schema design and Development apply, pilot authoring in Development, and the Lovable preview build; **Hard-Gate** for the Production migration apply, any Production publish of hook rows, and the Lovable publish.
**Owner:** Claude session (schema, authoring run, Lovable messages); outside-family checkers via AI Gateway.
**Product Owner:** David Bloom.
**Date opened:** 2026-10-08. **Approved:** 2026-10-08, `DECISION-0104` / `APPROVAL-0136`.
**Branch:** none yet (open on first implementation session). **PR:** none yet.
**Source:** `docs/product/MEMORY_HOOKS_PROPOSAL_2026_10_08.md` (approved as recommended, with the §12 amendment). Idea: Micah Bloom.
**Related:** `TASK-0054` (reference content on the taxonomy), `TASK-0006` (visual stimulus and rendering), `TOPIC_BRIEFS_AND_LEARN_MORE_PRODUCTION_PROTOCOL.md`, `research/CONTENT_AUTHORING_AND_QA_PROTOCOL.md` v0.6 §0, `COURSE_HOMEWORK_CONSOLIDATION_PLAN.md` §3.

## Product goal

Where a CED learning objective or scoring guideline requires a student to reproduce or apply an
ordered sequence, a list, a formula's structure, a sign or direction convention, or the labelled
parts of a required diagram, give the student one vetted memory hook for it, shown beside the
instruction they already get. Most topics get none. A hook is for recall; the exam answer is
written in CED language, and the hook says so when the two differ.

## Decisions this task executes (`DECISION-0104`)

| # | Decision | Approved as |
| --- | --- | --- |
| D1 | Grain | Topic-owned (`owner_topic_code`) with `topic_codes[]`, unit roll-up, no skill grain. |
| D2 | Inclusion rule | CED point-bearing sequences, lists, formula structures, sign conventions; **amended** to add labelled parts of a CED-required diagram. |
| D3 | Data model | Option B: `app.topic_memory_hooks` + public view + `get_topic_point_guides` returns `memoryHooks[]`. |
| D4 | Songs | Out of v1. No lyrics, no audio. |
| D5 | Surfaces | Deep Dive "Remember it" block, unit-reference "Memory hooks" list, Open Hand reference pane. Not hints, not post-miss feedback. |
| D6 | Pilot | AP Statistics Unit 1 + AP Chemistry Unit 4, at most 8 hooks, before any wider survey. |
| D7 | Priority | Not launch gating. Schema lands on the key `TASK-0054` settles. |

## Technical scope

### Phase A — Schema (Standard in Development; Hard-Gate for Production)

1. Read `TASK-0054`'s current state first. If its FK to `taxonomy_topics` has landed, key the new
   table the same way. If it has not, key on `(subject_key, topic_code)` text exactly as
   `topic_explainers` does, reuse its check constraints, and record the migration path to the FK in
   the migration header so the two tables convert together.
2. Migration creating `app.topic_memory_hooks`:
   `memory_hook_id`, `subject_key`, `owner_topic_code`, `topic_codes text[]` (must contain the owner),
   `kind` in (`acronym`, `acrostic`, `phrase`, `formula_sentence`, `visual`, `diagram_parts`),
   `hook_text`, `expands_to jsonb` (ordered `[{"cue","means"}]`), `when_to_use`, `caution` (nullable),
   `visual_asset_ref` (nullable; `diagram_parts` and `visual` only; references an existing
   visual-stimulus asset, never a new rendering path), `status` (`draft`/`published`/`retired`),
   `source_note`, `published_at`, `created_at`, `updated_at`. Same subject-key, topic-code, and
   status checks as `topic_explainers`. RLS: no direct student read.
3. A `public` view with the student-safe columns, created **in the same migration** (public views do
   not pick up new columns on their own; recorded trap).
4. Extend `public.get_topic_point_guides(subject_key, unit_number, topic_code)` to return
   `memoryHooks[]` (published rows whose `topic_codes` contains the topic, owner first), and a unit
   variant or parameter for the unit-reference list. Existing callers must see an unchanged shape
   except for the added key.
5. Extend the `TASK-0054` zero-orphan QA script: every element of `topic_codes` exists in the
   subject's taxonomy; `owner_topic_code` is in `topic_codes`; unit roll-up count matches.
6. Apply to Development; verify with the QA script and one RPC call per surface. Production apply is
   a separate Hard-Gate approval with the migration file under the Production version
   (`feedback_apply_migration_timestamp_drift` trap).

### Phase B — Pilot authoring (Development only until approved)

1. Scope: AP Statistics Unit 1 (topics 1.1–1.13) and AP Chemistry Unit 4, at most 8 published hooks
   in total. Start from the proposal's §10 inventory, including the OIL RIG row already live in prose
   in the 4.9 explainer's `practice_bridge`.
2. Method: protocol v0.6 §0 generate-and-select. Per topic, candidates are proposed from the CED fact
   pack; two checker families from different model families verify (a) the expansion is right
   against the fact pack, (b) the owning and additional topic codes are right, (c) the inclusion
   rule holds, (d) a `caution` is present when the CED wording differs from the hook, (e) for
   `diagram_parts`, the referenced asset exists and the parts named are the ones the CED requires.
   Reject-only; no hand edits. "No hook" is an accepted outcome for a topic and is recorded.
3. `source_note` per row: `public-domain-common` for mnemonics in general circulation,
   `cramapple-authored` for original ones. No publisher's novel phrasing, no lyrics.
4. Load as `draft` in Development; publish in Development; present the rows to the Product Owner for
   the Production publish approval.

### Phase C — Student surfaces (Lovable preview; publish is Hard-Gate)

1. Deep Dive: a "Remember it" block under `Understand`, shown only when the owner topic has a
   published hook; row limits 2 (hook) + 2 (expansion); overflow cuts the expansion to the list.
   Add the row to the protocol's row-limit table in the same change.
2. Unit reference: a "Memory hooks" list, every published hook in the unit, grouped by owner topic.
3. Open Hand reference pane: the same payload as the Deep Dive block.
4. `diagram_parts` hooks render the referenced asset through the existing visual-stimulus path
   (`TASK-0006`); if that path cannot show the asset on a surface, the hook shows text only there.
5. Every surface prints `caution` with the hook when present.
6. Preview-only until the Product Owner approves the publish, per the standing Lovable practice.

## Out of scope

Songs and audio of any kind; hooks inside hints or post-miss feedback (separate decision; hint
use is counted); a subject-wide survey beyond the two pilot units; new diagram rendering; any
change to `topic_explainers` free-text fields.

## Data, security, integration impact

New table and view, one RPC extension, no change to grading, attempts, or entitlements. Student
reads go through the RPC only. Rights exposure is limited by `source_note` and the no-lyrics rule.

## Acceptance criteria

- Development: migration applied, QA script passes with zero orphans, RPC returns `memoryHooks[]`
  for a pilot topic and an empty array for a topic with none.
- At most 8 pilot hooks, every one passed by both checker families with the five checks recorded;
  the per-topic "no hook" outcomes listed.
- Lovable preview shows all three surfaces for one Statistics and one Chemistry topic, with the
  caution visible where set, and nothing for a topic with no hook.
- Production migration, Production publish, and Lovable publish each have their own approval entry.

## QA plan

Independent re-read of the Development rows against the CED fact packs; row-limit check at 320,
390, 768, and 1440 widths; RPC shape diff before and after for an existing caller.

## Approval state

Scope approved (`APPROVAL-0136`). Production apply, Production publish, and Lovable publish: not
approved, each a separate Hard Gate.

## Implementation summary / Test results / QA result / Done decision

None yet.
