# QA Report — Work Order E (AP Statistics Topic Labels, Rework)

**Disposition: ACCEPTED, except six items — `APSTATS-HDG-2026-GRAPH-007`, `-013`, `-014`, `-015`,
`-016`, `-017` — which are REJECTED and must move from `1.8` to `1.9` before this proposal serves.**

This line is the DECISION-0055 independent cross-model QA gate for work order E. It is not Product
Owner ratification, which remains outstanding for all 384 labels.

- **QA model:** Claude Opus 5 (non-OpenAI, independent of the Codex builder), 2026-09-23
- **Producer:** Codex, snapshot `2026-09-23T13:09:08Z`
- **Proposal branch:** `codex/project2-2026-09-23` at `b043e2ae`
- **Production:** `pcntajvbdfqhbeewmdry`, read-only throughout. No writes, no migrations. Nothing in
  `bio_stats_topic_tagging_2026_09_22/` (the prior record) was modified.

## Context

`bio_stats_topic_tagging_2026_09_22` was QA'd on 2026-09-22: **Biology accepted, Statistics
rejected** on 56 items across four template-shaped defect classes. E is that rework. The bar it had
to clear was not "is the structure valid" — the rejected run's structure was flawless too — but "are
the labels right."

## Verification method

Every count below was recomputed from Production or from the artifacts before `SUMMARY.md` was read.

1. **Closed list re-derived from Production.** `app.taxonomy_topics` at
   `dae3c72e-82ca-4960-9552-1b034bd347e5`: **55 topics, 5 units, `subject_key` `ap_statistics`,
   confidence `verified`.** Matches the work order exactly.
2. **Packet re-derived against Production**, field by field for all 384 items — `content_item_version_id`,
   `version_num`, `item_type`, and md5 of `stem` and `stimulus`. **0 differences.**
3. **Label integrity.** Every proposed code checked against the closed list; every `proposed_unit`
   and `proposed_topic_title` checked against the registry row for that code.
4. **Defect-class before/after**, recomputed per class rather than trusting the summary.
5. **An independent signal the builder did not claim to use:** 140 items encode a unit.topic in their
   `content_key` (`apstat-u<unit>-<topic>-*`). Checked every one against the proposal.
6. **Semantic review** of all 20 graph items, all 11 sampling items, the 20-item `apstat-4b-compare`
   family, and a random sample of 14 label changes that had neither an author key nor a defect class.

## Independently confirmed

| Claim | Independent result | Verdict |
| --- | --- | --- |
| 384 published AP Statistics items | 384 from Production | Confirmed |
| Packet matches Production | 0 differences across all 384, on ids, versions, types, stem and stimulus hashes | Confirmed |
| Closed list: 55 topics, 5 units | 55 / 5, `verified` | Confirmed |
| Every code in the closed list | 0 outside it, 0 `undetermined` | Confirmed |
| Unit and title match the registry | 0 mismatches of either | Confirmed |
| No duplicate items | 0 duplicate `content_key` | Confirmed |
| 56 unique defect-class items, 0 retaining a wrong code | 20 + 11 + 20 + 5 = 56, 0 retained | Confirmed |
| Largest concentration `1.9` at 10.7% | 41/384 = 10.7%, down from 45% on two codes | Confirmed |

**The four commissioned defect classes are genuinely fixed.** Every one of the 56 items changed code,
and the replacements are correct in three of the four classes:

- **`comparison_mislabel` (20):** all `1.7` → `1.9`. Correct.
- **`sampling_method_mislabel` (11):** all `4.1` → `1.11`. Correct — each is a "which choice best
  describes the sampling method?" MCQ, and the `apstat-u1-11-*` keys independently corroborate 1.11.
  Items whose correct answer is "voluntary response" or "convenience" are still method
  *identification* (1.11), not the consequences of bias (1.12), and 1.12 is used correctly elsewhere
  in the corpus on 23 items.
- **`unit_misclassification` (5):** all `1.3` → Unit 5 (`5.3` ×4, `5.2` ×1). Correct.
- **`generic_graph_stem` (20):** 14 correct, **6 wrong** — see below.

## The rejection: six boxplot items

`GRAPH-007`, `-013`, `-014`, `-015`, `-016`, `-017` each present the same task:

> "A [role] compared [quantity] for two groups. Construct **side-by-side boxplots** from the
> five-number summaries using one common scale. Then **compare** the typical [quantity] and the
> spread in context."

Three of each item's four rubric criteria are comparison criteria ("Uses one interpretable common
scale for **both groups**", "Correctly **compares** medians in context", "Correctly **compares** IQR
or range in context"). These are labelled **`1.8` — "Graphical Representations of Summary Statistics
for One Quantitative Variable"**. They belong in **`1.9` — "Comparisons of the Distributions for One
Quantitative Variable"**.

This is **the same defect shape that caused the original rejection**: a two-group comparison filed
under a one-variable topic. It is the work order's own root cause 2 — "adjacent-topic ties were
resolved consistently in the wrong direction" — recurring in a family the work order did not name.

In fairness: this is an adjacent-topic call, not an absurdity. Constructing a boxplot from a
five-number summary is genuinely 1.8 content, and these items do both things. But the dominant
construct is comparison, AP's own treatment places comparative boxplots in 1.9, and **E's own
`SUMMARY.md` states the rule that resolves it** — "Both compare-two-groups templates were assigned
1.9." It simply was not applied to the graph family. A corpus-wide scan of everything labelled
1.5/1.6/1.7/1.8 found exactly these six items carrying two-group comparison language, so the error is
bounded and complete. (`STATS-MOD3-H006` also matched the scan and is correctly `1.6` — it describes
one bimodal distribution, not two groups.)

The other 14 graph items are correct. My initial concern that a boilerplate stem ("Submit one
photograph…") could not support a confident label was wrong: the **stimulus** carries the full task
and data, exactly as the work order's root cause 1 anticipated, so deriving a topic is right and
`undetermined` would have been over-cautious here.

## A finding that cuts the other way: the prior run was worse than its QA established

140 of the 384 items encode a unit and topic in their own `content_key`
(`apstat-u<unit>-<topic>-*`) — an independent author signal that E does not list among its
`evidence_fields_used`.

- **The rejected run agreed with it on 9 of 140 (6%).**
- **E agrees on 140 of 140 (100%).**

E changed 320 of 384 labels (83%), and 264 of those changes were outside the four commissioned defect
classes. That looked at first like uncommanded churn. It is not: **131 of those changes are
corroborated by a signal neither run claimed to use.** The 56 items the original QA confirmed wrong
were a floor, not a ceiling.

The 20-item `apstat-4b-compare-*` family is a good example — previously `4.3` ("Justifying a Claim
Based on a Confidence Interval"), now `1.9`. The items give two groups' means and SDs and ask whether
the data support a claim that one group is *always* higher. There is no interval and no test; it is
descriptive comparison reasoning. `1.9` is right and `4.3` was wrong, and this family was never in
the commissioned scope.

A random sample of 14 further changes with neither an author key nor a defect class found no clear
errors. Two are arguable — `APSTATS-SFRQ-003` (`5.1`, where `5.3` may fit better) and `APSTATS-MCQ-084`
(R² at `5.3`, where `5.5` may fit better) — and `SFRQ-003` is one of the 14 already flagged medium.

## Confidence is not usable for triage

Zero `undetermined`, zero `needs_human`, zero open questions, zero low confidence: 370 high, 14
medium. **All six rejected items are marked `high`.**

The 14 medium rows are all `APSTATS-SFRQ-*` with basis `legacy_metadata_crosswalk`, so confidence is
tracking *metadata provenance*, not *topical ambiguity*. A genuinely ambiguous adjacent-topic call —
precisely the 1.8/1.9 boxplot decision — is indistinguishable from a certain one. The work order
enabled the `undetermined` sentinel specifically because the prior run emitted zero; this run also
emitted zero. That is recorded as E-QA-002, and it is the thing most worth changing before the next
labelling order.

## What this disposition does and does not authorise

**Does:** satisfies DECISION-0055's independent cross-model QA gate for work order E.

**Does not:** ratify any label. All 384 remain proposals. Nothing here authorises a write to
Production or to `app.content_taxonomy_labels`. The six rejected items must be relabelled `1.9`
before this proposal serves, and GAP-1 is not closed for AP Statistics until that happens and the
Product Owner approves.
