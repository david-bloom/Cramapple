# Overnight Work Order Count Baseline — verified 2026-09-22

Every count asserted by Codex work orders A, B, C and D, re-verified from a clean read against
**Cramapple – Production** (`pcntajvbdfqhbeewmdry`), read-only, at session close on 2026-09-22.

**Purpose.** The work orders instruct Codex to proceed at ≤10% drift and report the delta. If a
morning `SUMMARY.md` reports a number that differs from its work order, this file decides which of
two things happened: **Production changed**, or **the builder's query is wrong**. Without a
timestamped baseline that distinction costs an hour of re-derivation.

**Result: 28 of 28 assertions verified exact. Zero drift.**

## A — AP Biology canonical recovery

| Assertion | Stated | Verified |
|---|---:|---:|
| Published Biology FRQ (latest version per item) | 75 | **75** |
| Rubric criteria across all 75 | 278 | **278** |
| Rubric split finer than prior version **and** answers byte-identical | 41 | **41** |
| Items with no canonical answer in either field | 7 | **7** |
| Items carrying `prompt_json.split_from` | 3 | **3** |
| Drawn-graph items (out of scope) | 4 | **4** |
| In-scope for segmentation (75 − 4) | 71 | **71** |
| `APBIO-FRQ-L-025` retired parent `canonical_answer_1` length | ~5,530 | **5,530** |
| Criteria the prior run marked `drafted` | 118 | **118** (across 48 items) |

The explicit 41-item list embedded in work order A was compared element-by-element against the
Production query result: **exact set match, no additions, no omissions.**

The 118 figure is recomputed from the prior artifact
(`apbio_frq_segmentation_2026_09_22/apbio_frq_segmentation.codex.jsonl`), not from Production,
since it describes that run rather than the database.

## B — AP Statistics canonical answers

| Assertion | Stated | Verified |
|---|---:|---:|
| Published AP Statistics FRQ | 80 | **80** |
| — with a canonical answer (out of scope) | 34 | **34** |
| — with **no** canonical answer (B's scope) | 46 | **46** |
| Of the 46, items having any prior version | 10 | **10** |
| Of those prior versions, ones carrying an answer | 0 | **0** |
| `apstats-frq-u12-005` criteria | 4 | **4** |
| `apstats-frq-u12-005` rubric points | 10 | **10** |

The "0 prior versions carry an answer" figure is the load-bearing one: it is why B is framed as
genuine generation rather than recovery, and why the order tells Codex not to spend the night
hunting for text that does not exist.

## C — AP Statistics segmentation

| Assertion | Stated | Verified |
|---|---:|---:|
| Published AP Statistics FRQ | 80 | **80** |
| In scope (existing canonical answer) | 34 | **34** |
| Out of scope (work order B owns these) | 46 | **46** |

B and C partition the same 80 items with no overlap, confirmed by construction: the two filters are
complements on `canonical_answer_1 IS NULL AND canonical_answer_2 IS NULL`.

## D — AP Calculus AB and AP Chemistry topic labels

| Assertion | Stated | Verified |
|---|---:|---:|
| Total published items | 241 | **241** |
| ap-calculus-ab FRQ | 62 | **62** |
| ap-calculus-ab MCQ | 60 | **60** |
| ap-chemistry FRQ | 51 | **51** |
| ap-chemistry MCQ | 68 | **68** |
| Items already carrying a valid CED topic code | 106 | **106** |
| — ap-calculus-ab FRQ | 20 | **20** |
| — ap-calculus-ab MCQ | 0 | **0** |
| — ap-chemistry FRQ | 37 | **37** |
| — ap-chemistry MCQ | 49 | **49** |
| Calculus AB closed list (`33b4408b-…`) topics | 81 | **81** |
| Chemistry closed list (`cbe3116f-…`) topics | 91 | **91** |

## Filters used

All counts take the **latest `version_num` per `content_item_id` where `status='published'`**.

- "No canonical answer" = `nullif(btrim(coalesce(canonical_answer_1,'')),'') IS NULL` **and** the
  same for `canonical_answer_2`. Blank-but-present strings count as absent.
- "Rubric split finer, answers byte-identical" = the item has a prior version at a lower
  `version_num`, the current version has strictly more `frq_criteria` rows than that prior version,
  and both canonical fields compare equal with `coalesce(x,'')`.
- "Valid CED topic code" = `substring(prompt_json->>'topic' from '^[0-9]+\.[0-9]+')` is non-null and
  exists in that subject's closed list. The registry stores `subject_key` with underscores
  (`ap_chemistry`) while content uses hyphens (`ap-chemistry`), and AP Biology is `ap_biology` in the
  registry against `biology` in content — **joining without normalising matches zero rows.**

## How to use this tomorrow

If a `SUMMARY.md` reports a count that differs from its work order:

1. Compare against this table. If this table also differs from the work order, Production changed
   after 2026-09-22 and the builder was right to proceed.
2. If this table matches the work order but the builder does not, **the builder's query is wrong** —
   treat every downstream number in that run as suspect, not just the one that differs.
3. Re-run these queries if anything wrote to Production overnight. Nothing should have: all four
   work orders are read-only, and `codex/overnight-2026-09-22` is a documentation branch.

Companion: `scripts/qa/overnight_qa_harness.py` recomputes the per-item invariants. This file
covers the population counts those invariants are scoped by.
