# Content Pipeline Live Census — 2026-09-26

**Scope:** Read-only Production baseline for
`LAUNCH_PLAN_CONTENT_PIPELINE_2026_09_26.md` before Tier 3 Pair 3/4 and AP Calculus BC execution.

**Production project:** `pcntajvbdfqhbeewmdry`

## Method

The census joins each `status='published'`, non-retired exam-pack version to published content items,
the highest-version-number content version, the current non-superseded serving label, and
`app.content_item_difficulty`. Counts below include only rows where both the item and its latest version
are published.

This explicit pack filter is necessary because `app.servable_items_census()` currently scans every exam
pack version without filtering `exam_pack_versions.status` or `retired_at`. It therefore still reports the
retired AP Statistics pilot pack. That is a reporting-helper defect, not a recurrence of the dual-published
pack hazard: the explicit live-pack query found exactly one published, non-retired pack for every subject.

## Baseline

| Subject | Live items | Validated | Provisional | Held | Stale | Legacy | No current label | Difficulty |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| AP Biology | 118 | 23 | 21 | 11 | 1 | 19 | 43 | 118 |
| AP Statistics | 170 | 44 | 107 | 19 | 0 | 0 | 0 | 170 |
| AP Chemistry | 119 | 40 | 34 | 40 | 0 | 5 | 0 | 119 |
| AP Calculus AB | 122 | 7 | 72 | 43 | 0 | 0 | 0 | 122 |
| AP Precalculus | 117 | 27 | 82 | 8 | 0 | 0 | 0 | 117 |
| AP Physics 1 | 117 | 7 | 0 | 3 | 2 | 71 | 34 | 0 |
| AP Physics 2 | 68 | 1 | 0 | 1 | 3 | 63 | 0 | 0 |
| AP Physics C: Mechanics | 77 | 0 | 0 | 1 | 2 | 74 | 0 | 0 |
| AP Physics C: E&M | 97 | 1 | 0 | 0 | 1 | 78 | 17 | 0 |
| AP Calculus BC | 127 | 4 | 12 | 13 | 9 | 39 | 50 | 0 |

The `validated` column is intentionally stricter than older reports: it counts only live-corpus items.
Older tables that counted labels attached to items whose latest version is not published report higher
numbers and must not be used as current serving coverage.

## Baseline selector verification

Before new writes, `app.servable_items_census_selftest()` returned:

- `ok`: 93 probes;
- `skipped_capped`: 3 probes;
- `MISMATCH`: 0 probes.

The self-test's predicates match the real selectors for the probes it can verify, but its subject/pack
iteration shares the retired-pack filtering defect described above. Final post-promotion verification must
therefore pair the self-test with direct calls against only the published, non-retired pack versions.

## Interpretation

- Difficulty is complete for Biology and the four executed Tier 3 subjects: Statistics, Chemistry,
  Calculus AB, and Precalculus.
- The remaining five subjects have zero difficulty coverage and require Pair 3, Pair 4, and Calculus BC
  execution.
- Pair 1/2 generated substantial provisional-label queues. Criterion 3 remains open until eligible
  single-unit agreements are promoted under DECISION-0066, multi-unit agreements receive an independent
  third review, and the real unit-gated selector is called afterward.

## Post-execution census

After the Pair 3 label writes, the five remaining difficulty migrations, and the freshness-gated
single-unit promotion batch, Production was re-counted from the same explicit live-pack query:

| Subject | Live items | Fresh validated | Provisional | Held | Stale | Legacy | No label | Difficulty |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| AP Biology | 118 | 23 | 21 | 11 | 1 | 19 | 43 | 118 |
| AP Statistics | 170 | 67 | 84 | 19 | 0 | 0 | 0 | 170 |
| AP Chemistry | 119 | 65 | 9 | 40 | 0 | 5 | 0 | 119 |
| AP Calculus AB | 122 | 31 | 48 | 43 | 0 | 0 | 0 | 122 |
| AP Precalculus | 117 | 52 | 57 | 8 | 0 | 0 | 0 | 117 |
| AP Physics 1 | 117 | 77 | 17 | 23 | 0 | 0 | 0 | 117 |
| AP Physics 2 | 68 | 50 | 2 | 16 | 0 | 0 | 0 | 68 |
| AP Physics C: Mechanics | 77 | 0 | 0 | 1 | 2 | 74 | 0 | 77 |
| AP Physics C: E&M | 97 | 1 | 0 | 0 | 1 | 78 | 17 | 97 |
| AP Calculus BC | 127 | 4 | 12 | 13 | 9 | 39 | 50 | 127 |

Evidence:

- Pair 3 labels: `20260926233000_apphysics1_tier3_labels.sql` and
  `20260926233100_apphysics2_tier3_labels.sql`.
- Fresh single-unit promotion: `20260926233500_promote_fresh_single_unit_two_model_labels.sql`
  promoted exactly 216 labels. It excluded every multi-unit agreement and every label older than
  the current content version's last update.
- Difficulty: `20260926234000` through `20260926234400`, exactly 486 new rows. All ten live subject
  packs now have complete difficulty coverage.
- Post-promotion `app.servable_items_census_selftest()`: 82 `ok`, 14 `skipped_capped`, 0 mismatch.
  Direct `select_unit_gated_practice_items` calls against every live pack also returned the expected
  fresh validated pool, subject to the RPC's 50-row cap and hand-drawn exclusion.

Remaining label work is not hidden by these gains. Physics C Mechanics, Physics C E&M, and Calculus
BC still need their two-model relabel runs. The configured route sends packets through Vercel AI
Gateway to OpenAI and Gemini; that external transfer is awaiting explicit approval for Vercel as
the intermediary. Multi-unit provisional labels also remain queued for an independent third review.

The remaining two-model provisional queue contains 142 stale-by-timestamp single-unit labels and 92
multi-unit labels. Of the multi-unit set, 63 are fresh enough for third review now (Calculus AB 33,
Chemistry 8, Physics 1 17, Physics 2 2, Precalculus 2, Statistics 1); the other 29 must be relabeled
before any review-based promotion. These queues were not promoted by the 216-row batch.

## Quantity target check

The approved AP Biology-only target is 600 MCQs, 300 short FRQs, and 64 long FRQs. The current live
pack contains 43 MCQs, 59 short FRQs, and 16 long FRQs, leaving gaps of 557, 241, and 48 respectively
(846 total). Whether the other nine subjects receive equivalent targets remains a Product Owner
decision; no targets were inferred for them.
