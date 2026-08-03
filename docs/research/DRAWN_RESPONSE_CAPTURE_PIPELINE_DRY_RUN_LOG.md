# Drawn-Response Capture & Manual-Grading Pipeline Dry Run Log

**Status:** Internal pipeline-mechanics testing, not a DR-1 method bake-off run
**Owner:** Product Owner
**Related:** `docs/research/DRAWN_RESPONSE_RUBRIC_MATCH_PROTOCOL.md` (DR-1),
`docs/research/DRAWN_RESPONSE_ANNOTATION_HANDBOOK.md`,
`prompts/DRG_P1_REFERENCE_IMAGE_PROMPTS.md`

## What This Log Is

This is **not** a DR-1 run. DR-1 compares an automated grading method's
output against locked human gold labels on a defined corpus tier; no
automated method exists yet, and none of these responses went through the
phase-1 section 3.2 authoring/preflight gate or the full annotation
handbook labeling protocol (no Corpus Coordinator, no blind dual-validator
pass, no lead adjudication).

This log instead tracks something upstream of DR-1: whether the practical
mechanics of the capture-and-grade pipeline work at all — can a real
person draw a response, photograph it, get it to a reviewer, and get a
criterion-level read back. Findings here feed into whether DR-1 and the
real labeling protocol are even operationally ready to run.

## Experiment 001 — 2026-06-19

**Item:** `DRG-P1-01A` (Asarum canadense stomatal density, four light
treatments), full-credit reference image only.
**Reference data:** Deep Shade 33.8±0.9, Partial Shade 40.8±1.1, Ambient
Sun 52.8±0.9, High Light 64.0±0.7. Y-axis must start at 0; categories in
stated order; point-with-whisker with symmetric SEM bars.
**Method:** Orly, David, and Micah each hand-drew one replica of the
`DRG-P1-01A_master_full_credit.png` reference image from memory/by eye (not
from the underlying data table), photographed it, and shared via AirDrop.
**Grader:** Claude, reading embedded photos directly in chat — no
measurement tooling, no zoom/crop, no pixel extraction. This is explicitly
a low-confidence grading method and is treated as such below.

### Submission count correction

5 photos were submitted but represent **3 distinct drawn responses**:
Orly's drawing photographed twice (2 captures, correct per protocol),
David's drawing photographed twice (2 captures, correct), Micah's drawing
photographed once (**1 capture — below the 2-capture minimum**).

### Per-Response Results

**Response 1 — Orly:**

| Criterion | Decision | Reason |
| --- | --- | --- |
| `REPRESENTATION_TYPE` | MET | Point-with-whisker |
| `CATEGORY_IDENTITY` / `X_SCALE` | MET | Correct order, all four distinct |
| `Y_UNIT` | MET | "Stomata/MM2" labeled |
| `Y_SCALE` | MET | Starts at 0 |
| `UNCERTAINTY_MARKS` | MET | Symmetric bars present on all four |
| `PLOT_VALUES` | ABSTAIN | Deep Shade and Partial Shade read close to target. Ambient Sun and High Light read roughly 6-7 units high (~60 and ~70 vs. true 52.8 and 64.0). Deviation looks larger than plausible hand-drawing slip, but grader confidence in pixel-level photo reading is too low to call this NOT_MET outright. |

Capture quality: clean, well-lit, no occlusion, 2 captures present — no
issues.

**Response 2 — David:**

| Criterion | Decision | Reason |
| --- | --- | --- |
| `REPRESENTATION_TYPE` | MET | Point-with-whisker |
| `Y_SCALE` | MET | Starts at 0 |
| `Y_UNIT` | MET | "Stomata/mm2" labeled |
| `CATEGORY_IDENTITY` | ABSTAIN | Third category label reads like "Ambient Shade" rather than "Ambient Sun" in both photos; could be a handwriting misread, not confirmed |
| `PLOT_VALUES`, `UNCERTAINTY_MARKS` | ABSTAIN — capture-level | A shadow (phone or hand) covers the lower-middle plot area in both photos, obscuring at least one data point entirely. Not a scoring call; the region is not safely readable. |

Capture quality: **`GLARE_OCCLUSION`-type defect in both captures** —
under the capture-quality labels this is a clean `RETAKE` case, not
`ACCEPT`.

**Response 3 — Micah:**

| Criterion | Decision | Reason |
| --- | --- | --- |
| `REPRESENTATION_TYPE`, `CATEGORY_IDENTITY`, `Y_UNIT`, `Y_SCALE` | MET | All correct |
| `PLOT_VALUES`, `UNCERTAINTY_MARKS` | ABSTAIN | Single photo, lower effective resolution; grader confidence too low to call point placement either way |

Capture quality: only 1 of the required 2 captures submitted.

### Findings

1. **Grader abstained on `PLOT_VALUES` for all three responses.** Reading
   exact point positions from a phone photo embedded in chat, by eye, with
   no measurement tooling, is precisely the low-confidence regime the
   phase-1 spec's abstention framework anticipates. This run is direct,
   first-hand evidence for that design choice — it is not a one-off
   caution, it's what actually happened on the very first attempt.
2. **`DRG-P1-01A`'s proposed development tolerance (mean placement within
   0.1 stomata/mm2 on a 0-80/90 scale) is not realistic for hand-drawn
   work**, independent of grader-confidence issues. Recommend revisiting
   this tolerance before it is used to score anything.
3. **Capture-quality defects showed up immediately and exactly as
   designed for** — David's shadow-occluded photos are a textbook
   `RETAKE` case under the existing capture-quality labels. The labeling
   vocabulary built earlier in this project correctly describes a real
   capture defect on the very first real photo set.
4. **Capture-count discipline needs reinforcement** — Micah submitted 1
   photo, not the 2-minimum. Worth a brief reminder before the next round,
   not a process redesign.

### Next Step (as planned)

Decision: retry the same item/drawings before moving to a new item —
David retakes without the shadow, Micah adds a second photo, Orly
provides a closer/zoomed photo of the same drawing to test whether
framing resolves the `PLOT_VALUES` abstention.

## Experiment 001 — Retry Round — 2026-06-19

Same item, same three drawings, new photos addressing the findings above.

**David:** Capture-quality fix worked — the shadow no longer covers the
plot area. With a readable photo, `PLOT_VALUES` upgrades from ABSTAIN to
**MET**: Deep Shade ~33, Partial Shade ~42, Ambient Sun ~50, High Light
~62, all within a few units of true values (33.8, 40.8, 52.8, 64.0).
`CATEGORY_IDENTITY` on the third label remains unresolved — still reads
ambiguously even in the cleaner photo.

**Orly:** Clean, well-lit, zoomed photo — removes the main reason for the
prior ABSTAIN. The same deviation from Experiment 001 reappears
identically: Deep Shade and Partial Shade read correctly (~34, ~41), but
Ambient Sun and High Light both read roughly 6-7 units high (~60 and ~70
against true 52.8 and 64.0). **Upgraded from ABSTAIN to NOT_MET on both
points** — image quality is no longer a credible explanation, since a
materially clearer photo reproduced the exact same pattern. This now
reads as a real, reproducible drawing discrepancy specific to the top two
categories, not a grader-confidence artifact.

**Micah:** Now has 2 captures (capture-count gap closed). Values read
close to target throughout (~30, ~40, ~50, ~62 against 33.8, 40.8, 52.8,
64.0); `CATEGORY_IDENTITY` on the third label shows the same ambiguity as
David's response.

### New Finding: Possible Defect In The Reference Image, Not The Drawings

Two of three responses (David, Micah) show the same ambiguous reading on
the third category label. Independent transcription slips landing on the
same ambiguity is a weak coincidence — more likely the master reference
image's label for that category (`DRG-P1-01A_master_full_credit.png`,
"Ambient Sun") is itself hard to read, and both people are faithfully
reproducing what they saw. Action: confirm directly against the reference
image before concluding this is a drawing-side error.

### Updated Recommendation

`PLOT_VALUES` and `CATEGORY_IDENTITY` resolved to confident decisions on
this retry round given clearer captures, in contrast to Experiment 001's
universal abstention — confirms the original abstention was capture- and
framing-driven for two of three responses, not a hard ceiling on
photo-based grading generally. Orly's persistent deviation is the one
finding that survived a quality fix and should be followed up directly
rather than re-tested with more photos of the same drawing.
