#!/usr/bin/env python3
"""Generate the 10 missing AP Biology reference images.

Textbook-style, labeled schematic diagrams and data-plot graphs — matching
the exact descriptions stored in content_item_versions.stimulus for each
content_key. Not photorealistic; appropriate for assessment content where
accuracy and clarity of the labeled relationships matters more than art
style.
"""
import argparse
import os
import tempfile
from pathlib import Path

# Keep Matplotlib's cache out of developer home directories and the repository.
os.environ.setdefault(
    "MPLCONFIGDIR",
    str(Path(tempfile.gettempdir()) / "cramapple-image-generator-matplotlib-cache"),
)
import matplotlib

DEFAULT_OUT = Path(__file__).resolve().parent
OUT = DEFAULT_OUT
EXPECTED_MATPLOTLIB = "3.11.1"


def load_render_dependencies():
    global plt, np, FancyArrowPatch, FancyBboxPatch, Circle, Rectangle, Ellipse
    matplotlib.use("Agg")
    import matplotlib.pyplot as pyplot
    import numpy as numpy
    from matplotlib.patches import (
        Circle as PatchCircle,
        Ellipse as PatchEllipse,
        FancyArrowPatch as PatchFancyArrowPatch,
        FancyBboxPatch as PatchFancyBboxPatch,
        Rectangle as PatchRectangle,
    )

    plt = pyplot
    np = numpy
    FancyArrowPatch = PatchFancyArrowPatch
    FancyBboxPatch = PatchFancyBboxPatch
    Circle = PatchCircle
    Rectangle = PatchRectangle
    Ellipse = PatchEllipse
    plt.rcParams.update({
        "font.size": 12,
        "font.family": "DejaVu Sans",
        "axes.edgecolor": "#333333",
    })

def save(fig, name):
    fig.savefig(OUT / name, dpi=150, bbox_inches="tight", facecolor="white")
    plt.close(fig)
    print(f"saved {name}")


# ---------------------------------------------------------------------------
# APBIO-FRQ-S-002: catalase reaction rate vs temperature
# ---------------------------------------------------------------------------
def s002():
    fig, ax = plt.subplots(figsize=(7, 5))
    t = np.linspace(10, 70, 400)
    # rises to peak near 37, sharp decline after 50, near zero by 65
    rate = np.where(
        t <= 37,
        100 * (t - 10) / 27,
        np.where(
            t <= 50,
            100 - 15 * (t - 37) / 13,
            85 * np.exp(-0.25 * (t - 50)),
        ),
    )
    rate = np.clip(rate, 0, 105)
    ax.plot(t, rate, color="#1a6b3e", linewidth=2.5)
    ax.axvline(37, color="#888", linestyle="--", linewidth=1)
    ax.text(37.5, 102, "37°C\n(optimum)", fontsize=10, va="top")
    ax.set_xlabel("Temperature (°C)")
    ax.set_ylabel("Relative reaction rate")
    ax.set_title("Catalase Reaction Rate vs. Temperature")
    ax.set_xlim(10, 70)
    ax.set_ylim(0, 110)
    ax.grid(alpha=0.25)
    save(fig, "APBIO-FRQ-S-002.png")


# ---------------------------------------------------------------------------
# APBIO-FRQ-S-012: logistic population growth
# ---------------------------------------------------------------------------
def s012():
    fig, ax = plt.subplots(figsize=(7, 5))
    t = np.linspace(0, 50, 400)
    K, r, N0 = 1000, 0.28, 20
    N = K / (1 + ((K - N0) / N0) * np.exp(-r * t))
    ax.plot(t, N, color="#1a6b3e", linewidth=2.5)
    ax.axhline(K, color="#888", linestyle="--", linewidth=1)
    ax.text(2, K + 25, "Carrying capacity (K)", fontsize=10)
    ax.set_xlabel("Time (years)")
    ax.set_ylabel("Population size (N)")
    ax.set_title("Rabbit Population Growth on Island (Logistic Model)")
    ax.set_xlim(0, 50)
    ax.set_ylim(0, K * 1.15)
    ax.grid(alpha=0.25)
    save(fig, "APBIO-FRQ-S-012.png")


# ---------------------------------------------------------------------------
# APBIO-FRQ-S-020: blood glucose after a meal
# ---------------------------------------------------------------------------
def s020():
    fig, ax = plt.subplots(figsize=(7, 5))
    t = np.linspace(0, 2.5, 400)  # hours
    baseline = 90
    # rises to peak ~150 around 0.5-0.75h, returns to baseline by ~2h
    glucose = baseline + 60 * np.exp(-((t - 0.6) ** 2) / (2 * 0.28 ** 2))
    glucose = np.maximum(glucose, baseline + (baseline - glucose) * 0)  # no-op, keep shape
    # blend back to baseline smoothly past 2h
    tail = t > 1.4
    glucose[tail] = baseline + (glucose[np.argmax(t > 1.4)] - baseline) * np.exp(-3 * (t[tail] - 1.4))
    ax.plot(t, glucose, color="#c0392b", linewidth=2.5)
    ax.axhline(baseline, color="#888", linestyle="--", linewidth=1)
    ax.text(2.05, baseline + 3, "Set point (~90 mg/dL)", fontsize=10)
    ax.axvline(0, color="#333", linewidth=1)
    ax.text(0.02, 205, "Meal", fontsize=10, rotation=90, va="top")
    ax.set_xlabel("Time after meal (hours)")
    ax.set_ylabel("Blood glucose (mg/dL)")
    ax.set_title("Blood Glucose Response to a Carbohydrate-Rich Meal")
    ax.set_xlim(0, 2.5)
    ax.set_ylim(60, 220)
    ax.grid(alpha=0.25)
    save(fig, "APBIO-FRQ-S-020.png")


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
# APBIO-FRQ-S-003: thylakoid membrane, light-dependent reactions
# ---------------------------------------------------------------------------
def s003():
    fig, ax = plt.subplots(figsize=(10, 6))
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 6)
    ax.axis("off")
    ax.set_title("Thylakoid Membrane: Light-Dependent Reactions", fontsize=13, pad=12)

    # membrane band
    ax.add_patch(Rectangle((0.5, 2.2), 9, 1.6, facecolor="#dcecdf", edgecolor="#1a6b3e", linewidth=1.5))
    ax.text(0.7, 5.5, "Thylakoid lumen (inside)", fontsize=9, style="italic")
    ax.text(0.7, 1.6, "Stroma (outside)", fontsize=9, style="italic")

    _box(ax, 1.0, 2.5, 1.5, 1.0, "Photosystem II\n(PSII)")
    _box(ax, 3.3, 2.5, 1.6, 1.0, "Electron\nTransport Chain")
    _box(ax, 5.7, 2.5, 1.5, 1.0, "Photosystem I\n(PSI)")
    _box(ax, 8.0, 2.0, 1.4, 1.6, "ATP\nsynthase")

    # light photons
    ax.annotate("", xy=(1.75, 3.6), xytext=(1.75, 5.2),
                arrowprops=dict(arrowstyle="-|>", color="#e6b800", lw=2))
    ax.text(1.9, 4.9, "light", color="#8a6d00", fontsize=9)
    ax.annotate("", xy=(6.45, 3.6), xytext=(6.45, 5.2),
                arrowprops=dict(arrowstyle="-|>", color="#e6b800", lw=2))
    ax.text(6.6, 4.9, "light", color="#8a6d00", fontsize=9)

    # electron flow along membrane
    _arrow(ax, (2.5, 3.0), (3.3, 3.0))
    _arrow(ax, (4.9, 3.0), (5.7, 3.0))
    _arrow(ax, (7.2, 3.0), (7.5, 3.6), connectionstyle="arc3,rad=-0.3")
    ax.text(3.9, 3.15, "e⁻", fontsize=11, color="#c0392b", ha="center")
    ax.text(6.0, 3.15, "e⁻", fontsize=11, color="#c0392b", ha="center")

    # H+ pumped into lumen
    ax.annotate("", xy=(3.9, 3.9), xytext=(3.9, 2.6),
                arrowprops=dict(arrowstyle="-|>", color="#2166ac", lw=1.5, linestyle="dashed"))
    ax.text(4.05, 3.4, "H⁺", color="#2166ac", fontsize=9)

    # H+ through ATP synthase back to stroma -> ATP
    ax.annotate("", xy=(8.7, 1.8), xytext=(8.7, 3.9),
                arrowprops=dict(arrowstyle="-|>", color="#2166ac", lw=1.5))
    ax.text(9.0, 2.3, "H⁺", color="#2166ac", fontsize=9)
    ax.text(8.5, 1.3, "ADP + Pi → ATP", fontsize=9, ha="center")

    # NADPH product from PSI
    _arrow(ax, (7.2, 3.4), (7.9, 4.3), connectionstyle="arc3,rad=0.3")
    ax.text(7.6, 4.6, "NADP⁺ + H⁺ → NADPH", fontsize=9, ha="center")

    save(fig, "APBIO-FRQ-S-003.png")


# ---------------------------------------------------------------------------
# APBIO-FRQ-S-005: GPCR signaling cascade
# ---------------------------------------------------------------------------
def s005():
    fig, ax = plt.subplots(figsize=(10, 6.5))
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 7)
    ax.axis("off")
    ax.set_title("GPCR Signal Transduction Cascade", fontsize=13, pad=12)

    # membrane
    ax.add_patch(Rectangle((0.5, 4.0), 9, 0.8, facecolor="#e5e9f5", edgecolor="#333", linewidth=1.2))
    ax.text(0.6, 6.4, "extracellular", fontsize=9, style="italic")
    ax.text(0.6, 3.4, "cytoplasm", fontsize=9, style="italic")

    ax.add_patch(Ellipse((1.3, 5.6), 0.9, 0.5, facecolor="#f2c14e", edgecolor="#333"))
    ax.text(1.3, 5.6, "signal", ha="center", va="center", fontsize=8)
    _arrow(ax, (1.7, 5.3), (2.6, 4.6))

    _box(ax, 2.6, 3.9, 1.3, 1.0, "GPCR", fc="#dfe6f5")
    _box(ax, 4.2, 3.4, 1.5, 0.9, "G protein\n(activated)", fc="#dfe6f5")
    _box(ax, 6.0, 3.4, 1.6, 0.9, "Adenylyl\ncyclase")
    _box(ax, 7.9, 3.4, 1.0, 0.9, "cAMP", fc="#fbe6e6", ec="#c0392b")
    _box(ax, 6.0, 1.9, 1.8, 0.9, "Protein Kinase A\n(active)")

    _arrow(ax, (3.9, 4.3), (4.2, 3.9))
    _arrow(ax, (5.7, 3.85), (6.0, 3.85))
    _arrow(ax, (7.6, 3.85), (7.9, 3.85))
    _arrow(ax, (8.4, 3.4), (7.4, 2.4), connectionstyle="arc3,rad=0.2")

    for i, dx in enumerate([-1.3, 0.0, 1.3]):
        tx = 6.9 + dx
        _arrow(ax, (6.9, 1.9), (tx, 0.8))
        _box(ax, tx - 0.6, 0.2, 1.2, 0.6, f"Target {i+1}\n(P)", fc="#fff4dc", ec="#c98a1a", fontsize=8)

    save(fig, "APBIO-FRQ-S-005.png")


# ---------------------------------------------------------------------------
# APBIO-FRQ-S-008: DNA replication fork
# ---------------------------------------------------------------------------
def s008():
    fig, ax = plt.subplots(figsize=(9, 6))
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 7)
    ax.axis("off")
    ax.set_title("DNA Replication Fork", fontsize=13, pad=12)

    # parental duplex (unopened) on the left
    ax.plot([0.5, 3.5], [4.6, 4.6], color="#333", linewidth=2)
    ax.plot([0.5, 3.5], [3.4, 3.4], color="#333", linewidth=2)
    ax.text(0.6, 5.0, "parental strands", fontsize=9)

    # helicase at the fork point
    ax.add_patch(Circle((3.8, 4.0), 0.35, facecolor="#f2c14e", edgecolor="#333"))
    ax.text(3.8, 4.0, "Helicase", ha="center", va="center", fontsize=7)

    # leading strand template -> continuous new strand (top, opens upward)
    ax.plot([4.15, 9.2], [5.4, 6.3], color="#333", linewidth=2)
    ax.plot([4.4, 9.2], [5.15, 5.9], color="#1a6b3e", linewidth=2.2)
    ax.text(6.6, 6.5, "leading strand\n(continuous synthesis)", fontsize=8, ha="center", color="#1a6b3e")
    _box(ax, 7.6, 5.55, 1.3, 0.55, "DNA pol", fc="#eaf3ec", fontsize=8)

    # lagging strand template -> Okazaki fragments (bottom, opens downward)
    ax.plot([4.15, 9.2], [2.6, 1.7], color="#333", linewidth=2)
    for i, xstart in enumerate([4.5, 5.6, 6.7, 7.8]):
        ax.plot([xstart, xstart + 0.9], [2.35 - 0.22 * i, 2.1 - 0.22 * i], color="#c0392b", linewidth=2.2)
    ax.text(6.6, 1.15, "lagging strand\n(Okazaki fragments)", fontsize=8, ha="center", color="#c0392b")
    _box(ax, 5.0, 0.55, 1.3, 0.55, "DNA pol", fc="#fbe6e6", fontsize=8)

    # Fork moves INTO the still-unopened parental duplex (left) -- the
    # leading/lagging strands to the right are already-unwound territory
    # the fork has passed through, so the arrow must point left, not right.
    # (Confirmed wrong in the original render: arrow pointed away from the
    # intact duplex and into the already-replicated region.)
    _arrow(ax, (3.35, 4.0), (2.95, 4.0))
    ax.text(3.15, 3.55, "fork\nmovement", fontsize=7, ha="center")

    save(fig, "APBIO-FRQ-S-008.png")


# ---------------------------------------------------------------------------
# APBIO-FRQ-S-009: pre-mRNA splicing, alternative products
# ---------------------------------------------------------------------------
def s009():
    fig, ax = plt.subplots(figsize=(9, 6))
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 7)
    ax.axis("off")
    ax.set_title("Pre-mRNA Splicing: Two Alternative Mature mRNA Products", fontsize=12, pad=12)

    def segment(ax, x, y, w, label, fc, ec):
        _box(ax, x, y, w, 0.6, label, fc=fc, ec=ec, fontsize=9)
        return x + w

    ax.text(0.3, 5.9, "Pre-mRNA:", fontsize=10, fontweight="bold")
    x = 1.6
    x = segment(ax, x, 5.6, 1.2, "E1", "#dfe6f5", "#333")
    x = segment(ax, x, 5.6, 1.0, "I1", "#f4f4f4", "#999")
    x = segment(ax, x, 5.6, 1.2, "E2", "#dfe6f5", "#333")
    x = segment(ax, x, 5.6, 1.0, "I2", "#f4f4f4", "#999")
    x = segment(ax, x, 5.6, 1.2, "E3", "#dfe6f5", "#333")

    _arrow(ax, (3.5, 5.5), (2.3, 4.4), connectionstyle="arc3,rad=-0.15")
    _arrow(ax, (3.5, 5.5), (2.3, 2.1), connectionstyle="arc3,rad=0.15")
    ax.text(2.6, 4.9, "splicing\n(includes E2)", fontsize=8, ha="center")
    ax.text(2.6, 2.6, "alternative splicing\n(skips E2)", fontsize=8, ha="center")

    ax.text(0.3, 4.1, "mRNA product 1:", fontsize=9)
    x = 1.6
    x = segment(ax, x, 3.8, 1.2, "E1", "#dfe6f5", "#333")
    x = segment(ax, x, 3.8, 1.2, "E2", "#dfe6f5", "#333")
    x = segment(ax, x, 3.8, 1.2, "E3", "#dfe6f5", "#333")

    ax.text(0.3, 1.8, "mRNA product 2:", fontsize=9)
    x = 1.6
    x = segment(ax, x, 1.5, 1.2, "E1", "#dfe6f5", "#333")
    x = segment(ax, x, 1.5, 1.2, "E3", "#dfe6f5", "#333")

    save(fig, "APBIO-FRQ-S-009.png")


# ---------------------------------------------------------------------------
# APBIO-FRQ-S-014: electron transport chain, inner mitochondrial membrane
# ---------------------------------------------------------------------------
def s014():
    fig, ax = plt.subplots(figsize=(10, 6))
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 6)
    ax.axis("off")
    ax.set_title("Electron Transport Chain — Inner Mitochondrial Membrane", fontsize=12, pad=12)

    ax.add_patch(Rectangle((0.4, 2.2), 9.2, 1.6, facecolor="#f5e6de", edgecolor="#8a4b2b", linewidth=1.5))
    ax.text(0.5, 4.2, "intermembrane space", fontsize=9, style="italic")
    ax.text(0.5, 1.6, "mitochondrial matrix", fontsize=9, style="italic")

    # Complex I and Complex II are INDEPENDENT, parallel entry points into
    # the chain (from NADH and FADH2 respectively) -- they do not feed into
    # each other. Both hand electrons to Complex III. The original render
    # drew a direct Complex I -> Complex II arrow, wrongly implying a single
    # sequential I-II-III-IV pathway; fixed by moving Complex II off the
    # main row with its own separate arrow into Complex III.
    _box(ax, 0.8, 2.5, 1.3, 1.0, "Complex I")
    _box(ax, 4.2, 2.5, 1.3, 1.0, "Complex III")
    _box(ax, 5.9, 2.5, 1.3, 1.0, "Complex IV")
    _box(ax, 8.0, 2.0, 1.4, 1.6, "ATP\nsynthase")
    _box(ax, 2.8, 0.55, 1.3, 0.9, "Complex II", fc="#f0f0f0")

    ax.text(0.9, 1.3, "NADH → NAD⁺", fontsize=8)
    ax.text(2.9, 0.25, "FADH₂ → FAD", fontsize=8)

    _arrow(ax, (2.1, 3.0), (4.2, 3.0))
    _arrow(ax, (5.5, 3.0), (5.9, 3.0))
    _arrow(ax, (7.2, 3.0), (7.5, 3.0))
    _arrow(ax, (4.05, 1.45), (4.4, 2.5), connectionstyle="arc3,rad=-0.25")
    ax.text(3.0, 3.15, "e⁻", color="#c0392b", fontsize=10, ha="center")
    ax.text(5.0, 3.15, "e⁻", color="#c0392b", fontsize=10, ha="center")
    ax.text(6.8, 3.15, "e⁻", color="#c0392b", fontsize=10, ha="center")
    ax.text(4.55, 1.75, "e⁻", color="#c0392b", fontsize=10, ha="center")

    for x in (1.45, 4.85, 6.55):
        ax.annotate("", xy=(x, 3.9), xytext=(x, 2.6),
                    arrowprops=dict(arrowstyle="-|>", color="#2166ac", lw=1.4, linestyle="dashed"))
    ax.text(1.6, 3.5, "H⁺", color="#2166ac", fontsize=8)

    ax.annotate("", xy=(8.7, 1.8), xytext=(8.7, 3.9),
                arrowprops=dict(arrowstyle="-|>", color="#2166ac", lw=1.5))
    ax.text(9.0, 2.3, "H⁺", color="#2166ac", fontsize=8)
    ax.text(8.6, 1.3, "ADP + Pi → ATP", fontsize=8, ha="center")

    save(fig, "APBIO-FRQ-S-014.png")


# ---------------------------------------------------------------------------
# APBIO-FRQ-S-015: lac operon
# ---------------------------------------------------------------------------
def s015():
    fig, ax = plt.subplots(figsize=(10, 5.5))
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 6)
    ax.axis("off")
    ax.set_title("The lac Operon", fontsize=13, pad=12)

    # regulatory gene lacI, transcribed from its own separate promoter --
    # NOT the operon's Promoter box a few pixels to the right. The original
    # render drew an arrow from lacI straight into that Promoter box, which
    # visually implied a functional link between the two (as if lacI's
    # transcription fed into starting the operon); replaced with a small
    # self-contained annotation above lacI instead, with no connecting line.
    _box(ax, 0.4, 3.7, 1.6, 0.8, "lacI\n(regulatory gene)", fc="#eaf3ec", fontsize=8)
    ax.text(1.2, 4.7, "(has its own separate promoter,\nnot shown)", fontsize=6, ha="center", style="italic")

    # repressor protein produced
    ax.add_patch(Circle((1.2, 2.3), 0.4, facecolor="#f2c14e", edgecolor="#333"))
    ax.text(1.2, 2.3, "Repressor", ha="center", va="center", fontsize=6)
    _arrow(ax, (1.2, 3.65), (1.2, 2.7))

    # main operon: promoter, operator, lacZ, lacY, lacA
    _box(ax, 2.6, 3.7, 1.1, 0.8, "Promoter", fc="#dfe6f5", fontsize=8)
    _box(ax, 3.8, 3.7, 1.1, 0.8, "Operator", fc="#fbe6e6", fontsize=8)
    _box(ax, 5.0, 3.7, 1.3, 0.8, "lacZ", fc="#fff4dc", fontsize=9)
    _box(ax, 6.4, 3.7, 1.3, 0.8, "lacY", fc="#fff4dc", fontsize=9)
    _box(ax, 7.8, 3.7, 1.3, 0.8, "lacA", fc="#fff4dc", fontsize=9)

    # repressor bound to operator (no lactose)
    ax.add_patch(Circle((4.35, 2.7), 0.35, facecolor="#f2c14e", edgecolor="#333", alpha=0.6))
    ax.text(4.35, 2.7, "Repressor\nbound", ha="center", va="center", fontsize=6)
    _arrow(ax, (4.35, 3.05), (4.35, 3.65))
    ax.text(4.35, 2.1, "(no lactose present:\ntranscription OFF)", fontsize=6.5, ha="center")

    # allolactose inducer
    ax.add_patch(Ellipse((7.0, 1.3), 0.9, 0.5, facecolor="#a8d5ba", edgecolor="#1a6b3e"))
    ax.text(7.0, 1.3, "allolactose", ha="center", va="center", fontsize=6.5)
    _arrow(ax, (6.6, 1.6), (4.7, 2.4), connectionstyle="arc3,rad=-0.2")
    ax.text(5.6, 1.5, "binds repressor\n→ released from operator\n→ transcription ON", fontsize=6.5, ha="center")

    save(fig, "APBIO-FRQ-S-015.png")


# ---------------------------------------------------------------------------
# APBIO-FRQ-S-018: gap junctions vs plasmodesmata
# ---------------------------------------------------------------------------
def s018():
    fig, axes = plt.subplots(1, 2, figsize=(11, 5))
    for ax in axes:
        ax.set_xlim(0, 10)
        ax.set_ylim(0, 6)
        ax.axis("off")

    ax = axes[0]
    ax.set_title("Animal Cells: Gap Junctions", fontsize=12)
    ax.add_patch(Ellipse((3, 3), 4.6, 4.2, facecolor="#eaf3ec", edgecolor="#1a6b3e", linewidth=1.5))
    ax.add_patch(Ellipse((7, 3), 4.6, 4.2, facecolor="#eaf3ec", edgecolor="#1a6b3e", linewidth=1.5))
    for x in (4.75, 5.05, 5.35):
        ax.add_patch(Rectangle((x, 2.5), 0.2, 1.0, facecolor="#c98a1a", edgecolor="#333"))
    ax.annotate("", xy=(4.6, 3.0), xytext=(5.6, 3.0), arrowprops=dict(arrowstyle="<->", color="#333"))
    ax.text(5.0, 1.8, "connexin channel\n(gap junction)", fontsize=8, ha="center")

    ax = axes[1]
    ax.set_title("Plant Cells: Plasmodesmata", fontsize=12)
    ax.add_patch(Rectangle((0.9, 0.9), 3.9, 4.2, facecolor="#eaf3ec", edgecolor="#1a6b3e", linewidth=1.5))
    ax.add_patch(Rectangle((5.2, 0.9), 3.9, 4.2, facecolor="#eaf3ec", edgecolor="#1a6b3e", linewidth=1.5))
    ax.add_patch(Rectangle((4.6, 0.7), 0.7, 4.6, facecolor="#d8d0b8", edgecolor="#8a7a4b", linewidth=1.5))
    ax.text(4.95, 5.55, "cell walls", fontsize=8, ha="center")
    ax.annotate("", xy=(4.4, 3.0), xytext=(5.5, 3.0), arrowprops=dict(arrowstyle="<->", color="#333"))
    ax.text(4.95, 1.8, "plasmodesma\n(channel through wall)", fontsize=8, ha="center")

    save(fig, "APBIO-FRQ-S-018.png")


def main():
    global OUT
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--out",
        type=Path,
        default=DEFAULT_OUT,
        help="Output directory (default: this package directory)",
    )
    parser.add_argument(
        "--allow-version-drift",
        action="store_true",
        help="Generate with a different Matplotlib version for visual comparison only.",
    )
    args = parser.parse_args()
    if matplotlib.__version__ != EXPECTED_MATPLOTLIB and not args.allow_version_drift:
        parser.error(
            f"Matplotlib {EXPECTED_MATPLOTLIB} is required for recorded-output "
            f"reproducibility; found {matplotlib.__version__}. Use "
            "--allow-version-drift only for non-canonical visual comparison."
        )
    load_render_dependencies()
    OUT = args.out.resolve()
    OUT.mkdir(parents=True, exist_ok=True)

    for fn in (s002, s003, s005, s008, s009, s012, s014, s015, s018, s020):
        fn()

    print(f"done: {OUT}")


if __name__ == "__main__":
    main()
