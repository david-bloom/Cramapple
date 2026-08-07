#!/usr/bin/env python3
"""Deterministic, code-drawn candidate images for AP Biology's 8 construct-
sensitive items (see ../APBIO_SYNTHETIC_IMAGE_SURVEY_2026_08_04.md, section 1).

Same rationale and style conventions as
../ap_biology_stimulus_images_2026_07_12/generate.py: textbook-schematic,
not photorealistic; matplotlib patches/plots driven by the exact values in
each item's Production `stimulus` text, not free-form generation. This is
the recommended alternative to the generative-image-model smoke test in this
directory, which failed scientific-accuracy QA on 4 of 6 images (2 models x
3 items).

Covers 7 of the 8 construct-sensitive items: APBIO-FRQ-L-003, L-009, L-011,
L-019, L-020, L-021, L-027. L-028 (Mount St. Helens succession photographs)
is intentionally NOT covered here - it asks for actual photographs, which a
chart library cannot produce; see the survey doc section 4.2 for the
recommended separate path (licensable archival photography, not synthesis).

Candidate output only. Every image here still requires the same human
scientific-accuracy review pass that caught 3 real errors in the original
10-image batch, plus the Learning Quality construct-equivalence review
TASK-0020 requires, before anything is a release candidate.
"""
import os
import tempfile
from pathlib import Path

os.environ.setdefault(
    "MPLCONFIGDIR",
    str(Path(tempfile.gettempdir()) / "cramapple-image-generator-matplotlib-cache"),
)
import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.patches import Circle, Rectangle, FancyArrowPatch, FancyBboxPatch

OUT = Path(__file__).resolve().parent

plt.rcParams.update({
    "font.size": 12,
    "font.family": "DejaVu Sans",
    "axes.edgecolor": "#333333",
})


def save(fig, name):
    fig.savefig(OUT / name, dpi=150, bbox_inches="tight", facecolor="white")
    plt.close(fig)
    print(f"saved {name}")


def _box(ax, x, y, w, h, text, fc="#eaf3ec", ec="#1a6b3e", fontsize=10):
    box = FancyBboxPatch(
        (x, y), w, h,
        boxstyle="round,pad=0.02,rounding_size=0.04",
        linewidth=1.5, edgecolor=ec, facecolor=fc,
    )
    ax.add_patch(box)
    ax.text(x + w / 2, y + h / 2, text, ha="center", va="center", fontsize=fontsize, wrap=True)


def _arrow(ax, xy_from, xy_to, color="#333333", style="-|>", lw=1.8, connectionstyle="arc3,rad=0.0"):
    arr = FancyArrowPatch(
        xy_from, xy_to, arrowstyle=style, color=color, lw=lw,
        mutation_scale=14, connectionstyle=connectionstyle,
    )
    ax.add_patch(arr)


# ---------------------------------------------------------------------------
# Pedigree helper - shared by APBIO-FRQ-L-003 and APBIO-FRQ-L-019
# ---------------------------------------------------------------------------
SYMBOL_SIZE = 0.32


def _pedigree_person(ax, x, y, sex, affected, label):
    fc = "black" if affected else "white"
    if sex == "M":
        ax.add_patch(Rectangle(
            (x - SYMBOL_SIZE, y - SYMBOL_SIZE), SYMBOL_SIZE * 2, SYMBOL_SIZE * 2,
            facecolor=fc, edgecolor="black", linewidth=1.6,
        ))
    else:
        ax.add_patch(Circle((x, y), SYMBOL_SIZE, facecolor=fc, edgecolor="black", linewidth=1.6))
    ax.text(x, y - SYMBOL_SIZE - 0.22, label, ha="center", va="top", fontsize=9)


def _mating_line(ax, x1, x2, y):
    ax.plot([x1 + SYMBOL_SIZE, x2 - SYMBOL_SIZE], [y, y], color="black", linewidth=1.4)


def _sibship(ax, parent_mid_x, parent_y, child_xs, child_y, bar_y):
    # drop from the mating-line midpoint down to a horizontal sibship bar,
    # then a vertical stub from the bar down to each child's symbol.
    ax.plot([parent_mid_x, parent_mid_x], [parent_y, bar_y], color="black", linewidth=1.4)
    ax.plot([min(child_xs), max(child_xs)], [bar_y, bar_y], color="black", linewidth=1.4)
    for cx in child_xs:
        ax.plot([cx, cx], [bar_y, child_y + SYMBOL_SIZE], color="black", linewidth=1.4)


def _pedigree_legend(ax, x, y, extra_note=None):
    _pedigree_person(ax, x, y, "M", False, "")
    ax.text(x + 0.5, y, "Unaffected male", va="center", fontsize=9)
    _pedigree_person(ax, x, y - 0.9, "F", False, "")
    ax.text(x + 0.5, y - 0.9, "Unaffected female", va="center", fontsize=9)
    _pedigree_person(ax, x + 3.6, y, "M", True, "")
    ax.text(x + 4.1, y, "Affected male", va="center", fontsize=9)
    _pedigree_person(ax, x + 3.6, y - 0.9, "F", True, "")
    ax.text(x + 4.1, y - 0.9, "Affected female", va="center", fontsize=9)
    if extra_note:
        ax.text(x, y - 1.8, extra_note, fontsize=8.5, style="italic")


# ---------------------------------------------------------------------------
# APBIO-FRQ-L-003: pedigree for Syndrome X, 3 generations, II-3 x II-4 mated
# ---------------------------------------------------------------------------
def l003():
    fig, ax = plt.subplots(figsize=(9, 8))
    ax.set_xlim(0, 8)
    ax.set_ylim(-2.6, 7)
    ax.axis("off")
    ax.set_title("Pedigree for Syndrome X", fontsize=13, pad=12)

    ax.text(0.2, 6, "I", fontsize=13, fontweight="bold")
    ax.text(0.2, 4, "II", fontsize=13, fontweight="bold")
    ax.text(0.2, 2, "III", fontsize=13, fontweight="bold")

    # Generation I: I-1 (affected female) x I-2 (unaffected male)
    _pedigree_person(ax, 3, 6, "F", True, "I-1")
    _pedigree_person(ax, 5, 6, "M", False, "I-2")
    _mating_line(ax, 3, 5, 6)

    # Generation II: six children of I-1 x I-2
    gen2_x = [1, 2, 3, 4, 5, 6]
    gen2 = [
        ("M", True, "II-1"), ("F", False, "II-2"), ("F", True, "II-3"),
        ("M", False, "II-4"), ("M", False, "II-5"), ("F", False, "II-6"),
    ]
    for x, (sex, aff, label) in zip(gen2_x, gen2):
        _pedigree_person(ax, x, 4, sex, aff, label)
    _sibship(ax, parent_mid_x=4, parent_y=6, child_xs=gen2_x, child_y=4, bar_y=5)

    # II-3 x II-4 mate (adjacent at x=3 and x=4)
    _mating_line(ax, 3, 4, 4)

    # Generation III: four children of II-3 x II-4
    gen3_x = [2.5, 3.17, 3.83, 4.5]
    gen3 = [
        ("M", False, "III-1"), ("F", True, "III-2"),
        ("M", False, "III-3"), ("F", False, "III-4"),
    ]
    for x, (sex, aff, label) in zip(gen3_x, gen3):
        _pedigree_person(ax, x, 2, sex, aff, label)
    _sibship(ax, parent_mid_x=3.5, parent_y=4, child_xs=gen3_x, child_y=2, bar_y=3)

    _pedigree_legend(ax, 0.5, -1.3)

    save(fig, "APBIO-FRQ-L-003.png")


# ---------------------------------------------------------------------------
# APBIO-FRQ-L-019: X-linked pedigree, no affected females
# ---------------------------------------------------------------------------
def l019():
    fig, ax = plt.subplots(figsize=(9, 7.5))
    ax.set_xlim(0, 8)
    ax.set_ylim(-2.6, 7)
    ax.axis("off")
    ax.set_title("Pedigree - Figure 1", fontsize=13, pad=12)

    ax.text(0.2, 6, "I", fontsize=13, fontweight="bold")
    ax.text(0.2, 4, "II", fontsize=13, fontweight="bold")
    ax.text(0.2, 2, "III", fontsize=13, fontweight="bold")

    # Generation I: I-1 (unaffected male) x I-2 (unaffected female)
    _pedigree_person(ax, 3, 6, "M", False, "I-1")
    _pedigree_person(ax, 5, 6, "F", False, "I-2")
    _mating_line(ax, 3, 5, 6)

    # Generation II: five children of I-1 x I-2
    gen2_x = [1, 2, 3, 4, 5]
    gen2 = [
        ("F", False, "II-1"), ("M", False, "II-2"), ("M", True, "II-3"),
        ("F", False, "II-4"), ("M", False, "II-5"),
    ]
    for x, (sex, aff, label) in zip(gen2_x, gen2):
        _pedigree_person(ax, x, 4, sex, aff, label)
    _sibship(ax, parent_mid_x=4, parent_y=6, child_xs=gen2_x, child_y=4, bar_y=5)

    # II-4 x II-5 mate (adjacent at x=4 and x=5)
    _mating_line(ax, 4, 5, 4)

    # Generation III: two children of II-4 x II-5
    gen3_x = [4.2, 4.8]
    gen3 = [("M", True, "III-1"), ("F", False, "III-2")]
    for x, (sex, aff, label) in zip(gen3_x, gen3):
        _pedigree_person(ax, x, 2, sex, aff, label)
    _sibship(ax, parent_mid_x=4.5, parent_y=4, child_xs=gen3_x, child_y=2, bar_y=3)

    _pedigree_legend(ax, 0.5, -1.3, extra_note="No affected females appear in this pedigree.")

    save(fig, "APBIO-FRQ-L-019.png")


# ---------------------------------------------------------------------------
# APBIO-FRQ-L-009: marine food web, linear chain
# ---------------------------------------------------------------------------
def l009():
    fig, ax = plt.subplots(figsize=(10.6, 2.4))
    ax.set_xlim(0, 10.6)
    ax.set_ylim(0, 2)
    ax.axis("off")

    labels = ["Phytoplankton", "Zooplankton", "Small fish\n(anchovies)", "Tuna"]
    xs = [0.3, 2.9, 5.5, 8.3]
    w = 2.0
    for x, label in zip(xs, labels):
        _box(ax, x, 0.5, w, 1.0, label, fontsize=11)
    for i in range(len(xs) - 1):
        _arrow(ax, (xs[i] + w, 1.0), (xs[i + 1], 1.0))

    save(fig, "APBIO-FRQ-L-009.png")


# ---------------------------------------------------------------------------
# APBIO-FRQ-L-011: enzyme activity vs. pH, three enzymes
# ---------------------------------------------------------------------------
def _bell(x, peak, low, high, height=100):
    # Gaussian shaped to be ~0 at the stated active-range edges, peak at `peak`.
    sigma_left = (peak - low) / 3
    sigma_right = (high - peak) / 3
    sigma = np.where(x <= peak, sigma_left, sigma_right)
    return height * np.exp(-0.5 * ((x - peak) / sigma) ** 2)


def l011():
    fig, ax = plt.subplots(figsize=(8, 5.5))
    ph = np.linspace(0, 14, 600)

    pepsin = _bell(ph, 2.0, 1.0, 3.5)
    amylase = _bell(ph, 7.0, 6.0, 8.5)
    trypsin = _bell(ph, 8.0, 7.0, 9.0)

    ax.plot(ph, pepsin, color="#1a6b3e", linewidth=2.5, label="Pepsin (peak pH 2.0)")
    ax.plot(ph, amylase, color="#2166ac", linewidth=2.5, linestyle="--", label="Amylase (peak pH 7.0)")
    ax.plot(ph, trypsin, color="#c0392b", linewidth=2.5, linestyle=":", label="Trypsin (peak pH 8.0)")

    ax.set_xlabel("pH")
    ax.set_ylabel("Relative enzyme activity")
    ax.set_xlim(0, 14)
    ax.set_xticks(range(0, 15, 2))
    ax.set_ylim(0, 110)
    ax.set_yticks([])
    ax.legend(loc="upper right", fontsize=9, frameon=True)
    ax.grid(alpha=0.2)

    save(fig, "APBIO-FRQ-L-011.png")


# ---------------------------------------------------------------------------
# APBIO-FRQ-L-020 (Figure 2 only): norm of reaction for wheat yield
# ---------------------------------------------------------------------------
def l020():
    fig, ax = plt.subplots(figsize=(7, 5.5))
    levels = ["Low", "Medium", "High"]
    x = [0, 1, 2]
    genotype_x = [20, 25, 30]
    genotype_y = [15, 25, 35]
    genotype_z = [28, 28, 28]

    ax.plot(x, genotype_x, marker="o", linewidth=2.2, color="#1a6b3e", label="Genotype X")
    ax.plot(x, genotype_y, marker="s", linewidth=2.2, color="#2166ac", label="Genotype Y")
    ax.plot(x, genotype_z, marker="^", linewidth=2.2, color="#c0392b", label="Genotype Z")

    ax.set_xticks(x)
    ax.set_xticklabels(levels)
    ax.set_xlabel("Nitrogen level")
    ax.set_ylabel("Wheat yield (kg/plot)")
    ax.set_title("Figure 2: Norm of Reaction for Wheat Yield", fontsize=12)
    ax.legend(loc="upper left", fontsize=9)
    ax.grid(alpha=0.2)
    ax.set_ylim(10, 40)

    save(fig, "APBIO-FRQ-L-020.png")


# ---------------------------------------------------------------------------
# APBIO-FRQ-L-021 (Figure 1 only): euchromatin vs. heterochromatin
# ---------------------------------------------------------------------------
def l021():
    fig, axes = plt.subplots(1, 2, figsize=(10, 5))

    # Euchromatin: beads-on-a-string, loosely packed, gene accessible
    ax = axes[0]
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 6)
    ax.axis("off")
    ax.set_title("Euchromatin - Gene ON", fontsize=12)
    xs = np.linspace(0.5, 9.5, 14)
    ys = 3 + 0.6 * np.sin(xs * 1.3)
    ax.plot(xs, ys, color="#333", linewidth=1.5, zorder=1)
    for x, y in zip(xs, ys):
        ax.add_patch(Circle((x, y), 0.28, facecolor="#dfe6f5", edgecolor="#333", linewidth=1.2, zorder=2))
    ax.text(1, 5.4, "nucleosomes\n(“beads on a string”)", fontsize=8.5)
    _box(ax, 3.5, 4.4, 2.5, 0.7, "RNA polymerase\ncan access DNA", fc="#eaf3ec", fontsize=8)
    _arrow(ax, (4.75, 4.4), (4.75, 3.5))

    # Heterochromatin: highly compact, gene inaccessible
    ax = axes[1]
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 6)
    ax.axis("off")
    ax.set_title("Heterochromatin - Gene OFF", fontsize=12)
    np.random.seed(7)
    cx, cy = 5, 3
    for i in range(40):
        r = 1.6 * np.sqrt(np.random.rand())
        theta = 2 * np.pi * np.random.rand()
        ax.add_patch(Circle(
            (cx + r * np.cos(theta), cy + r * np.sin(theta)), 0.28,
            facecolor="#8a8f99", edgecolor="#333", linewidth=1.0, zorder=2,
        ))
    ax.text(1.5, 5.4, "densely packed\n300 nm fiber", fontsize=8.5)
    _box(ax, 3.75, 0.6, 2.5, 0.7, "DNA inaccessible\nto RNA polymerase", fc="#fbe6e6", ec="#c0392b", fontsize=8)

    save(fig, "APBIO-FRQ-L-021.png")


# ---------------------------------------------------------------------------
# APBIO-FRQ-L-027 (Figure 1 only): Keeling Curve + temperature anomaly
# ---------------------------------------------------------------------------
def l027():
    fig, ax1 = plt.subplots(figsize=(9, 5.5))
    years = np.linspace(1850, 2024, 400)
    t = (years - 1850) / (2024 - 1850)
    # accelerating rise from 280 -> 421 ppm; simple convex interpolation
    co2 = 280 + (421 - 280) * t ** 1.7
    seasonal = 4 * np.sin(2 * np.pi * years) * (t ** 1.5) * 0.15
    co2_seasonal = co2 + seasonal
    temp_anom = 1.4 * t ** 1.6

    color_co2 = "#2166ac"
    color_temp = "#c0392b"

    ax1.plot(years, co2_seasonal, color=color_co2, linewidth=2)
    ax1.set_xlabel("Year")
    ax1.set_ylabel("Atmospheric CO₂ (ppm)", color=color_co2)
    ax1.tick_params(axis="y", labelcolor=color_co2)
    ax1.set_xlim(1850, 2024)
    ax1.set_ylim(260, 440)
    ax1.axhline(280, color=color_co2, linestyle=":", linewidth=1, alpha=0.6)
    ax1.text(1855, 285, "280 ppm (1850)", fontsize=8, color=color_co2)
    ax1.axhline(421, color=color_co2, linestyle=":", linewidth=1, alpha=0.6)
    ax1.text(1855, 425, "421 ppm (2024)", fontsize=8, color=color_co2)

    ax2 = ax1.twinx()
    ax2.plot(years, temp_anom, color=color_temp, linewidth=2)
    ax2.set_ylabel("Global temperature anomaly (°C, vs. 1850 baseline)", color=color_temp)
    ax2.tick_params(axis="y", labelcolor=color_temp)
    ax2.set_ylim(-0.2, 2.2)
    ax2.axhline(1.4, color=color_temp, linestyle=":", linewidth=1, alpha=0.6)
    ax2.text(2015, 1.45, "+1.4°C (2024)", fontsize=8, color=color_temp, ha="right")

    ax1.set_title("Figure 1: Atmospheric CO₂ and Global Temperature Anomaly, 1850-2024", fontsize=11.5)
    save(fig, "APBIO-FRQ-L-027.png")


def main():
    l003()
    l009()
    l011()
    l019()
    l020()
    l021()
    l027()


if __name__ == "__main__":
    main()
