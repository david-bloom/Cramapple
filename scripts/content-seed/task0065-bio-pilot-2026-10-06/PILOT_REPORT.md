# TASK-0065 checker pilot — AP Biology, 2026-10-06

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
3. **Scope is larger than the task says.** Production has 61 Biology topic point briefs (60 topics in the taxonomy); TASK-0065's "27 Biology topics" counts topics that have MCQs. If every briefed topic gets a teaching item, the ~214 total is an undercount.
4. **C3 is not fully deterministic on borderline rationales.** 1.1's distractor D passed C3 in round 2 while the identical text in X4 failed. Union-of-flags plus re-audit after patching (runbook §3) covers this; it is the reason to keep the union rule.

## Cost and volume

162 calls per round, 324 total. Tokens (input / output): DeepSeek v4-pro 351k / 304k; Gemini 3.8 flash 364k / 91k; GPT-6.1 sol 31k / 3k.

## Files

`build_items.py` (items + controls), `items.json`, `controls.json`, `briefs.json` (verbatim from Production `app.topic_point_briefs`), `lint.py`, `run_checks.sh`, `analyze.py`, `analysis.json`, `out_*`, `round1/`.
