#!/usr/bin/env python3
"""Generate the APBIO-FRQ-S-009 alternative-splicing replacement candidate."""

from __future__ import annotations

import argparse
import os
import tempfile
from pathlib import Path

os.environ.setdefault(
    "MPLCONFIGDIR",
    str(Path(tempfile.gettempdir()) / "cramapple-image-generator-matplotlib-cache"),
)

import matplotlib


EXPECTED_MATPLOTLIB = "3.11.1"
DEFAULT_OUT = Path(__file__).resolve().parent / "candidates"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--out", type=Path, default=DEFAULT_OUT)
    parser.add_argument(
        "--allow-version-drift",
        action="store_true",
        help="Generate a non-canonical visual preview with another Matplotlib version.",
    )
    parser.add_argument(
        "--candidate-version",
        type=int,
        choices=(2, 3),
        default=3,
        help=(
            "Candidate 2 preserves the first corrected layout, including its "
            "answer-leaking footer. Candidate 3 omits that footer."
        ),
    )
    args = parser.parse_args()
    if matplotlib.__version__ != EXPECTED_MATPLOTLIB and not args.allow_version_drift:
        parser.error(
            f"Matplotlib {EXPECTED_MATPLOTLIB} is required for a canonical candidate; "
            f"found {matplotlib.__version__}."
        )

    matplotlib.use("Agg")
    import matplotlib.pyplot as plt
    from matplotlib.patches import FancyArrowPatch, FancyBboxPatch

    plt.rcParams.update({
        "font.size": 12,
        "font.family": "DejaVu Sans",
        "axes.edgecolor": "#333333",
    })

    def segment(ax, x, y, width, label, fill, edge):
        box = FancyBboxPatch(
            (x, y),
            width,
            0.7,
            boxstyle="round,pad=0.02,rounding_size=0.04",
            linewidth=1.8,
            edgecolor=edge,
            facecolor=fill,
        )
        ax.add_patch(box)
        ax.text(x + width / 2, y + 0.35, label, ha="center", va="center")

    def arrow(ax, start, end):
        ax.add_patch(
            FancyArrowPatch(
                start,
                end,
                arrowstyle="-|>",
                color="#333333",
                linewidth=2,
                mutation_scale=16,
                connectionstyle="arc3,rad=0",
            )
        )

    fig, ax = plt.subplots(figsize=(10, 6))
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 7)
    ax.axis("off")
    ax.set_title("Alternative Splicing Produces Two Mature mRNAs", fontsize=14, pad=14)

    exon_fill = "#dfe6f5"
    intron_fill = "#f4f4f4"
    edge = "#333333"
    muted_edge = "#888888"

    ax.text(0.5, 5.8, "Pre-mRNA", fontweight="bold", va="center")
    pre_x = 1.8
    for width, label, fill, border in (
        (1.2, "E1", exon_fill, edge),
        (1.0, "I1", intron_fill, muted_edge),
        (1.2, "E2", exon_fill, edge),
        (1.0, "I2", intron_fill, muted_edge),
        (1.2, "E3", exon_fill, edge),
    ):
        segment(ax, pre_x, 5.45, width, label, fill, border)
        pre_x += width

    ax.text(8.0, 5.8, "E = exon   I = intron", fontsize=10, color="#555555", va="center")

    # Both arrows originate at the same precursor level and terminate at
    # separate products. No product-to-product transformation is implied.
    arrow(ax, (3.9, 5.35), (3.0, 3.05))
    arrow(ax, (5.3, 5.35), (7.0, 3.05))
    ax.text(2.9, 4.35, "introns removed\nE2 retained", ha="center", fontsize=10)
    ax.text(6.9, 4.35, "introns removed\nE2 skipped", ha="center", fontsize=10)

    product_1_x = 1.8
    for label in ("E1", "E2", "E3"):
        segment(ax, product_1_x, 2.2, 1.2, label, exon_fill, edge)
        product_1_x += 1.2
    ax.text(
        3.6, 1.75, "Mature mRNA 1", fontweight="bold", fontsize=10,
        ha="center", va="top",
    )

    product_2_x = 6.5
    for label in ("E1", "E3"):
        segment(ax, product_2_x, 2.2, 1.2, label, exon_fill, edge)
        product_2_x += 1.2
    ax.text(
        7.7, 1.75, "Mature mRNA 2", fontweight="bold", fontsize=10,
        ha="center", va="top",
    )

    if args.candidate_version == 2:
        ax.text(
            5,
            0.65,
            "The same pre-mRNA can be spliced into different exon combinations.",
            ha="center",
            color="#555555",
            fontsize=10,
        )

    args.out.mkdir(parents=True, exist_ok=True)
    output = args.out / f"APBIO-FRQ-S-009-v{args.candidate_version}-candidate.png"
    fig.savefig(output, dpi=150, bbox_inches="tight", facecolor="white")
    plt.close(fig)
    print(output.resolve())
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
