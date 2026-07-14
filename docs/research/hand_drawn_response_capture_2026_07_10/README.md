# Hand-Drawn Response Capture — 2026-07-10

**Status:** Research capture, sorted and catalogued. Not adjudicated gold, not
production content.
**Source:** `docs/hand drawn samples/Stats-HRD-1/` (50 HEIC photos) and
`docs/hand drawn samples/Stats-HRD-2/` (28 HEIC photos) — despite the folder
names, these are two different subjects (see below).

## What this is

78 hand-drawn graph responses were photographed, converted from HEIC to PNG,
had EXIF/GPS metadata stripped, and were identified against their source item
pools by reading each page's handwritten item ID. Despite both source folders
being named "Stats-HRD-*", they turned out to hold two different corpora:

- **`Stats-HRD-1` (50 images) is actually AP Biology**, not Statistics —
  responses to the `HDG-2026-P1-*` item pool in
  `../hand_drawn_graph_corpus_2026_06_29/hand_drawn_graph_questions_2026_06_29.jsonl`
  (150-item pool: CAT/SER/EST archetypes, categorical comparison / continuous
  measured series / continuous relationship-estimate).
- **`Stats-HRD-2` (28 images) is genuine AP Statistics** — responses to
  `APSTATS-HDG-2026-GRAPH-013` through `-040` in
  `../apstats_packet_bundle_2026_07_07/hdr_frq_pool.json` (40-item pool).

## Contents

- `biology/` — 50 JPEGs (resized to max 1800px, quality 87), named
  `<canonical_item_id>__<source_file>.jpg`
- `statistics/` — 28 JPEGs (same treatment), named
  `<canonical_item_id>__<source_file>.jpg`
- `manifest.json` — per-image record: source file, source folder, subject,
  canonical item ID, whether it matched the source pool, archetype, and any
  data-quality flag
- `contact_sheet_biology.jpg`, `contact_sheet_statistics.jpg` — thumbnail
  grids for quick visual scan

## Coverage

**Biology (50/50 photographed):**
- CAT-001 through CAT-017: complete, 17/17
- SER-001 through SER-017: 16/17 written — see SER-008 note below
- EST-001 through EST-016: 15/16 written, plus one unlabeled page — see notes
  below

**Statistics (28/28 photographed):** GRAPH-013 through GRAPH-040, a clean
contiguous run, no gaps, no duplicates.

## Data-quality flags (resolved by evidence, noted for the record)

1. **`HRD1_IMG_1202` was labeled `EST-008` but its content (a continuous
   glucose-uptake-rate curve vs. external glucose concentration) matches the
   SER archetype, not EST.** `HRD1_IMG_1203` is also labeled `EST-008` and
   *does* match the standard EST pattern (numeric axis + "estimate" annotation
   + inverse-linear form). SER-008 was otherwise entirely missing from the
   sequence. Two independent signals converge on the same conclusion: IMG_1202
   is almost certainly a mislabeled SER-008, and IMG_1203 is the real EST-008.
   **Not auto-relabeled in the filenames** — both are still filed under
   `HDG-2026-P1-EST-008__*` in `biology/` pending your confirmation, since
   renaming based on inference risks compounding an error rather than fixing
   one.
2. **`HRD1_IMG_1215` (physical page 36) has no item ID written on it at all**
   (checked at full resolution, not a misread). Content matches the standard
   EST numeric-estimate pattern (percent mass change vs. sucrose
   concentration, "estimate -0.4"). EST-012 was the only number missing from
   the sequence. High-confidence inference, same caveat as above — filed as
   `UNLABELED__HRD1_IMG_1215.jpg`, not renamed to EST-012.

Recommend: confirm both before these enter any calibration or gold-set work.

## Not done in this pass

- No criterion-level scoring or transcription of plotted values.
- No archetype-consistency QC beyond the two flagged items above.
- No comparison against `hdr_frq_pool.json`'s `hdr_image_path` field to link
  these captures back into that pool's record structure — the images are
  sorted and identified, but the pool JSON itself hasn't been updated to
  point at them yet.
