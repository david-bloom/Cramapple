# TASK-0070 — Serve shared reference content across sibling subjects (Calculus BC from AB)

**Status:** **Built and applied to Development 2026-10-10.** Production is a Hard Gate and untouched.
Code change, so the PR goes to David.
**Tier:** Standard for the Development apply; **Hard-Gate** for Production.
**Owner:** Claude session. **Product Owner:** David Bloom.
**Branch / PR:** `claude/task-0067-production-records`.
**Source:** David, 2026-10-10, on reviewing the Calculus BC re-key proposal: *"For Calc BC, why do we need a
separate reference pack for units 1-3?"* then *"write it up as a task and execute it."*
**Related:** `TASK-0067` (unit reference content), `TASK-0066` (memory hooks),
`MEMORY_HOOKS_AND_UNIT_REFERENCE_PRODUCTION_PROTOCOL.md`, `TASK-0057` (subject ↔ taxonomy key link).

## Why this exists

The units 1-3 reference-pack run covered nine subjects and skipped Calculus BC, because a BC run would
re-extract content that AP Calculus AB already has. Asked why BC needed its own pack at all, the answer
turned out to be: **it does not, pedagogically.** The requirement came entirely from the data model.

Measured 2026-10-10 against Development:

| Fact | Evidence |
|---|---|
| AB and BC share **one CED PDF** | `docs/teaching/ap-calculus-ab-and-bc-course-and-exam-description.pdf` |
| Units 1-5 topic sets are **identical** | 16/10/6/7/12 topics each, zero asymmetric difference in either direction |
| Units 6-8: BC is a **superset** of AB | BC adds 3, 2 and 1 topics; `ab_only = 0` for every unit 1-8 |
| Units 9-10 are **BC only** | AB has none |
| `unit_reference_entries` is keyed by `subject_key`, and `get_topic_point_guides` filters on it | so a BC student resolves to `ap_calculus_bc` and gets `reference[] = []` while an AB student on the identical topic gets entries |

**The duplication precedent exists and has already failed.** `topic_explainers` and `topic_point_briefs`
do carry separate BC rows (BC 111, AB 81). But the copies have drifted: **all 81 shared AB/BC explainers
differ in text**, and `source_note` shows why — BC's were largely repaired on 2026-08-21 and AB's were
not (units 1-8: **AB 81 rows with 35 repaired; BC 87 rows with 85 repaired**). On topic 1.1 an AB student
gets "Calculus begins with the problem that average rate is easy over an interval" while a BC student on
the same topic gets a fuller repaired explainer. Duplicating per subject did not keep the two in sync; it
hid a one-sided repair. Copying the reference pack would start the same clock, and every one of the 43
corrections just made to AB rows would need mirroring or BC would silently keep the uncorrected text.

So: serve the shared content once instead of duplicating it.

## What was built

A general alias, not a Calculus special case.

1. **`app.subject_reference_aliases`** — `(subject_key, source_subject_key, unit_from, unit_to, note)`.
   One seeded row: `ap_calculus_bc` reads `ap_calculus_ab` for units 1-8. RLS enabled and forced with no
   policies and no grants; only the `SECURITY DEFINER` RPC reads it, and `postgres` carries
   `rolbypassrls`, which is how the existing content tables are already read.
2. **`public.get_topic_point_guides`** — its `published_reference` CTE now unions the requesting
   subject's own published rows with alias-sourced rows, under three guards:
   - **the subject's own row always wins** — an alias row is skipped when the requesting subject already
     has a published row with the same `(owner_topic_code, kind, title)`, so authoring a BC-specific row
     later overrides the shared one with no migration;
   - **unit range** — only units within the alias's `unit_from..unit_to`;
   - **taxonomy guard** — an alias row is served only when its `owner_topic_code` exists in the
     *requesting* subject's latest verified taxonomy version, so a BC student can never be shown an entry
     for a topic their course does not contain.
3. Each reference object gains **`sharedFromSubjectKey`**, null for a subject's own rows and the source
   subject for a shared row. Additive, so existing clients are unaffected. `subjectKey` still reports the
   row's real owning subject rather than pretending.

Hooks need no change: `published_hooks` joins `published_reference`, so a shared entry brings its hooks.

## What this deliberately does not do

- **No content was written, copied, re-keyed or deleted.** Not one row in `unit_reference_entries`
  changed. Calculus BC now serves AB's 51 checked entries for units 1-3 without a second copy existing.
- **The anonymous BYOQ path is not covered.** BYOQ reads the `public.unit_reference_entries` /
  `public.topic_memory_hooks` views, which filter by their own `subject_key` projection and are untouched
  here. A BC visitor on anonymous BYOQ still sees no reference entries. Left out on purpose: those views
  are table-shaped and are read by the edge function in the still-open PR #399, so widening them there
  risks a conflict with work in flight. Recorded as follow-up F1 below.
- **AB's stale explainers are not fixed.** Follow-up F2.

## Follow-ups

- **F1 — anonymous BYOQ sharing.** Apply the same alias to the `public.unit_reference_entries` and
  `public.topic_memory_hooks` views, or have BYOQ call a function that honours the alias. Needs the owner
  of the BYOQ path; sequence it after PR #399 merges.
- **F2 — AP Calculus AB explainers look pre-repair.** Units 1-8: AB 81 rows with 35 repaired versus BC
  87 with 85. Every one of the 81 shared topics differs between the two subjects, and the BC side is the
  repaired one. This predates this task and is a live content-quality gap for AB students, not a serving
  bug. Needs a Product Owner call on whether AB adopts BC's repaired text for shared topics, which the
  alias built here could also serve in reverse.
- **F3 — other sibling subjects.** The alias table is general. Physics C: Mechanics and E&M are separate
  courses with disjoint units, so nothing applies today, but if a future subject pair shares units the
  mechanism is already in place.

## Verification

See the activity-log entry for 2026-10-10 and §14 of
`docs/handoffs/REFERENCE_PACKS_UNITS_1_3_ALL_SUBJECTS_2026_10_10.md`. In short: BC units 1-3 went from 0
to AB's entry counts topic by topic; AB, Precalculus, Biology, Statistics, Chemistry and the three Physics
subjects returned byte-identical payloads before and after; BC units 9-10 and BC-only topics stayed empty;
the own-row-wins and taxonomy guards were both exercised; all 8 QA checks pass.

## Rollback

`app.subject_reference_aliases` is additive and the RPC is `CREATE OR REPLACE`. To revert serving without
a migration, `delete from app.subject_reference_aliases;` — the unioned branch then matches nothing and
the function returns exactly its previous payload. The migration file also carries the prior function body
in a comment block for a full restore.
