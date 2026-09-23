# QA Report — Work Order A (AP Biology Canonical-Answer Recovery)

**Disposition: ACCEPTED, with one rejected criterion — `APBIO-FRQ-S-073` criterion `a` must be corrected before it serves.**

This line is the DECISION-0055 independent cross-model QA gate for work order A. It unlocks work order F
for Codex. It is not Product Owner ratification, which remains outstanding for every proposed answer.

- **QA model:** Claude Opus 5 (non-OpenAI, independent of the Codex builder), 2026-09-23
- **Producer:** Codex, snapshot `2026-09-23T01:30:44Z`, run end `2026-09-23T01:41:24Z`
- **Branch:** `claude/qa-overnight-abcd-semantic`, from `main` at `360059a1`
- **Production:** `pcntajvbdfqhbeewmdry` (Cramapple – Production), read-only throughout. No writes, no migrations,
  no edge-function deploys. No file under `apbio_frq_segmentation_2026_09_22/` was read for anything but
  comparison, and none was modified.

## What this QA covered

Structural QA of A–D was completed on 2026-09-23 and passed. **This pass is the semantic gate**: does each
span actually earn the criterion it claims, does each authored number re-derive, and is each provenance label
true. Every count below was recomputed from Production or from the artifacts before `SUMMARY.md` was opened.

## Verification method

1. **Packet re-derived against Production.** MD5 and length of `canonical_answer_1` / `canonical_answer_2`,
   criterion counts and point sums, for all 75 current versions and all 56 prior versions named in the packet.
   **0 differences.** The packet is byte-exact, so it is a sound proxy for Production in every later check.
2. **Recovered spans verified verbatim.** All `recovered_ca1` / `recovered_ca2` spans checked against the
   named field at the stated `source_offset`, with the source version confirmed to belong to the same
   `content_item_id`. All 14 `recovered_parent` spans checked **directly in Production** with SQL
   `substring()` against retired parent `APBIO-FRQ-L-025` v4 (`b88a1376…`, 5,530 chars, md5
   `adfdcf38e52dcc624a32e7d018e4c2ed`). **0 failures; all 14 exact at the stated offsets.**
3. **Rubric integrity.** Every criterion has at least one span; no span names a criterion outside the stored
   rubric; every coverage list equals the stored rubric exactly. **0 violations.**
4. **Ledger reconciliation.** All 278 ledger rows cross-checked against the proposal's coverage blocks and
   `prior_run_drafted`. **0 disagreements.**
5. **Semantic review.** All 13 recovered criteria and all 88 drafted span-to-criterion pairs read against
   their stem, stimulus and criterion. Every numeric claim re-derived independently.

## Independently confirmed claims

| Claim in `SUMMARY.md` | Independent result | Verdict |
| --- | --- | --- |
| Packet 75/75 items, 278/278 criteria | 75 packet rows, 278 ledger rows, md5-identical to Production | Confirmed |
| 41/41 rubric-split items, byte-identical answers | Re-derived from Production: 41/41 have a finer current rubric **and** byte-identical `canonical_answer_1/2` | Confirmed |
| Proposal covers 71/71 in-scope items | 71 | Confirmed |
| 118 prior-run drafted = 101 in-scope + 17 out-of-scope | Recounted from the prior run's own `criteria_drafted`: 118 total, 17 on the four GRAPH items, 101 in scope; A's `prior_run_drafted` matches the prior record item-for-item | Confirmed |
| 13 recovered, all from parent `L-025` | 13 fully recovered, all on S-101/102/103, all from `L-025` v4 | Confirmed |
| Span provenance counts (six classes) | Exact match on all six | Confirmed |
| Spans concatenate to `full_text` | 71/71 | Confirmed |
| Nine point-total mismatches | Re-derived: all nine are `total_points=8` vs rubric sum 9, exactly the nine items the work order named | Confirmed |
| Four GRAPH items out of scope | Present in packet and ledger, absent from the proposal | Confirmed |
| Reused prior segmentation on 28 items | 28 items have at least one `unchanged_from_prior_run` span (19 are wholly unchanged) | Confirmed |
| Same-item source invariant FAILS on 14 parent spans | Confirmed, and correctly self-reported rather than quietly passed (A-001) | Confirmed |

`assembly_literal`, a sixth provenance value not named in the work order, is used for 140 spans totalling 280
characters — every one a bare `\n\n` separator carrying zero criterion keys. It is what makes exact
concatenation possible and is not a defect.

## The recovery yield, and why it was low

The work order's hypothesis was that the 2026-08-12 rubric split left recoverable text in prior versions.
**The mechanism was real; the yield was near zero, and the reason is stronger than "the split created new
criteria."**

For all 41 rubric-split items the prior version's canonical answers are **byte-identical** to the published
ones — independently re-derived here from Production. Recovering "from the prior version" is therefore
logically identical to reusing the current answer, which the accepted prior run had already done. **There was
never any additional text to recover for those 41 items.** The only genuinely new source in scope was the
retired parent `APBIO-FRQ-L-025`, and that is precisely where all 13 recoveries came from.

Codex identified this and disclosed it in `open_questions.csv` A-004 rather than burying it. The honest
headline is:

- **13 of 101** in-scope prior-drafted criteria fully recovered
- **6 more** partly recovered (they retain a drafted span alongside recovered text)
- **82** still fully drafted

**GAP-9's drafted-content problem is confirmed real, not a migration artifact.**

## The 13 recoveries

All 13 are on the three items split from retired parent `APBIO-FRQ-L-025`, and all 13 earn their criteria.
The work order's instruction to map by content rather than label was followed correctly: the parent's `(a)(i)`
supplies both `a-i` and `a-ii`; `(a)(ii)` → `a-iii`; `(a)(iii)` → `a-iv`; `(b)(iii)`'s two reasons become
`b-iii` and `b-iv`; `(d)`'s three lines become `d-i`, `d-ii`, `d-iii`.

Both numeric claims re-derived independently against the stored stimulus:

- **S-102 `b-ii`** — Table 1 gives Human–Gorilla 4.0%; calibration 1% ≈ 2 Mya; 4.0 × 2 = **8.0 Mya**. Correct.
- **S-101 `a-iii`** — the character matrix (A 0000, B 1000, C 1100, D 1110, E 1111) yields **(A,(B,(C,(D,E))))**
  with A as outgroup. Correct.

`S-103` `c-ii`'s whales–hippopotamus example is factually right and is one of the two examples the criterion's
evidence requirement names.

## The 88 drafted criteria

One factual error, reported as **A-QA-001** and the reason for the single rejection:

> **APBIO-FRQ-S-073 `a` (2 points).** The drafted span says that after meiosis II "four cells each contain one
> chromosome represented by a single chromatid". The stem specifies **2n=4**, so each of the four haploid
> products holds **two** chromosomes. Meiosis II separates sister chromatids; it does not reduce chromosome
> number. The span's own first half is correct, and the item's retained canonical text ("meiosis II separates
> sister chromatids") contradicts the second half — the error is detectable from the item alone.

Every other drafted span is biologically sound. All 21 quantitative drafted spans re-derived correctly,
including S-011 `a2` (rr = 80/500 → q² = 0.16, q = 0.4, p = 0.6, 2pq = **0.48**), S-045 `b` (**1/16**),
S-047 `b1` (**1:2:1**), S-038 `b2` (2–4 ATP by substrate-level phosphorylation) and S-097 `a1` (~20-nt guide
RNA). S-046 `b2`'s "always receives Xᴮ from her father" is correct **for this item**, whose stem fixes the
father as `X^B Y`. S-051 `b1` is a case where the drafted text is *more* accurate than the criterion it serves
("relatively few genes" for "the fewest genes").

The method concern is **A-QA-002**: a large share of the drafted content restates its own criterion rather
than answering from the stem — mean similarity 0.582, 3 pairs character-identical. That is not a spec
violation, but it means these 88 criteria cannot be validated against the rubric they were copied from, and
they are thin as post-submission exemplars. It belongs in front of the Product Owner at ratification.

## Disagreements recorded where the proposal is still structurally valid

- **A-QA-003** — three items carry a `fully_drafted_answer` flag that their own coverage blocks contradict.
- **A-QA-004** — 46 uncredited sentence-spans across 33 items sit ahead of drafted spans restating the same
  point, so the assembled answers say things twice. This follows the work order's "fill gaps; do not replace"
  rule and is reported as a visible-quality issue, not a violation.
- **A-QA-005** — the S-102 `b-iii`/`b-iv` connective entanglement is disclosed in `SUMMARY.md` prose but
  carries no `cross_criterion_entanglement` flag. A mechanical scan of all 261 in-scope criteria found this to
  be the corpus's **only** connective-fragment span, so the content risk is contained; the gap is in the flag
  channel.

## What this disposition does and does not authorise

**Does:** satisfies DECISION-0055's independent cross-model QA gate for work order A, and unlocks **work order
F** for Codex.

**Does not:** ratify any answer. All 71 proposals remain proposals. Nothing here authorises a write to
Production, and `APBIO-FRQ-S-073` criterion `a` must be corrected before that item serves students or is used
to calibrate a grader.

**Still open and not in A's scope:** the nine `total_points=8` vs rubric-sum-9 mismatches (recorded, unfixed);
the four `APBIO-HDG-2026-GRAPH-*` items, which need a spatial canonical on the Engine 4 path and cannot be
served by text.
