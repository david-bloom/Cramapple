# Codex Task: Validate, Then Correct, AP Physics FRQ Structure Against the Real CEDs

**Context:** Following the AP Biology FRQ structure fix (`CODEX_AP_BIOLOGY_FRQ_STRUCTURE_CORRECTION_2026_07_25.md`), the same class of problem was found in AP Physics — but bigger. This task has two phases. **Do not start Phase 2 until Phase 1 is complete and reported back**, because the exact scope of the correction depends on numbers Phase 1 has to establish, some of which are not yet confirmed.

## Phase 1: Validate

### 1a. Establish ground truth from the primary source for all 4 subjects

Four real College Board CED PDFs are in the shared Drive (folder referenced in `docs/research/PHYSICS_CONTENT_EXPANSION_2026_07_24.md`), file IDs:

| Subject | Drive file ID | Status as of 2026-07-25 |
|---|---|---|
| AP Physics 1 | `1cgb6SQ1YWzwoD1lNTVJ6TZEP17ypDHeg` | **Verified directly against the source**: exactly 4 FRQs — Question 1 Mathematical Routines (MR) = 10 pts, Question 2 Translation Between Representations (TBR) = 12 pts, Question 3 Experimental Design and Analysis (LAB) = 10 pts, Question 4 Qualitative/Quantitative Translation (QQT) = 8 pts. 40 points total. Source: "Scoring Guidelines for Question N: [name] — [X] points" headers late in the PDF, near the sample-exam section. |
| AP Physics 2 | `1oE15zOd6YqBJ_MIgrg34s_toAT8_GbEq` | Reported as identical to Physics 1 (MR=10, TBR=12, LAB=10, QQT=8) by a prior pass, but **not yet independently confirmed against this specific document** — re-verify it yourself, don't assume it matches Physics 1 just because they're sibling algebra-based courses. |
| AP Physics C: Mechanics | `16Oh-XnX2d9nGFTovmVJelWlK_f_37w80` | **Unconfirmed.** Confirmed only that the exam has "Free-response: 4 questions" using the same 4 archetype names (Mathematical Routines / Translation Between Representations / Experimental Design and Analysis / Qualitative/Quantitative Translation). The actual per-question point values were NOT found — the PDF is >10MB and hit tooling limits on both a direct download and a natural-language extraction (the latter truncated partway through Unit 6, well before the exam-information/scoring-guidelines section near the end). A previous pass guessed "15 points each" but explicitly flagged this as *not* sourced from the document — treat that number as unverified, do not use it without confirming it yourself. Find a way to read the full document (page-range export, chunked retrieval, or ask David for a local PDF copy) and get the real numbers. |
| AP Physics C: E&M | `1n5CKL7v5kyliZ2yN2VxDVHBHUASWIeqN` | Reported as MR=10/TBR=12/LAB=10/QQT=8 by a prior pass, but that report did not include verbatim quotes as evidence, so it's unconfirmed — could be a copy of the Physics 1/2 pattern rather than an actual read of this document. Re-verify independently.

For each subject, extract and quote **verbatim** (not paraphrased, not "standard AP Physics is usually...") the actual per-question point breakdown, and if a given FRQ type has a further sub-part breakdown (e.g. Part A/B/C worth specific point counts within a 10-point question), extract that too — check whether the CED shows this level of detail the way the Bio CED did with its "Part A/B/C/D" breakdown.

### 1b. Audit current state against that ground truth — full audit, not a sample

For each of the 4 subjects, query every `frq` content item (not just a 20-item sample — get the true total):

```sql
select ci.content_key, ci.frq_form, civ.prompt_json->>'archetype' as archetype,
  (select count(*) from app.frq_criteria fc where fc.content_item_version_id = civ.id) as n_parts,
  (select coalesce(sum(points_possible),0) from app.frq_criteria fc where fc.content_item_version_id = civ.id) as total_points
from app.content_items ci
join app.content_item_versions civ on civ.content_item_id = ci.id and civ.version_num = (select max(version_num) from app.content_item_versions v2 where v2.content_item_id = ci.id)
where ci.content_key like '<subject-prefix>-frq-%'
order by ci.content_key;
```

Report, per subject: total FRQ count, how many already carry a correct `archetype` tag in `prompt_json` matching one of the 4 real archetype names, the actual point distribution found (min/max/histogram), and how far that is from the real per-archetype requirement. Also check: are there existing items tagged to each of the 4 archetypes at all, or do most items have no archetype tag (generic `frq_form: short/long` only)?

**Do not repeat the mistake a prior pass made**: the real CED's "4 FRQs" describes a single student's exam that day, not a target count for the content bank. A practice bank should have *many* items per archetype. The correction target is "every FRQ item, tagged to its correct archetype, built to that archetype's real point/complexity requirement" — not "shrink the bank to 4 items total." If you find yourself concluding the bank needs fewer items, stop and re-read this paragraph.

### Report back before proceeding to Phase 2

For each of the 4 subjects: confirmed point structure (with verbatim CED quotes as evidence), current DB state (full counts, not sampled), and the size of the gap. Flag anything ambiguous — in particular, whether the CED's real FRQs have sub-part breakdowns (like Bio's Part A-D) that need to be matched exactly, or whether each FRQ is more monolithic and the point total is what matters most.

## Phase 2: Correct (only after Phase 1 is confirmed complete)

This is **not a mechanical relabel/reweight fix like the Bio one was.** Bio's gap was 2 missing parts within an existing 4-9 point item. Physics items are currently 2-6 points and need to reach 8-12+ points per the real archetype requirements — that's substantial new content, not restructuring existing content. Treat this as authoring work: expanding each item's scope to match its archetype's real complexity, not just changing numbers on existing criteria.

Before rewriting anything, decide (and report the decision, don't just proceed) between two approaches, since this is a real scope/cost call:
- **(a)** Expand every existing under-built FRQ in place/via new version to reach the correct point/complexity structure for its archetype.
- **(b)** Treat the current short items as a distinct internal practice-drill format (rename/re-scope them explicitly as such, not exam-representative FRQs) and author a separate, smaller set of new full-scale, archetype-correct FRQs alongside them.

Whichever direction, apply the same rules established for the Bio fix:
- **Versioning safety is critical and the stakes are higher than Bio here** — Physics reviewer Muhammad Saood Iqbal alone has already submitted review decisions on a large share of existing physics content (124+ decisions per the last roster check). Any item with a `submitted` decision in `app.content_review_decisions` must get a forked new `content_item_versions` row, never an in-place edit — check this per item, don't assume from aggregate counts. Create a `content_review_assignment` for every forked version; don't leave any orphaned like the first Bio pass did before it was caught.
- Original authorship only — no adapting real released FRQs or scoring guidelines; the CED's structural facts (question names, point totals) are fine to reference, actual question content is not (`docs/architecture/CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §3-4).
- Verify Physics 1/2 stay algebra-only (no calculus) and Physics C: Mechanics/E&M appropriately use calculus where the archetype calls for it — this boundary was checked during the original expansion and shouldn't regress.
- After each item is written, **run a fresh SELECT and report the literal query output** — do not report a value from memory or from what you intended to write. A prior pass on the Bio fix stated specific "verified correct" values that a fresh query proved false; independent verification against a live query, every time, is non-negotiable for this task.
- Work in small batches (5-10 items) and report back before continuing, rather than attempting the full set unsupervised in one pass — this is what caught real errors on the Bio fix that self-verification alone missed.

## Deliverable

A written report (before any Phase 2 execution) with Phase 1's confirmed numbers for all 4 subjects, verbatim CED evidence, full current-state audit, and a clear recommendation on the (a) vs (b) scope question above for David to approve before Phase 2 begins.
