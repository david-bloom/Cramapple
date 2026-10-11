# Lane A figures: how they display, and how they are recalled

**Date:** 2026-10-10
**Status:** Design, built and measured in `scripts/lane-a-pilot/`. No app change yet.
**Follows:** `LANE_A_PILOT_RESULTS_2026_10_10.md` §5a, which found the display blocker.
**Product Owner direction, 2026-10-10:** put the figure beside or below the question in Open Hand
where it is relevant; give the student a way to enlarge it from a side pane; never omit figures
from the notes export — give them their own section; and make every figure titled and labelled so
it can be recalled and reused with different questions.

---

## 1. Three layouts from one spec

| Layout | Canvas | Where | Smallest type, rendered |
| --- | --- | --- | --- |
| `compact` | 340×344 | reference pane, phone | 8.8px at 272px · 10.7px at 332px · **14.9px at 460px** |
| `full` | 680×440 | question centre pane, notes two-column flow | 10.5px at 680px |
| `expanded` | 980×620 | the enlarge control, notes single column | 10.5px at 980px |

`compact` keeps the title (wrapped), both axis labels, the curves and the single marker that
carries the teaching point. Every measured annotation — activation-energy brackets, node labels,
well depths — moves to `full` and `expanded`. That is what buys the type size.

Before this, one 980-unit canvas was shrunk into every slot, so an 11.5-unit label rendered at
3.9px in the reference pane. The three presets are checked at their target widths by
`verify.py`, so the regression cannot come back silently.

**This is the part a stored image could not do.** A PNG in a 300px column can only shrink. A spec
can drop annotations, re-wrap its title and grow its type.

## 2. Open Hand: the figure goes next to the question

The question experience is three panes: Grading (260–296px), the question (flexible), Reference
(300–360px). A figure that *is* part of the question belongs in the centre, at `full`, directly
below the stem or beside it when the stem is short — the same slot `qx-figure` already uses for
worked-example images.

The reference pane keeps the `compact` figure, as a recall aid rather than the thing being read.

### Enlarging

Every `compact` figure is a button that opens the `expanded` layout over the plate: the same
dialog treatment as the notes sheet, with the figure, its caption, its labelled parts as text and
its disclosure. Escape and an explicit close both dismiss it, focus returns to the thumbnail.
This is required, not optional — at 272px the compact figure is a legible thumbnail, not a
readable diagram.

## 3. The centre pane is too wide, and the side panes pay for it

`.qx-panes` is `minmax(260px, 296px) minmax(0, 1fr) minmax(300px, 360px)`. The centre is the only
flexible track, so every extra pixel of viewport goes to it while the side panes stay capped:

| Viewport | Grading | Question | Reference |
| --- | --- | --- | --- |
| 1440px | 296 | 680 | 360 |
| 2000px | 296 | **1240** | 360 |

At 2000px the question column runs to 1240px — far past a comfortable measure, which is why the
stem in the current screenshot sets as very long lines — while the reference pane, which has to
hold a figure, is still 360px.

**Proposed:** cap the question column and let the side panes take the surplus.

```
.qx-panes { grid-template-columns: minmax(280px, 420px) minmax(0, 720px) minmax(320px, 520px);
            justify-content: center; }
```

The payoff for figures is direct: compact type goes from 10.7px at 360px to **14.9px at 460px**
and 16.8px at 520px. The question column lands at a readable measure. This needs testing in the
app against the real breakpoints — it is a `/question` change, not a figure change, and it should
be verified with the local harness before any Lovable round.

## 4. Figures are first-class objects, so they can be recalled

The pilot's specs were keyed one-to-one to a reference entry. That blocks exactly what the
Product Owner asked for: showing the same figure with a different question.

Each figure now carries its own identity:

| Field | Purpose |
| --- | --- |
| `figure_id` | stable slug, the thing anything else points at |
| `title`, `short_title` | full title, and a compact-layout title that fits 340 units |
| `caption` | one line of what it shows |
| `alt` | the accessible description, always exported as text |
| `labels` | the labelled parts **this figure draws**, named on the figure |
| `used_by` | a **list** of consumers: `{kind, id, title, role}` |
| `covers` | which of a linked entry's authored `items[]` this figure renders |

`used_by` being a list is the whole point. A figure linked to the Unit 5 entry
*Maxwell-Boltzmann energy distribution* can also be pointed at by a question, or by the Unit 5
convention *How a catalyst increases rate*, without duplicating the figure or re-deriving its
labels. `labels` lives on the figure for the same reason: a second consumer inherits them.

`verify.py` enforces that every figure has an id, a title, a caption, at least one labelled part,
and either a declared use or a written reason it has none.

In the database this is a figures table keyed by `figure_id` with a join to
`unit_reference_entries` (and later to questions) — **not** a `visual_spec` column on the entry,
which would re-create the one-owner problem. That is a change from §7 of the pilot results, and
it is the direct consequence of the recall requirement.

## 5. The notes export always carries figures

Figures get their own **Figures** section in Copy notes. Each entry in it carries, always:

- the title and caption
- the drawing, as inline SVG
- **what the figure shows**, as prose (the `alt`)
- **every labelled part**, as a text list
- the disclosure — illustrative or from data — and any `values_note`

### Settled by test, 2026-10-10

The Product Owner pasted the real clipboard payload into Google Docs in three variants.

| Variant | Result |
| --- | --- |
| **PNG `data:` URI** | **Works.** The diagram arrives rendered and legible, surrounding text clean. |
| inline `<svg>` | **Fails badly.** Docs drops the drawing *and* flattens the SVG's own `<text>` nodes into the document as a run-on paragraph: "…pKa = 4.76 equiv… 20 30 40 50 TITRATION CURVE… ILLUSTRATIVE…" |
| text only | Clean, as expected. |

Docs: [SVG variant](https://docs.google.com/document/d/186gaiOjG6XmPBabUYwg2hvvHvzWpkojldtGobj2vnyQ/edit),
[PNG variant](https://docs.google.com/document/d/1iP0nZyViRHlZ2nimJJ7s98ZJ3KC_WiKhjdyeMsF5Qco/edit).

**Decisions, all closed:**

1. **Rasterise to PNG at copy time.** Client-side: SVG → `Image` → `canvas` → `toDataURL`, at 2×
   for a crisp result. The exact function is pinned in `export_figures.py`
   (`client_rasteriser_js`) so the app port cannot drift from it.
2. **Never put inline SVG on the clipboard** — not even as a fallback for untested targets. The
   failure mode is not a missing picture, it is axis ticks pasted into a student's notes as prose.
3. **Public raster hosting is not needed.** That decision is withdrawn, not deferred.
4. **The blanket Google Docs warning is deleted.** Warning every student about a problem they will
   not hit is noise. A notice now fires only when a figure genuinely fails to rasterise — a canvas
   or `toDataURL` error — in which case that figure arrives as its written description and the
   notice says so.
5. **The text always ships anyway.** Title, caption, description and labelled parts are in the
   export whether or not the picture made it, so a rasterisation failure degrades rather than loses.

### Two of my earlier claims, corrected by the test

I asserted without evidence that Docs strips inline SVG, then hedged it to "may not" when a search
could not confirm it. The test says the assertion was right and the hedge was appropriate — it was
not verified at the time I first said it.

The same search suggested Docs also strips `data:` URIs. **That is wrong**, and had I relied on it
we would have built public raster hosting we do not need.

## 6. What is built and what is not

Built and checked (391 checks, 0 failing): three layouts, title wrapping, legibility assertions at
target widths, figure identity with `used_by`, labels on the figure, and the Figures export
section in both HTML and plain text.

Not built: the TypeScript port, the enlarge dialog, the `/question` grid change, and the figures
table. Public rasters are no longer needed. None of the rest is blocked by anything here.
