# TASK-0065 checker pilot — AP Biology, 2026-10-06

> **Reconciled with APPROVAL-0123 / PR #340 (2026-10-06, later the same day).** Another session ran TASK-0065
> in parallel on PR #340 (merged), under APPROVAL-0123: Units 1-3 of Biology, Statistics, Chemistry and Calculus AB
> (91 items), with habit lines taken from the topic's point brief on screen rather than carried per item. That
> approval governs. This pilot's **scope revision (603 topics) is withdrawn** and **C6 is retired**. C3, the lint,
> the planted-defect controls and the CED-text topic probe stay as supplementary stages to #340's checker
> (`open_hand_teaching_check.mjs`). See "Supplementary stages on the APPROVAL-0123 batch" at the end.

**Task:** `docs/tasks/TASK-0065-OPEN-HAND-TEACHING-QUESTION-GENERATION.md`. **Owner:** Claude (David, 2026-10-06).
**Purpose:** prove the checker suite catches what the item standard forbids, before any full-batch spend.
Nothing was written to any database. Nothing is published.

## Setup

- 5 clean teaching MCQs authored by Claude on Biology topics with no spare item: 1.1, 2.5, 3.1, 5.3, 7.5.
- 4 controls, each a copy of a clean item with **one** planted defect (listed in `controls.json`, never shown to a checker):
  X1 named-trap failure (C3), X2 habit lines that are facts (C6), X3 topic drift 7.5 → 7.2 (C5), X4 false rationale (C2).
  All four controls pass the lint, so only a model check can catch them.
- Checkers (roster checked live on the gateway): `deepseek/deepseek-v4-pro` + `google/gemini-3.8-flash`; topic votes add `openai/gpt-6.1-sol`, 2 samples each (6 votes). No Anthropic model checks Claude's work.
- Rule: an item fails a check if **either** checker flags it (David, 2026-10-06). C5 needs ≥ 5 of 6 votes for the designated topic.

| Check | Tool | What it blocks |
|---|---|---|
| L | `lint.py` (self-test: 9 planted defects caught) | not A-D, key missing, choices repeated in stem, bare "Credited", distractor without `Fix:`/`Next time:`, not 3+3 habit lines, line > 14 words, emoji, "!", calculator, figure without asset |
| C1 | `subject_audit_check.mjs --pass=solve` | either checker misses the key or reports a defect |
| C2 | `subject_audit_check.mjs --pass=audit` | key judged wrong or any rationale inaccurate |
| C3 | `teaching_item_check.mjs --pass=trap` (new) | a distractor without a named temptation or a specific one-line fix; a keyed rationale that does not explain itself |
| C4 | `subject_ced_check.mjs` + Biology fact pack | anything outside the CED (`DECISION-0095`) |
| C5 | `apbio_seeded_label_probe.mjs` × 3 models | < 5 of 6 votes for the designated topic |
| C6 | `teaching_item_check.mjs --pass=habits` (new) | lines that are facts not habits, not one line, hedged, off the point brief, not paired with the item, or missing the brief's core |

`teaching_item_check.mjs` recomputes each verdict from the per-field booleans, so a model cannot pass an item it flagged.

## Results

Round 1 (`round1/`) then one patch round (round 2, top level), per the one-patch-loop policy.

| Item | Round 1 | Round 2 | Round 2 blocker |
|---|---|---|---|
| 1.1 water | C3, C6 | C6 | DeepSeek: brief's "biological consequence" step not in the earned lines |
| 2.5 transport | C5, C6 | C2, C5, C6 | DeepSeek: a charged solute can move passively against its concentration gradient (correct; the stem must say X is uncharged). Topic 4/6 for 2.8 |
| 3.1 enzymes | pass | **pass** | — |
| 5.3 Mendel | C6 | C6 | DeepSeek: brief core not covered (Gemini passes) |
| 7.5 Hardy-Weinberg | C6 | **pass** | — |
| X1 (C3 control) | **C3 caught** | **C3 caught** | both checkers, both rounds |
| X2 (C6 control) | **C6 caught** | **C6 caught** | both checkers, both rounds |
| X3 (C5 control) | **C5 caught** (0/6, all 7.2) | **C5 caught** | also failed C6 against the 7.5 brief |
| X4 (C2 control) | **C2 caught** | **C2 caught** | both checkers named the ice-density error |

**Detection: 4 of 4 planted defects caught by the intended check, by both checkers, in both rounds. 0 false negatives.**

The clean items were not clean. The checkers found real authoring defects that I missed:
1.1's distractor C had a vague temptation and B's fix stated a fact, not an action; 5.3 and 7.5 had a "lost" line for an error no choice punishes (7.5 now has a 0.15 distractor for the wrong-square-root error, which the brief names); 2.5's stem leaned on protein energetics and drew 2.8 votes. One flag was checker miscalibration (DeepSeek rejected gerund phrases as "not one clause"); the C6 prompt now says one short line, phrase or clause.

## Findings that need a decision

1. **C6 has two blocking rules that pull against each other.** "Pairs with this item" (every line is a habit this question exercises) and "covers the brief's core" (the earned/lost lines include the topic brief's main move and main loss). A brief is topic-level and lists 3-4 moves; one MCQ exercises one or two. Round 2's three remaining C6 blocks are all DeepSeek on "brief core". Recommendation: keep "pairs with item" blocking; soften brief coverage to "does not contradict the brief and shares at least one of its moves".
2. **The topic probe sees titles only.** 2.5 Membrane Transport vs 2.8 Mechanisms of Transport is a CED overlap (EK 2.5.A.3 and EK 2.8.A.1 both cover active transport). Recommendation: pass each topic's EK lines from the fact pack to the probe, or allow the runbook's `ced_text_tiebreak` for designated-topic items. Until then, 2.5 is dropped from the pilot.
3. **Scope is larger than the task says.** Production has 60 published Biology topic point briefs; TASK-0065's "27 Biology topics" counts topics that have MCQs. If every briefed topic gets a teaching item, the ~214 total is an undercount.
4. **C3 is not fully deterministic on borderline rationales.** 1.1's distractor D passed C3 in round 2 while the identical text in X4 failed. Union-of-flags plus re-audit after patching (runbook §3) covers this; it is the reason to keep the union rule.

## Cost and volume

162 calls per round, 324 total. Tokens (input / output): DeepSeek v4-pro 351k / 304k; Gemini 3.8 flash 364k / 91k; GPT-6.1 sol 31k / 3k.

## Files

`build_items.py` (items + controls), `items.json`, `controls.json`, `briefs.json` (verbatim from Production `app.topic_point_briefs`), `lint.py`, `run_checks.sh`, `analyze.py`, `analysis.json`, `out_*`, `round1/`.

## Round 3 — David's decisions applied (2026-10-06)

David accepted all three recommendations. Changes:
1. **C6:** "covers the brief's core" became `brief_shares_a_move`: no line contradicts the brief and at least one line shares one of its moves. "Pairs with this item" stays blocking.
2. **C5:** `apbio_seeded_label_probe.mjs` now prints each topic's CED learning objectives and essential knowledge under its title when the taxonomy carries a `ced` field (`taxonomy_ced.json`, extracted from `docs/product/AP_BIOLOGY_CED_FACT_PACK.md`, all 60 topics). Taxonomies without `ced` behave as before. `ced_text_tiebreak` (runbook §6) remains the fallback.
3. **Scope:** ~~every topic with a published point brief (603)~~ **withdrawn**; APPROVAL-0123 (91 items) governs. The count of 603 published briefs across the 10 subjects stands as a measurement.

Items are unchanged from round 2 except 2.5, whose stem now says X is **uncharged** (DeepSeek's correct round-2 C2 finding). That is a second patch, beyond the one-patch-loop policy, so **2.5 is not publish-eligible from this pilot**. It was rerun only to test the CED-text probe. Round 2 is archived in `round2/`.

| Item | Round 3 | Notes |
|---|---|---|
| 1.1 water | **pass** | |
| 2.5 transport | C6 | topic votes now **6/6 for 2.5** (round 2: 2/6). Both checkers: earned line "Link active transport to an energy requirement" is not exercised by this question. A valid flag; not eligible anyway |
| 3.1 enzymes | **pass** | |
| 5.3 Mendel | **pass** | |
| 7.5 Hardy-Weinberg | **pass** | |
| X1 (C3 control) | **C3 caught** | |
| X2 (C6 control) | **C6 caught** | the softened rule still fails facts-not-habits |
| X3 (C5 control) | **C5 caught** | 0/6 for 7.5 (votes 7.2 ×4, 7.1 ×2) |
| X4 (C2 control) | **C2 caught** | |

**Controls: 4 of 4 caught, in all three rounds. Clean items: 4 of 5 pass (2.5 excluded by policy). Topic votes are unanimous (6/6) on every clean item.**

One note on noise: X4 (a copy of 1.1 with one false rationale) failed C6 "not paired with item" on DeepSeek, while 1.1's identical habit lines passed. That is the same single-call variance seen on C3 in round 2. The union-of-flags rule absorbs it by blocking. In a full run, a C6-only block where the other checker passes should get a second DeepSeek sample before an item is dropped.

### Readiness for the full batch

The checker suite is ready for the Biology and Statistics batch. Volume: about 18 calls per item per round. 603 topics × about 1.5 rounds is about 16k calls; Biology + Statistics (115 topics) is about 3k.

## Supplementary stages on the APPROVAL-0123 batch (2026-10-06)

Input: `docs/research/open_hand_teaching_batch_2026_10_06/SCOPE_UNITS_1-3.json` (91 items, unpatched drafts, the
same input as #340's `check_run_1`). The tools now read that batch shape directly. Nothing in the batch directory
was edited.

**Tool changes.** `teaching_item_check.mjs` is C3 only, reads the batch shape, keys items `subject:topic` like
`open_hand_teaching_check.mjs --only`, and refuses Anthropic models. Regression: control X1 still fails and 3.1
still passes on both checkers (`out_c3_regression/`). `lint.py` dropped the habit-line rules and reads the batch shape. Its figure rule
now flags only a reference to a visual the student cannot see (the first pass flagged inline tables and graphs
described in words: 9 false positives on the batch). It also names `!=` (self-test: 9 planted defects caught).

**Lint (L), 91 items:** 2 fail. Calculus AB 1.11 and 1.13 write `x != 4` / `x != 3` where a student should see `≠`.

**C3 named-trap audit, 91 items, DeepSeek v4-pro + Gemini 3.8 flash, union of flags:** 38 blocked (13 flagged by
both). Results are in `batch_c3/`, and the per-item reasons are in `batch_c3_blocked.json`.
- **13 items: a distractor's temptation is not named.** These are real defects, for example Calculus AB 1.16 ("12 feels close"),
  Biology 1.7 C, 3.2 A and 3.3 B.
- **25 items are blocked only because a `Fix:` line states the correct fact instead of telling the student what to
  do differently.** C3 reads "one-line fix" as an action, which is stricter than the item standard's wording.
  **Open for David:** keep that reading, which means a rewrite of those fix lines in the patch loop, or accept a
  factual fix line.
- No item fails on a missing `Fix:` line, a long fix, or an unexplained keyed rationale.

**C5 topic probe with CED text, Biology (21 items), 3 models × 2 samples:** 21 of 21 reach 5/6 or better for the
designated topic (`batch_c5_*/`). The other three subjects have no per-topic LO/EK text in their fact packs
(Chemistry and Calculus AB list titles only; Statistics is prose by topic), so the probe cannot be extended to
them without extracting that text from the CEDs first. They stay on #340's single-model `on_topic` judgement.

Calls: 182 (C3) + 126 (C5) + 4 (regression). These results are inputs to #340's patch loop. They do not clear any
item on their own.

## Fix lines rewritten as actions (2026-10-06)

David: "Fix lines must be actions; rewrite the 25." `patch_fix_lines.py` reviewed every fix line in the 25 items
blocked only on fact-style fixes and rewrote **44** of them as instructions, changing only the text after `Fix: `.
Each old fix was asserted before replacement. Fix lines that already gave an action were left alone. The same edit
went into `SCOPE_UNITS_1-3.json` and each item's subject file (`biology_u1-4.json`, `ap-statistics.json`,
`ap-chemistry_u1-4.json`, `ap-calculus-ab_u1-4.json`), which held identical copies. This counts as the items' one patch round.

**Re-check of all 25 patched items, both models:**
- Lint: 0 fail.
- C3: 24 pass. Biology 3.1 D was flagged once by DeepSeek for its temptation sentence, which was not changed and
  which both checkers passed in round 1. Two further DeepSeek samples both passed. Recorded as single-call variance.
- `open_hand_teaching_check.mjs` (#340's blind solve + fact-pack audit): 24 clean. Chemistry 2.6 D was flagged by DeepSeek
  ("the central O obeys the octet in O=O=O"). **Adjudicated false:** neutral ozone has 18 valence electrons, so
  with two double bonds the remaining pair must sit on an oxygen, giving it 10. The rationale is correct. Gemini
  passed it. That rationale sentence was not part of this patch.

**Result: all 25 clear on L, C3 and #340's solve and audit checks** (two flags adjudicated above). Outputs:
`patched25.json`, `patched25_c3/`, `patched25_c3_resample2/`, `patched25_c3_resample3/`, `patched25_solve_audit/`.

**Still open:** the 13 items blocked for an unnamed temptation. 7 of them also have fact-style fix lines, and both
need rewriting in the same patch. Nothing has been loaded to any database.
