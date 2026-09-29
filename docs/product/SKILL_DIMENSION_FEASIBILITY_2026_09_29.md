# Skill Dimension — Feasibility Measurement, All 10 Subjects (2026-09-29)

**Status:** CURRENT | **Type:** Evidence record (read-only measurement, no writes)
**Companion to:** `SKILL_DIMENSION_ROLLOUT_PLAN_2026_09_29.md` §5a
**Measured against:** Cramapple Production (`pcntajvbdfqhbeewmdry`), 2026-09-29, read-only.
No Production write, migration, or deployment was performed. No AI-Gateway spend was incurred.

## Headline

**MCQ inventory, not the skill dimension, is the binding constraint on `DECISION-0074` mastery — in
all ten subjects.** The bar is 2 correct MCQ + 1 full-point FRQ per topic×skill cell, so a subject
can never have more masterable cells than `floor(published_MCQ / 2)`. That cap is **independent of
grid size**: no Phase A curation choice, and no labeling quality, can raise it. Completing the
rollout for all ten subjects is still required for schema parity (plan §2), but it should not be
expected to unlock mastery at scale, because the ceiling is set by content inventory that does not
yet exist.

## Method

Necessary-condition arithmetic. For a topic×skill cell to be masterable, at least 2 MCQ and at least
1 FRQ must be *labeled into that cell*, so the whole-subject ceiling is:

```
ceiling = min( published_FRQ , floor(published_MCQ / 2) , grid_cell_count )
```

This is an **optimistic** bound in three ways, all of which push the real number down:
1. It assumes a perfect spread — every FRQ lands in a distinct cell that also happens to receive
   exactly 2 MCQ. Real label distributions clump.
2. It counts **published** items. Servable items are fewer (see the Servability caveat below).
3. The bar is on student *performance* (2 correct, 1 full-point), not item availability. Items
   existing is necessary, not sufficient.

Item counts are per published content item version, grouped by exam pack version.

## Per-subject measurement

| Subject | Live pack MCQ | Live pack FRQ | `floor(MCQ/2)` | Ceiling | Binding constraint |
| --- | --- | --- | --- | --- | --- |
| AP Biology | 43 | 75 | 21 | **21** | MCQ |
| AP Statistics (live pack) | 101 | 80 | 50 | **50** | MCQ |
| AP Chemistry | 68 | 51 | 34 | **34** | MCQ |
| AP Physics 1 | 63 | 54 | 31 | **31** | MCQ |
| AP Physics 2 | 40 | 28 | 20 | **20** | MCQ |
| AP Physics C: Mechanics | 41 | 36 | 20 | **20** | MCQ |
| AP Physics C: E&M | 48 | 49 | 24 | **24** | MCQ |
| AP Precalculus | 53 | 64 | 26 | **26** | MCQ |
| AP Calculus AB | 60 | 62 | 30 | **30** | MCQ |
| AP Calculus BC | 63 | 64 | 31 | **31** | MCQ |

MCQ is binding in **10 of 10** subjects. The plan's §5a originally guessed FRQ would bind; that was
wrong, and is corrected there.

## Grid size in context

`app.taxonomy_topics` / `taxonomy_cells` in Production:

| Subject | Topics | Skills | Cells | Ceiling as % of grid |
| --- | --- | --- | --- | --- |
| AP Statistics | 55 | 18 | **131** (real) | 50 / 131 = 38% |
| AP Biology | 60 | 0 | 0 (≈143 est.) | 21 / 143 ≈ 15% |
| AP Calculus AB | 81 | 0 | 0 (≈194 est.) | 30 / 194 ≈ 15% |
| AP Calculus BC | 111 | 0 | 0 (≈266 est.) | 31 / 266 ≈ 12% |
| AP Chemistry | 91 | 0 | 0 (≈218 est.) | 34 / 218 ≈ 16% |
| AP Precalculus | 58 | 0 | 0 (≈139 est.) | 26 / 139 ≈ 19% |
| AP Physics 1 | 43 | 0 | 0 (≈103 est.) | 31 / 103 ≈ 30% |
| AP Physics 2 | 46 | 0 | 0 (≈110 est.) | 20 / 110 ≈ 18% |
| AP Physics C: Mechanics | 41 | 0 | 0 (≈98 est.) | 20 / 98 ≈ 20% |
| AP Physics C: E&M | 31 | 0 | 0 (≈74 est.) | 24 / 74 ≈ 32% |

Estimated cell counts apply Statistics' observed 2.4 cells-per-topic ratio (131 / 55) and are an
estimate only — each subject's real number comes from its own Phase A curation.

**What coarsening the grid does and does not do.** A coarser grid does *not* raise the ceiling (the
`MCQ/2` cap is grid-independent). It raises the fraction of cells that can realistically reach the
bar, by concentrating the same items into fewer cells. So coarsening is worth considering for
student-facing coherence, but it is not a fix for the inventory shortfall.

## Two findings that change the plan's sequencing

### 1. AP Statistics' existing skill labels are stranded on a pack that serves nothing

Statistics has **two** published exam pack versions:

| Pack | Exam date | MCQ | FRQ | Unit-gated servable | Practice servable | Skill-level labels |
| --- | --- | --- | --- | --- | --- | --- |
| `548f06be` | 2027-05-11 | 101 | 80 | 128 | 49 | **0** |
| `7c5a2975` | 2027-05-18 | 203 | **0** | **0** | **0** | **203** |

All 203 skill-coded `content_item_cells` rows are on `7c5a2975` — the retired Course Mode pilot pack,
which has **zero FRQs** and, per `app.servable_items_census()`, zero servable items and 203 items with
no serving label at all. The live pack `548f06be` has zero skill-level labels.

**Consequence:** the plan's §9 ranks Statistics first as "Phase B only (grid exists), cheapest
possible first win." The premise is false. The existing labels are on non-servable content, and a cell
on `7c5a2975` can *never* be masterable because that pack contains no FRQ to satisfy the bar. Phase B
for Statistics must target `548f06be` (101 MCQ + 80 FRQ, currently 0 skill labels) — a **full MCQ+FRQ
labeling pass**, not the FRQ-only top-up the plan describes. Statistics is still a reasonable first
subject (its grid genuinely exists, so Phase A is skippable), but it is not cheap.

This also explains GAP-10's measured zero without invoking a labeling defect. Live query:

```
skill_coded_cells = 11, cells_with_2mcq = 11, cells_with_1frq = 0, masterable_cells = 0
```

All 11 cells already clear the MCQ half of the bar. None clears the FRQ half, because their pack has
no FRQs. GAP-10 is a **content/pack** gap first, and a labeling gap second.

### 2. The "provisional topics under provisional skills" concern is moot

Plan §5a raised an open decision about skill labels stacked on unratified `provisional_model` topic
assignments. Measured in Production: **zero rows are `provisional_model`.**

| Subject | `content_item_cells` rows | with `skill_code` | `validated` | `authored` | `provisional_model` |
| --- | --- | --- | --- | --- | --- |
| AP Biology | 112 | 0 | 112 | 0 | 0 |
| AP Statistics | 384 | 203 | 181 | 203 | 0 |

Biology's 112 topic-only rows and Statistics' 181 seeded rows have since been promoted to
`validated`; the 203 pilot rows are `authored`. The stacked-uncertainty question does not currently
apply, and §5a is corrected accordingly. It would re-apply if a future Phase B writes
`provisional_model` skill rows onto topics that are themselves later invalidated, so the plan still
asks Phase B to record the topic's status alongside each skill label.

## Servability caveat

These ceilings count **published** items. `app.servable_items_census()` shows servable counts are
materially lower for several subjects (e.g. AP Calculus AB: 122 published, 36 unit-gated servable, 44
practice targeted-drill; AP Biology: 118 published, 43 unit-gated servable, 71 practice
targeted-drill). A mastery claim must ultimately rest on items a student can actually be served, so
the real ceiling per subject is lower than the table above. Measuring the servable-only ceiling needs
a per-item-type servability breakdown the census does not currently expose.

## Recommendation

1. **Do not treat this rollout as the mastery unlock.** It delivers schema parity (plan §2), which is
   what David asked for and is worth doing. Mastery at scale additionally requires authoring MCQs —
   roughly 2 per cell you want masterable — which is a content-production decision, not a taxonomy one.
2. **Fix §9's sequencing** before any subject session runs: Statistics is Phase B on the live pack, not
   an FRQ top-up.
3. **Decide the grid-size posture per subject** knowing the ceiling is fixed: a coarser grid buys
   realized coverage, not headroom.
4. **Re-measure the servable-only ceiling** if mastery is going to be a student-facing claim.

## Queries

All measurements came from read-only `select` against Production: `app.content_item_versions` joined
to `app.content_items` / `app.exam_pack_versions` / `app.exam_packs` for item counts by pack and type;
`app.taxonomy_source_versions` with correlated counts over `taxonomy_topics` / `taxonomy_skills` /
`taxonomy_cells` for grid state; `app.content_item_cells` joined to `content_items` and grouped by
`(topic_code, skill_code)` for the masterable-cell and assignment-status tables; and
`app.servable_items_census()` for servability.
