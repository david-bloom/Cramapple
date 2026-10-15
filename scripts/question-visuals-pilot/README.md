# Four question-stimulus visuals

**Status:** Built and locally verified; not uploaded or published.
**Owner authorization:** David Bloom, 2026-10-14: “Build the 4.” This authorizes the four-visual artifact build identified in the pilot source review. It does not record a Production deployment approval.

Open `preview.html` to inspect all four. Each has compact, full and expanded layouts, an SVG source rendering and a 2× PNG derivative. `specs.json` is the editable deterministic source; `manifest.json` pins the exact question version, source digests, accessible descriptions, file checksums and proposed immutable private-storage object paths.

| Visual | Exact source question |
| --- | --- |
| `calc-ab-u13-002-graph` | `apcalcab-frq-u13-002`, version `d0f2974c-bac9-498d-8173-8a1c88b3d8eb` |
| `calc-ab-u13g-1-3-graph` | `apcalcab-frq-u13g-1-3`, version `a59eb1ed-b96e-4d89-94ee-a4a32b309744` |
| `calc-ab-oht-1-3-graph` | `apcalcab-oht-1.3`, version `f1548706-2043-4f7b-9941-c1c6e2724174` |
| `chem-oht-3-8-particles` | `apchem-oht-3.8`, version `b7b068cb-0610-4da7-8565-4290621d402f` |

## Rebuild and verify

Use Python with the pinned requirements installed:

```sh
MPLCONFIGDIR=/tmp/cramapple-question-mpl python3 render.py
MPLCONFIGDIR=/tmp/cramapple-question-mpl python3 verify.py
```

This Mac's existing packages are Intel builds, so this session used `arch -x86_64 python3` for those commands. No dependency installation was needed. All eight semantic/layout/artifact tests pass, including a byte-identical rebuild; all twelve renderings were visually inspected. A clipped compact y-axis title was found, fixed by increasing the left margin, and verified after the fix.

The minimum meaningful label sizes are **17.6px** for compact at 272 CSS px and full at 544 CSS px, and **19.2px** for expanded at 784 CSS px. Tick labels are exempt under DECISION-0120. These measurements use the actual generated SVG font sizes and viewBox scaling. Agg additionally checks meaningful label bounds and overlap. Do not shrink a layout below its declared minimum; use the smaller layout instead. Browser integration must select based on the image's container width, not merely the viewport. The standalone preview uses `ResizeObserver` on each image to select its layout and preserves a minimum width of 272px.

## Mathematical and content decisions

- Preserve every given line, endpoint, isolated point and inclusion/exclusion marker. No answer, limit value or discontinuity classification is added as an annotation.
- `apcalcab-frq-u13g-1-3` does not uniquely specify the curved interiors. The left branch uses `4 + (x−2)/(4−x)` and the right uses `2/(x−4)`. Both preserve every stated endpoint/limit, continuity and direction. Those authoring formulas stay in the source; they are not new student givens.
- Chemistry contains exactly eight and sixteen particles, uses identical particle symbols and the supplied 100/200 mL labels. The schematic boxes have a two-to-one area and the same physical particle scale, with no labelled concentration, ratio or conclusion.
- Accessible text repeats the given representation, not the requested inference. Retain the original prose as the current long description; modifying/removing question text is separate content work.

## Storage and delivery boundary

These are **question stimulus build artifacts**, not new reference-catalogue `app.figures` rows or runtime family registrations. Reference Lane A's spec-only production pipeline has not been changed. The three graphs use deterministic Lane A principles; the particulate diagram uses a constrained Lane B grammar. PNG/SVG derivatives are committed for inspection/export; there is no model at student request time.

The existing question delivery contract can sign approved binary objects in private `content-assets`, but attaching these requires the reviewed version binding, approved accessibility metadata and actual student-route verification. The manifest's `questions/<content-key>/v1/<sha256>.png` paths are proposals, not uploaded objects. No public bucket or arbitrary client path is introduced. If the runtime spec route is chosen instead, these JSON sources are the contract to port; a reference figure's topic match alone is insufficient.

**Pending:** independent content/accessibility review (including the two-reader gate where applicable), Development attachment/route checks, the responsive image-selection integration, and any named Production release approval. The existing `no_not_needed` decision on `apcalcab-frq-u13-002` was not changed. Do not mark these student-delivered merely because the files exist.
