# TASK-0072 — Raise figure text to the reading floor (DECISION-0120)

**Status:** **Open, not started.** Measurement is done; no code or content change has been made.
**Tier:** Standard for the build; **Hard-Gate** for the Production figure reload.
**Owner:** unassigned. **Product Owner:** David Bloom.
**Branch / PR:** none yet.
**Source:** David, 2026-10-13, after the enlarged mathematics shipped: *"Document this size standard for
future equations, graphs and other visuals"*, then *"open a task for the figure sizing"*.
**Related:** `DECISION-0120` (the standard), `DECISION-0119` (equation presentation),
`docs/new_design/VISUAL_IDENTITY.md` → "Sizing what a student reads", `TASK-0006` (Lane A figures),
`project_reference_diagram_lane_status`, the three-gate figure verification.

## Why this exists

`DECISION-0120` fixed the rendered mathematics and set the rule behind it: **the 16px floor binds on the
smallest character a student must read to answer, measured in rendered pixels, not on the nominal size of
the element.** Applying that same measurement to the published figures found they do not meet it.

Measured 2026-10-13 against 47 rendered figures (`/dev-figures`), 526 text labels:

| Fact | Value |
|---|---|
| Labels rendering **below 16px** | **99.8%** |
| Labels rendering **below 12px** | **87.1%** |
| Median label | 9.8px |
| Smallest label | 8px |
| Smallest label in the *most legible* figure | 10.7px |

For scale: 12px is the size the Product Owner rejected as unreadable in the mathematics. **The figures are
mostly smaller than that.**

This is not an artefact of the width it was measured at. Figure text is authored in SVG user units and then
scaled to its container, and the **authored** scale in the app's `src/lib/figures/render.ts` is already under
the floor before any scaling:

| Preset | title | axis | tick | ann | mark | legend |
|---|---|---|---|---|---|---|
| `compact` (W 340) | 15 | 13 | 11 | 12 | 11 | 11 |
| `full` (W 680) | 17 | 12 | 10.5 | 11 | 11 | 11 |
| `expanded` (W 980) | 20 | 12.5 | 10.5 | 11.5 | 11.5 | — |

## What makes this harder than a constant bump

**Do not globally multiply the type scale.** The figures are drawn into a fixed `viewBox`, so type size and
layout room trade off directly: larger labels mean fewer ticks that fit, longer labels colliding, legends
wrapping, and axis titles pushed off-canvas. Past sessions have shipped exactly those defects (an off-canvas
y-axis title in *every* figure; a legend overprinting its own axis label), and they were caught by eye, not by
the property suite.

Consequences for how this is done:

1. **The property tests say nothing about legibility.** A green suite has never caught a size or layout
   defect in this lane. Plan for the three gates — property tests, eyes, and model readers — per the figures
   protocol, and expect the eye to find what the tests cannot.
2. **Byte-parity matters.** The Python renderer and the app's TypeScript port are held at byte parity
   (45/45, then 219/219 across 23 families). Any size change must be made in both and re-proven, or the
   parity run fails.
3. **Scaling may be the better lever than font size.** Raising the rendered scale (a larger displayed width,
   or a smaller `viewBox` at the same display size) lifts every label at once without re-laying-out the
   figure. Measure this option before editing the type scale.
4. **`compact` is the risk case**, at W 340 in a ~324px column: it is the preset with the least room and the
   one most likely to need a layout change rather than a type change.

## Scope

- **In scope:** figure text in `src/lib/figures/render.ts` and its Python counterpart, the three presets,
  and whatever layout follows from the sizes; re-proving byte parity; the three-gate verification; the
  Production reload of affected figures.
- **Out of scope:** the figure *content* (nothing here says a figure is wrong, only that its labels are too
  small); the ~402-row prose retrofit from `DECISION-0119`; any change to the mathematics renderer, which
  now complies.

## Open questions for the Product Owner

1. **Does the floor apply to every label in a figure, or only to the ones carrying meaning?** A tick label is
   arguably closer to chrome than to body copy, while an axis title and a data annotation plainly are not.
   `DECISION-0120` exempts chrome and maths subordinates but does not rule on tick labels. This single answer
   decides whether the task is a resize or a redesign.
2. **Scale or type size?** See 3 above — worth measuring before committing.
3. **Is this launch-blocking?** The figures are live and have been since 2026-10-12. They are legible enough
   that nobody reported them; they were found by measurement, not by a student.

## Definition of done

- Every figure label that the answer to question 1 puts in scope renders at or above the floor, **measured**
  (authored `font-size` × rendered-width ÷ viewBox-width), not inspected.
- Byte parity re-proven between the Python renderer and the app port.
- Three-gate verification passed, with planted controls.
- Development and Production hold identical figure content, verified as an authenticated student rather
  than `service_role`.
