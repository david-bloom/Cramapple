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
any `skill_code`-tagged content (`app.content_item_cells`, MCQ only, 11 of its own 131 cells). The
other 9 subjects are at zero on both counts. "Same schema" = every subject ends this rollout with:

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
(`supabase/migrations/20260823130000_course_mode_f4_servable_content_path.sql`). A content item
literally cannot be tagged with a skill that isn't already a registered cell — the DB rejects it.

**Consequence: Phase A (grid) must exist before Phase B (item labeling) for a given subject.**
This is a hard dependency, not a style preference, and it's actually a safety net: it makes it
impossible for the labeling pass to hallucinate a skill_code/topic_code pair that isn't real. Run
Phase A to completion and verify the grid in Dev before starting Phase B for that subject.

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

**This rules out blind auto-write for Phase B.** Design each subject's labeling run as:
- Two-model proposal (per `extend_serving_labels_mcp.mjs`'s existing pattern) writes labels with
  `label_scope='coverage'`... `taxonomy_confidence` (or whatever the content-item-cells equivalent
  flag is — check current schema, this table predates the T2 label-versioning redesign and may need
  a status column added) marked provisional, not auto-promoted.
- A confirm/correct pass — model agreement auto-accepts only where both models agree AND a
  spot-check sample (recommend 10%) confirms; everything else needs a human confirm, same as
  `DECISION-0079`'s promotion gate for the original MCQ labels.
- Never promote a batch to "validated"/servable without recording who confirmed it and against
  what CED citation, mirroring the audit trail T2 already establishes for serving labels.

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
- Add FRQ items to its packet query, not just MCQ — check `fetch_serving_label_packets.sql` /
  `fetch_candidate_serving_label_packets.sql` for what's currently excluded and why.
- Emit `skill_code` (not just `required_units`) in its output, validated against the subject's now-
  existing `taxonomy_cells` registry from Phase A — the composite FK is the safety net if the model
  proposes a cell that isn't registered.
- Keep the model pair (`openai/gpt-5.5`, `google/gemini-2.5-flash`) and the Vercel AI Gateway path
  already wired (`scripts/vercel-gateway-check/.env.local`) — this is the spend David authorized.
- Apply the confirm/correct discipline from §5: write, don't auto-promote; spot-check; promote with
  a record of who/what confirmed it.

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

1. **AP Statistics** — Phase B only (grid exists), cheapest possible first win, closes the launch
   subject's own gap.
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
  FRQ), verified by ID, not by trusting the labeling script's own success message.
- GAP-10 entry updated with the subject's result, using the same evidence-first standard as every
  other verification in this project — no claim of completion without a primary-source check.
