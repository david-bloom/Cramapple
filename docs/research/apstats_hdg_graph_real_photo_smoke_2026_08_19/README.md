# AP Statistics hand-drawn graph grading — 20-photo smoke test — 2026-08-19

**Trigger:** `docs/GRADING_ENGINES_TO_PRODUCTION_HANDOFF.md` UPDATE 2026-08-18d
§3 and §8 item 3 — Statistics had ground truth for 40 items
(`apstats_hdg_graph_corpus_2026_08_18/`) but **zero accuracy measurement of
any kind**, despite holding the majority of `human_shadow` content (40 of 59
tagged items). This is a smoke test before committing to a full-corpus run,
per the user's explicit request.

## What this is

20 real photos from `docs/hand drawn samples/Stats-HRD-2/` (of 28 total,
selected deterministically — first 20 sorted by filename, via
`select_apstats_smoke_subsample.mjs`), covering 5 of the corpus's 6
archetypes (missing only `boxplot_construction_interpretation`, which has no
photographed response in this sample folder).

Same method as the Biology real-photo benchmark: single-pass `openai/gpt-5.2`,
full-page uncropped images, one joint-judgment call per photo asking for an
`earned`/`not_earned`/`unable_to_determine` status per rubric criterion.

**Gold labels are genuine**, built by direct visual inspection of all 20
photos against each item's `student_prompt` / `display_table` /
`criterion_definitions` (same method used for the Biology 200-photo gold:
`docs/research/HAND_DRAWN_REAL_PHOTO_GRADING_ACCURACY_2026_08_18.md` "Grade
them yourself first"). Not an assumption that every response is fully
correct — several are partial credit.

Scripts: `select_apstats_smoke_subsample.mjs`, `apstats_hdg_graph_smoke_run.mjs`
(both in `scripts/vercel-gateway-check/`). Gold: `gold/apstats_smoke_gold_labels_2026_08_19.json`.
Raw run output: `runs/apstats_smoke_gpt52_results.jsonl`.

## Headline result

| Metric | Value (n=20 photos, 80 criteria) |
|---|---:|
| Exact criterion-vector match | 13/20 = 65.0% |
| Per-criterion F1 | 93.8% (precision 100%, recall 88.4%; 61 TP / 0 FP / 8 FN / 11 TN) |
| False-accept rate (gold `not_earned` → predicted `earned`) | 0/11 = **0.0%** |
| False-reject rate (gold `earned` → predicted `not_earned`) | 8/69 = 11.6% |

**Zero false accepts is a genuinely different profile from Biology**, where
`gpt-5.2` on the full 200-photo corpus ran 18.4% FAR / 7.9% FRR (better than
`gpt-4o-mini`'s 30.6%/20.5% but still failing DR-1). Here it's the opposite
shape — no false accepts, all the error is false rejects — on a sample small
enough (n=11 not-earned instances) that this could easily not hold at scale.
**Do not treat 0% FAR as a real number yet; treat it as "worth confirming on
the full 40-item corpus," the same lesson this program already learned once
from the 21-photo escalation pilot reversing at 105-photo scale.**

## Two real, distinct findings from the 8 mismatches

### 1. A mosaic-plot-specific model defect: rationale contradicts verdict

4 of 5 mosaic-plot items (023, 024, 025, 026 — not 027) show `WIDTHS_BY_TOTAL`
scored `not_earned` by the model despite all three of that item's
category-totals genuinely being equal (100/100/100), meaning equal-width
columns are the objectively correct construction. **On two of these
(GRAPH-024, GRAPH-026) the model's own rationale text reasons its way to the
correct conclusion — "since all totals are equal, equal widths are
acceptable" / "since totals are equal this is consistent" — and then still
outputs `not_earned` as the final criterion status.** This is a real,
reproducible self-contradiction between stated reasoning and emitted verdict,
not a defensible stricter reading (contrast with the `ASSOCIATION_DESCRIPTION`
disagreements below, which are a legitimate stricter-rubric-reading, not a
self-contradiction). On GRAPH-025 and GRAPH-027 the model instead claims a
specific visual difference in the drawn column widths that gold's inspection
did not find — possibly a genuine visual misjudgment, not yet independently
re-verified pixel-by-pixel.

**This finding also caught a real gold-labeling error**: GRAPH-023's `Bike`
row sums to 80, not 100 (unlike every other row in the 027/026/025/024/023
set, which all sum to 100) — meaning unequal widths are actually *correct*
for that one item, and gold's original "earned" call (built from an
unverified assumption that all mosaic rows summed to 100) was wrong. Fixed
in the gold file after the model's disagreement prompted a direct recheck
against the corpus table. **Worth a general lesson: verify the arithmetic
premise behind any "equal is correct here" gold call per-item, not once for
the archetype.**

Not yet scoped: whether this WIDTHS_BY_TOTAL defect is prompt-fixable (e.g.
demanding the verdict restate the numeric comparison before committing to a
status) or needs a larger sample to confirm it generalizes past mosaic plots.

#### Follow-up: does escalating to Sonnet fix it? Yes on this bug specifically, but no net improvement

Re-ran the same 5 mosaic photos with `anthropic/claude-sonnet-4.5` (same
prompt, same gold) via `SMOKE_MODEL=anthropic/claude-sonnet-4.5
SMOKE_ONLY_ITEMS=... node apstats_hdg_graph_smoke_run.mjs`. Results:
`runs/apstats_smoke_sonnet45_mosaic_results.jsonl`.

| | exact/5 | TP | FP | FN | TN | F1 |
|---|---:|---:|---:|---:|---:|---:|
| `gpt-5.2` (mosaic subset) | 1/5 | 14 | 0 | 5 | 1 | 84.8% |
| `claude-sonnet-4.5` (mosaic subset) | 1/5 | 14 | 1 | 5 | 0 | 82.4% |

**The specific rationale/verdict self-contradiction is gone** — Sonnet's
`WIDTHS_BY_TOTAL` reasoning and verdict agree on all 5 items (4 correct, 1
wrong the honest way: it explicitly reasoned "Bike should be slightly
narrower... this is close enough to earn credit" on GRAPH-023, a defensible
but over-lenient tolerance call, not a contradiction). But it **introduces a
new, different failure mode**: on 4 of 5 items it withholds
`AREA_OR_COUNT_REASONING` credit because the response says "largest
*percentage*" instead of "largest *count*", even though every one of these
items has equal group totals (100 each), so percentage and count are the
same number and the response correctly named the right group every time.
That reads as overly literal phrasing-policing rather than a real content
error. Net effect on this narrow 5-item slice: **same exact-match count,
slightly lower F1** — escalating traded one bug for a different one rather
than fixing net accuracy. Not a reason to rule out Sonnet generally (it
fixed a real defect cleanly), but not a demonstrated net win either on this
sample size — would need a larger run, and possibly a rubric clarification
on "count" vs "percentage" phrasing tolerance, to know which model is
actually better here.

### 2. Dotplot skew-direction terminology reversal (response-authoring artifact, not a model bug)

3 of 4 dotplot responses (028, 029, 031) describe the distribution's shape
using "bias" toward where the **bulk** of the data sits (e.g. "left bias"
for a distribution whose bulk is low and tail is high) — which is the
**opposite** of the standard AP Statistics skew-naming convention (named for
the tail: that same distribution is *right*-skewed). This is a real,
consistent authoring pattern in this specific response set, not a one-off
typo — worth checking whether other Stats-HRD photo batches share it before
assuming it is representative of real student behavior. Gold scored these
strictly against the rubric's literal term (`not_earned`) all three times.
`gpt-5.2` did not commit a false accept on any of them (all `not_earned`
matched gold's `not_earned` where checked) — this pattern didn't produce a
model error in this sample, it's flagged because it's a corpus-authoring
observation worth knowing about before writing a fuller gold set.

### Also present: scatterplot point-idealization (5/5 items, gold-vs-real-data issue, not a mismatch)

All 5 scatterplot-regression-context photos (032, 033, 034, 035, 036) draw
points as a smooth idealized monotonic line rather than the actual supplied
noisy pairs (the real tables all have a genuine non-monotonic bump or dip
that the drawings do not reproduce). Gold scored `POINTS_PLOTTED` as
`not_earned` on all 5, and **`gpt-5.2` correctly agreed on all 5** — this is
not one of the 8 mismatches, it's included here because it's a striking,
consistent pattern across every single response of this archetype in the
sample and is worth knowing about for any future gold-set or corpus-quality
work on this archetype specifically.

### `ASSOCIATION_DESCRIPTION` disagreements (033, 036) — legitimate strictness difference, not a defect

Gold credited these two because their interpretation text stated the
correct direction and the correct strength word ("strong negative"). The
model withheld credit because the text doesn't explicitly state the
form ("roughly linear") or reference the variables by name ("in context").
Both readings are defensible against the rubric's literal wording
("Describes strong negative roughly linear association in context") — this
is a real rubric-interpretation boundary case surfaced by the smoke test,
not a clear model error. Worth a governance decision (how literal should
"in context"/"form" enforcement be) before it affects a larger run's numbers.

## What this does and does not tell you

- **Does not** replace the dual-human-adjudicated gold standard
  (`CONTENT_GOVERNANCE_AND_VALIDATION.md` §12.2) any more than the Biology
  200-photo AI-provisional gold does — same caveat applies here.
- **Does not** cover `boxplot_construction_interpretation`, the 6th
  archetype, at all (no photo available in this sample).
- **Does** establish, for the first time, that Statistics is gradeable with
  the same method/model as Biology, gives a first (small-n) accuracy
  estimate, and surfaces two concrete, actionable findings (the mosaic-plot
  self-contradiction, the dotplot terminology pattern) worth investigating
  before scaling to the full 40-item corpus.

## Cross-model comparison: does escalating to Sonnet, or ensembling, help?

Ran the full 20-photo set through `anthropic/claude-sonnet-4.5` (same prompt,
same gold): `runs/apstats_smoke_sonnet45_full_results.jsonl`.

| | exact/20 | F1 | FAR | FRR |
|---|---:|---:|---:|---:|
| `gpt-5.2` | 13/20 = 65.0% | 93.8% | 0/11 = 0.0% | 8/69 = 11.6% |
| `claude-sonnet-4.5` | 9/20 = 45.0% | 87.7% | **4/11 = 36.4%** | 12/69 = 17.4% |

**Sonnet alone is worse here, and specifically worse on false accepts** — the
mosaic-only subset (previous section) made Sonnet look at worst neutral;
across the full 20 photos it has a real FAR problem `gpt-5.2` does not.
Traced all 4 of Sonnet's false accepts: it re-credited exactly the two things
gold marked `not_earned` for good reason elsewhere in this same report —
the scatterplot idealized-line issue (`GRAPH-036 POINTS_PLOTTED`), the
dotplot skew-terminology reversal (`GRAPH-029`/`028 SHAPE_DESCRIPTION`), and
the one genuinely-unequal-totals mosaic item (`GRAPH-023 WIDTHS_BY_TOTAL`,
Bike=80). `gpt-5.2` got all four of these right.

### Does ensembling the two models help? Only the cautious version.

Compared per-criterion across all 80 judgments (20 photos × 4 criteria):

| Combination rule | Coverage | Accuracy on covered | Notes |
|---|---:|---:|---|
| **Escalate on disagreement** (only auto-grade where both models agree) | 60/80 = 75% | 58/60 = **96.7%** | Safe: 2 shared-wrong cases are a genuine blind spot both models hit the same way and ensembling cannot rescue (`GRAPH-021` region), but no new FAR risk introduced. |
| **Trust "earned" on disagreement** (auto-resolve, no escalation) | 80/80 = 100% | 74/80 = 92.5% | **Looks better in aggregate but is not safe** — see below. |

The "trust earned" rule's 92.5% number is misleading: of its 20
disagreements, exactly **4 have gold `not_earned`, and all 4 are the same
false-accept cases listed above** — the rule is defined to always resolve
toward the more generous verdict, so it inherits every one of Sonnet's false
accepts by construction. It only looks good here because in this sample
`gpt-5.2` never disagreed with Sonnet on a case where `gpt-5.2` itself was
the lenient one. That's a property of this specific 20-photo sample, not a
property of the rule — at scale, "trust earned" will systematically absorb
whichever model is more lenient on whatever it's lenient about. **Escalate-
on-disagreement is the direction worth pursuing further; auto-resolve-to-
earned is not, despite its higher raw accuracy on this sample.**

This is the same shape of lesson the Biology Engine 4 work already learned
from self-consistency majority-voting and from the escalation-at-scale
reversal: the safe move buys real precision at a real coverage cost, and a
shortcut that looks better in aggregate can be hiding a systematic bias that
only shows up once you check *which* cases it's resolving, not just how many.

## Tier-1 follow-up (n=10): does an explicit numeric tolerance clause fix the boundary disputes? No — and the failure mode is informative.

Hypothesis (from the cross-model comparison above): `WIDTHS_BY_TOTAL` and
`POINTS_PLOTTED` disagreements trace to undefined qualifiers ("proportional",
"recoverable locations"), the same class of problem written-response grading
fixed by tightening rubric-boundary language. Tested directly:
`apstats_hdg_graph_smoke_tolerance_run.mjs` appends an explicit numeric
tolerance clause to just those two criteria's `met_rule` text at prompt-build
time only (corpus file and gold untouched), run on all 10 tier-1 photos (the
5 mosaic + 5 scatterplot items) on both models.

| | exact/10 | F1 | Notes |
|---|---:|---:|---|
| gpt-5.2 baseline | 4/10 | 87.7% | |
| gpt-5.2 + tolerance clause | 2/10 | 84.2% | **Worse.** Still wrong on all 4 of the same `WIDTHS_BY_TOTAL` false-rejects, plus a new false-accept on `GRAPH-023` (previously its one correct call). |
| sonnet-4.5 baseline | 3/10 | 84.7% | |
| sonnet-4.5 + tolerance clause | 1/10 | 70.6% | **Much worse.** Flipped `WIDTHS_BY_TOTAL` from mostly-lenient-mostly-right to uniformly-skeptical-mostly-wrong (024/025/026 now wrong, previously correct), plus a new `GRAPH-027` outright generation failure ("No object generated: could not parse the response") and a new `POINTS_PLOTTED` false-accept on `GRAPH-034`. |

**The tolerance clause did not resolve gpt-5.2's rationale/verdict
self-contradiction — it made the hedging more visible.** Its rationale on
the tolerance-prompted `GRAPH-026` retry: *"...all totals are 100, so equal
widths would be proportional—however in the image the columns appear not
exactly equal? On inspection they look essentially equal; but the rubric
expects proportionality within 5 percentage points and equal totals should
produce equal widths."* — the model visibly argues with itself mid-rationale
and still lands on the wrong verdict despite explicitly stating the correct
premise twice. Adding more rubric text gave it more to hedge around, not a
resolution.

**Conclusion, corrected after checking the noise floor:** the original
write-up compared each condition from a single run per model and attributed
the whole accuracy swing to the tolerance clause. That's not supportable —
re-running the *unmodified* baseline prompt a second time on the same 10
photos (`runs/apstats_smoke_gpt52_rerun2_results.jsonl`,
`runs/apstats_smoke_sonnet45_rerun2_results.jsonl`) shows real run-to-run
noise from the model alone, with no prompt change at all:

| | exact/10 | F1 |
|---|---:|---:|
| gpt-5.2 run 1 | 4/10 | 87.7% |
| gpt-5.2 run 2 (same prompt, rerun) | 4/10 | **77.8%** |
| gpt-5.2 + tolerance clause | 2/10 | 84.2% |
| sonnet-4.5 run 1 | 3/10 | 84.7% |
| sonnet-4.5 run 2 (same prompt, rerun) | 3/10 | 82.1% |
| sonnet-4.5 + tolerance clause | 1/10 | 70.6% |

For gpt-5.2, the two identical-prompt runs disagree with each other on 5 of
40 criteria (12.5%) and swing F1 by nearly 10 points on their own — bigger
than the tolerance clause's apparent effect (87.7%→84.2%). **The original
claim that the tolerance clause made gpt-5.2 measurably worse is not
supported; that swing is within the model's own noise band.**

What *does* survive the noise check: `WIDTHS_BY_TOTAL` on `GRAPH-024/025/
026/027` was wrong in **all three** independent gpt-5.2 runs (both
baselines and the tolerance-fixed one) — 12/12 consistent wrong verdicts.
That specific defect is real and reproducible, not noise, and the tolerance
clause specifically did not fix it. `GRAPH-023` flipped only in the
tolerance run (both baselines got it right) — with just one tolerance-run
sample that single flip can't be cleanly separated from noise either.

For Sonnet, the picture is different: the two baseline runs disagree on
only 2 of 5 `WIDTHS_BY_TOTAL` judgments (023, 024), but the tolerance run
flips **all five** to `not_earned`, in a uniform direction neither baseline
run showed. That's a larger, more directional shift than the observed
noise band — plausibly a real (if crude, over-triggered) effect of the
tolerance clause on Sonnet specifically, unlike gpt-5.2 where the same
clause produced no detectable change beyond noise. This is still a
single tolerance-run sample per model, not a repeated-tolerance-run
confirmation — treat it as directional, not settled.

**Net, corrected conclusion:** the tolerance clause did not fix gpt-5.2's
`WIDTHS_BY_TOTAL` defect (which is real and reproducible on its own,
independent of the clause) and plausibly made Sonnet's version of the same
judgment worse in a specific, directional way — but the aggregate
exact-match/F1 comparisons from the original single-run A/B are not
reliable evidence on their own; several of the individual criterion flips
attributed to the intervention are within normal run-to-run noise. The
verdict-consistency-defect hypothesis for gpt-5.2 still stands (it's the
part confirmed stable across 3 runs); the "tolerance clause actively harms
accuracy" framing does not, at least not for gpt-5.2. **Do not extend the
tolerance-clause fix to tier 2 (n=25-30) as currently written** — not
because it's confirmed harmful, but because it's confirmed *not helpful*
for the one thing it was designed to fix, which is reason enough to not
scale it up.

## Tier-1 fix, take 2 (n=5, run twice): precompute the expected widths instead of describing tolerance

Motivation: every `WIDTHS_BY_TOTAL` rationale across all 15 prior gpt-5.2
samples computed the group totals correctly — the model's arithmetic was
never the problem. So instead of asking the model to both derive the
correct ratio *and* visually judge the drawn widths in one pass (and
describing the tolerance more precisely, which didn't help — see above),
`apstats_hdg_graph_smoke_precomputed_widths_run.mjs` computes the exact
expected width percentages from `display_table` in plain code (no model
call) and hands them to the model as a given fact, narrowing its job to
just the visual comparison.

Run twice (not once) specifically because of the noise-floor lesson above:

| | exact/5 | F1 |
|---|---:|---:|
| baseline run 1 | 1/5 | 84.8% |
| baseline run 2 | 1/5 | 69.0% |
| tolerance-clause run | 0/5 | 82.4% |
| **precomputed-widths run 1** | **4/5** | **97.3%** |
| **precomputed-widths run 2** | **4/5** | **97.4%** |

`WIDTHS_BY_TOTAL` specifically, across all 5 runs (3 old + 2 new):

| item | gold | baseline×2, tolerance×1 | precomputed×2 |
|---|---|---|---|
| `GRAPH-024/025/026/027` | earned | **wrong in all 12** | **correct in all 8** |
| `GRAPH-023` | not_earned | not_earned, not_earned, earned | not_earned, earned (still noisy) |

The reproducible defect (024-027 wrong in every prior run, 12/12) is now
reproducibly fixed (correct in both new runs, 8/8) — a clean reversal, not
a single-sample fluke, confirmed the same way the previous fix's failure
was confirmed: by rerunning before trusting it. `GRAPH-023` — the one item
where widths genuinely *should* differ (Bike totals 80 vs Car/Bus's 100,
a real but modest ~8-point gap, 35.7%/35.7%/28.6%) — is still inconsistent
across runs; this is the same item that was already the noisiest across
every previous test in this report, consistent with it being a genuinely
harder visual call (a smaller, subtler true difference) rather than a new
problem this fix introduced.

**This confirms the specific hypothesis from the "resolve in repair, not
grading" discussion**: the model's descriptive/arithmetic content was
already reliable; the failure was in re-deriving that content visually
inside the same call as the judgment. Moving the arithmetic out of the
model's job (not just describing it more carefully) fixed the reproducible
part of the defect. Not yet tested on Sonnet, on the other criteria with
similar undefined-tolerance shapes (`POINTS_PLOTTED`, `ASSOCIATION_
DESCRIPTION`), or at tier-2 scale.

## Does the precompute fix generalize to a different image type? Mechanism yes, result no — because the target wasn't actually broken

Extended `apstats_hdg_graph_smoke_precomputed_widths_run.mjs` to also handle
`dotplot_distribution_shape`'s `DOT_COUNTS` criterion — same mechanism
(count occurrences per value from `display_table` in plain code, hand the
model the exact expected histogram instead of asking it to tally the raw
list itself), applied to a genuinely different archetype (points on a
number line, not proportional column widths), on the 4 dotplot photos
(`028`-`031`). Run twice, same noise-check discipline as the mosaic test.

| | exact/9 (5 mosaic + 4 dotplot) | F1 |
|---|---:|---:|
| baseline (single sample, n=1 for dotplot) | 4/9 | 89.7% |
| precomputed facts, run 1 | 7/9 | 96.8% |
| precomputed facts, run 2 | 8/9 | 98.4% |

The combined number looks good, but it's entirely the mosaic fix carrying
it. `DOT_COUNTS` specifically:

| item | gold | baseline (n=1) | precomputed run 1 | precomputed run 2 |
|---|---|---|---|---|
| `028` | earned | earned | earned | earned |
| `029` | earned | earned | earned | **not_earned** |
| `030` | earned | earned | earned | earned |
| `031` | earned | not_earned | **not_earned** | earned |

3 of 4 correct in the one baseline sample, 3 of 4 correct in each
precomputed run — same hit rate, just a different item wrong each time.
That's the shape of ordinary noise, not a reproducible defect and not a
fix. **`DOT_COUNTS` was never broken the way `WIDTHS_BY_TOTAL` was** — the
mosaic defect was specifically that the model's rationale reliably computed
the right answer and then contradicted itself; dotplot counting didn't show
that pattern in the baseline, so there was nothing for the precompute step
to fix. Only 1 baseline sample exists for dotplots (the `rerun2` baseline
was scoped to mosaic+scatterplot only), so this reads as suggestive, not
conclusive — a second dotplot baseline run would be needed to confirm
`DOT_COUNTS`'s baseline noise band precisely.

**Lesson: "precompute the deterministic fact" is a fix for a specific kind
of failure (model's stated reasoning is reliable, its final verdict isn't),
not a general-purpose accuracy lever.** Applying it where that specific
failure isn't present costs a prompt-complexity increase for no measurable
gain. Worth checking per-criterion whether the reproducible-contradiction
pattern is actually present before applying this fix elsewhere, rather than
assuming it will help anywhere a table-derived fact exists.

## Full-corpus baseline noise floor (n=20, run twice): FAR holds, FRR doesn't, and the dotplot gap is filled

The earlier noise check only covered the 10 tier-1 photos (mosaic +
scatterplot). Reran the full, unmodified 20-photo baseline a second time
(`runs/apstats_smoke_gpt52_full_rerun2_results.jsonl`) — same prompt, same
gold, no changes — to get a real noise floor across every archetype,
including dotplot, whose `DOT_COUNTS` noise band was previously
unmeasured (flagged explicitly above as a gap).

| | exact/20 | F1 | FAR | FRR |
|---|---:|---:|---:|---:|
| run 1 (original baseline) | 65.0% | 93.8% | 0/11 = **0.0%** | 8/69 = 11.6% |
| run 2 (identical prompt, rerun) | 60.0% | 89.6% | 0/11 = **0.0%** | 13/69 = 18.8% |

**FAR is now confirmed at 0% across two independent full runs, not one** —
this is the strongest evidence yet that gpt-5.2's error on this corpus is
concentrated entirely in false rejects, not false accepts, and it's no
longer resting on a single-sample fluke. Exact-match and FRR are noisier
(65.0%→60.0%, 11.6%→18.8%), consistent with the tier-1 noise check above —
across all 80 criteria, 5 flipped between runs (6.2%), and in this
particular pair **all 5 flips went the same direction** (run 1 correct →
run 2 wrong), which is a property of this one pair of runs, not a proven
directional bias — a third run would be needed to know if FRR-ward drift
is a real tendency or just what happened to come up twice.

`DOT_COUNTS` noise floor, now measurable (previously only 1 baseline
sample existed for dotplots):

| item | gold | baseline run 1 | baseline run 2 |
|---|---|---|---|
| `028` | earned | earned | earned |
| `029` | earned | earned | **not_earned** |
| `030` | earned | earned | earned |
| `031` | earned | **not_earned** | **not_earned** |

This changes the read on `031` specifically: wrong in **both** independent
baseline runs, which looks more like a small reproducible miss than pure
noise (its own gold rationale already noted a plausible cause — dots
stacked closely near value 1-2, a genuinely crowded/ambiguous region of
that specific photo) — worth a closer look on its own, separate from the
`DOT_COUNTS`-in-general question this section was checking. `029` flipping
between the two runs (and also flipping in one of the two precomputed-facts
runs above) does read as ordinary noise on a closer call, not a
reproducible defect.

## GRAPH-031 investigated directly: same defect family as WIDTHS_BY_TOTAL, not a genuine crowding issue

Flagged above as newly-looking-reproducible once the dotplot baseline noise
floor was filled in (wrong in 2/2 baseline runs). Pulled the `DOT_COUNTS`
rationale text from all 4 available gpt-5.2 runs on this photo (2 baseline,
2 precomputed-facts) and re-inspected the photo directly against the
corpus table (`1,2,2,2,3,3,3,3,4,4,5,11` — 12 values).

**In all 4 runs, the model's own stated tally is identical and correct**:
"1 dot at 1, 3 dots at 2, 4 dots at 3, 2 dots at 4, 1 dot at 5, 1 dot at 11
(12 total)" — matching gold exactly, matching this session's own original
gold-labeling pass. But in 3 of the 4 runs it then invents an *additional*
13th dot beyond that already-complete, already-correct list, at three
different phantom locations across the three runs ("near the top-left,
not aligned with any labeled value" / "the dot at 1 should not be present"
/ "an extra dot at 0") — each contradicting its own tally, not agreeing
with each other on what the phantom element even is. Only the one run that
dropped this claim landed on `earned`.

**Confirmed directly by the user against the actual photo: the true counts
are 1/3/4/2/1/1 at values 1/2/3/4/5/11 — 12 points, no 13th dot anywhere.**
This settles it: there is no genuine ambiguity or crowding artifact behind
the model's phantom-dot claims — it is fabricating a disqualifying element
against a photo that has none, not resolving a real close call the way
`GRAPH-023`'s narrower-Bike-column judgment was.

**This is the same defect family as `WIDTHS_BY_TOTAL`** (reliable stated
facts, unreliable final verdict), manifesting as a fabricated disqualifying
element instead of a stated-then-contradicted premise. It is not a genuine
image-crowding issue — there's no real ambiguity in the dot count itself,
which is presumably why the precomputed-facts fix only partially worked
here (1 of 2 runs fixed) instead of the clean 2/2 seen on mosaic plots:
handing over the correct count doesn't stop the model from also claiming
it sees an extra mark that isn't there.

## Tier 2 (n=28, all real Stats photos, run twice): the honest full-corpus number

Extended gold to the 8 previously-unused `Stats-HRD-2` photos (5
`boxplot_construction_interpretation` — filling the one archetype that had
zero coverage all session — and 3 more `segmented_bar_graph_construction`),
built the same way as every other gold record this session (direct visual
inspection against `student_prompt`/`display_table`/`criterion_definitions`).
This is now **every real Stats photo that exists** — 28 of 28, the ceiling
this program can reach without new photo capture.

Ran `openai/gpt-5.2` across all 28 with the precompute fix applied wherever
targetable (mosaic `WIDTHS_BY_TOTAL`, dotplot `DOT_COUNTS`) and the plain
baseline prompt everywhere else, twice, same noise-check discipline as
every other result in this report.

| | exact/28 | F1 | FAR | FRR |
|---|---:|---:|---:|---:|
| tier-2 run 1 | 18/28 = 64.3% | 94.8% | 2/13 = 15.4% | 8/99 = 8.1% |
| tier-2 run 2 | 18/28 = 64.3% | 94.2% | 2/13 = 15.4% | 9/99 = 9.1% |

Remarkably stable in aggregate — identical exact-match count, F1 within 0.6
points, **and the exact same two false accepts in both runs**:
`GRAPH-023 WIDTHS_BY_TOTAL` (the genuinely-narrower-Bike-column case, wrong
in every run of this photo all session regardless of fix) and
`GRAPH-014 VARIABILITY_COMPARISON` (the garbled-but-directionally-correct
numbers case — a legitimate grading-strictness dispute, not a clear
defect). A stable, reproduced FAR source is a much stronger finding than a
single-run FAR number — **this supersedes the earlier "FAR confirmed 0%"
claim**, which only held on the 20-item corpus before boxplot/segmented-bar
coverage existed. 9 of 112 criteria (8.0%) flipped between the two runs,
consistent with every other noise measurement in this report.

**The precompute fix looks real but weaker on this larger, more diverse
set than tier-1 suggested**: targeted criteria (`WIDTHS_BY_TOTAL` +
`DOT_COUNTS`, 9 judgments) were correct 6/9 and 8/9 across the two tier-2
runs (~78% average) — clearly better than the ~0-33% baseline correct rate
established earlier, but well below tier-1's 8/8 and 7/9. Consistent with
`GRAPH-025` and `GRAPH-029` (the two dotplot/mosaic items that flipped
between runs here) being genuinely harder cases, not a sign the fix stopped
working — but a real, honest downgrade from the tier-1 read, which is
exactly why this scale-up was worth doing before trusting tier-1's numbers
as final.

The 8 new boxplot/segmented-bar items' mismatches (`013` five-number-value
precision, `014` above, `019` relative-frequencies) continue to read as
genuine close calls rather than the fabrication pattern found in
mosaic/dotplot — no `WIDTHS_BY_TOTAL`-style self-contradiction observed in
either new archetype so far.

## Recommended next step

Run the full 40-item Statistics corpus (all `human_shadow` Stats content, not
just the 28 photographed here) once more real photos exist for the missing
archetype and the remaining 8 Stats-HRD-2 photos are added, specifically to
confirm or reverse the 0% FAR and to get a large-enough `not_earned` sample
to trust. Investigate the mosaic-plot `WIDTHS_BY_TOTAL` self-contradiction
directly (re-run 024/026 alone, inspect whether it reproduces) before
assuming it will recur at scale.
