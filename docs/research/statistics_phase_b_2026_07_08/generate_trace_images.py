#!/usr/bin/env python3
"""
Render each bake-off capture-corpus item as a SYNTHETIC hand-drawn-style trace
image (matplotlib xkcd), one PNG per item with its reference lines stacked
top-to-bottom, and write a captures manifest {item_key: abs_png_path}.

These are machine-rendered "sketch" images, NOT real human handwriting — the
resulting fidelity number is an OPTIMISTIC UPPER BOUND (same disclosure as the
repo's existing xkcd chem trace images). A real-handwriting corpus is still
required before the number gates anything.
"""
import json
import os

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
OUT_DIR = os.path.join(HERE, "trace_images")
os.makedirs(OUT_DIR, exist_ok=True)

# LaTeX (mathtext) rendering per item, matching each reference_line in order.
LATEX = {
    "BK-STAT-MOD3-CI": [
        r"$\frac{120}{\sqrt{30}}$",
        r"$850 - 1.96\left(\frac{120}{\sqrt{30}}\right)$",
        r"$850 + 1.96\left(\frac{120}{\sqrt{30}}\right)$",
    ],
    "BK-PHYSC-DRAG": [r"$\frac{mg}{b}\left(1 - e^{-bt/m}\right)$"],
    "BK-CALCBC-IBP": [r"$x\,e^{x} - e^{x} + C$"],
    "BK-STAT-SE": [r"$\frac{s}{\sqrt{n}}$"],
    "BK-ECON-MULT": [r"$\frac{1}{1-0.8}$"],
    "BK-PHYS1-KIN": [r"$\sqrt{2gh}$"],
    "BK-CALCAB-DERIV": [r"$\cos(x^{2})\cdot 2x$"],
}


def render(item_key, latex_lines):
    n = len(latex_lines)
    fig = plt.figure(figsize=(6, 1.3 * n + 0.6))
    for i, tex in enumerate(latex_lines):
        y = 1.0 - (i + 0.5) / n
        fig.text(0.5, y, tex, ha="center", va="center", fontsize=30)
    path = os.path.join(OUT_DIR, f"{item_key}.png")
    fig.savefig(path, dpi=130, bbox_inches="tight", facecolor="white")
    plt.close(fig)
    return path


def main():
    corpus = [json.loads(l) for l in open(os.path.join(HERE, "bakeoff_capture_corpus.jsonl")) if l.strip()]
    manifest = {}
    with plt.xkcd():  # sketchy hand-drawn styling
        for item in corpus:
            key = item["item_key"]
            if key not in LATEX:
                print(f"  (skip {key}: no LaTeX map)")
                continue
            assert len(LATEX[key]) == len(item["reference_lines"]), key
            manifest[key] = render(key, LATEX[key])
            print(f"  rendered {key} ({len(LATEX[key])} line(s))")
    with open(os.path.join(HERE, "captures_manifest.json"), "w") as fh:
        json.dump(manifest, fh, indent=2)
    print(f"\n{len(manifest)} images -> {OUT_DIR}\nmanifest -> captures_manifest.json")


if __name__ == "__main__":
    main()
