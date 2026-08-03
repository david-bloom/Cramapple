#!/usr/bin/env python3
"""Generate DRG-P1 reference images and a markdown index.

The source prompts live in prompts/DRG_P1_REFERENCE_IMAGE_PROMPTS.md.
This script renders the 20 requested graph images as simple hand-drawn
style PNGs and writes a markdown file that embeds them.
"""

from __future__ import annotations

import math
import re
from dataclasses import dataclass
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.font_manager import FontProperties
from matplotlib.ticker import LogLocator, MultipleLocator
import numpy as np

plt.rcParams["path.sketch"] = (1, 100, 2)


ROOT = Path("/Users/davidbloom/Documents/Cramapple")
PROMPT_FILE = ROOT / "prompts/DRG_P1_REFERENCE_IMAGE_PROMPTS.md"
OUT_MD = ROOT / "prompts/DRG_P1_REFERENCE_IMAGES.md"
ASSET_DIR = ROOT / "prompts/DRG_P1_REFERENCE_IMAGES_assets"
FONT_PATH = Path("/System/Library/Fonts/Supplemental/Bradley Hand Bold.ttf")


@dataclass
class GraphCase:
    item_id: str
    variant_tag: str
    filename: str
    archetype: str
    x_label: str
    y_label: str
    x_values: list[float] | list[str]
    means: list[float]
    sems: list[float] | None = None
    x_unit: str | None = None
    intercept: float | None = None
    plateau: float | None = None
    missing: str | None = None


def fp(size: int = 14) -> FontProperties:
    if FONT_PATH.exists():
        return FontProperties(fname=str(FONT_PATH), size=size)
    return FontProperties(size=size)


def parse_display_table(table: str) -> list[list[str]]:
    rows = []
    for line in table.splitlines():
        line = line.strip()
        if not line.startswith("|"):
            continue
        if set(line.replace("|", "").strip()) <= {"-", ":", " "}:
            continue
        cells = [c.strip() for c in line.strip("|").split("|")]
        rows.append(cells)
    return rows


def extract_block_text(md: str, heading: str) -> str:
    start = md.index(heading)
    rest = md[start:]
    # block ends at next heading with "## " or EOF
    m = re.search(r"\n## DRG-P1-", rest[4:])
    if m:
        return rest[: 4 + m.start()]
    return rest


def parse_case(block: str) -> GraphCase:
    item_id = re.search(r"OUTPUT NAMING:\s*\nSave the generated image as exactly:\s*([A-Z0-9_]+)\.png", block)
    if not item_id:
        item_id = re.search(r"^##\s+(DRG-P1-[A-Z0-9]+)", block, re.M)
    item = item_id.group(1)
    filename = re.search(r"Save the generated image as exactly:\s*([A-Za-z0-9_\-]+\.png)", block).group(1)
    target = re.search(r"TARGET VARIANT TO RENDER:\s*([A-Z_]+)(?:,\s*missing\s*`?([A-Z_]+)`?)?", block)
    variant = target.group(1)
    missing = target.group(2) if target and target.group(2) else None

    if item.startswith("DRG-P1-01"):
        if "Asarum" in block:
            archetype = "categorical"
            x_label = "growth-light treatment"
            y_label = "stomata/mm2"
            means = [33.8, 40.8, 52.8, 64.0]
            sems = [0.9, 1.1, 0.9, 0.7]
            x_values = ["Deep Shade", "Partial Shade", "Ambient Sun", "High Light"]
        else:
            archetype = "categorical"
            x_label = "growth-light treatment"
            y_label = "stomata/mm2"
            means = [30.2, 37.6, 46.8, 55.0]
            sems = [0.9, 0.9, 0.9, 1.0]
            x_values = ["Cool White", "Warm White", "Red-Enriched", "Far-Red Filtered"]
        return GraphCase(item, variant, filename, archetype, x_label, y_label, x_values, means, sems, missing=missing)
    if item.startswith("DRG-P1-02"):
        if "Solution A" in block and "0.05" in block:
            x_values = ["Solution A", "Solution B", "Solution C", "Solution D"]
            means = [0.05, 0.10, 0.76, 0.81]
            sems = [0.01, 0.02, 0.02, 0.03]
        else:
            x_values = ["Solution Alpha", "Solution Beta", "Solution Gamma", "Solution Delta"]
            means = [0.05, 0.11, 0.79, 0.83]
            sems = [0.01, 0.02, 0.03, 0.03]
        return GraphCase(item, variant, filename, "categorical", "solution treatment", "absorbance at 540 nm", x_values, means, sems, missing=missing)
    if item.startswith("DRG-P1-03"):
        if "desert beetle" in block or "heat-stable" in block:
            x_values = [8, 18, 28, 38, 48, 58, 68, 78]
            means = [9.0, 15.0, 23.5, 34.5, 45.5, 51.5, 39.1, 20.5]
            sems = [0.3, 0.4, 0.5, 0.6, 0.5, 0.5, 0.5, 0.5]
        else:
            x_values = [10, 20, 30, 40, 50, 60, 70, 80]
            means = [12.0, 18.4, 26.8, 37.9, 47.2, 43.5, 31.7, 17.1]
            sems = [0.3, 0.5, 0.5, 0.4, 0.6, 0.4, 0.5, 0.5]
        return GraphCase(item, variant, filename, "series", "temperature (degC)", "umol product/min", x_values, means, sems, x_unit="degC", missing=missing)
    if item.startswith("DRG-P1-04"):
        if "shade-grown tomato" in block:
            x_values = [0, 75, 175, 350, 650, 950, 1400]
            means = [4.5, 9.7, 16.8, 26.6, 35.6, 39.5, 40.7]
            sems = [0.4, 0.4, 0.5, 0.7, 0.7, 0.4, 0.3]
        else:
            x_values = [0, 100, 250, 500, 750, 1000, 1500]
            means = [4.2, 11.1, 21.9, 34.8, 42.1, 43.2, 43.5]
            sems = [0.4, 0.5, 0.7, 0.7, 0.5, 0.5, 0.3]
        return GraphCase(item, variant, filename, "series", "light intensity (umol photons/m2/s)", "umol CO2/m2/s", x_values, means, sems, x_unit="umol photons/m2/s", missing=missing)
    if item.startswith("DRG-P1-05"):
        x_values = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]
        means = [12.6, 7.8, 2.7, -2.6, -7.1, -11.8]
        return GraphCase(item, variant, filename, "relationship", "solute concentration (M)", "percent mass change", x_values, means, x_unit="M", intercept=0.48, missing=missing)
    if item.startswith("DRG-P1-06"):
        if "cyanobacterium" in block:
            x_values = [0, 2, 5, 8, 11, 14, 17, 21]
            means = [1.4, 4.9, 8.7, 11.8, 13.7, 14.8, 15.4, 15.7]
            plateau = 16.0
        else:
            x_values = [0, 4, 8, 12, 16, 20, 24, 28]
            means = [1.6, 6.9, 10.8, 13.3, 15.2, 16.4, 17.0, 17.5]
            plateau = 18.0
        return GraphCase(item, variant, filename, "plateau", "time (hr)", "10^5 cells/mL", x_values, means, x_unit="hr", plateau=plateau, missing=missing)
    raise ValueError(f"Unrecognized item in block: {item}")


def setup_axes(ax, xlim, ylim):
    ax.set_facecolor("#fcfbf6")
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)
    for s in ("left", "bottom"):
        ax.spines[s].set_linewidth(1.8)
    ax.set_xlim(*xlim)
    ax.set_ylim(*ylim)
    ax.grid(which="major", color="#cfd3d8", linewidth=0.85)
    ax.grid(which="minor", color="#e8eaee", linewidth=0.55)
    ax.set_axisbelow(True)


def draw_graph(case: GraphCase, out_path: Path):
    fig, ax = plt.subplots(figsize=(8.5, 11), dpi=180)
    if case.archetype == "categorical":
        x = np.arange(len(case.x_values))
        ymax = max(m + s for m, s in zip(case.means, case.sems or []))
        setup_axes(ax, (-0.7, len(case.x_values) - 0.3), (0, ymax * 1.3))
        ax.set_xticks(x)
        ax.set_xticklabels(case.x_values, fontproperties=fp(12), rotation=15, ha="right")
        ax.set_ylabel(case.y_label, fontproperties=fp(15))
        ax.set_xlabel("treatment", fontproperties=fp(15))
        ax.yaxis.set_major_locator(MultipleLocator(10 if ymax > 10 else 0.1))
        ax.yaxis.set_minor_locator(MultipleLocator(2 if ymax > 10 else 0.02))
        if case.missing == "Y_SCALE":
            if "06B" in case.filename:
                ax.set_ylim(1.0, 18.0)
                ax.yaxis.set_major_locator(MultipleLocator(2))
                ax.yaxis.set_minor_locator(MultipleLocator(0.5))
            elif ymax <= 1.5:
                ax.set_ylim(0.02, 0.9)
                ax.yaxis.set_major_locator(MultipleLocator(0.1))
                ax.yaxis.set_minor_locator(MultipleLocator(0.02))
            else:
                ax.set_ylim(max(20, ymax * 0.25), ymax * 1.3)
                ax.yaxis.set_major_locator(MultipleLocator(10))
                ax.yaxis.set_minor_locator(MultipleLocator(2))
        if case.variant_tag.startswith("PARTIAL"):
            if case.missing == "UNCERTAINTY_MARKS":
                ax.plot(x, case.means, color="#1b1b1b", linestyle="None", marker="o", markersize=4.3)
            else:
                ax.errorbar(x, case.means, yerr=case.sems, fmt="o", color="#1b1b1b", ecolor="#1b1b1b", elinewidth=1.2, capsize=4, markersize=4.3)
        else:
            ax.errorbar(x, case.means, yerr=case.sems, fmt="o", color="#1b1b1b", ecolor="#1b1b1b", elinewidth=1.2, capsize=4, markersize=4.3)
    elif case.archetype == "series":
        xs = np.array(case.x_values, dtype=float)
        ys = np.array(case.means, dtype=float)
        sems = np.array(case.sems or [0] * len(xs), dtype=float)
        xpad = (xs.max() - xs.min()) * 0.08 or 1.0
        ypad = (ys.max() + sems.max()) * 0.12 or 1.0
        setup_axes(ax, (xs.min() - xpad, xs.max() + xpad), (0, ys.max() + sems.max() + ypad))
        ax.xaxis.set_major_locator(MultipleLocator(max((xs.max() - xs.min()) / 5, 1)))
        ax.xaxis.set_minor_locator(MultipleLocator(max((xs.max() - xs.min()) / 20, 0.25)))
        ax.yaxis.set_major_locator(MultipleLocator(max((ys.max() + sems.max()) / 5, 5)))
        ax.yaxis.set_minor_locator(MultipleLocator(max((ys.max() + sems.max()) / 20, 1)))
        if case.missing == "POINT_CONNECTION":
            ax.scatter(xs, ys, color="#1b1b1b", s=18, zorder=3)
            ax.errorbar(xs, ys, yerr=sems, fmt="none", color="#1b1b1b", ecolor="#1b1b1b", elinewidth=1.2, capsize=4)
            # Intentional misconception: a smooth curve that misses the exact points.
            if len(xs) >= 3:
                offset = np.array([0.6 if i % 2 == 0 else -0.6 for i in range(len(xs))], dtype=float)
                coeffs = np.polyfit(xs, ys + offset, min(3, len(xs) - 1))
                x_dense = np.linspace(xs.min(), xs.max(), 300)
                ax.plot(x_dense, np.polyval(coeffs, x_dense), color="#1b1b1b", linewidth=1.8)
        elif case.missing == "UNCERTAINTY_MARKS":
            ax.plot(xs, ys, color="#1b1b1b", linewidth=1.8, marker="o", markersize=4.2)
        elif case.missing == "BEST_FIT_RELATIONSHIP":
            ax.plot(xs, ys, color="#1b1b1b", linewidth=1.8, marker="o", markersize=4.2)
        else:
            ax.errorbar(xs, ys, yerr=sems, fmt="o-", color="#1b1b1b", ecolor="#1b1b1b", elinewidth=1.2, capsize=4, linewidth=1.8, markersize=4.2)
        if case.filename.startswith("DRG-P1-04"):
            ax.set_xlabel(case.x_label, fontproperties=fp(15))
        else:
            ax.set_xlabel(case.x_label, fontproperties=fp(15))
        ax.set_ylabel(case.y_label, fontproperties=fp(15))
    elif case.archetype == "relationship":
        xs = np.array(case.x_values, dtype=float)
        ys = np.array(case.means, dtype=float)
        xpad = (xs.max() - xs.min()) * 0.15 or 1.0
        ypad = max(abs(ys).max() * 0.2, 3.0)
        setup_axes(ax, (xs.min() - xpad, xs.max() + xpad), (min(ys.min() - ypad, -ypad), max(ys.max() + ypad, ypad)))
        ax.scatter(xs, ys, color="#1b1b1b", s=18, zorder=3)
        if case.missing == "BEST_FIT_RELATIONSHIP":
            ax.plot(xs, ys, color="#1b1b1b", linewidth=1.8, marker="o", markersize=4.2)
        else:
            slope, intercept = np.polyfit(xs, ys, 1)
            xline = np.linspace(xs.min() - xpad * 0.6, xs.max() + xpad * 0.6, 200)
            ax.plot(xline, slope * xline + intercept, color="#1b1b1b", linewidth=1.8)
            ax.axvline(case.intercept, color="#1b1b1b", linestyle="--", linewidth=1.1)
            ax.annotate(
                f"{case.intercept:.1f} M",
                xy=(case.intercept, 0),
                xytext=(case.intercept + xpad * 0.12, ypad * 0.35),
                fontproperties=fp(13),
                arrowprops=dict(arrowstyle="->", linewidth=1.0, color="#1b1b1b"),
            )
        ax.set_xlabel(case.x_label, fontproperties=fp(15))
        ax.set_ylabel(case.y_label, fontproperties=fp(15))
    elif case.archetype == "plateau":
        xs = np.array(case.x_values, dtype=float)
        ys = np.array(case.means, dtype=float)
        xpad = (xs.max() - xs.min()) * 0.08 or 1.0
        ypad = (ys.max() - ys.min()) * 0.18 or 1.0
        setup_axes(ax, (xs.min() - xpad, xs.max() + xpad), (0, ys.max() + ypad))
        ax.xaxis.set_major_locator(MultipleLocator(max((xs.max() - xs.min()) / 5, 1)))
        ax.xaxis.set_minor_locator(MultipleLocator(max((xs.max() - xs.min()) / 20, 0.25)))
        ax.yaxis.set_major_locator(MultipleLocator(max(ys.max() / 5, 5)))
        ax.yaxis.set_minor_locator(MultipleLocator(max(ys.max() / 20, 1)))
        if case.missing == "Y_SCALE":
            if "06B" in case.filename:
                ax.set_yscale("log")
                ax.set_ylim(1.0, 22.0)
                ax.yaxis.set_major_locator(LogLocator(base=10, subs=(1.0, 2.0, 5.0)))
                ax.yaxis.set_minor_locator(LogLocator(base=10, subs=tuple(np.arange(1.0, 10.0) * 0.1)))
            else:
                ax.set_ylim(20, ys.max() * 1.3)
                ax.yaxis.set_major_locator(MultipleLocator(10))
                ax.yaxis.set_minor_locator(MultipleLocator(2))
        if case.missing == "BEST_FIT_RELATIONSHIP":
            ax.plot(xs, ys, color="#1b1b1b", linewidth=1.8, marker="o", markersize=4.2)
        else:
            degree = min(3, len(xs) - 1)
            coeffs = np.polyfit(xs, ys, degree)
            x_dense = np.linspace(xs.min(), xs.max(), 300)
            y_dense = np.polyval(coeffs, x_dense)
            ax.plot(x_dense, y_dense, color="#1b1b1b", linewidth=1.8)
            ax.scatter(xs, ys, color="#1b1b1b", s=18, zorder=3)
        if case.missing not in {"PLATEAU_ANNOTATION", "BEST_FIT_RELATIONSHIP"}:
            start = xs[int(len(xs) * 0.6)]
            ax.annotate(
                "",
                xy=(start, case.plateau),
                xytext=(start + (xs.max() - xs.min()) * 0.18, case.plateau + 0.8),
                arrowprops=dict(arrowstyle="-[", linewidth=1.2, color="#1b1b1b"),
            )
            ax.text(start + (xs.max() - xs.min()) * 0.06, case.plateau + 1.0, "level-off", fontproperties=fp(13))
        ax.set_xlabel(case.x_label, fontproperties=fp(15))
        ax.set_ylabel(case.y_label, fontproperties=fp(15))
    ax.tick_params(axis="both", labelsize=11)
    fig.tight_layout(pad=1.15)
    fig.savefig(out_path, facecolor=fig.get_facecolor())
    plt.close(fig)


def read_prompt_blocks() -> list[str]:
    text = PROMPT_FILE.read_text(encoding="utf-8")
    blocks = []
    current = []
    in_block = False
    for line in text.splitlines():
        if line.startswith("## DRG-P1-"):
            if current:
                blocks.append("\n".join(current))
                current = []
            in_block = True
        if in_block:
            current.append(line)
    if current:
        blocks.append("\n".join(current))
    return blocks


def main() -> int:
    blocks = read_prompt_blocks()
    cases: list[GraphCase] = []
    for block in blocks:
        cases.append(parse_case(block))
    ASSET_DIR.mkdir(parents=True, exist_ok=True)
    lines = [
        "# DRG P1 Reference Images",
        "",
        "Reference image set generated from [DRG_P1_REFERENCE_IMAGE_PROMPTS.md](/Users/davidbloom/Documents/Cramapple/prompts/DRG_P1_REFERENCE_IMAGE_PROMPTS.md).",
        "",
    ]
    for case in cases:
        out_path = ASSET_DIR / case.filename
        draw_graph(case, out_path)
        lines.append(f"## {case.item_id} - {case.variant_tag}")
        lines.append("")
        lines.append(
            f"**Image (Supabase Storage):** "
            f"`validation-artifacts/drawn-response-reference-images/drg-p1/{case.filename}` "
            f"— see prompts/UPLOAD_TO_STORAGE.md"
        )
        lines.append("")
    OUT_MD.write_text("\n".join(lines), encoding="utf-8")
    print(f"Wrote {OUT_MD}")
    print(f"Rendered {len(cases)} images into {ASSET_DIR}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
