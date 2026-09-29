# TASK-0050 — Skill Dimension Rollout: Same Data Schema for All 10 Subjects

**Status:** Approved to execute subject by subject; Development scope only. Production writes Hard-Gated.
**Tier:** Hard-Gate
**Owner:** Claude (execution), one subject per fresh session
**Product Owner:** David Bloom
**Date opened:** 2026-09-29
**Decision:** `DECISION-0085`
**Approval:** `APPROVAL-0060`
**Plan:** `docs/product/SKILL_DIMENSION_ROLLOUT_PLAN_2026_09_29.md`
**Evidence:** `docs/product/SKILL_DIMENSION_FEASIBILITY_2026_09_29.md`
**Area:** Content taxonomy / Mastery / Data schema

> **Numbering collision, unresolved — read before citing this number.** A different, unmerged body of
> work also carries TASK-0050: the Open Hand answer-key serving contract, on the local branch
> `codex/task-0049-open-hand-answer-key`, which has **never been pushed** and is not in `main`. That
> work was itself renumbered 0049 → 0050 on 2026-09-28 to escape an earlier collision. This number was
> assigned to the skill-dimension rollout by David on 2026-09-29, when `main` contained no TASK-0050.
> Per this repo's stated convention (later-merging branch renumbers), if the Open Hand branch is ever
> pushed it renumbers again. **Do not silently merge the two records.** If the Open Hand work is still
> live, David should confirm which one keeps 0050.

## Outcome

Bring all ten AP subjects to the same skill-dimension schema state: a CED-sourced topic × skill grid
in `app.taxonomy_cells`, and published MCQs **and** FRQs carrying real `skill_code` values in
`app.content_item_cells` — not topic codes alone.

Originating direction (David, 2026-09-29): *"I appreciate that we are talking about a 2 subject
launch, but we have ten subjects. we need them to have the same data schema."*

## Scope

In scope, per subject: Phase 0 (source the CED practices/skills section into the fact pack, where
missing), Phase A (curate and apply the topic × skill grid), Phase B (skill-label published MCQ and
FRQ via the model-consensus pipeline), and verification against the mastery bar.

Out of scope: authoring new content items; changing `DECISION-0074`'s mastery rule; any Production
write without a per-subject Hard-Gate approval.

## What is already known — do not re-derive

Measured against Production 2026-09-29, recorded in the feasibility doc:

1. **MCQ inventory, not the skill dimension, is the binding constraint on mastery — in 10 of 10
   subjects.** The ceiling is `floor(published_MCQ / 2)` and is **independent of grid size**. Per
   subject: Biology 21, Statistics 50, Chemistry 34, Physics 1 31, Calculus BC 31, Calculus AB 30,
   Precalculus 26, Physics C E&M 24, Physics 2 20, Physics C Mechanics 20. **This task delivers
   schema parity; it does not deliver mastery at scale.** Report it that way.
2. **AP Statistics needs no Phase A.** All 181 items on live pack `548f06be` already carry
   topic-only rows with `validated` topics across 48 topics, and all 48 are already in the existing
   131-cell grid. 42 of the 181 sit on single-skill topics and are deterministic.
3. **Statistics' 203 existing skill-coded rows are stranded** on retired pilot pack `7c5a2975`
   (203 MCQ, **0 FRQ**, 0 servable items). No cell there can ever be masterable. Phase B targets
   `548f06be`.
4. **`is_primary` defaults true** under a one-primary-per-version unique index, so a naive
   skill-row insert fails for items that already have a topic-only primary. Insert with
   `is_primary = false`.
5. **The packet query already includes FRQs** — `fetch_serving_label_packets.sql` has no
   `item_type` filter. Only the script's *emitted* fields need changing.

## Model pipeline (`DECISION-0085`)

| Seat | Model |
| --- | --- |
| Proposer A | `openai/gpt-5.5` |
| Proposer B | `gemini-2.5-pro` |
| Blind adjudicator | `claude-opus-5` |

All three run on every item. `validated` is earned by ≥2-of-3 agreement; no-majority items park as
`held`. No human review pass. Record the agreement tier (unanimous vs majority-earned) on every row.
`scripts/taxonomy/extend_serving_labels_mcp.mjs:33` still hardcodes the superseded pair and must be
updated in the Phase B fork.

## Open items

1. **Blocker, not blocking:** `content_item_cells_validation_check` requires `validated_by`, a uuid
   FK to `app.profiles`, and Production has no system/service profile — so a model-consensus
   `validated` is rejected by the database today. `DECISION-0085` records the decision but leaves the
   implementation route open (relax the CHECK, recommended, vs. mint a synthetic profile, not
   recommended). Both are Hard Gates needing their own approval. Until one lands, Phase B writes
   `provisional_model` and promotion is a later UPDATE. **Do not block the labeling run on this.**
2. **Grid-size posture per subject.** The ceiling is fixed by MCQ inventory, so a coarser grid buys
   realized coverage, not headroom. A curation call that isn't mechanical from the CED needs a David
   spot-check before Phase B consumes it.
3. **Servable-only ceiling unmeasured.** The published-item ceilings above overstate what a student
   can actually be served. Needs a per-item-type servability breakdown the census does not expose.

## Sequencing

Per the plan's §9, adjusted by the feasibility measurement: AP Statistics first (no Phase A, but a
full MCQ+FRQ pass, not an FRQ top-up), then AP Biology, then Chemistry / Calculus AB / Calculus BC
(light Phase 0), then Precalculus and the four Physics subjects (full Phase 0).

## Definition of done, per subject

Per the plan's §10: a CED-cited grid in `taxonomy_cells`; published MCQs and FRQs carrying
**non-null** `skill_code` with a recorded consensus trail; at least one cell meeting `DECISION-0074`'s
bar verified by ID; feasibility numbers and implied ceiling recorded; `CONTENT_GAPS_RUNNING_LIST.md`
GAP-10 updated with the subject's result.
