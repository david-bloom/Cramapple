# QA Report — Work Order C (AP Statistics Existing-Answer Segmentation)

**Disposition: ACCEPTED.** All 34 segmentations are sound and every stated invariant recomputes
true. C is the cleanest of the four runs QA'd so far.

**But the content it segmented is not.** The highest-severity finding here is not against C at all:
the published canonical answers for the 14 `APSTATS-SFRQ-*` items **are the rubric text**, already
live in Production. C preserved them verbatim because that is exactly what it was told to do.

This line is the DECISION-0055 independent cross-model QA gate for work order C. It ratifies nothing.

- **QA model:** Claude Opus 5 (non-OpenAI, independent of the Codex builder), 2026-09-23
- **Producer:** Codex, snapshot `2026-09-23T02:10:13Z`, run end `02:13:50Z`
- **Production:** `pcntajvbdfqhbeewmdry`, read-only throughout. No writes. The prior Biology record in
  `apbio_frq_segmentation_2026_09_22/` was read for precedent only and not modified.

## What was verified

Every count recomputed from Production or the artifacts before `SUMMARY.md` was read.

| Invariant | Independent result | Verdict |
| --- | --- | --- |
| 80 published AP Statistics FRQ; 34 with a canonical answer | 80 / 34 from Production | Confirmed |
| Packet matches Production | 9 of 9 field aggregates identical across all 80 items | Confirmed |
| **Packet matches work order B's packet** | 9 of 9 identical, despite snapshots 24 minutes apart | Confirmed |
| Scope partition with B | C 34 + B 46 = 80; **0 collisions, 0 orphans** | Confirmed |
| Spans concatenate exactly to `full_text` | 34/34 | Confirmed |
| `full_text` equals the stored `canonical_answer_1` | 34/34 — **no text was authored** | Confirmed |
| Every span verbatim in its named source field at its stated offset | 34/34, 0 failures | Confirmed |
| No invented criteria | 0 violations | Confirmed |
| Declared uncovered == actually uncovered | exact match on all 34 | Confirmed |
| Removing any one criterion never empties the answer | 34/34 | Confirmed |
| The 46 out-of-scope items untouched | 0 proposal rows | Confirmed |
| 122 criteria, 108 covered, 14 uncovered | 122 / 108 / 14 | Confirmed |

The cross-packet agreement matters: the work order asked QA to **prove** the two snapshots agree
rather than assume it, since B and C read Production at different times. They do, byte for byte.

## Two things a careless QA would get wrong here

**1. All 105 spans cite `canonical_answer_1` and none cite `canonical_answer_2`.** That looks exactly
like the defect that damaged the prior Biology run, which "read only `canonical_answer_1` and ignored
`canonical_answer_2` on all 52 items that had one." It is not. I queried Production directly:
**0 of the 80 published AP Statistics FRQ has a nonblank `canonical_answer_2`.** The defect class
cannot occur in this subject. C's single-field sourcing is correct.

**2. The 14 uncovered criteria are all honest.** Every one falls on an `APSTATS-HDG-2026-GRAPH-*`
item, and every one is a criterion about the *drawn artifact* — `AXIS_LABELS`, `POINTS_PLOTTED`,
`SEGMENT_LABELS`, `BOXPLOT_SCALE`. A text answer cannot label an axis or plot nine ordered pairs. The
14 non-graph items have 42 criteria and **zero** uncovered. C marked these uncovered and drafted
nothing, which is precisely what the work order demanded: "An honest uncovered criterion is a
finding; invented text is a defect."

## The finding that matters: published answers that are rubric text

The `APSTATS-SFRQ-*` canonical answers, live in Production, read like this:

> `a1) States the median is 22 minutes. b1) Describes the distribution as right-skewed and identifies
> 41 as a potential outlier. c1) Computes the mean as about 23.7 minutes and says the mean is greater
> than the median.`

That is the rubric's `learner_facing_text`, in third-person rubric voice, with criterion-key
prefixes. It is not what a student writes. A student answer is "The median commute time is 22
minutes."

Measured across 134 span-by-criterion pairs, after stripping the `a1)` prefixes:

- Mean word-level similarity to the criterion's own text: **0.405** overall, **0.652** for the
  `APSTATS-SFRQ` family.
- **28 of 56** SFRQ pairs are at or above 0.85; **32** pairs overall are at or above 0.95, several
  character-identical. `APSTATS-SFRQ-013` criterion `a`: answer and criterion are both exactly
  "States H0: mu = 70 and Ha: mu != 70."
- **18 of the 34 in-scope items** carry at least one such span. **All 14 SFRQ items do.**

This is the same defect class work order B was explicitly warned about and successfully avoided
(B's authored spans score 0.167 with none above 0.70) — except here it is already published, and it
is what Open Hand shows a student as the full-credit exemplar.

**C is not at fault for the content.** It is mildly at fault for not flagging it: rule of engagement
2 requires that existing content which looks wrong be flagged rather than edited, and C raised 26
flags about uncovered criteria and span entanglement while saying nothing about segmenting text that
matches its own rubric near-verbatim. Recorded as C-QA-002, low severity.

## Corrected: the drawn-response items, and what is actually missing

**An earlier version of this report got this wrong.** It said the 14 uncovered criteria are
"structurally unearnable by text" and questioned C's scoping against work order A's. The Product
Owner corrected it, and the correction is right: **hand-drawn capture was built precisely so these
criteria can be earned.** The drawing earns them; the prose was never supposed to.

So C's uncovered markings are not a symptom of anything wrong — they are the correct division of
labour between the text canonical and the spatial one.

Verified read-only in Production, the pieces are further along than my first reading implied:

- **Capture is live.** `app.capture_pairing_tokens` (3 rows), `app.capture_pairing_events` (5 rows),
  and the `learner-uploads` bucket all exist in Production.
- **The spatial canonical already exists.** Every one of the 24 published hand-drawn items — 20 AP
  Statistics and 4 Biology — carries `prompt_json.expected_graph_spec`. For
  `APSTATS-HDG-2026-GRAPH-005` that is
  `{x_axis: "hours studied", y_axis: "test score", representation: "scatterplot with trend line"}`,
  which is exactly what `AXIS_LABELS` needs to be checked against.
- **Routing is declared.** 23 of 24 carry `rubric_type = 'spatial'`.

**What is missing is the verifier.** All 24 items carry `evaluator_strategy = 'human_shadow'`, and
the grading router maps that to target `shadow_review`. In
`supabase/functions/evaluate-attempt/index.ts:1482` that branch is commented as a hold — *"held for
human/shadow review until the declared verifier is wired in"* — and it awards no points. Production
does no human grading, so there is nobody at the other end of that hold.

**The practical consequence today:** a student can capture the drawing, and the attempt then holds
rather than scores. The content is ready and the capture is ready; Engine 4's spatial verifier is the
gap. That is a sequencing question for the Product Owner, not a defect in C, in the content, or in
the scoping of either work order. Recorded as C-QA-003.

Two smaller things surfaced while checking this, both recorded:

- **C-QA-006** — `APSTATS-HDG-2026-GRAPH-005` has `rubric_type` NULL where the other 19 carry
  `'spatial'`. It still routes correctly through the `evaluator_strategy` fallback, so the gap is
  latent rather than live. Work order I.2 already scopes `rubric_type` coverage.
- **C-QA-007** — `expected_graph_spec` may be too thin to verify everything it must. GRAPH-005's spec
  supports `AXIS_LABELS` but does not carry the nine ordered pairs that `POINTS_PLOTTED` requires;
  that data sits in `stimulus_table` instead. Worth auditing all 24 specs against their spatial
  criteria **before** the verifier is written rather than after.

## Segmentation granularity

38 of 108 covered criteria (35%) have no span of their own; mean over-strike 0.35. That is materially
better than work order B (81%, 0.82), and the difference is principled: C segments **published prose
it is forbidden to rewrite**, so residual entanglement is inherent to the source, not a choice. C
flagged every affected item with its count.

Unlike B's, this one cannot be fixed by re-cutting spans. It resolves only if the underlying answers
are re-authored — which C-QA-001 may force anyway.

## What this disposition does and does not authorise

**Does:** satisfies DECISION-0055's independent cross-model QA gate for work order C. The 34
segmentations may go to the Product Owner for ratification.

**Does not:** authorise any write to Production; endorse the underlying canonical answers for the 14
`APSTATS-SFRQ-*` items, which should not serve as grading exemplars until re-authored; or make the
24 hand-drawn items gradeable — they hold at `shadow_review` until Engine 4's spatial verifier is
wired, however good the segmentation and the capture are.
