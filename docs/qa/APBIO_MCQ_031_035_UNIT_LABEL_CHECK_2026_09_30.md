# APBIO-MCQ-031 / -035 Unit-Label Suspicion — Closed, No Oct 2 Exposure

**Date:** 2026-09-30 · **Ran by:** Claude · **Status:** Closed for launch; one item for post-launch
**Origin:** `docs/research/apbio_serving_labels_2026_09_24/HANDOFF.md` and `u3_audit.csv` flagged
`APBIO-MCQ-031` (RTK dimerization) and `APBIO-MCQ-035` (somatostatin/Gi/cAMP) as suspected Unit 3/Unit 4
mix-ups. Carried into the 2026-09-30 session close as a Biology day-1 risk. **That framing was wrong.**
**Method:** Production read-only SQL. No writes.

## Finding 1 — Both items are unservable

| Item | Item status | Versions | Published versions |
|---|---|---|---|
| `APBIO-MCQ-031` | `reviewed_disapproved` | 1 | **0** |
| `APBIO-MCQ-035` | `reviewed_disapproved` | 1 | **0** |

Neither has ever been published. No selector can reach them, so a wrong unit label on either **cannot
affect a student on Oct 2 or any other day** until someone republishes them. The audit inspected labels
without checking publication state.

## Finding 2 — The label pattern that looked wrong is by design

117 of 160 published AP Biology items carry more than one un-superseded `content_taxonomy_labels` row.
That is not drift: labels are **scoped**. Each item legitimately holds one `coverage` row (what the item
assesses, from the 2026-09-22 topic tagging) and one `serving` row (which units gate it). The audit's
"15 unsuperseded serving labels containing Unit 3" are the serving-scope rows, sitting correctly beside
newer coverage rows.

## Finding 3 — The real disagreements, computed across every published item

Re-running the audit's question mechanically rather than by hand — published items whose live **serving**
label requires Unit 3 while the live **coverage** label assesses only topics outside Unit 3 — gives exactly
three:

| Item | Serving units | Coverage topics |
|---|---|---|
| `APBIO-FRQ-S-003` | `[3]` | `8.2` |
| `APBIO-MCQ-033` | `[3]` | `4.2` |
| `APBIO-MCQ-046` | `[3]` | `2.8` |

`APBIO-MCQ-030`, the third named N.1 case, is **not** a disagreement: its coverage topic is `3.3`, which
agrees with its serving label. The 2026-09-22 topic tagging already corrected `-033` on the coverage side;
only its serving row still says Unit 3.

## Why none of this gates Oct 2

The three Oct 2 flat-path selectors read no taxonomy labels at all:

| Function | Reads `required_units` | Reads `content_taxonomy_labels` |
|---|---|---|
| `app.select_biology_practice_items` | no | no |
| `app.select_ordinary_combined_practice_items` | no | no |
| `public.select_practice_frqs` | no | no |
| `public.select_unit_gated_practice_items` | **yes** | **yes** |

Only the unit-gated selector consults them, and unit-gated practice is explicitly post-launch in
`LAUNCH_RUNBOOK_2026_10_02.md`. **Serving-label unit correctness has no Oct 2 student impact.**

## Post-launch

Fix the three serving-scope rows above alongside the unit-gated work, and decide whether `-031`/`-035`
are ever republished — if they are, re-derive their labels first, since the audit's suspicion (both are
Unit 4 Cell Communication, not Unit 3 Cellular Energetics) still looks right on the content.
