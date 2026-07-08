# AP Statistics HDR Grading Experiment Prep -- 2026-07-06

**Status: NOT frozen, NOT authoritative, NOT approved.** This package assembles
the four inputs requested for Codex to run AP Statistics hand-drawn grading
experiments, using real photographed hand-drawn responses (David drew all 12
by hand and photographed them 2026-07-06, then redrew 11 of the 12 same-day
to add a missing written interpretation -- see "v2 redraw" below). It is a
draft assembled by Claude. See "What still needs to happen before Codex can
use this" below -- nothing here should be treated as frozen or gold until
that happens.

## v2 redraw (same day, 2026-07-06)

The original v1 photos (still kept as `{item_id}__hdr_photo.jpeg`) were
missing the written interpretive sentence each stem asks for, on 10 of 12
items (see the original finding below). David redrew all 12 items to add an
explicit "Interpretation:" sentence and re-photographed them
(`{item_id}__hdr_photo_v2.jpeg`). Proposed labels below are graded against
v2 for all 12 items.

**Result: 45 of 48 possible points across the 12 items** (up from 33/48 on
v1). Notes:

- **GRAPH-007's photo (`IMG_7026.jpeg`) simply hadn't finished syncing to
  the images folder** when it was first checked -- it appeared ~8 minutes
  after the other 10 v2 files. It was resubmitted; once found, it earns full
  credit (4/4), matching GRAPH-001's redraw.
- **GRAPH-002's redraw** ("larger relative frequency of app use," not
  specifically "weekly app use") was reviewed and confirmed `earned` by
  David (approver), 2026-07-06 -- since the stem only asks about weekly use,
  the identification is unambiguous in context. Recorded as a confirmed
  rubric-interpretation call, not an open gap.
- **GRAPH-010's redraw fixed the shape description but not the outlier
  call.** The new interpretation says "roughly unimodal with a slight right
  tail" (earning `SHAPE_DESCRIPTION`) but says nothing about 82 cm at all, so
  `OUTLIER_NOTE` is still `not_earned` regardless of which wording (original
  or corrected) applies -- see the note in `proposed_gold_labels.md` for the
  full explanation of why 82 cm is a *mild* (not obvious) outlier by the
  1.5xIQR rule, and why that's a pre-existing, already-documented finding in
  this repo (from `ap_statistics_graph_response_seed_2026_07_02/README.md`,
  written 2026-07-02), not something newly asserted here.
- **GRAPH-003 and GRAPH-009** remain at 3/4 -- `WIDTHS_BY_TOTAL` is still
  `unable_to_determine` on both (mosaic-plot column-width proportionality is
  hard to confirm confidently from a photo at this scale); unaffected by the
  redraw since it's a drawing-accuracy question, not an interpretation one.

## What's in this package

1. **FRQ packets/stems** -- `frq_packets.md`. Reused verbatim from
   `docs/research/ap_statistics_graph_response_seed_2026_07_02/ap_statistics_graph_response_seed_2026_07_02.jsonl`
   for all 12 items (stem, data table, rubric criteria, canonical answer) --
   nothing re-authored, except one inline correction (see below).
2. **Rubric/answer key per FRQ** -- the criteria + canonical answer sections
   of `frq_packets.md`. **This is the piece that is not actually
   human-approved yet** -- see next section.
3. **Gold labels for the hand-drawn responses** -- `proposed_gold_labels.md` /
   `.jsonl`. Claude's criterion-by-criterion visual grading of each of the 12
   photographed responses against its canonical answer, explicitly marked
   `claude_proposed_pending_approval`, not gold.
4. **Manifest pairing each FRQ with its HDR** -- `manifest.jsonl` / `.csv`.
   One row per item: FRQ source pointer, rubric status, HDR image path, gold
   label source pointer.
5. **`images/`** -- the photographs, copied from
   `docs/research/AP Stats HDR Images/` and renamed from camera filenames
   (`IMG_70##.jpeg`) to `{item_id}__hdr_photo.jpeg` (v1, all 12) and
   `{item_id}__hdr_photo_v2.jpeg` (v2 redraw, 11 of 12 -- all but GRAPH-007).
   Both versions are kept for audit trail. Provenance tables below.
6. **`scripts/`** -- the generator (`generate.py`) and the proposed-label
   data (`proposed_labels_data.py`) that produced everything above, for
   reproducibility.

## Image provenance (camera filename -> item ID)

Identified by reading the item ID written at the top of each photographed
page, cross-checked against `expected_graph_spec`/stem content in the source
JSONL:

| Original filename | Item ID |
| --- | --- |
| `IMG_7017.jpeg` | `APSTATS-HDG-2026-GRAPH-001` |
| `IMG_7018.jpeg` | `APSTATS-HDG-2026-GRAPH-002` |
| `IMG_7019.jpeg` | `APSTATS-HDG-2026-GRAPH-003` |
| `IMG_7014.jpeg` | `APSTATS-HDG-2026-GRAPH-004` |
| `IMG_7016.jpeg` | `APSTATS-HDG-2026-GRAPH-005` |
| `IMG_7012.jpeg` | `APSTATS-HDG-2026-GRAPH-006` |
| `IMG_7013.jpeg` | `APSTATS-HDG-2026-GRAPH-007` |
| `IMG_7010.jpeg` | `APSTATS-HDG-2026-GRAPH-008` |
| `IMG_7011.jpeg` | `APSTATS-HDG-2026-GRAPH-009` |
| `IMG_7008.jpeg` | `APSTATS-HDG-2026-GRAPH-010` |
| `IMG_7009.jpeg` | `APSTATS-HDG-2026-GRAPH-011` |
| `IMG_7007.jpeg` | `APSTATS-HDG-2026-GRAPH-012` |

All 12 of the source pool's items are covered (this extends past the 10 used
in `docs/research/benchmark_corpus_2026_07_06/statistics_hand_drawn_*`, which
deliberately excluded GRAPH-006 and GRAPH-012).

**v2 redraw batch** (2026-07-06, same day):

| Original filename | Item ID |
| --- | --- |
| `IMG_7031.jpeg` | `APSTATS-HDG-2026-GRAPH-001` |
| `IMG_7030.jpeg` | `APSTATS-HDG-2026-GRAPH-002` |
| `IMG_7029.jpeg` | `APSTATS-HDG-2026-GRAPH-003` |
| `IMG_7027.jpeg` | `APSTATS-HDG-2026-GRAPH-004` |
| `IMG_7028.jpeg` | `APSTATS-HDG-2026-GRAPH-005` |
| `IMG_7025.jpeg` | `APSTATS-HDG-2026-GRAPH-006` |
| *(none)* | `APSTATS-HDG-2026-GRAPH-007` -- not resubmitted, still on v1 |
| `IMG_7024.jpeg` | `APSTATS-HDG-2026-GRAPH-008` |
| `IMG_7023.jpeg` | `APSTATS-HDG-2026-GRAPH-009` |
| `IMG_7022.jpeg` | `APSTATS-HDG-2026-GRAPH-010` |
| `IMG_7021.jpeg` | `APSTATS-HDG-2026-GRAPH-011` |
| `IMG_7020.jpeg` | `APSTATS-HDG-2026-GRAPH-012` |

## Two findings from the original (v1) visual grading pass, before anything is frozen

### 1. Known rubric bug in GRAPH-010 (already documented, not yet fixed at the source)

`ap_statistics_graph_response_seed_2026_07_02/README.md` already documents
that GRAPH-010's `OUTLIER_NOTE` criterion and `canonical_answer` are wrong:
the original text claims 82 cm should **not** be called an outlier, but
independently recomputing the standard 1.5xIQR rule on this item's own data
(Q1=71.5, Q3=75.5, IQR=4, upper fence=81.5) shows **82 > 81.5**, so 82 cm
**is** a mild outlier by the rule AP Statistics actually teaches. This was
fixed only in a staged Supabase row back in July, never in the source JSONL
kept in this repo. `frq_packets.md` shows both the original (struck through)
and corrected wording for GRAPH-010 -- **the corrected wording is what
should go into any frozen rubric**, not the original.

### 2. 10 of the 12 photographed responses appear to be missing their required written interpretation

Every stem in this set asks for the graph **plus** a written interpretive
statement (a comparison sentence, a shape description, an outlier
identification, an association description, or an identification of which
group is largest). Looking at all 12 photographs:

- **GRAPH-006 and GRAPH-012** (the curve-annotation items) have their
  required numeric estimate written directly on the page as an annotation
  next to the marked point (e.g. "n=20, rate ~ 0.39") -- full credit
  proposed on all 4 criteria for both.
- **The other 10 items** (both boxplot items, both segmented-bar items, both
  mosaic-plot items, both dotplot items, both scatterplot items) show only
  the constructed graph -- no written comparison/shape/outlier/association
  sentence appears anywhere on the photographed page. Under a literal
  reading of each rubric, that's 1 of 4 criteria not earned on each of those
  10 items (proposed `not_earned`, not a guess at what the words might have
  been).

**Resolved by the v2 redraw** for 9 of these 10 items (David confirmed the
missing sentences were a real gap, not a photographing issue, and redrew
them with the interpretation written in). Two items still need attention:
GRAPH-007 (not resubmitted at all) and GRAPH-010 (redrawn, but the new text
addresses shape, not the outlier question).

## What still needs to happen before Codex can use this

1. **Someone with actual approval authority needs to confirm the rubric is
   frozen.** The source pool's own status is explicitly "Staged for tutor
   review only. Not reviewed, not validated, not published" -- no tutor or
   Learning Quality review has ever happened on these 12 items' criteria or
   canonical answers, including before this package existed. Freezing them
   now for a grading experiment is a real decision, not a formality.
2. **GRAPH-010's interpretation could still be extended** to address whether
   82 cm is an outlier (ideally via the corrected 1.5xIQR rule) if you want
   that item at full credit -- currently 3/4, and this is the only remaining
   interpretation-content gap across all 12 items.
3. **Someone needs to confirm `proposed_gold_labels.jsonl`** (45/48 as of
   the v2 redraw, all 12 items now graded against redrawn photos) as the
   actual gold labels, or correct them, before Codex uses them as ground
   truth -- including the two `unable_to_determine` calls on GRAPH-003/009's
   `WIDTHS_BY_TOTAL`.

Until 1-3 happen, every file in this package should be treated as a
well-organized draft, not an experiment-ready input set.
