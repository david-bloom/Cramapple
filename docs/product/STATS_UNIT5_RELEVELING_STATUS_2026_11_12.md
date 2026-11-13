# AP Statistics Unit 5 re-leveling status (2026-11-12)

**Scope:** Regression Analysis, topics 5.1–5.5, Production served pack `548f06be-ccf4-426d-b82b-b424137a4438`. Authoring follows the effective Fall 2026 AP Statistics CED. The older pilot pack `7c5a2975` is outside the serving and retirement scope.

## Read-only before audit

Command, run 2026-11-12 UTC from the pinned Production-linked worktree:

```sh
python3 scripts/difficulty-audit/audit.py --subject 'AP Statistics' --units 5 --out audit-stats-u5 --workdir /private/tmp/cramapple-unit5-statistics
```

The audit covered 21 published MCQs across two packs. Three topic 5.3 R1 pilot items have no serving labels and are excluded from this package. A direct Production query verified 18 published MCQs in the served pack, 17 with valid serving labels; `APSTATS-MCQ-033` was published but its serving label was invalid.

| Topic | Published, both packs | R1 | R2 | R3 | R1 share | R1 seed families in served pack |
|---|---:|---:|---:|---:|---:|---:|
| 5.1 | 1 | 1 | 0 | 0 | 100% | 1 |
| 5.2 | 3 | 3 | 0 | 0 | 100% | 3 |
| 5.3 | 10 | 9 | 1 | 0 | 90% | 6 (plus 3 unserved pilot items) |
| 5.4 | 4 | 2 | 2 | 0 | 50% | 2 |
| 5.5 | 3 | 3 | 0 | 0 | 100% | 3 |
| **Total** | **21** | **18** | **3** | **0** | **86%** | **15 served; 3 pilot excluded** |

The 15 proposed retire keys are in `retire_keys.json`. Each is a standalone R1 family in the served pack; none is an `-oht-` teaching item. The three unserved pilot items remain outside this package.

## Package and projected impact

`scripts/content-seed/apstats-harder-seeds-u5-2026-11-12/` contains three new seed families per topic, each with three variants: 15 seeds and 45 variants, 60 MCQs. The third family supplies the 12-item topic floor after R1 retirement. New topic labels use the verified Unit 5 taxonomy version `dae3c72e-82ca-4960-9552-1b034bd347e5` and `required_units=[5]`.

| Topic | Served published before | R1 families/items proposed for retirement | R1 retained | Existing R2 retained | New R2 seeds / variants | New R3 seeds / variants | Published after |
|---|---:|---:|---:|---:|---:|---:|---:|
| 5.1 | 1 | 1 / 1 | 0 | 0 | 2 / 7 | 1 / 2 | 12 |
| 5.2 | 3 | 3 / 3 | 0 | 0 | 3 / 9 | 0 / 0 | 12 |
| 5.3 | 7 | 6 / 6 | 0 | 1 | 3 / 9 | 0 / 0 | 13 |
| 5.4 | 4 | 2 / 2 | 0 | 2 | 2 / 8 | 1 / 1 | 14 |
| 5.5 | 3 | 3 / 3 | 0 | 0 | 3 / 8 | 0 / 1 | 12 |
| **Total** | **18** | **15 / 15** | **0** | **3** | **13 / 41** | **2 / 4** | **63** |

The projected final published set has 16 R2 seed families (13 new, three existing), 41 R2 variants, two R3 seed families, and four R3 variants. No R1 item remains in the served pack. Arithmetic: 18 old published − 15 retired + 60 new = 63. The invalid-label R1 item is among the retirements, so the projected 63 all have valid serving labels. The existing R2 items were retained for topic coverage and the floor. A cross-family and retained-old stem comparison found zero pairs with `difflib.SequenceMatcher` ratio above 0.80.

## Checks

- Format validator: 60 items / 15 seeds, passed. Package builder: seven load chunks, 60 new items, 15 retire keys.
- Blind answer check: DeepSeek 60/60 and Kimi 60/60 agree. No missing answers.
- Two-model tier audit: 0 R1, 54 R2, 6 R3; 0 disputed keys, 0 duplicate flags. Both models returned a tier for all 60 items. Model disagreements on tier remain, with the lower tier used in the table.
- Earlier draft iterations exposed a signed-residual key flag. Hand derivation confirmed `observed − predicted`; the residual family was rewritten to compare two observations, then rechecked. The final package has no key flags.
- Numeric premises were recomputed from the generator inputs: regression predictions, residuals, unit conversions, `r²`, and line-through-means predictions. Rationale text was read against each distractor pattern. Several variants retain a common operation with changed contexts and data; this is a content-diversity limitation.

## Release authority and limits

David directed execution of Unit 5 for Statistics, Biology, Calculus AB, and Calculus BC in chat on 2026-11-12, with separately authored AB and BC questions. He approved a one-time exception for these batches to use the handoff prompt's two-model blind solve and tier audit instead of the standing four-checker/planted-control protocol. See `APPROVAL-0257_STATS_UNIT5_PRODUCTION_2026_11_12.md` for this batch. No subject-expert review is claimed. Difficulty tiers are uncalibrated model judgments, not observed student performance.

**Execution state:** Prepared; update this section with Production write and selector evidence after execution.
