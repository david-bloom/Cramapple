"""The Figures section for Copy notes. Figures are never omitted from the export.

SETTLED BY TEST, 2026-10-10. The Product Owner pasted the real clipboard payload
into Google Docs in three variants. Results:

  PNG data: URI   WORKS. The diagram arrives, rendered and legible, and the
                  surrounding text is clean. No hosting required.
  inline <svg>    FAILS, and fails BADLY. Docs drops the drawing *and* flattens
                  the SVG's own <text> nodes into the document as a run-on
                  paragraph: "...pKa = 4.76 equiv... 20 30 40 50 TITRATION
                  CURVE... ILLUSTRATIVE...". That is not graceful degradation,
                  it is corrupting the student's notes with axis ticks.
  text only       Clean, as expected.

So: **rasterise to PNG at copy time, and never put inline SVG on the clipboard**,
not even as a fallback for other targets. The failure mode is too ugly to risk
on a target we have not tested.

Two earlier claims corrected by that test. Docs does strip inline SVG, which I
had asserted without evidence and then hedged. But Docs does NOT strip `data:`
URIs, which a web search had suggested it would — the hedge was right, the
sub-claim was wrong.

Public raster hosting is therefore unnecessary and that decision is closed.

Rasterisation happens in the browser at copy time (SVG -> Image -> canvas ->
toDataURL), because that is where the copy happens; this module builds the HTML
around the data URIs the client produces.
"""
from __future__ import annotations

import html
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import render as R  # noqa: E402

P = "font-family:Arial,sans-serif;font-size:11pt;line-height:1.25;margin:0 0 7pt;"
H3 = "font-family:Arial,sans-serif;font-size:10pt;font-weight:bold;line-height:1.25;margin:0 0 7pt;"
H2 = "font-family:Arial,sans-serif;font-size:16pt;line-height:1.25;margin:0 0 7pt;"
EXPORT_WIDTH = 620  # points; the figure's own layout is `full` (680 units)


def esc(t: str) -> str:
    return html.escape(t, quote=False)


def figure_block(fig: dict, png: str | None) -> str:
    """One figure. `png` is a data: URI from the client rasteriser, or None if
    rasterising failed — in which case the figure degrades to text, never SVG."""
    out = [f'<h3 style="{H3}">{esc(fig["title"])}</h3>']
    if fig.get("caption"):
        out.append(f'<p style="{P}">{esc(fig["caption"])}</p>')
    if png:
        out.append(f'<p style="{P}"><img src="{png}" width="{EXPORT_WIDTH}" '
                   f'alt="{esc(fig["alt"])}"></p>')

    # Always present, whether or not the picture made it: this is what lets a
    # student use the figure from the text alone.
    out.append(f'<p style="{P}"><b>What the figure shows.</b> {esc(fig["alt"])}</p>')
    if fig.get("labels"):
        items = "".join(f'<li style="{P}">{esc(l)}</li>' for l in fig["labels"])
        out.append(f'<p style="{P}"><b>Labelled parts.</b></p><ul>{items}</ul>')
    flag = "Illustrative values." if fig.get("synthetic") else "Values from data."
    if fig.get("values_note"):
        flag += " " + fig["values_note"]
    out.append(f'<p style="{P}"><i>{esc(flag)}</i></p>')
    if fig.get("note"):
        out.append(f'<p style="{P}">{esc(fig["note"])}</p>')
    return "".join(out)


def figures_section(figs: list[dict], rasters: dict[str, str] | None = None) -> tuple[str, str]:
    """(html, plain_text) for the Figures section. `rasters` maps figure_id to a
    PNG data URI; a missing entry means that figure degrades to text."""
    if not figs:
        return "", ""
    rasters = rasters or {}
    h = f'<h2 style="{H2}">Figures</h2>' + "".join(
        figure_block(f, rasters.get(f["figure_id"])) for f in figs)

    lines = ["Figures", ""]
    for f in figs:
        lines.append(f["title"])
        if f.get("caption"):
            lines.append(f["caption"])
        lines.append(f["alt"])
        lines += [f"  - {l}" for l in f.get("labels", [])]
        lines.append("Illustrative values." if f.get("synthetic") else "Values from data.")
        lines.append("")
    return h, "\n".join(lines)


def copy_notice(figs: list[dict], rasters: dict[str, str] | None = None) -> str | None:
    """Shown beside "Copied" only when a figure could NOT be rasterised.

    The blanket Google Docs warning is gone: PNG export was tested and works, so
    warning every student about a problem they will not hit is noise. This fires
    only on the real failure — a canvas or toDataURL error — which is rare and
    worth telling them about, because those figures arrive as text.
    """
    rasters = rasters or {}
    missing = [f for f in figs if not rasters.get(f["figure_id"])]
    if not missing:
        return None
    n = len(missing)
    noun = "diagram" if n == 1 else "diagrams"
    return (f"{n} {noun} could not be copied as an image and {'is' if n == 1 else 'are'} "
            f"included as a written description instead.")


def client_rasteriser_js() -> str:
    """The client-side step, specified here so the app port cannot drift from it."""
    return """
// Copy notes: rasterise each figure before writing the clipboard.
// Never put inline <svg> on the clipboard - Google Docs drops the drawing and
// flattens the SVG's text nodes into the document as a run-on paragraph.
async function rasterise(svgMarkup, scale = 2) {
  const img = new Image();
  const src = 'data:image/svg+xml;base64,' +
    btoa(unescape(encodeURIComponent(svgMarkup)));
  await new Promise((res, rej) => { img.onload = res; img.onerror = rej; img.src = src; });
  const c = document.createElement('canvas');
  c.width = img.width * scale; c.height = img.height * scale;
  const x = c.getContext('2d');
  x.fillStyle = '#FAFAF8'; x.fillRect(0, 0, c.width, c.height);
  x.drawImage(img, 0, 0, c.width, c.height);
  return c.toDataURL('image/png');   // on throw: omit the image, keep the text
}
""".strip()


if __name__ == "__main__":
    here = os.path.dirname(os.path.abspath(__file__))
    specs = {k: v for k, v in json.load(open(os.path.join(here, "specs.json"))).items()
             if not k.startswith("_")}
    figs = [s for s in specs.values()
            if s.get("entry_title") == "Graphs showing the approach to equilibrium"]
    fake = {f["figure_id"]: "data:image/png;base64,iVBORw0KGgo=" for f in figs}
    h, t = figures_section(figs, fake)
    out = os.path.join(here, "out")
    open(os.path.join(out, "export_figures_sample.html"), "w").write(
        f'<!doctype html><meta charset="utf-8"><body style="margin:24px;max-width:760px">{h}</body>')
    open(os.path.join(out, "export_figures_sample.txt"), "w").write(t)
    print(f"{len(figs)} figures; html {len(h)} chars, text {len(t)} chars")
    print("notice with all rasters present :", copy_notice(figs, fake))
    print("notice with one raster missing  :", copy_notice(figs, {figs[0]['figure_id']: fake[figs[0]['figure_id']]}))
    assert "<svg" not in h, "inline SVG must never reach the clipboard HTML"
    print("no inline SVG in the export: OK")
