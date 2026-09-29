# Skill Dimension Rollout Plan — 2026-09-29

**Status:** Approved to execute, subject by subject | **Owner:** David Bloom
**Authorization:** David, 2026-09-29 — "create a plan for adding the skill dimension to each
subject. I authorize the vercel gateway cost. Use the CEDs." (Explicit approval for AI-Gateway
spend; each subject's actual grid/label content still needs David's sign-off before a Production
write, per the Hard Gate boundary in §7.)

**Reframe driving this doc:** GAP-10 (`CONTENT_GAPS_RUNNING_LIST.md`) was diagnosed against the
2-subject launch (Biology, Statistics). David: "I appreciate that we are talking about a 2 subject
launch, but we have ten subjects. we need them to have the same data schema." This plan generalizes
GAP-10 remediation from "fix Biology + finish Statistics" to "bring all 10 subjects to the same
skill-dimension schema state."

**Revision note (2026-09-29, same day).** This doc was corrected before merge after a
verification pass read
`supabase/migrations/20260927004500_generalize_content_item_cells_topic_only.sql` — a migration
applied to **Development and Production** on 2026-09-26/27 that the first draft did not account
for. Three claims changed as a result (§2's "zero on both counts", §3's ordering/safety-net
reasoning, §5's "may need a status column added"), a new hard `is_primary` insert constraint was
added to §7, and a new no-spend feasibility gate (§5a) was inserted ahead of Phase A. The original
draft is on record in PR #257. Nothing in the authorization above changed.

## 1. The 10 subjects

AP Biology, AP Statistics, AP Chemistry, AP Physics 1, AP Physics 2, AP Physics C: Mechanics,
AP Physics C: Electricity and Magnetism, AP Precalculus, AP Calculus AB, AP Calculus BC.

Each has (or, for Calc AB/BC, shares) a CED fact pack in `docs/product/*_CED_FACT_PACK.md` — the
one and only taxonomy source per `TAXONOMY_LABELING_PLAN_V3_2026_08_04.md` T1. **Every fact pack
update in this plan follows the rule David set for the Statistics Math Medic cross-check: a public
or secondary source (Math Medic, Albert.io, Fiveable, old fact-pack drafts, a model's own
recollection of the CED) is a cross-check only and is never adopted into a fact pack or a grid
unless it is confirmed against the actual College Board CED PDF / Course-at-a-Glance pages.** If a
subject's official CED can't be sourced in a given session, that session stops and flags it —
it does not proceed on a secondary source.

## 2. What "same data schema" means concretely

Statistics is the only subject with rows in `app.taxonomy_cells` (131 cells) and the only one with
any `skill_code`-tagged content (`app.content_item_cells`, MCQ only, 11 of its own 131 cells).

**The other 9 subjects are at zero on `taxonomy_cells` and at zero on `skill_code` — but not at zero
on `content_item_cells`.** AP Biology already has ~112 **topic-only** rows there (`skill_code` NULL),
loaded from `content_taxonomy_labels` by
`supabase/migrations/20260927004600_biology_topic_labels_into_cells.sql` against Production data
2026-09-26/27; Statistics has 203 `authored` skill-level rows plus 181 seeded topic-only rows
(`20260927160000_seed_statistics_topic_labels_proposal.sql`). This matters operationally: Phase B is
**adding skill-coded rows alongside existing primary rows**, not populating an empty table — see
§7's `is_primary` constraint, which is the single most likely way a labeling run fails on its first
insert.

"Same schema" = every subject ends this rollout with:

1. A `taxonomy_source_version` + `taxonomy_skills` + `taxonomy_cells` registry (topic × skill grid),
   sourced from that subject's own CED, at the same rigor as Statistics' 131-cell grid.
2. `app.content_item_cells` rows carrying real `skill_code` values (not just `topic_code`) for its
   published MCQs **and FRQs** — FRQs are the current universal gap; every FRQ in every subject
   today is topic-only.

Reaching mastery-capable cells (`DECISION-0074`: 2 correct MCQ + 1 full-point FRQ per topic×skill
cell) requires both, together, for a given cell — a grid with no labeled content, or labeled
content with no grid, is not enough.

## 3. The ordering constraint (read before running any subject)

`app.content_item_cells.skill_code` has a **composite foreign key** to
`app.taxonomy_cells(taxonomy_source_version, topic_code, skill_code)`
(`supabase/migrations/20260823130000_course_mode_f4_servable_content_path.sql:83`). A content item
cannot be tagged with a **non-null** skill that isn't already a registered cell — the DB rejects it.

**Consequence: Phase A (grid) must exist before Phase B (item labeling) for a given subject.**
This is a hard dependency, not a style preference. Run Phase A to completion and verify the grid in
Dev before starting Phase B for that subject.

**The safety net is narrower than it looks.** Since
`20260927004500_generalize_content_item_cells_topic_only.sql`, `skill_code` is **nullable**, and the
composite FK is MATCH SIMPLE — Postgres treats it as trivially satisfied when `skill_code` is NULL.
So the FK catches a hallucinated *skill*, but a labeling pass that emits NULL for a skill it
couldn't determine silently writes a legal topic-only row and reports success. A second FK
(`content_item_cells_topic_fkey`, added by the same migration) guards the topic on those rows, so
nothing invalid lands — but **"no FK violation" is not evidence that a skill was assigned.** Phase
B's verification must count non-null `skill_code` rows, never row inserts.

## 4. Subject readiness — who needs a Phase 0 first

Checked every fact pack's practices/skills section for this plan. Five subjects don't have one yet;
their fact packs need a sourcing pass before a grid can be authored.

| Subject | Practices/skills documented in fact pack? | Phase 0 needed? |
| --- | --- | --- |
| AP Statistics | Yes — §4, full skill codes (1.A–4.E), already has a grid | No (skip Phase A entirely, see §6) |
| AP Biology | Yes — §5, full skill codes (1.A–6.E, 26 codes) | No |
| AP Chemistry | Practice-level only (Practice 1–6), no sub-codes | Yes — confirm whether the real CED breaks these into sub-skills (it does, per College Board's SP tables) and add them |
| AP Calculus AB/BC | Practice-level only (Practice 1–4), no sub-codes | Yes — same as Chemistry |
| AP Precalculus | **No practices section at all** | Yes — add from scratch |
| AP Physics 1 | **No practices section at all** | Yes — add from scratch |
| AP Physics 2 | **No practices section at all** | Yes — add from scratch |
| AP Physics C: Mechanics | **No practices section at all** | Yes — add from scratch |
| AP Physics C: Electricity and Magnetism | **No practices section at all** | Yes — add from scratch |

Phase 0 for a subject is: pull that subject's official College Board CED PDF (Science Practices /
Mathematical Practices section, usually the same part of the CED that already anchors the Topic
map §3), transcribe the practice categories **and their lettered/numbered sub-skills** verbatim
with a page citation, and add it as a new section in that subject's fact pack — same citation
discipline the fact packs already use for units/topics (see any fact pack's "Source control"
section for the pattern to match). Do not infer sub-skills from the practice-level summary alone;
get them from the primary source.

## 5. Automation ceiling — read before trusting any auto-generated label

`TAXONOMY_LABELING_PLAN_V3_2026_08_04.md`'s own measurement (§0, T6.b): the two-model
(GPT-5.5 + Gemini) AI-Gateway lane agreed on **unit**-level labels 89% of the time but only **44%**
of the time at **topic** granularity — a coin flip. Skill-level labeling (finer than topic) should
be assumed to sit at or below that 44% agreement ceiling until measured otherwise per subject.

**Where the choice set is small, that ceiling is pessimistic — measure it per subject rather than
assuming it.** The 44% figure was measured on a choice among ~55 topics. Phase B's choice is narrower:
the composite FK restricts a skill to the cells already registered for that item's topic, which for
AP Statistics averages **2.33 candidate skills (min 1, max 4)**. Picking 1 of 2–4 is a materially
easier task than picking 1 of 55, and **items whose topic has exactly one registered skill are
deterministic — no model call, no judgment.** For Statistics that is 42 of 181 items (23%). Compute
this distribution per subject before sizing a labeling run; it is the difference between "label 181
items" and "adjudicate 139."

**This still rules out blind auto-write for Phase B.** Design each subject's labeling run as:
- Two-model proposal (per `extend_serving_labels_mcp.mjs`'s existing pattern) writes labels marked
  provisional, not auto-promoted. **No schema work is needed for this — the governance apparatus
  already exists and is live in Dev and Production.**
  `20260927004500_generalize_content_item_cells_topic_only.sql` added to `content_item_cells`:
  `assignment_status` (CHECK-constrained to
  `legacy_unvalidated|provisional_model|validated|stale|held|authored`), `source`, `model_run_id`,
  `validated_by`, `validated_at`, `validation_decision_id`, and `superseded_by` — the same
  vocabulary as `content_taxonomy_labels`. A second CHECK
  (`content_item_cells_validation_check`) makes `assignment_status='validated'` *impossible* unless
  `validated_by`, `validated_at`, and `validation_decision_id` are all populated, so the audit trail
  §5 asks for is enforced by the database rather than by discipline. Phase B writes
  `provisional_model` with `source` + `model_run_id`; promotion is an UPDATE to `validated` that
  physically cannot omit who confirmed it and under which decision.
- A confirm/correct pass — model agreement auto-accepts only where both proposers agree AND a
  spot-check sample (recommend 10%) confirms.
- **Disagreements are broken by the blind adjudicator (David, 2026-09-29), not by a human queue.**
  Where the two proposers disagree, the adjudicator model is asked the same question with both
  candidate labels withheld, and **its answer is the label** — the same blind-third-review pattern
  this project already used for the 27-of-141 multi-unit review. This replaces the previous design,
  in which every disagreement went to a human. It is what makes a subject-sized run tractable: for
  AP Statistics it moves ~139 contested items off the Product Owner's desk.

**Model roster (David, 2026-09-29), replacing the earlier pair:**

| Seat | Model | Rationale |
| --- | --- | --- |
| Proposer A | `openai/gpt-5.5` | Retained from the measured baseline, so agreement rates stay loosely comparable to `TAXONOMY_LABELING_PLAN_V3`'s 89%/44%. |
| Proposer B | `gemini-2.5-pro` | Replaces `gemini-2.5-flash`. Different lab from A, so proposer errors stay uncorrelated. |
| Blind adjudicator | `claude-opus-5` | Strongest model, in the seat that decides contested labels. Must not be a proposer — an adjudicator that proposed would be grading its own answer. |

`gemini-2.5-flash` was dropped because it is the small/fast tier and this is a content-quality
judgment feeding a student-facing mastery claim. The cost argument for keeping it does not hold:
measured against the live AP Statistics pack, all 181 items total ~79k tokens of content (~260k
input tokens per model pass with scaffolding), so a full frontier two-model pass over a subject is
**well under $10**, and under ~$100 for all ten. Record the exact model IDs per run in
`content_item_cells.model_run_id` so any future re-measurement can tell runs apart.

**Constraint the tie-break rule runs into — read before implementing.** A model-decided label
**cannot be written as `assignment_status='validated'`.** `content_item_cells_validation_check`
requires `validated_by`, `validated_at`, and `validation_decision_id` to be populated, and
`validated_by` is `uuid references app.profiles(user_id)` — a human. So the tie-break decides *what
the label is*, not *that it is validated*. Implement it as: adjudicator's answer is written as the
label with `assignment_status='provisional_model'` and the tie-break recorded in `model_run_id`;
promotion to `validated` still happens in batch, on the strength of the 10% spot-check, with a
human recorded as `validated_by`. David's intent — no per-item human adjudication queue — is fully
preserved; what survives is a sampled human sign-off the database will not let us skip.

- Never promote a batch to "validated"/servable without recording who confirmed it and against
  what CED citation, mirroring the audit trail T2 already establishes for serving labels.

## 5a. Feasibility gate — run this before spending anything on a subject

**Status: RUN, 2026-09-29.** This gate has been executed for all ten subjects against Production,
read-only, no gateway spend. Results and queries:
`SKILL_DIMENSION_FEASIBILITY_2026_09_29.md`. A subject session should read that doc's row for its
subject rather than re-deriving the numbers, and re-run only the parts its own scope changes.

**Why this section exists.** §10's definition of done is "at least one topic×skill cell satisfies
`DECISION-0074`'s 2 MCQ + 1 FRQ bar." Whether that is *reachable* is arithmetic, and it is knowable
before a single AI-Gateway call.

**What the measurement found — read this before planning any subject.** The ceiling is
`min(published_FRQ, floor(published_MCQ / 2), grid_cells)`, and **MCQ is the binding term in 10 of 10
subjects**: Biology 21, Statistics 50, Chemistry 34, Physics 1 31, Physics 2 20, Physics C Mech 20,
Physics C E&M 24, Precalculus 26, Calculus AB 30, Calculus BC 31 masterable cells at the absolute
optimistic bound. **That cap is independent of grid size** — no Phase A curation choice and no
labeling improvement raises it. Coarsening the grid raises the *fraction* of cells that realistically
reach the bar (items concentrate) but not the ceiling itself.

**Consequence for this plan's framing.** The rollout delivers the schema parity §2 asks for, which is
what David authorized and is worth doing. It should **not** be presented as the unlock for
`DECISION-0074` mastery: reaching mastery at scale additionally requires authoring more MCQs (~2 per
cell you want masterable), which is a content-production decision, not a taxonomy one. Say this
plainly in any status report rather than reporting "schema complete" as if mastery followed.

Per subject, read-only, no writes and no gateway spend (the recipe, for re-running):

1. Count published items by type (MCQ, FRQ) for the subject.
2. Count the candidate grid size N the Phase A curation would produce (topics × plausible skills per
   topic from the fact pack — an estimate is fine here).
3. Compute items-per-cell for each type and the ceiling
   `min(published_FRQ, floor(published_MCQ / 2), N)`. **Measured: MCQ binds in every subject** — the
   `floor(MCQ/2)` term was smaller than the FRQ term in all ten. Check item counts **per exam pack
   version**, not per subject: Statistics has two published packs and the distinction is decisive
   (see below).
4. Record the numbers as evidence (counts + the query used), and state the implied ceiling: the
   maximum number of masterable cells this subject can reach at that grid size.

**Grid size is a free variable, and this plan previously treated it as fixed by the CED.** Where the
arithmetic says the CED-faithful grid cannot produce a masterable cell, the correct response is a
**deliberately coarser grid** — fewer, broader cells, so items concentrate — not a labeling run that
cannot succeed. Coarsening is a product decision (it changes what "mastery of a skill" means to a
student) and belongs to David, not to the executing session. Surface the number and the recommended
grid size; do not silently pick one.

**Closed by measurement — provisional topics under provisional skills.** An earlier draft of this
section raised an open decision about skill labels stacked on unratified `provisional_model` topic
assignments. Measured in Production 2026-09-29: **zero `content_item_cells` rows are
`provisional_model`.** Biology's 112 topic-only rows and Statistics' 181 seeded rows are now
`validated`; the 203 pilot rows are `authored`. No decision is needed today. It could re-apply if a
future Phase B writes `provisional_model` skill rows onto topics later invalidated, so Phase B should
still record the topic's `assignment_status` alongside each skill label.

**Check the exam pack before labeling anything.** Item counts and servability are per exam pack
version, and a skill label on a non-servable pack is wasted work. Statistics is the live example: its
203 existing skill-coded rows sit on retired pilot pack `7c5a2975`, which has **zero FRQs and zero
servable items**, so no cell on it can ever be masterable. Confirm which pack a subject actually
serves (`app.servable_items_census()`) before choosing Phase B's target.

## 6. Phase A — build each subject's topic × skill grid

Reference precedent: `scripts/course_mode_stats_generator/cells.py` built Statistics' 131-cell grid
and the migration that loaded it, `supabase/migrations/20260823115605_course_mode_f1_ap_statistics_skills_and_cells.sql`.
That script also builds a synthetic item generator around the grid — **don't copy that part**; only
the registry-construction shape (skills table + curated topic×skill cross-product, not a full
cartesian product) is precedent here.

Per subject:
1. Confirm/complete the skills section per §4 above (skip for Statistics/Biology).
2. Curate the topic × skill cells: for each topic in the fact pack's §"Topic map", determine which
   skills are actually assessed against it. Prefer the CED's own alignment (many official CEDs pair
   each Learning Objective with a specific practice/skill in their EK/LO tables — check the fact
   pack's "Topic-level Learning Objectives" section, e.g. Biology §10, before inventing an
   alignment). Where the CED doesn't give an explicit LO-to-skill map, curate by the same judgment
   Statistics used (`cells.py` docstring/comments explain its topic×skill rationale) — this is a
   content decision, not mechanical, and should get an SME or David spot-check before it's applied
   to Dev, since every later labeled item inherits whatever grid shape is chosen here.
3. Write the migration: one `taxonomy_skills` row per skill code, one `taxonomy_cells` row per
   curated (topic_code, skill_code) pair, scoped to a new `taxonomy_source_version` for that subject
   (reuse the subject's existing verified version if one is already registered — check
   `app.taxonomy_source_versions` first rather than minting a duplicate).
4. Apply to Dev via the Supabase MCP tool, verify row counts and the invariants pattern
   `cells.py`'s `python3 cells.py` prints (total topics covered, cells per unit, no orphaned skill
   codes) before moving to Phase B.

## 7. Phase B — skill-label existing published content

Extend `scripts/taxonomy/extend_serving_labels_mcp.mjs` (or a sibling script forked from it, same
as it was forked from `extend_math_serving_labels.mjs`) to:
- ~~Add FRQ items to its packet query, not just MCQ.~~ **Already done — verified 2026-09-29.**
  `fetch_serving_label_packets.sql` has **no `item_type` filter** and already selects `frq_criteria`
  alongside `mcq_choices`, so FRQs are in the packet set today. No packet-query change is needed for
  either type; the gap was only ever in what the script *emits*.
- Emit `skill_code` (not just `required_units`) in its output, validated against the subject's now-
  existing `taxonomy_cells` registry from Phase A — the composite FK is the safety net if the model
  proposes a cell that isn't registered.
- Use §5's model roster — proposers `openai/gpt-5.5` + `gemini-2.5-pro`, blind adjudicator
  `claude-opus-5` — over the Vercel AI Gateway path already wired
  (`scripts/vercel-gateway-check/.env.local`); this is the spend David authorized. Note the script's
  `MODELS` constant (`extend_serving_labels_mcp.mjs:33`) still hardcodes the old pair including
  `gemini-2.5-flash` and must be updated as part of the Phase B fork.
- Apply the confirm/correct discipline from §5: write `provisional_model`, break proposer
  disagreements with the blind adjudicator rather than a human queue, spot-check 10%, then promote
  the batch with a human recorded as `validated_by`.

**Hard constraint — `is_primary`, the most likely way Phase B fails on its first insert.**
`20260927004500_generalize_content_item_cells_topic_only.sql` added `is_primary boolean not null
default true` plus a unique index `content_item_cells_one_primary_per_version` (one primary row per
content item version). Most items targeted by Phase B **already have a primary topic-only row** (§2).
A naive insert of a skill-coded row therefore takes the `is_primary` default of `true` and **violates
that index**. Two legal shapes, and the subject's session must pick one explicitly:

- **Add a secondary row** — insert the skill-coded row with `is_primary = false`, leaving the existing
  topic-only primary in place. Safe, additive, reversible; the cell coverage lives on secondary rows.
- **Enrich the existing primary** — UPDATE the existing primary row's `skill_code` in place (its
  `topic_code` is already there), which keeps one row per item but mutates a row whose
  `assignment_status`/`model_run_id` describe the *topic* pass, not the skill pass.

The first is recommended; the second loses provenance. The unique constraint is
`(content_item_version_id, topic_code, skill_code)` with `NULLS NOT DISTINCT`, so a topic-only row and
a skill-coded row for the same topic coexist without collision. Precedent: the Statistics seed
migration hit exactly this and documented its workaround
(`20260927160000_seed_statistics_topic_labels_proposal.sql`, header notes) — read it before writing
the insert.

Run MCQ and FRQ as separate passes if that's operationally easier (Statistics already needs only
the FRQ pass, since its MCQ pass exists and mostly succeeded — its 11 skill-coded cells came from
MCQ-only labeling).

## 8. One subject = one self-contained session

Each subject is sized to run in its own fresh context window, in any order, with no cross-subject
dependency. A session picking up a subject should be handed exactly:
- This plan doc's path.
- The subject's fact pack path.
- Whether Phase 0 applies (from §4's table).
- Instruction to re-verify §4's "practices documented?" claim against the current fact pack before
  trusting this doc's table (fact packs get edited; this table is a snapshot from today).

Per-subject checklist for that session:
0. **§5a feasibility gate** — run the arithmetic first, record it, and stop for David if the implied
   masterable-cell ceiling is zero at the candidate grid size. No gateway spend before this.
1. Phase 0 (if flagged) — source and add the skills/practices section to the fact pack, with page
   citations. Stop and ask David if the primary CED can't be located.
2. Phase A — curate and apply the grid to Dev. Flag any topic×skill curation call that isn't
   mechanically obvious from the CED for a human spot-check before Phase B consumes it.
3. Phase B — extend/run the labeling script for that subject's MCQ and FRQ items, write provisional
   labels, spot-check per §5, promote what's confirmed.
4. Verify: re-run GAP-10's masterable-cell query (`mcq_n >= 2 AND frq_n >= 1` per skill-coded cell)
   for the subject and record the before/after count with evidence (row IDs, not just a count), the
   same evidentiary standard used throughout the TASK-0041 QA and the Biology/Statistics GAP-10
   diagnosis.
5. Update `CONTENT_GAPS_RUNNING_LIST.md`'s GAP-10 entry with that subject's result.
6. Stop at the Dev boundary. Production writes (the grid migration and the promoted labels) are a
   Hard Gate — do not apply to `pcntajvbdfqhbeewmdry` without David's explicit go-ahead for that
   specific subject's content, same boundary already observed for `open-hand-item`'s Production
   deploy in the plate-loop plan.

## 9. Suggested sequencing

Not a hard dependency order (§8), just cheapest-and-most-valuable first:

1. **AP Statistics** — Phase B only (its 131-cell grid genuinely exists, so Phase A is skippable),
   but **not cheap and not an FRQ-only top-up**. Corrected 2026-09-29: its 203 existing skill-coded
   rows are stranded on retired pilot pack `7c5a2975` (203 MCQ, **0 FRQ**, 0 servable items). The
   pack Statistics actually serves, `548f06be`, has 101 MCQ + 80 FRQ and **zero** skill-level labels.
   Phase B here is a full MCQ + FRQ labeling pass against `548f06be`. This is also why GAP-10
   measures zero masterable cells despite 11 cells already clearing the 2-MCQ half of the bar — their
   pack has no FRQ to clear the other half.

   **Still the right first subject, and Phase A is confirmed unnecessary (verified 2026-09-29).** All
   181 items on `548f06be` (101 MCQ + 80 FRQ) already carry topic-only rows with `validated` topics,
   spanning 48 distinct topics — and **all 48 are already present in the existing 131-cell grid, with
   zero topics missing.** So Statistics needs no grid work at all: Phase B is adding a `skill_code` to
   181 rows that already exist. Of those, **42 sit on topics with exactly one registered skill and are
   therefore deterministic** (24 MCQ + 18 FRQ — no model call needed); the remaining 139 are a pick
   among 2–4 candidates. Sized this way: ~3–5 hrs to extend the script, a ~278-call two-model run,
   and roughly 1–2 hrs of Product Owner adjudication for disagreements plus a 10% spot-check of
   agreements. Checkpoint the disagreement rate after the first ~30 items — if it runs far above the
   expected ~25–40%, the adjudication load, not the compute, is what grows.
2. **AP Biology** — Phase A + B, the other launch subject, matches GAP-10's original ask.
3. **AP Chemistry, AP Calculus AB, AP Calculus BC** — Phase 0 is light (practice-level already
   documented, just needs sub-skill sourcing) before Phase A + B.
4. **AP Precalculus, AP Physics 1, AP Physics 2, AP Physics C: Mechanics, AP Physics C: E&M** —
   full Phase 0 + A + B, do these last since they're the most CED-sourcing-heavy.

David can reorder this freely — nothing here blocks running them in a different order or in
parallel across separate sessions, since each subject's grid and labels are independent rows keyed
to that subject's own `taxonomy_source_version`.

## 10. Definition of done, per subject

- `taxonomy_cells` has a non-empty, CED-cited grid for the subject in Dev (and, once David approves,
  Production).
- Published MCQs and FRQs for the subject carry `skill_code` (not just `topic_code`) in
  `content_item_cells`, with a recorded confirm/promote trail.
- At least one topic×skill cell in the subject satisfies `DECISION-0074`'s mastery bar (2 MCQ + 1
  FRQ), verified by ID, not by trusting the labeling script's own success message — and counted from
  rows with a **non-null** `skill_code` (§3: a NULL skill passes the FK silently).
- §5a's feasibility numbers recorded for the subject, with the implied ceiling stated. If the ceiling
  was zero and a coarser grid was adopted, David's decision on that grid size is cited.
- GAP-10 entry updated with the subject's result, using the same evidence-first standard as every
  other verification in this project — no claim of completion without a primary-source check.
