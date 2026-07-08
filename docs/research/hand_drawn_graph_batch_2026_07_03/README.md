# Hand-Drawn Graph Batch - 2026-07-03

This package captures the next live experiment batch for hand-drawn response grading.

## Set 04

- Purpose: hard-case calibration for hand-drawn image grading.
- Gradeable pages: 47
- Excluded pages: 27 capture-noise / blank / partial `IMG_08xx` shots.
- Pack label: `set_04`
- Manifest: `set_04/set_04_manifest.json`

## What is in set 04

The pack is the usable July 3 subset from `docs/hand drawn samples/`, with one record per photographed response page.
It covers the three active archetypes:

- categorical comparison
- continuous measured series
- continuous relationship with estimate / plateau annotation

## Notes

- The `IMG_08xx` files are intentionally left out because they do not provide gradeable graph evidence.
- The manifest stores the response image path and item ID; the runner hydrates rubric metadata from the frozen P1 corpus.
