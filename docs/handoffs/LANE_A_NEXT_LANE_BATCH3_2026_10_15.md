# Next figure lane, batch 3: skew direction and mean versus median (AP Statistics)

**STATUS:** built and verified in the renderers; **loaded to Development only.** **The app change is pushed but NOT merged and NOT published,
and Production is untouched.** The reason is a conflict with the More help release, below.
**DATE:** 2026-10-15. **Ruling:** `DECISION-0123` item 4, plus David's 2026-10-15 "Yes on 2, build and have lovable publish".

## What was built

Six figures on `density_curve`, on two entries that author no `items[]` (route (b), `DECISION-0116`):

| Entry | Figures |
|---|---|
| Statistics 1.6 "Skew direction is named by the longer tail" | `stats-skew-right`, `stats-skew-left`, `stats-skew-symmetric` |
| Statistics 1.8 "Mean vs. median under skew" | `stats-mean-median-right`, `-left`, `-symmetric` |

**The renderer change.** `density_curve` drew normal and chi-square curves only, so there was no left-skewed curve. A chi-square
curve now takes an optional `mirror_about`, reflecting it: `density(x) = chi2(mirror_about - x)`. One subtraction, identical in
`scripts/lane-a-pilot/render.py` and the app's `src/lib/figures/render.ts`, so the two stay byte-identical.

## Gates

- **4a:** 4,413 checks, 0 failed (85 figures). Two new property tests read the CURVE, not the words: the longer tail and the
  mean-versus-median relation are computed numerically from the density (right: mean above median and right tail longer; left: the
  reverse; symmetric: equal), and the dashed lines must sit at the computed mean and median.
- **4b eye pass at four widths:** all six legible, no defect. The mean and median lines are named with free text anchored to the
  side that keeps it clear of the other line, because two close vertical-line labels collide at the compact width.
- **4c two readers:** all six accepted by both; **controls 5/5 rejected**, all five word-only and all passing the property suite
  (a right-skewed curve called skewed left, the two lines named the wrong way round, the left-skew mean called larger, skew named
  for the side of the peak, a symmetric mean called far from the median).
- **Port parity (Bun):** **255/255** figure/layout pairs byte-identical across 23 families; `density_curve` 48/48.
- **App tests:** the figure and reference tests pass (210), including the six new figures in the regenerated catalogue fixture.

## The blocker: publishing the app would also publish More help

Lovable publishes `main`, which carries the More help feature for Calculus AB/BC and Chemistry, with **no feature flag**. Production
does **not** have its backend: the four migrations `20261014001227`, `20261014005146`, `20261014014023`, `20261014015127` are applied
in Development only (checked 2026-10-15). `MORE_HELP_SESSION_CLOSE_2026_10_14.md` says the production rollout is in progress and
lists "exact app publication" as a pending step. Publishing now would put a More help control on every Calculus and Chemistry
question in Production with nothing behind it. That is a decision for the Product Owner, not a side effect of a figure publish.

I do not know whether the live app already includes More help (the last published commit is not shown by the connector; the
project's latest commit is `7b81177`, the More help follow-up merge, equal to `main`).

## Options

1. **Hold** the app merge and publish until the More help rollout completes, then publish once. The six figures wait in Development.
2. **Publish now anyway**, accepting that Calculus and Chemistry students see a More help control that reports "isn't available yet".
3. **Roll out More help first** (its own approvals: four migrations, config, signed-in smoke), then publish and load these figures.

The app branch is `claude/reference-pack-production-68juff` (`ap-prep-blueprint#26`), which also carries the shared-hook
de-duplication fix. Merging it ships both. Neither is merged.

## To promote, once the publish question is settled

Merge `ap-prep-blueprint#26`, publish, verify the live bundle contains `mirror_about` (as for `APPROVAL-0162`), then load
`out/load_stats_next3_a.sql` and `_b.sql` to Production under a new `APPROVAL-`, with rollback
`update app.figures set status='retired' where source_note like '%batch=stats-next3-figures-2026-10-15%'`.
**Order is not optional:** a figure whose renderer the app does not know renders nothing, silently.
