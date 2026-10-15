> Current live compact revision: `../question-visuals-phone-v2/` (APPROVAL-0174). This folder retains the earlier immutable build/release evidence.

# Four question-stimulus visuals

**Status:** Four compact PNGs attached to their live Production question versions, 2026-10-15 01:40:28 UTC.
**Owner authorization:** David Bloom: “Build the 4”, then “attach to live student questions” (APPROVAL-0173). See `production-release.json` for exact paths, checksums, approval and verification limits. Full/expanded layouts remain local build artifacts.

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

The existing deployed `student-session-items` v40 signs the four compact PNGs in private `content-assets`. Exact-version paths, approved alt text/long descriptions and required/approved decisions were attached atomically after a successful rollback rehearsal. All four signed downloads match the source SHA-256 and all four public reads are blocked. Authenticated student-role RPC checks select the expected AB 1.3 and Chemistry 3.8 teaching versions with image paths. No app/function/schema deployment was needed. The deterministic build manifest preserves its historical `built_not_published` state; `production-release.json` is the separate live release record.

**Live browser follow-up, 2026-10-15:** all four images load in the signed-in student-facing app: both worked examples and both FRQs. Each image is complete, has the expected 680px natural width, and renders at 622.65625 CSS px in the normal desktop viewport. Approved alt text appears in the DOM; teaching examples also show their long descriptions. Screenshots are in `browser-evidence/`; details in `docs/qa/QUESTION_IMAGE_LIVE_BROWSER_CHECK_2026_10_15.md`. No answers were submitted. The check used the owner’s admin account, with student-role teaching RPC checks recorded separately. Phone widths and a fresh independent content/accessibility verdict remain unverified. A subject-switch stale worked-example defect is recorded for the app maintainer; leaving the view and returning loaded the correct Chemistry question.

Development has only one of these four published questions, so no artificial parity was created. The owner-authorized attachment replaces the first FRQ’s prior `no_not_needed` decision. `attach_production.sql` preserves the applied transaction; `rollback_production.sql` was successfully rehearsed with ROLLBACK. All four live attachments remain in place.
