"""Deterministic question-stimulus builds; no runtime model or arbitrary eval.

These are reviewed build artifacts for the existing question-image contract,
not app.figures reference entries. Publication is a separate operation.
Run: MPLCONFIGDIR=/tmp/cramapple-mpl python3 render.py
"""
from __future__ import annotations

import hashlib
import html
import json
import math
from pathlib import Path
import re
import xml.etree.ElementTree as ET

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import Circle, FancyArrowPatch, Rectangle
import numpy as np

HERE = Path(__file__).resolve().parent
LAYOUTS = {
    "compact": {"width": 340, "height": 350, "min_width": 272, "font": 22},
    "full": {"width": 680, "height": 460, "min_width": 544, "font": 22},
    "expanded": {"width": 980, "height": 620, "min_width": 784, "font": 24},
}
INK, AXIS, GRID = "#151515", "#4a3073", "#e5e0eb"
plt.rcParams.update({"font.family": "DejaVu Sans", "svg.fonttype": "none",
                     "svg.hashsalt": "cramapple-question-visuals-v1",
                     "axes.unicode_minus": True, "path.simplify": False})


def value(segment, x):
    """Small, closed grammar; coefficients ordered constant first."""
    kind = segment["kind"]
    if kind == "polynomial":
        y = 0.0
        for a in reversed(segment["coefficients"]):
            y = y * x + a
        return y
    if kind == "left_pole":
        return 4 + (x - 2) / (4 - x)
    if kind == "right_pole":
        return 2 / (x - 4)
    raise ValueError(f"Unsupported curve kind {kind!r}")


def font(px):
    return px * 72 / 100


def graph(spec, layout):
    w, h = layout["width"], layout["height"]
    fig = plt.figure(figsize=(w / 100, h / 100), dpi=100, facecolor="white")
    left = .23 if w == 340 else .16
    ax = fig.add_axes([left, .19, .95 - left, .63])
    ax.set(xlim=spec["window"]["x"], ylim=spec["window"]["y"])
    ax.set_xticks(spec["ticks"]["x"])
    ax.set_yticks(spec["ticks"]["y"])
    ax.tick_params(labelsize=font(13), colors=INK, length=3, pad=5)
    ax.grid(color=GRID, linewidth=.6, zorder=0)
    for spine in ax.spines.values():
        spine.set_visible(False)
    ax.axhline(0, color=AXIS, linewidth=1, zorder=1)
    ax.axvline(0, color=AXIS, linewidth=1, zorder=1)
    for x in spec.get("asymptotes", []):
        ax.axvline(x, color="#737373", linewidth=1.1, linestyle=(0, (4, 4)))

    for segment in spec["segments"]:
        xs = np.linspace(*segment["draw_domain"], 401)
        ys = np.array([value(segment, x) for x in xs])
        ax.plot(xs, ys, color=INK, linewidth=2.0, zorder=3,
                solid_capstyle="butt")
        for end in segment.get("continues", []):
            i, j = (9, 0) if end == "left" else (-10, -1)
            arrow = FancyArrowPatch((xs[i], ys[i]), (xs[j], ys[j]),
                                    arrowstyle="->", mutation_scale=12,
                                    linewidth=1.8, color=INK, zorder=4)
            ax.add_patch(arrow)

    for point in spec["points"]:
        ax.plot(point["x"], point["y"], marker="o", markersize=7,
                markerfacecolor=INK if point["included"] else "white",
                markeredgecolor=INK, markeredgewidth=1.6, zorder=6)

    title = ax.set_title(spec["title"], fontsize=font(layout["font"]), pad=20)
    title.set_gid("meaningful-title")
    ax.set_xlabel("x", fontsize=font(layout["font"]), color=AXIS, labelpad=9)
    ax.set_ylabel(spec["function"] + "(x)", fontsize=font(layout["font"]),
                  color=AXIS, labelpad=8)
    ax.xaxis.label.set_gid("meaningful-x-axis")
    ax.yaxis.label.set_gid("meaningful-y-axis")
    return fig


def particles(spec, layout):
    w = layout["width"]
    # Stack on phones; never squeeze the two panel labels into tiny type.
    compact = w == 340
    h = 600 if compact else layout["height"]
    fig = plt.figure(figsize=(w / 100, h / 100), dpi=100, facecolor="white")
    title = fig.text(.5, .95, spec["title"], ha="center", va="top",
                     fontsize=font(layout["font"]))
    title.set_gid("meaningful-title")
    box_width = .56 if compact else .32
    unit_height = box_width * w / 4 / h
    positions = ([.22, .58, box_width, 2 * unit_height],
                 [.22, .12, box_width, 4 * unit_height]) if compact else (
        [.09, .69 - 2 * unit_height, box_width, 2 * unit_height],
        [.57, .69 - 4 * unit_height, box_width, 4 * unit_height])
    for i, panel in enumerate(spec["panels"]):
        ax = fig.add_axes(positions[i])
        # Physical panel area is 1:2; the same solute marker radius is retained.
        ax.set_xlim(0, 4)
        ax.set_ylim(0, 2 if i == 0 else 4)
        ax.set_aspect("equal", adjustable="box")
        ax.axis("off")
        height = 2 if i == 0 else 4
        ax.add_patch(Rectangle((0, 0), 4, height,
                               facecolor="#f6f3fa", edgecolor=AXIS, linewidth=1.5))
        for j, (x, y) in enumerate(panel["particles"]):
            dot = Circle((x, y), radius=.10, facecolor=INK, edgecolor=INK)
            dot.set_gid(f"particle-panel-{i + 1}-{j + 1}")
            ax.add_patch(dot)
        cap_x = positions[i][0] + box_width / 2
        top = positions[i][1] + positions[i][3]
        cap_y = top + 48 / h if compact else .83
        vol_y = top + 15 / h if compact else .76
        caption = fig.text(cap_x, cap_y, panel["label"],
                           ha="center", va="bottom", fontsize=font(layout["font"]))
        caption.set_gid(f"meaningful-panel-{i+1}")
        volume = fig.text(cap_x, vol_y, str(panel["volume_ml"]) + " mL",
                         ha="center", va="bottom",
                         fontsize=font(layout["font"]))
        volume.set_gid(f"meaningful-volume-{i+1}")
    note = fig.text(.5, .035, "Each dot represents\na solute particle." if compact else
                    "Each dot represents a solute particle.",
                    ha="center", va="bottom", fontsize=font(layout["font"]))
    note.set_gid("meaningful-key")
    return fig


def svg_metadata(path, spec, layout):
    """Set accessible, non-answer-bearing name/description; inspect real glyphs."""
    ET.register_namespace("", "http://www.w3.org/2000/svg")
    tree = ET.parse(path)
    root = tree.getroot()
    ns = "{http://www.w3.org/2000/svg}"
    title = ET.Element(ns + "title", {"id": spec["visual_id"] + "-title"})
    title.text = spec["title"]
    desc = ET.Element(ns + "desc", {"id": spec["visual_id"] + "-desc"})
    desc.text = spec["alt"] + " " + spec["long_description"]
    root.insert(0, desc)
    root.insert(0, title)
    root.set("role", "img")
    root.set("aria-labelledby", title.attrib["id"] + " " + desc.attrib["id"])
    width = float(root.attrib["viewBox"].split()[2])
    sizes = []
    for group in root.iter(ns + "g"):
        if not group.attrib.get("id", "").startswith("meaningful-"):
            continue
        for text in group.iter(ns + "text"):
            m = re.search(r"font(?:-size)?:\s*([\d.]+)px", text.attrib.get("style", ""))
            if not m:
                raise ValueError("Cannot measure meaningful SVG text")
            sizes.append(float(m[1]) * layout["min_width"] / width)
    if not sizes or min(sizes) < 16 - 1e-6:
        raise ValueError(f"Meaningful labels below 16px: {sizes}")
    tree.write(path, encoding="utf-8", xml_declaration=True)
    return round(min(sizes), 2)


def build():
    data = json.loads((HERE / "specs.json").read_text())
    out = HERE / "assets"
    out.mkdir(exist_ok=True)
    manifest = {"schema_version": 1, "status": "built_not_published",
                "renderer": "render.py", "renderer_version": 1,
                "renderer_sha256": hashlib.sha256((HERE / "render.py").read_bytes()).hexdigest(),
                "specs_sha256": hashlib.sha256((HERE / "specs.json").read_bytes()).hexdigest(),
                "matplotlib_version": matplotlib.__version__, "visuals": []}
    cards = []
    for spec in data["visuals"]:
        record = {k: spec[k] for k in ("visual_id", "content_key", "question_version_id",
                   "audit_content_digest", "source_stem_md5", "source_stimulus_md5",
                   "alt", "long_description", "lane")}
        record["layouts"] = {}
        for name, layout in LAYOUTS.items():
            fig = particles(spec, layout) if spec["kind"] == "particles" else graph(spec, layout)
            base = out / (spec["visual_id"] + "-" + name)
            png, svg = base.with_suffix(".png"), base.with_suffix(".svg")
            fig.savefig(svg, metadata={"Date": None, "Creator": "Cramapple deterministic question renderer v1"})
            fig.savefig(png, dpi=200, metadata={"Software": "Cramapple deterministic question renderer v1"})
            floor = svg_metadata(svg, spec, layout)
            plt.close(fig)
            digests = {ext: hashlib.sha256(base.with_suffix("." + ext).read_bytes()).hexdigest()
                       for ext in ("png", "svg")}
            record["layouts"][name] = {
                "png": str(png.relative_to(HERE)), "svg": str(svg.relative_to(HERE)),
                "sha256": digests, "min_display_width_css_px": layout["min_width"],
                "min_meaningful_glyph_css_px": floor,
                "proposed_private_object_path": f'questions/{spec["content_key"]}/v1/{digests["png"]}.png'}
        manifest["visuals"].append(record)
        paths = record["layouts"]
        cards.append(f'<article><h2>{html.escape(spec["content_key"])}</h2>'
                     f'<p>{html.escape(spec["title"])}</p>'
                     f'<img src="{paths["compact"]["png"]}" data-full="{paths["full"]["png"]}" '
                     f'data-compact="{paths["compact"]["png"]}" data-expanded="{paths["expanded"]["png"]}" '
                     f'alt="{html.escape(spec["alt"], quote=True)}">'
                     f'<details><summary>Accessible description</summary><p>{html.escape(spec["long_description"])}</p></details></article>')
    (HERE / "manifest.json").write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n")
    (HERE / "preview.html").write_text('<!doctype html><html lang="en"><meta charset="utf-8">'
        '<meta name="viewport" content="width=device-width,initial-scale=1">'
        '<title>Four question visuals</title><style>body{font:18px system-ui;margin:0 auto;max-width:980px;padding:24px;'
        'color:#151515;background:#fff}h1{font-size:28px}h2{font-size:18px}article{padding:20px 0;border-top:1px solid #ccc}'
        'img{display:block;width:100%;min-width:272px;height:auto}details{margin:12px 0}p{line-height:1.5}</style>'
        '<h1>Four question visuals</h1><p>Built for review. Question data only; no answer annotations.</p>'
        + "".join(cards) + '<script>const observer=new ResizeObserver(entries=>{for(const {target,contentRect} of entries){'
        'const key=contentRect.width>=784?"expanded":contentRect.width>=544?"full":"compact";'
        'if(target.getAttribute("src")!==target.dataset[key])target.src=target.dataset[key];}});'
        'document.querySelectorAll("img[data-full]").forEach(img=>observer.observe(img));</script></html>')
    print(f'Built {len(data["visuals"])} visuals × {len(LAYOUTS)} layouts (SVG + 2× PNG).')


if __name__ == "__main__":
    build()
