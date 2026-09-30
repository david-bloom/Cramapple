# AP Calculus AB, Unit 1: original item batch (DRAFT, not applied)

**Batch id:** `calc-ab-unit1-original-2026-09-29`
**Status:** drafted, re-derived by its author, and passed the phase 4 two-family CED check (`CED_CONFORMANCE_REPORT.md`). **Nothing has been applied to any database, and nothing is published.**
**Governing protocol:** `docs/research/CONTENT_AUTHORING_AND_QA_PROTOCOL.md` (v0.4), `docs/research/ORLY_EXTERNAL_ASSIGNMENT_MINING_PROTOCOL_2026_08_24.md`
**Files:** `items.py` (the items), `verify_and_build.py` (verification + SQL), `20260929_apcalcab_unit1_original_batch.sql` (generated; safe to regenerate, but each run draws new answer positions)

## Provenance (protocol section 7.1: no column holds this yet, so it is recorded here)

| Field | Value |
|---|---|
| Authoring model | `claude-sonnet-5-5` (Claude Code session, 2026-09-29) |
| Fact pack | `docs/product/AP_CALCULUS_AB_BC_CED_FACT_PACK.md` (deep tier for Units 1-3) |
| Fact-pack constraints applied | epsilon-delta not assessed; DNE cases limited to unbounded / oscillating / mismatched one-sided; Practice 4 not assessed in MCQ; IVT-complete rubric standard (not used here, no 1.16 items) |
| Calculator | none required; all items are no-calculator |

## Originality statement

Every problem was designed from the CED topic list, the fact pack, and general skill descriptions.
The author read three third-party homework packets (topics 1.13, 1.14, 1.15) for **topic scope and the
kinds of skills practiced only**. No stem wording, function, number set, answer choice or rubric language
was taken from them, and no problem from them was paraphrased or reshaped ("same shape, new numbers").
Where a draft distractor coincided with a textbook expression that also appears in a packet, it was replaced
(two replacements: item 008 choice B, item 014 choice B). The packets are not stored in this repository.
The author compared the finished items against the packets by eye; there is no automated originality check.
Per the mining protocol these packets look like licensed-curriculum material, so they are treated as the
more restricted case and should be entered in `docs/research/orly_source_log/SOURCE_LOG.md` with that flag.

## Coverage (Calc AB Unit 1)

| Topic | MCQ added | FRQ added | Notes |
|---|---:|---:|---|
| 1.1 | 2 | 0 | |
| 1.2 | 2 | 0 | |
| 1.3 | 0 | 0 | **Not covered: graph-based topic. Needs image stimuli.** |
| 1.4 | 1 | 0 | |
| 1.5 | 2 | 0 | |
| 1.6 | 0 | 0 | already has 3 MCQ |
| 1.7 | 2 | 0 | |
| 1.8 | 1 | 0 | |
| 1.9 | 2 | 1 | |
| 1.10 | 2 | 0 | |
| 1.11 | 1 | 0 | |
| 1.12 | 2 | 1 | |
| 1.13 | 4 | 1 | previously 0 MCQ |
| 1.14 | 4 | 1 | previously 0 MCQ |
| 1.15 | 4 | 1 | previously 1 MCQ, 0 FRQ |
| 1.16 | 0 | 0 | already has 2 MCQ and 2 FRQ |
| **Total** | **29** | **5** | 34 items |

All 5 FRQs are short (`frq_form='short'`, `practice_format='targeted_drill'`), 4 points each, 1 point per criterion.
All items are pure Unit 1, so each qualifies for the single-unit serving-label lane (DECISION-0066); none is multi-unit.

## What was verified, and what that does and does not mean

**Done (author, this session):**
- Every MCQ answer and every FRQ numeric claim was recomputed with sympy from the problem's own expression
  (`verify_and_build.py`). The script computes first, then asserts the keyed text matches and that each
  distractor's error pattern really does produce the wrong value. All 29 + 5 agree.
- Structural QA (protocol phase 2): 4 distinct non-blank choices with rationales; criterion keys unique;
  FRQ points sum to 4; no non-ASCII math; no duplicate content keys.
- The correct-answer letter was drawn at random per item from OS entropy, then the whole draw was resampled
  until no letter held more than 10 of 29 keys. Final distribution: see the header of the generated SQL (it is re-drawn each time `verify_and_build.py` runs, so the figure on disk is the one that counts; last run A 6, B 6, C 7, D 10). (Feedback rule: never a fixed or hand-picked position.)

**Not done, and required before any publish:**
1. **Independent re-derivation by someone other than the author** (protocol section 9, a publish precondition). The
   verification above is the author checking their own work with a tool; it catches arithmetic and key errors but not a
   misconception the author shares. A fresh context must re-solve every item without reading the keys.
2. ~~Two-family CED-conformance check (phase 4).~~ **Done 2026-09-29**, DeepSeek v3.2 + Gemini 2.5 Flash (Haiku excluded as same family as the author). 33 of 34 cleared by both; FRQ 003 flagged by both and adjudicated as a false positive against CED LIM-2.D.5. See `CED_CONFORMANCE_REPORT.md`.
3. **Human tutor review** (phase 3) and the reviewer assignment.
4. **Topic and serving-label assignment.** Items carry no `content_item_cells` rows and no serving labels; the topic
   column above is the author's intent only. Labeling must go through the normal pipeline (DECISION-0066 single-unit lane).

## Items a reviewer should look at first

- **MCQ 016** (largest set of continuity for `sqrt(x - 1)/(x - 4)`): relies on the AP convention that continuity at a domain
  endpoint is one-sided. The distractor "union of (1,4) and (4,infinity)" is a true statement that is not the largest set, so a
  student could argue it. Consider rewording to "on which set is f continuous at every point of its domain" or dropping it.
- **MCQ 011 and 012** overlap in skill (limit/continuity/discontinuity vocabulary); keep only one if the pool needs to be lean.
- **FRQ 003** has three unrelated parts in one 4-point item (context, radical asymptotes, growth rates). It is dense for a
  short FRQ; split it if reviewers agree.
- **MCQ 002 and 013 and 018** use a parameter/table setup that is standard for these topics; confirm they read as fresh, not templated.

## To apply (after the gates above, and only with David's per-action approval)

Development first, then Production, each its own approval. Follow runbook Traps 1 and 7 (commit the file under the version the
environment records; apply to Dev, verify, then Production). The SQL is wrapped in one transaction with an advisory lock and a
batch-already-seeded guard.


## Variants (added 2026-09-29)

**Pre-run answers (protocol section 2.1):** variants wanted: **yes, 3 per question**; axes: **numbers and context**. Checker models for the variants' CED check: **not yet chosen** (pick two from the section 3.2 menu).

**What exists:** 102 variants (87 MCQ, 15 FRQ), three for each of the 34 originals, in `variants_mcq_a.py`, `variants_mcq_b.py`, `variants_mcq_c.py`, `variants_frq.py`.
`build_variants.py` verifies them, checks word overlap, draws random answer positions, and writes `20260929_apcalcab_unit1_variants_batch.sql`
(not applied), `variants_manifest.json` (variant -> original, topic, what changed) and `variants_ced_items.json` (input for the CED script).
Variants are separate `content_items` with keys `apcalcab-{mcq,frq}-u1v-NNN-vK`, never new versions of the originals.

**How they were made:** authored by four parallel Claude subagents from the originals, then nine low-context MCQ variants were sent back for a rewrite.
Every MCQ variant recomputes its correct answer with sympy (`calc`) and, where a distractor is a numeric slip, that slip too (`wrong_calcs`).
Every FRQ rubric claim has an exact check. The author of all variants is Claude, so the same writer-independence rule applies to their checkers.

**What has and has not been done for the variants:**
- Done: author-side sympy verification; structural QA; word-overlap check (stem plus choices, Jaccard); random answer positions.
- **Not done: phase 4 CED check, phase 3 human review, independent section 9 re-derivation.** Nothing here is published or in a database.
- Known weak spots: 16 MCQs still overlap 0.61-0.69 with their originals (mostly short symbolic items), and the three 016 siblings
  overlap 0.73-0.82 with each other; FRQ siblings overlap 0.6-0.78 by design (same part layout and rubric structure).
  Reviewer attention first: 025-v3 (`1/(tan x - 1)` on [0, pi], subtle), 016 variants (a single template), the FRQs whose part (c)
  ends in a different discontinuity type than the original (004-v1, 004-v2), and the conceptual MCQs 003 and 007 whose checks are weaker.
- Open question: whether the serving layer avoids showing sibling variants back to back. Not verified.
