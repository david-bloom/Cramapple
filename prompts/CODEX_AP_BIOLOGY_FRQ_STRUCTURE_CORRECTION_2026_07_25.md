# Codex Task: Correct AP Biology FRQ Structure to Match the Real CED Format

**Context:** A Bio reviewer (Adil Abbasi) flagged several FRQs as needing "AP rubric numbering (i, ii, iii, iv)." Investigating that comment turned up something bigger than a labeling nit: our live AP Biology FRQ bank does not match the actual point/part structure the College Board specifies, and the mismatch is systemic, not a handful of items.

**Update 2026-07-25 — partial progress already landed, read this before starting:** A Haiku-run pass already fixed 5 of the 42 long FRQs in Production (`APBIO-FRQ-L-001`, `-002`, `-003`, `-031`, `-033` — these were the 5-criteria outliers). **Verify current state per item before touching anything** — don't assume the counts/lists below are still accurate, they're a 2026-07-25 snapshot and some items have already moved. The merge/reweight/relabel pattern Haiku used on those 5 was verified correct (concatenate split sub-part text with "Also, ...", sum points, reweight the resulting 4 parts to 1/3/3/2, relabel stem to "Part A"–"Part D," and — for the 2 of those 5 that already had a submitted review decision — fork a clean version 2 rather than edit in place). Reuse that exact pattern for consistency rather than inventing a different merge convention.

The same run also surfaced a process gap you need to close: **the 2 forked versions it created (`APBIO-FRQ-L-001` version 2, `APBIO-FRQ-L-031` version 2) have no `content_review_assignment` yet** — they're correctly structured in the DB but orphaned from the review queue. Create assignments for these (and for every other version you fork) as part of this task, don't leave that for a separate pass.

It also stalled after those 5 — instead of continuing through the remaining, purely mechanical 37 long FRQs (no merging needed, just reweight + relabel), it wrote itself planning documents instead of executing. That's a persistence/stamina limitation on long repetitive execution, not a correctness problem — the 5 it did complete were accurate. Worth building in a hard per-item verification loop (don't move to item N+1 until item N's write is confirmed by re-querying it) so you don't have the same failure mode: drifting into summarizing/planning instead of continuing to execute.

## What the real CED says (verified directly, not from memory)

`docs/teaching/ap-biology-course-and-exam-description.pdf` (the actual 2025 College Board CED, already in this repo) specifies Section II: Free-Response as **2 long questions + 4 short questions**, each with parts labeled **"Part A / Part B / Part C / Part D"** (capitalized word "Part," not lowercase letters, not roman numerals) and *fixed, uneven* point weights per part:

| FRQ slot | Total pts | Part A | Part B | Part C | Part D |
|---|---:|---:|---:|---:|---:|
| FRQ1 — Interpreting/Evaluating Experimental Results | 9 | 1 | 3 | 3 | 2 |
| FRQ2 — Interpreting/Evaluating Experimental Results **with Graphing** | 9 | 1 | 4 | 2 | 2 |
| FRQ3 — Scientific Investigation | 4 | 1 | 1 | 1 | 1 |
| FRQ4 — Conceptual Analysis | 4 | 1 | 1 | 1 | 1 |
| FRQ5 — Analyze Model or Visual Representation | 4 | 1 | 1 | 1 | 1 |
| FRQ6 — Analyze Data | 4 | 1 | 1 | 1 | 1 |

So: every real long FRQ is **9 points** across **4 parts**, unevenly weighted (either the 1/3/3/2 or 1/4/2/2 pattern, the second only when Part B is graph construction). Every real short FRQ is **4 points** across **4 parts**, evenly weighted at exactly 1 point each.

## What we actually have (verified against Production, `pcntajvbdfqhbeewmdry`, 2026-07-25)

- **100 short FRQs** (`APBIO-FRQ-S-001` through `-100`): every single one has exactly **2 criteria worth 2 points each = 4 total**. Half the required parts are missing entirely — Parts C and D don't exist anywhere for any of these 100 items.
- **42 long FRQs** (`APBIO-FRQ-L-001` through `-042`): average 4.12 criteria (most have exactly 4, a handful have 5 — treat those as their own outlier to resolve), averaging **8.29 points**, essentially flat ~2 points per part. Not 9 points, not unevenly weighted. **As of 2026-07-25, `-001`, `-002`, `-003`, `-031`, `-033` are already fixed** (see the Update note above) — the remaining 37 all have exactly 4 criteria already, so they need reweighting + relabeling only, no merging.
- Labeling throughout uses lowercase `(a)`, `(b)`, `(c)`, `(d)` in the stem text, and some long FRQs additionally nest sub-parts like `(a)(i)` / `(a)(ii)` — the CED's real convention has no such nesting; parts are flat, named "Part A" through "Part D."

## Where this came from (useful context, not something to fix by itself)

The original authoring prompts, `prompts/Biology Short FRQ Promp.txt` and `prompts/Biology Long FRQ Prompt.txt`, **already specify the correct 4-part structure** — short FRQs as "(a) 1pt (b) 1pt (c) 1pt (d) 1pt," long FRQs as "(a) 2-3pts (b) 2-3pts (c) 2pts (d) 2pts." So the defect likely isn't in the original generation intent — something between generation and the `frq_criteria` table lost 2 of every short FRQ's 4 parts (and flattened the long FRQs' weighting). **Before writing any new content, check whether the original full generations (pre-insertion JSON/markdown, wherever this pipeline stages content before SQL insert) still exist and contain the missing Part C/Part D content.** If they do, recovering and correctly inserting the original authored parts is strongly preferable to fresh re-authoring — it's real content that already went through whatever quality pass happened at generation time, just never made it into the DB.

If the original full generations are **not** recoverable (likely, if generation was ephemeral LLM output never persisted per-item), then author the missing parts fresh, following the same master prompt's task-verb pattern for whichever part letter is missing:
- Part A: describe/explain a biological concept, process, or model.
- Part B: identify/describe/construct experimental methods, data, or a graph (Part B carries the graph-construction task on FRQ2-type long items).
- Part C: analyze data, perform calculations, or predict.
- Part D: justify a prediction or claim using evidence and reasoning.

## The scope

Two separate corrections, both needed:

### 1. Short FRQs (100 items, `APBIO-FRQ-S-001`..`-100`)
For each: add 2 new parts (whichever of Part A–D are currently missing — inspect each item, since the 2 existing criteria don't consistently map to the same two letters across items), reweight all 4 parts to exactly 1 point each, and update the stem to show all 4 parts labeled "Part A" / "Part B" / "Part C" / "Part D" (not `(a)`/`(b)`). Update `canonical_answer_1`/`_2` to cover all 4 parts. The new parts must be answerable from the item's existing stimulus — don't introduce a new stimulus unless the existing one genuinely can't support 2 more parts (check first; most of these stimuli look rich enough already, e.g. `APBIO-FRQ-S-001`'s hypotonic/isotonic/hypertonic red-blood-cell scenario could easily support 2 more parts on osmotic concentration prediction or aquaporin structure/function).

### 2. Long FRQs (37 remaining items — `APBIO-FRQ-L-001`, `-002`, `-003`, `-031`, `-033` already done, see Update note)
For each remaining item: confirm exactly 4 parts (as of 2026-07-25 none of the 37 should need merging — verify anyway), then reweight to the correct CED pattern — 1/3/3/2 by default, or 1/4/2/2 for any item where Part B is (or should be) a graph-construction task. Relabel stems to "Part A"/"Part B"/"Part C"/"Part D." As of 2026-07-25, 5 of these 37 (`-005`, `-009`, `-034`, `-038`, `-041`) have a submitted review decision and need version-forking per the process constraint below — re-verify this per item rather than trusting this snapshot.

## Critical process constraint — do not silently invalidate completed review work

This bank has already been through real human review: **78 of these 142 FRQs have `submitted` review decisions** from a now-departed reviewer (Amjad Ali), and a second reviewer (Adil Abbasi) is actively submitting more right now. If you rewrite `stem`/`stimulus`/`frq_criteria` **in place** on `content_item_versions` rows that already have a `submitted` decision recorded against them in `content_review_decisions`, you will silently make that decision reference content that no longer exists, with no record of the mismatch.

For any item with an existing `submitted` decision on its current version: **create a new `content_item_versions` row (`version_num + 1`)** with the corrected structure, set its status appropriately (e.g. `assigned`/back into the review queue), and create fresh `content_review_assignments` for it — don't touch the old version's row. For items with no submitted decision yet (still `pending`/`skipped`/never assigned), editing the existing version in place is fine.

Check `app.content_review_decisions` and `app.content_review_assignments` per item before deciding which path applies — don't assume based on the counts above, verify per-`content_key`.

## Quality bar

- Original authorship only for any newly written parts — this repo's abstraction firewall policy applies (`docs/architecture/CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §3–4). The CED quotes above are structural/exam-format information (publicly described point weights and task types), not secure scored content — fine to reference; do not reference or adapt any actual released FRQ text or scoring guideline.
- New parts must be independently answerable and must not leak the answer to another part.
- Keep the existing (already-reviewed-or-not) 2 parts' wording and criteria as close to unchanged as possible when you only need to reweight/relabel them — don't rewrite content that isn't actually part of this fix.
- Update `app.frq_criteria.points_possible` to sum exactly to 4 (short) or 9 (long) per item — verify this per item before moving on, don't batch-trust it.

## Also fix: the master authoring prompts

`prompts/Biology Short FRQ Promp.txt` and `prompts/Biology Long FRQ Prompt.txt` are *mostly* right already but should be updated so future runs don't drift:
- Replace `(a)/(b)/(c)/(d)` labels with `Part A`/`Part B`/`Part C`/`Part D`.
- Replace the short-FRQ prompt's point spec (already correct at 1/1/1/1 — just relabel) and the long-FRQ prompt's "(2-3)/(2-3)/2/2" ranges with the CED's exact two patterns (1/3/3/2 default, 1/4/2/2 when Part B is graph construction) so it's deterministic, not a range.

## Validation pass — run before calling it done

1. Every one of the 142 items has exactly 4 `frq_criteria` rows, summing to exactly 4 (short) or exactly 9 (long) points.
2. Every stem literally shows "Part A" / "Part B" / "Part C" / "Part D" in order, no lowercase-letter or roman-numeral remnants.
3. No item with a `submitted` review decision had its existing version_id's stem/stimulus/criteria mutated in place — spot check a sample of the 78 Amjad-reviewed and however-many Adil-reviewed items to confirm new versions were created instead.
4. New part content is factually correct (re-derive/verify any calculations or mechanisms yourself, don't approximate) and doesn't duplicate or contradict the existing 2 parts.
5. Report back: how many items needed new-version forking vs. in-place edits, how many needed the 1/4/2/2 (graphing) pattern vs. 1/3/3/2, the 5-criteria long-FRQ outliers found and how you resolved them, and confirmation the validation pass came back clean (or what it caught and how you fixed it).

## After: review assignment

Any newly forked versions need review assignments created — check the current reviewer roster (`docs/activity_log/ACTIVITY_LOG.md`, most recent entries) for who's on Bio before assigning; confirm with David how the corrected batch should be split rather than assuming.
