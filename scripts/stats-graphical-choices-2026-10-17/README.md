# Statistics: twenty graphical-choice repairs

**Status:** All twenty choice specifications resolved; local SVG/PNG builds and reviewer-preview checks pass. Independent content QA, live stored-key comparison and publication remain open.
**Authorization:** David: “Resolve the 20 graphical choice questions.”
**Report:** [Resolution and exact limits](../../docs/qa/STATS_GRAPHICAL_CHOICES_RESOLUTION_2026_10_17.md).

The questions are `apstat-u1-5-3a-graphs-105000` through `105019`, pinned to the original audit inventory. Each keeps its complete stem, twelve observations, option order and both original histogram specifications. The under-specified categorical-bar and keyless-stemplot distractors are replaced with explicit, distinct histogram count errors. This is a newly authored repair of existing content, not a claim to have recovered missing original artwork or created new questions through the new-MCQ pipeline.

Every question now has four graphical histogram choices, identical axes/scales and neutral styling, with exactly one frequency vector matching the raw data. The derived correct letter is the original matching-histogram letter. The frozen inventory excludes stored keys/rationales; those must be compared before a new version can be released. New per-choice rationales are included so obsolete categorical/stemplot feedback is not copied into a release.

## Artifacts

- `specs.json`: all twenty exact source/version/digest pins, raw data, bin edges, four choice specifications, proposed keys/rationales, old/new replacements and release gates. **Reviewer data contains answer flags; do not serve this file as an ordinary student payload.**
- `assets/`: eighty individual choice images and twenty complete A–D sheets, each as editable SVG and 2× PNG. No graphic marks the answer or embeds a rationale. The full sheet contains every choice, never only the correct one.
- `manifest.json`: source/spec/renderer/artifact SHA-256 values, PNG dimensions, alt text, long descriptions and rasterizer versions.
- `preview.html`: local review gallery, two columns on desktop and one on phones; reviewer answers are collapsed.
- `verification.json`: source/arithmetic/artifact checks, including four rejected negative controls.
- `browser-verification.json`, `review-evidence/`: local Chromium measurements and representative desktop/320px screenshots. These are not live student-app evidence.

## Rebuild and verify

From this directory:

```sh
python3 build_specs.py
node render.mjs
python3 verify.py
node verify-browser.mjs
```

The renderer needs `sharp`; browser verification needs `playwright` and Chromium. If dependencies are in a shared runtime rather than this repository, pass its Node dependency root as the second command argument, for example `node render.mjs /path/to/dependencies/node`. The Codex desktop dependency locator returns that root. No database, model or network call is part of the build.

Rebuilding produces the same manifest and all one hundred SVG/PNG pairs byte for byte on the recorded runtime. Meaningful labels are 26 SVG units: 17.588px at 230 CSS pixels image width. The local 320px preview gives 244px images and 18.659px labels. The ten-bin chart uses 20-unit tick labels, which are exempt under DECISION-0120; axis titles and option labels stay at 26. All one hundred SVGs have browser-measured text bounds without clipping or overlap.

## Release boundary

These are local repair drafts. Existing-content QA under the authoring protocol applies; no same-author pass is labeled independent review. Compare current complete source, actual stored keys and scoring before release; create new `content_item_versions` revisions, never edit published versions in place, and replace stale distractor rationales with the reviewed revisions.

No per-choice image-delivery contract has been verified in the current app. The individual images support a future choice-image path; the complete A–D sheet is an alternative review/delivery artifact only if the app renders it at natural height with scrolling/enlargement and complete accessible equivalents. A height cap could shrink a tall sheet below the reading floor. Do not blindly attach it through the current common-stimulus slot. Verify the selected route at the actual pane width in authenticated desktop/phone views, with all four options and their labels intact. A single correct-answer graph in the stem is never a repair.

Production publication, private immutable storage, version-matched metadata/visual decisions, guarded promotion/recovery and actual student delivery are a subsequent scoped release. No upload, schema change, data write, live query, student-state change or app deployment was performed here. The other three teaching stimuli and twenty-six retained-text cases are unchanged.
