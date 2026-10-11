"""Lane A pilot renderer: spec (JSON) -> SVG, deterministically, with no dependencies.

TASK-0006 Lane A. One renderer per chart FAMILY; each authored reference entry
supplies only a small parameter set. No model participates at render time: the
same spec produces byte-identical output on every run, offline, forever.

Families implemented (6) covering 10 AP Chemistry `kind='diagram'` entries:
  mb_distribution      Maxwell-Boltzmann energy distribution; catalysis variant
  energy_profile       single-step; multistep; generic endo/exothermic diagram
  stick_spectrum       mass spectrum of a single element; photoelectron spectrum
  pe_vs_distance       potential energy vs. internuclear distance
  approach_equilibrium concentration (or rate) vs. time to equilibrium
  titration_curve      pH vs. volume of titrant

The physics/chemistry lives here, once, and is covered by properties.py.
"""
from __future__ import annotations

import math
from typing import Callable

# ---------------------------------------------------------------- palette ---
BG, INK, GRAY, LIGHT, GRID = "#FAFAF8", "#151515", "#6E6E6E", "#B9B9B9", "#D8D8D3"

# One spec, three sizes. SVG text scales with the image, so a figure drawn at
# 980 units and displayed in a 332px pane renders its 11.5-unit labels at 3.9px.
# Each preset is drawn at roughly the CSS width it will occupy, so type lands
# near its nominal size instead of a third of it.
#
#   compact  the /question reference pane (272-332px) and phone widths. Title,
#            axes, curves and the one marker that carries the teaching point.
#            Every other annotation moves to the expanded view.
#   full     the question centre pane (~680px) and the notes sheet two-column
#            flow (~470px): the complete figure.
#   expanded what the enlarge control opens, and what the notes sheet uses in
#            single column.
LAYOUTS = {
    "compact":  {"W": 340, "H": 344, "L": 46, "R": 14, "T": 78, "B": 86,
                 "f": {"title": 15, "sub": 0, "axis": 13, "tick": 11, "ann": 12,
                       "mark": 11, "legend": 11, "note": 0, "flag": 0},
                 "annotations": False, "stroke": 2.0, "ylab_dx": 33},
    "full":     {"W": 680, "H": 440, "L": 84, "R": 44, "T": 76, "B": 92,
                 "f": {"title": 17, "sub": 12, "axis": 12, "tick": 10.5, "ann": 11,
                       "mark": 11, "legend": 11, "note": 10, "flag": 9.5},
                 "annotations": True, "stroke": 2.3, "ylab_dx": 46},
    "expanded": {"W": 980, "H": 620, "L": 112, "R": 60, "T": 104, "B": 128,
                 "f": {"title": 20, "sub": 12.5, "axis": 12.5, "tick": 10.5, "ann": 11.5,
                       "mark": 11.5, "legend": 11.5, "note": 10.5, "flag": 10},
                 "annotations": True, "stroke": 2.6, "ylab_dx": 46},
}
W, H = 980, 620
L, R, T, B = 112, 60, 104, 128


# ------------------------------------------------------------- the maths ---
def mb_density(E: float, theta: float) -> float:
    """Maxwell-Boltzmann distribution over KINETIC ENERGY (not speed).

    f(E) = (2/sqrt(pi)) * sqrt(E) / theta^1.5 * exp(-E/theta), theta = kT.
    Normalised: the integral over [0, inf) is 1. Mode at E = theta/2.

    The speed distribution is a different function; AP Chemistry's CED asks for
    the energy form. properties.py pins the mode and the normalisation so a
    substitution of the speed form fails loudly.
    """
    if E <= 0:
        return 0.0
    return (2 / math.sqrt(math.pi)) * math.sqrt(E) / theta ** 1.5 * math.exp(-E / theta)


def morse(r: float, de: float, re: float, a: float) -> float:
    """Morse potential: V(r) = De*(1-exp(-a(r-re)))^2 - De.

    V(re) = -De (the well depth is the bond energy), V(inf) = 0, and V rises
    steeply as r -> 0. Those three are the facts the entry's labelled parts name.
    """
    return de * (1 - math.exp(-a * (r - re))) ** 2 - de


def titration_ph(v: float, v_eq: float, pka: float, c_analyte: float, strong: bool) -> float:
    """pH against titrant volume for a monoprotic acid titrated with strong base.

    Weak acid: Henderson-Hasselbalch before equivalence, so pH = pKa exactly at
    v = v_eq/2 (the half-equivalence point the entry's caution calls out), and a
    basic equivalence point set by hydrolysis of the conjugate base.
    """
    if v <= 0:
        return (-math.log10(c_analyte)) if strong else 0.5 * (pka - math.log10(c_analyte))
    if v < v_eq:
        if strong:
            excess = c_analyte * (v_eq - v) / (v_eq + v)
            return -math.log10(max(excess, 1e-14))
        return pka + math.log10(v / (v_eq - v))
    if abs(v - v_eq) < 1e-9:
        if strong:
            return 7.0
        c_salt = c_analyte * v_eq / (v_eq + v)
        pkb = 14 - pka
        poh = 0.5 * (pkb - math.log10(max(c_salt, 1e-14)))
        return 14 - poh
    excess_oh = c_analyte * (v - v_eq) / (v_eq + v)
    return 14 + math.log10(max(excess_oh, 1e-14))


def nice_ticks(lo: float, hi: float, target: int = 6) -> list[float]:
    """Ticks at 1/2/5 x 10^n inside [lo, hi].

    Fifths of an arbitrary range give axes like -793, -547, -300: unreadable,
    and on a pH axis actively misleading. Students read values off these.
    """
    if hi <= lo:
        return [lo]
    raw = (hi - lo) / max(target - 1, 1)
    mag = 10 ** math.floor(math.log10(raw))
    step = next((m * mag for m in (1, 2, 2.5, 5, 10) if raw <= m * mag), 10 * mag)
    first = math.ceil(lo / step) * step
    out, v = [], first
    while v <= hi + step * 1e-9:
        out.append(round(v, 10))
        v += step
    return out or [lo, hi]


def smoothstep(t: float) -> float:
    return t * t * (3 - 2 * t)


def median(xs: list[float]) -> float:
    s = sorted(xs)
    n = len(s)
    return s[n // 2] if n % 2 else (s[n // 2 - 1] + s[n // 2]) / 2


def five_number(values: list[float]) -> dict:
    """Five-number summary, quartiles by the AP convention.

    Q1 is the median of the lower half and Q3 the median of the upper half, with
    the overall median EXCLUDED from both halves when n is odd. AP Statistics
    teaches this split, and a boxplot drawn with a different quartile rule puts
    the box edges somewhere the student's own calculation will not land.

    Also returns the 1.5*IQR fences, the whisker ends (the most extreme values
    that are NOT outliers -- not the fences themselves, which is the error the
    entry's "whisker ends when outliers exist" label exists to prevent) and the
    outliers.
    """
    s = sorted(values)
    n = len(s)
    med = median(s)
    half = n // 2
    lower, upper = s[:half], s[half + (n % 2):]
    q1, q3 = median(lower), median(upper)
    iqr = q3 - q1
    lo_fence, hi_fence = q1 - 1.5 * iqr, q3 + 1.5 * iqr
    inliers = [v for v in s if lo_fence <= v <= hi_fence]
    return {"min": s[0], "q1": q1, "med": med, "q3": q3, "max": s[-1],
            "iqr": iqr, "lo_fence": lo_fence, "hi_fence": hi_fence,
            "whisk_lo": min(inliers), "whisk_hi": max(inliers),
            "outliers": [v for v in s if v < lo_fence or v > hi_fence], "n": n}


def stem_leaf_rows(values: list[int], stem_div: int = 10) -> list[tuple[int, list[int]]]:
    """Split each value into stem = value // stem_div and leaf = value % stem_div.

    Every leaf is therefore a single digit when stem_div is 10, which is what the
    entry's "Leaf" label claims, and both stems and leaves come out ordered,
    which is what "Ordering" claims. Stems with no leaves are kept so the gaps
    in the distribution are visible rather than silently closed up.
    """
    if any(v < 0 for v in values):
        raise ValueError("stem-and-leaf here assumes non-negative values")
    stems = {}
    for v in sorted(values):
        stems.setdefault(v // stem_div, []).append(v % stem_div)
    lo, hi = min(stems), max(stems)
    return [(s, sorted(stems.get(s, []))) for s in range(lo, hi + 1)]


# --------------------------------------------------------- family builders --
# Each returns a dict: curves[], areas[], vlines[], hlines[], marks[], steps[],
# x_range, y_range, x_ticks, y_ticks, legend[]
def f_mb_distribution(p: dict) -> dict:
    xs = [i * p["x_max"] / 600 for i in range(601)]
    curves, areas, legend, vlines = [], [], [], []
    for s in p["series"]:
        pts = [(x, mb_density(x, s["theta"])) for x in xs]
        curves.append({"pts": pts, "style": s.get("style", "solid"),
                       "color": INK if s.get("style", "solid") == "solid" else GRAY})
        legend.append((s["label"], s.get("style", "solid")))
    # Markers are OPTIONAL. AP Physics 2's entry is purely qualitative -- axes
    # and the shape of the curve -- and has no activation energy in it, so an
    # unexplained dashed line and a shaded tail would assert a concept the
    # entry never mentions.
    for m in p.get("markers", []):
        vlines.append({"x": m["x"], "label": m["label"], "caption": m.get("caption", "")})
    if p.get("markers"):
        # Shade beyond the first marker, largest series area underneath.
        ea = p["markers"][0]["x"]
        order = sorted(range(len(p["series"])), key=lambda i: -p["series"][i]["theta"])
        for rank, i in enumerate(order):
            s = p["series"][i]
            pts = [(x, mb_density(x, s["theta"])) for x in xs if x >= ea]
            areas.append({"pts": pts, "x0": ea, "fill": LIGHT if rank == 0 else INK,
                          "op": 0.5 if rank == 0 else 0.16})
    ymax = max(y for c in curves for _, y in c["pts"]) * 1.12
    return {"curves": curves, "areas": areas, "vlines": vlines, "legend": legend,
            "x_range": (0, p["x_max"]), "y_range": (0, ymax)}


def f_energy_profile(p: dict) -> dict:
    """Levels and barriers along a reaction coordinate.

    `nodes` alternates level, barrier, level, (barrier, level)*; the curve is a
    smoothstep between consecutive stationary points, so every barrier is a true
    local maximum and every intermediate a true local minimum.
    """
    nodes = p["nodes"]
    span = len(nodes) - 1
    pts = []
    for i in range(span):
        y0, y1 = nodes[i]["e"], nodes[i + 1]["e"]
        for k in range(61):
            t = k / 60
            pts.append((i + t, y0 + (y1 - y0) * smoothstep(t)))
    marks = []
    for i, n in enumerate(nodes):
        marks.append({"x": i, "y": n["e"], "label": n["label"],
                      "place": n.get("place", "above" if n.get("kind") == "ts" else "below")})
    arrows = []
    for a in p.get("arrows", []):
        arrows.append({"x": a["x"], "y0": nodes[a["from"]]["e"], "y1": nodes[a["to"]]["e"],
                       "label": a["label"]})
    ys = [n["e"] for n in nodes]
    pad = (max(ys) - min(ys)) * 0.28 or 1
    return {"curves": [{"pts": pts, "style": "solid", "color": INK}], "areas": [],
            "marks": marks, "arrows": arrows, "legend": [],
            "x_range": (-0.35, span + 0.35), "y_range": (min(ys) - pad, max(ys) + pad),
            "x_ticks": [], "hide_y_ticks": True}


def f_stick_spectrum(p: dict) -> dict:
    """Peaks at positions with heights. Optional log x-axis.

    Photoelectron spectra span two orders of magnitude in binding energy (N 1s
    at 39.6 MJ/mol against 2p at 1.45), so a linear axis collapses the valence
    peaks into each other. `x_log` plots log10(E) and labels the ticks with the
    real energies, which is how PES is conventionally drawn.
    """
    log = p.get("x_log", False)
    tx = (lambda v: math.log10(v)) if log else (lambda v: v)
    sticks = [{"x": tx(pk["x"]), "y": pk["y"], "label": pk.get("label", "")} for pk in p["peaks"]]
    xs = [s["x"] for s in sticks]
    span = (max(xs) - min(xs)) or 1
    x0 = tx(p["x_min"]) if "x_min" in p else min(xs) - span * 0.18
    x1 = tx(p["x_max"]) if "x_max" in p else max(xs) + span * 0.18
    ticks = [(tx(v), p.get("tick_fmt", "{:g}").format(v)) for v in p["x_tick_values"]] \
        if "x_tick_values" in p else None
    out = {"curves": [], "areas": [], "sticks": sticks, "legend": [],
           "x_range": (x0, x1), "y_range": (0, max(s["y"] for s in sticks) * 1.22),
           "x_reversed": p.get("x_reversed", False)}
    if ticks:
        out["x_ticks"] = ticks
    return out


def f_pe_vs_distance(p: dict) -> dict:
    """One Morse curve per bond order.

    The entry's labelled parts include "Effect of bond order", which a single
    curve cannot show, so this family takes a series: higher order -> shorter
    re and deeper well. properties.py asserts that ordering holds.
    """
    r0, r1 = p["r_min"], p["r_max"]
    curves, vlines, arrows, legend = [], [], [], []
    deepest = max(s["de"] for s in p["series"])
    for i, s in enumerate(p["series"]):
        pts = [(r0 + k * (r1 - r0) / 700, 0.0) for k in range(701)]
        pts = [(r, morse(r, s["de"], s["re"], s["a"])) for r, _ in pts]
        pts = [(r, y) for r, y in pts if y <= deepest * 0.70]
        style = s.get("style", "solid")
        curves.append({"pts": pts, "style": style, "color": INK if style == "solid" else GRAY})
        legend.append((s["label"], style))
        vlines.append({"x": s["re"], "label": "", "caption": ""})
    main = p["series"][0]
    return {"curves": curves, "areas": [], "vlines": vlines, "legend": legend,
            "hlines": [{"y": 0.0, "label": p["zero_label"]}],
            "marks": [{"x": main["re"], "y": -main["de"], "label": p["re_label"], "place": "below"}],
            "arrows_v": [{"x": min(main["re"] * 1.75, r1 * 0.80), "y0": -main["de"], "y1": 0.0,
                          "label": p["well_label"]}],
            "x_range": (0, r1), "y_range": (-deepest * 1.30, deepest * 0.72)}


def f_approach_equilibrium(p: dict) -> dict:
    t1, k = p["t_max"], p["k"]
    ts = [i * t1 / 600 for i in range(601)]
    curves, legend = [], []
    for s in p["series"]:
        s0, sinf = s["start"], s["end"]
        pts = [(t, sinf + (s0 - sinf) * math.exp(-k * t)) for t in ts]
        curves.append({"pts": pts, "style": s.get("style", "solid"),
                       "color": INK if s.get("style", "solid") == "solid" else GRAY})
        legend.append((s["label"], s.get("style", "solid")))
    t_eq = -math.log(p.get("eq_tol", 0.02)) / k
    ys = [y for c in curves for _, y in c["pts"]]
    return {"curves": curves, "areas": [], "legend": legend,
            "vlines": [{"x": t_eq, "label": "", "caption": p["eq_caption"]}],
            "x_range": (0, t1), "y_range": (0, max(ys) * 1.2), "x_ticks": []}


def f_titration_curve(p: dict) -> dict:
    v1 = p["v_max"]
    vs = [i * v1 / 1400 for i in range(1401)]
    pts = [(v, titration_ph(v, p["v_eq"], p["pka"], p["c"], p["strong"])) for v in vs]
    v_half = p["v_eq"] / 2
    marks = [
        {"x": v_half, "y": titration_ph(v_half, p["v_eq"], p["pka"], p["c"], p["strong"]),
         "label": p["half_label"], "place": "below"},
        {"x": p["v_eq"], "y": titration_ph(p["v_eq"], p["v_eq"], p["pka"], p["c"], p["strong"]),
         "label": p["eq_label"], "place": "right"},
    ]
    return {"curves": [{"pts": pts, "style": "solid", "color": INK}], "areas": [],
            "marks": marks, "legend": [],
            "vlines": [{"x": p["v_eq"], "label": "", "caption": ""}],
            # pH is read off this axis, so pin every even unit: 7 and 14 must be there.
            "y_ticks": [0, 2, 4, 6, 8, 10, 12, 14],
            "x_range": (0, v1), "y_range": (0, 14)}


# --------------------------------------------- AP Statistics family builders --
# These five cover AP Statistics' seven Lane A entries. The distinctions they
# draw ARE the teaching points, so each one is pinned by a property:
#   bar chart     bars SEPARATED, because the variable is categorical
#   histogram     bars CONTIGUOUS and bins ordered, because it is quantitative
#   segmented     equal-width bars, each segment set summing to the whole
#   mosaic        bar widths PROPORTIONAL to the column marginals
#   dotplot       one dot per observation, stacked at equal values
#   stem-and-leaf single-digit leaves that reconstruct the data exactly
#   boxplot       whiskers to the extreme NON-outliers, not to the fences

def _bar_fill(i: int, n: int) -> tuple[str, float]:
    """Monochrome fills that stay distinguishable in the reference pane.

    Colour is not available (the figures are deliberately monochrome), and a
    legend swatch heavier than the thing it labels was a real defect in the
    pilot, so levels differ by value: solid ink, then light grey with an ink
    edge, then mid grey.
    """
    return [(INK, 1.0), (LIGHT, 1.0), (GRAY, 1.0), (LIGHT, 0.45)][i % 4]


def f_categorical_bars(p: dict) -> dict:
    """Bar chart, histogram, side-by-side, segmented and mosaic.

    One family, five modes, because the geometry is the same rectangle machinery
    and only the x placement and the stacking differ. `mode` picks:

      bar        one bar per category, separated by a gap
      histogram  one bar per ordered bin, edge to edge with no gap
      grouped    one bar per (category, level), grouped with a gap between
                 categories (the side-by-side bar chart)
      segmented  one bar per category, levels stacked to the full height
      mosaic     as segmented, but each bar's WIDTH is its share of the total
    """
    mode = p["mode"]
    bars, legend, xticks = [], [], []

    if mode == "histogram":
        edges, counts = p["bin_edges"], p["counts"]
        if len(edges) != len(counts) + 1:
            raise ValueError("histogram needs one more edge than counts")
        if any(edges[i + 1] <= edges[i] for i in range(len(counts))):
            raise ValueError("histogram bin edges must increase")
        for i, c in enumerate(counts):
            bars.append({"x0": edges[i], "x1": edges[i + 1], "y0": 0, "y1": c,
                         "fill": INK, "op": 1.0, "edge": BG})
        xticks = [(e, p.get("tick_fmt", "{:g}").format(e)) for e in edges]
        ymax = max(counts)
        out = {"x_range": (edges[0], edges[-1]), "y_range": (0, ymax * 1.18), "x_ticks": xticks}
        if "measure" in p:          # the bin-width annotation
            m = p["measure"]
            out["xmeasure"] = {"x0": edges[m["bin"]], "x1": edges[m["bin"] + 1],
                               "y": ymax * 1.08, "label": m["label"]}

    elif mode == "bar":
        cats, counts = p["categories"], p["counts"]
        gap = p.get("gap", 0.34)    # a real gap: the variable is categorical
        for i, (c, v) in enumerate(zip(cats, counts)):
            bars.append({"x0": i + gap / 2, "x1": i + 1 - gap / 2, "y0": 0, "y1": v,
                         "fill": INK, "op": 1.0, "edge": None,
                         "label": p.get("value_fmt", "{:g}").format(v)})
            xticks.append((i + 0.5, c))
        out = {"x_range": (0, len(cats)), "y_range": (0, max(counts) * 1.20), "x_ticks": xticks}

    elif mode == "grouped":
        cats, levels, table = p["categories"], p["levels"], p["table"]
        k = len(levels)
        gap, inner = p.get("gap", 0.30), p.get("inner", 0.04)
        for i, c in enumerate(cats):
            w = (1 - gap) / k
            for j, lv in enumerate(levels):
                x0 = i + gap / 2 + j * w
                fill, op = _bar_fill(j, k)
                bars.append({"x0": x0 + inner / 2, "x1": x0 + w - inner / 2, "y0": 0,
                             "y1": table[j][i], "fill": fill, "op": op,
                             "edge": INK if fill != INK else None})
            xticks.append((i + 0.5, c))
        legend = [(lv, "solid" if j == 0 else "swatch" + str(j)) for j, lv in enumerate(levels)]
        out = {"x_range": (0, len(cats)), "y_range": (0, max(max(r) for r in table) * 1.20),
               "x_ticks": xticks}

    elif mode in ("segmented", "mosaic"):
        cats, levels, table = p["categories"], p["levels"], p["table"]
        totals = [sum(table[j][i] for j in range(len(levels))) for i in range(len(cats))]
        grand = sum(totals)
        gap = p.get("gap", 0.06)
        # Mosaic: width is the column's share of the grand total. Segmented:
        # every bar the same width. That single difference is the distinction
        # between the two displays, and the property test pins it.
        widths = ([t / grand for t in totals] if mode == "mosaic"
                  else [1 / len(cats)] * len(cats))
        x = 0.0
        for i, c in enumerate(cats):
            w = widths[i]
            y = 0.0
            for j, lv in enumerate(levels):
                frac = table[j][i] / totals[i]      # conditional proportion
                fill, op = _bar_fill(j, len(levels))
                bars.append({"x0": x + gap * w / 2, "x1": x + w - gap * w / 2,
                             "y0": y, "y1": y + frac, "fill": fill, "op": op,
                             "edge": INK if fill != INK else None,
                             "label": p.get("value_fmt", "{:.0%}").format(frac)
                             if frac >= p.get("label_floor", 0.12) else None})
                y += frac
            # The n= suffix is what the group size is FOR in a mosaic, but at
            # 272px three of them collide, so it is opt-in and off by default.
            show_n = mode == "mosaic" and p.get("width_in_tick", False)
            xticks.append((x + w / 2, f'{c} (n={totals[i]})' if show_n else c))
            x += w
        legend = [(lv, "solid" if j == 0 else "swatch" + str(j)) for j, lv in enumerate(levels)]
        out = {"x_range": (0, 1), "y_range": (0, 1), "x_ticks": xticks,
               "y_ticks": [0, 0.25, 0.5, 0.75, 1.0]}
    else:
        raise ValueError(f"unknown categorical_bars mode: {mode}")

    out.update({"curves": [], "areas": [], "bars": bars, "legend": legend,
                "bars_contiguous": mode in ("histogram", "segmented", "mosaic")})
    return out


def f_pie_chart(p: dict) -> dict:
    """Slices whose angles are the relative frequencies, summing to exactly 360.

    Drawn in a frame with no axes. Starts at twelve o'clock and goes clockwise,
    which is the convention a student will have seen.
    """
    cats, counts = p["categories"], p["counts"]
    total = sum(counts)
    wedges, start = [], 0.0
    for i, (c, v) in enumerate(zip(cats, counts)):
        sweep = 360.0 * v / total
        fill, op = _bar_fill(i, len(cats))
        wedges.append({"start": start, "sweep": sweep, "label": c,
                       "frac": v / total, "count": v,
                       "fill": fill, "op": op, "edge": INK})
        start += sweep
    return {"curves": [], "areas": [], "wedges": wedges, "legend": [],
            "frame": "bare", "total": total,
            "x_range": (0, 1), "y_range": (0, 1)}


def f_dotplot(p: dict) -> dict:
    """One dot per observation, stacked where values repeat.

    Takes raw `values`, not stack heights, so "a dot is one observation" is a
    property of the drawing rather than a claim in the caption: the test counts
    the dots and compares with len(values).
    """
    values = p["values"]
    dots, stacks = [], {}
    for v in sorted(values):
        stacks[v] = stacks.get(v, 0) + 1
        dots.append({"x": v, "y": stacks[v]})
    lo, hi = min(values), max(values)
    pad = p.get("pad", 0.5)
    return {"curves": [], "areas": [], "dots": dots, "legend": [],
            "x_range": (lo - pad, hi + pad), "y_range": (0, max(stacks.values()) + 1),
            "x_ticks": [(v, p.get("tick_fmt", "{:g}").format(v))
                        for v in p.get("tick_values", sorted(stacks))],
            "hide_y_axis": True, "n": len(values)}


def f_stem_leaf(p: dict) -> dict:
    """A stem-and-leaf plot: typography on a rule, not a chart.

    Shares none of the axis machinery, so it renders in the bare frame. The key
    line ("5 | 2 means 52") is part of the plot, not decoration -- without it the
    reader cannot tell 52 from 5.2.
    """
    rows = stem_leaf_rows(p["values"], p.get("stem_div", 10))
    text_rows = [{"stem": str(s), "leaves": " ".join(str(l) for l in leaves)}
                 for s, leaves in rows]
    return {"curves": [], "areas": [], "text_rows": text_rows, "legend": [],
            "frame": "bare", "key": p["key"], "rows": rows,
            "x_range": (0, 1), "y_range": (0, 1)}


def f_boxplot(p: dict) -> dict:
    """A horizontal boxplot of the five-number summary, with outliers marked.

    Derived from raw `values` by five_number(), so the box edges, the median
    line, the whisker ends and the outlier marks are all computed rather than
    positioned by hand -- which is what lets the properties check the rule the
    entry states, that the whiskers stop at the most extreme non-outlier.
    """
    s = five_number(p["values"])
    lo, hi = s["whisk_lo"], s["max"] if s["outliers"] else s["whisk_hi"]
    span = (hi - lo) or 1
    x0 = p.get("x_min", lo - span * 0.12)
    x1 = p.get("x_max", hi + span * 0.12)
    box = {"q1": s["q1"], "med": s["med"], "q3": s["q3"],
           "whisk_lo": s["whisk_lo"], "whisk_hi": s["whisk_hi"],
           "outliers": s["outliers"], "yc": 0.52, "h": p.get("height", 0.30)}
    return {"curves": [], "areas": [], "boxes": [box], "legend": [],
            "summary": s, "hide_y_axis": True,
            "x_range": (x0, x1), "y_range": (0, 1),
            "x_ticks": [(v, p.get("tick_fmt", "{:g}").format(v)) for v in p["tick_values"]]}


# -------------------------------------------- physics family builders (Lane A) --

def isotherm_p(v: float, pv: float) -> float:
    """Boyle's law along an isotherm: P = (nRT)/V, so PV is constant."""
    return pv / v


def adiabat_p(v: float, k: float, gamma: float) -> float:
    """Adiabatic (quasi-static, ideal gas): P*V^gamma = constant.

    gamma > 1, so an adiabat through a point is STEEPER than the isotherm
    through the same point -- the one fact that distinguishes the two curves by
    eye, and the one the properties pin.
    """
    return k / v ** gamma


def f_xy_series(p: dict) -> dict:
    """A general x-y chart: curves from explicit points, scatter, an optional
    shaded area under one curve, a zero line, and point markers.

    Covers the PV diagram (isotherm and the four special processes), electric
    potential around a circuit loop, and the residual plot. These are different
    sciences but one geometry, which is the test for whether a family earns its
    place: the alternative was three renderers drawing the same axes.
    """
    curves, dots, marks, areas, hlines, legend = [], [], [], [], [], []
    for sr in p["series"]:
        kind = sr.get("kind", "line")
        pts = [(float(x), float(y)) for x, y in sr["points"]]
        if kind == "scatter":
            dots.extend({"x": x, "y": y} for x, y in pts)
        else:
            style = sr.get("style", "solid")
            curves.append({"pts": pts, "style": style,
                           "color": INK if style == "solid" else GRAY})
            if sr.get("label"):
                legend.append((sr["label"], style))
        if sr.get("fill_under"):
            areas.append({"pts": pts, "x0": pts[0][0], "fill": LIGHT, "op": 0.55})
        for m in sr.get("marks", []):
            marks.append({"x": m["x"], "y": m["y"], "label": m["label"],
                          "place": m.get("place", "above")})
    for h in p.get("hlines", []):
        hlines.append({"y": h["y"], "label": h["label"]})
    xs = [x for c in curves for x, _ in c["pts"]] + [d["x"] for d in dots]
    ys = [y for c in curves for _, y in c["pts"]] + [d["y"] for d in dots]
    xr = p.get("x_range") or (min(xs) - (max(xs) - min(xs)) * 0.08,
                              max(xs) + (max(xs) - min(xs)) * 0.08)
    pad = (max(ys) - min(ys)) * 0.16 or 1
    yr = p.get("y_range") or (min(ys) - pad, max(ys) + pad)
    out = {"curves": curves, "areas": areas, "dots": dots, "marks": marks,
           "hlines": hlines, "legend": legend,
           "x_range": tuple(xr), "y_range": tuple(yr)}
    if p.get("hide_axis_numbers"):
        # A qualitative PV diagram teaches shape, not readings: unlabelled axes
        # are the convention, and invented numbers would imply a measurement.
        out["x_ticks"] = []
        out["hide_y_ticks"] = True
    if "x_ticks" in p:
        out["x_ticks"] = [(v, lbl) for v, lbl in p["x_ticks"]]
    if "y_ticks" in p:
        out["y_ticks"] = p["y_ticks"]
    return out


def f_kinematic_panels(p: dict) -> dict:
    """Three stacked panels sharing one time axis: x(t), v(t), a(t).

    Deliberately NOT three figures. Every labelled part of the entry is about
    the relationship BETWEEN the panels -- the slope of a tangent on x-t is the
    value on v-t, the area under v-t is the change on x-t -- and three separate
    figures would destroy exactly the thing being taught.

    The curves are generated from ONE motion (constant acceleration), so the
    three panels are consistent by construction rather than by three hand-drawn
    sketches that happen to look related.
    """
    x0, v0, a = p["x0"], p["v0"], p["a"]
    t1 = p["t_max"]
    ts = [i * t1 / 400 for i in range(401)]
    xf = lambda t: x0 + v0 * t + 0.5 * a * t * t
    vf = lambda t: v0 + a * t
    af = lambda t: a
    shades = p.get("shades", [])
    panels = []
    for key, fn, lab in (("x", xf, p["x_label_panel"]),
                         ("v", vf, p["v_label_panel"]),
                         ("a", af, p["a_label_panel"])):
        pts = [(t, fn(t)) for t in ts]
        ys = [y for _, y in pts]
        pad = (max(ys) - min(ys)) * 0.22 or (abs(ys[0]) * 0.6 or 1)
        lo, hi = min(ys) - pad, max(ys) + pad
        # An area is shaded down to the zero line, so a panel that carries one
        # must SHOW zero. Without this the v-t panel spanned 2 to 11, had no
        # baseline to shade to, and silently drew nothing -- while the figure
        # went on claiming "area under v-t curve" as a labelled part it covered.
        if any(sh["panel"] == key for sh in shades):
            lo = min(lo, 0.0)
            hi = max(hi, 0.0)
        panels.append({"key": key, "label": lab, "pts": pts, "y_range": (lo, hi),
                       "annotations": [x for x in p.get("annotations", []) if x["panel"] == key]})
    return {"curves": [], "areas": [], "legend": [], "panels": panels,
            "motion": {"x0": x0, "v0": v0, "a": a, "t_max": t1},
            "shades": shades,
            "x_range": (0, t1), "y_range": (0, 1), "hide_y_ticks": True}


def f_arrow_diagram(p: dict) -> dict:
    """Vectors drawn as arrows from a common origin: the first Lane B grammar.

    Not a chart. There is no quantity on an axis, so it renders in the bare
    frame; what it asserts instead is a drawing CONVENTION -- an arrow's
    direction is the vector's direction and its length is proportional to the
    magnitude, with ONE constant of proportionality shared by every arrow in
    the figure. That constant is the whole teaching point of both entries this
    serves, so it is computed here, once, rather than left to each arrow.

    Angles are degrees counter-clockwise from the positive x axis, the
    convention the entries use. The renderer flips to screen coordinates; no
    spec ever sees a negative y.

    `side_by_side` is the free-body diagram's own labelled part: two forces in
    the same direction must not be drawn on top of each other, so an arrow may
    carry a perpendicular offset in arrow-widths. It shifts where the arrow is
    DRAWN, never its direction or length, which is why the property tests still
    read the magnitudes and angles straight from the spec.
    """
    arrows = []
    mags = [float(a["magnitude"]) for a in p["arrows"]]
    if min(mags) <= 0:
        raise ValueError("an arrow with no magnitude is not a vector")
    longest = max(mags)
    for a in p["arrows"]:
        m = float(a["magnitude"])
        arrows.append({
            "label": a["label"],
            "magnitude": m,
            "angle": float(a["angle_deg"]) % 360.0,
            # One shared scale: the ratio of any two drawn lengths is the ratio
            # of their magnitudes, which is what "proportional" has to mean.
            "frac": m / longest,
            "offset": float(a.get("offset", 0.0)),
            "caption": a.get("caption"),
        })
    axis = None
    if p.get("axis"):
        axis = {"angle": float(p["axis"]["angle_deg"]) % 360.0,
                "label": p["axis"]["label"]}
    return {"curves": [], "areas": [], "legend": [], "frame": "bare",
            "vectors": arrows, "dot": bool(p.get("dot", True)), "axis": axis,
            "unit_note": p.get("unit_note"),
            "x_range": (-1.0, 1.0), "y_range": (-1.0, 1.0)}


def _pb_jitter(seed: int, i: int) -> tuple[float, float]:
    """Deterministic pseudo-jitter. A particulate box must not be random: the
    figure is re-rendered on every page load and the suite asserts that two
    renders are byte-identical, so the scatter is a pure function of (panel,
    index) rather than anything drawn from a global RNG.
    """
    h = (seed * 1103515245 + i * 12345 + 1013904223) & 0x7FFFFFFF
    return (((h >> 7) & 1023) / 1023.0 - 0.5, ((h >> 17) & 1023) / 1023.0 - 0.5)


def f_particulate_box(p: dict) -> dict:
    """Particles in a box: the second Lane B grammar.

    Coloured circles in a panel, with counts, spacing and arrangement carrying
    the meaning. Five AP Chemistry entries are this one picture with different
    contents -- phases, a solution, a balanced equation, a reversible reaction
    and metallic bonding -- which is the test for whether a family earns its
    place.

    A species is a MOLECULE: a list of atoms at fixed offsets, so the figure
    knows how many atoms of each element it has drawn. That is what makes atom
    conservation machine-checkable rather than a matter of counting circles by
    eye, and atom conservation is the balanced-equation entry's own labelled
    part.

    Arrangement modes, which are the phase entry's labelled parts:
      lattice  regular rows and columns, touching          (crystalline solid)
      close    in contact but irregular                    (liquid, amorphous)
      sparse   far apart, same box                         (gas)
    """
    els = p["elements"]
    specs = p["species"]
    panels = []
    cap = max(sum(int(sp["count"]) for sp in pan["species"]) for pan in p["panels"])
    for pi, pan in enumerate(p["panels"]):
        mode = pan.get("mode", "close")
        units = []
        for sp in pan["species"]:
            units += [sp["key"]] * int(sp["count"])
        n = len(units)
        if pan.get("mix"):
            # Filling cells in the order the species are listed put all six
            # solute particles in the top two rows -- a clump, which is what
            # UNdissolved looks like, while the alt text said each was
            # surrounded by solvent. Spread each species evenly through the
            # sequence instead (Bresenham), deterministically.
            counts = [(sp["key"], int(sp["count"])) for sp in pan["species"]]
            placed = {k: 0 for k, _ in counts}
            units = []
            for i in range(n):
                # the species furthest behind its own share of the slots so far
                key = max(counts, key=lambda kc: (i + 1) * kc[1] / n - placed[kc[0]])[0]
                placed[key] += 1
                units.append(key)
        if n == 0:
            raise ValueError(f"panel {pan['label']!r} has no particles")
        # ONE grid shared by every panel, sized by the fullest one, so three
        # boxes of the same size are directly comparable -- which is the whole
        # claim of the phases figure. A sparse panel then STRIDES across that
        # grid instead of filling its first cells: sizing the grid to its own
        # count and normalising back to the box left the gas no further apart
        # than the liquid, while the caption said "far apart".
        cols = max(1, int(math.ceil(math.sqrt(cap))))
        rows = max(1, int(math.ceil(cap / cols)))
        # A constant stride across the grid lands the gas on a straight
        # diagonal, which is a pattern -- the one thing a gas must not show.
        # Spread the cells deterministically instead: order them by a hash and
        # take the first n, so the scatter is reproducible but not a line.
        sparse_cells = None
        if mode == "sparse":
            # Farthest-point selection: start at a hash-chosen cell, then
            # repeatedly take the cell furthest from everything already taken.
            # A constant stride put the gas on a straight diagonal, and a
            # hash-ordered pick clumped two of them together so the gas was no
            # further apart than the liquid. This is deterministic AND spread.
            def ctr(c):
                return ((c % cols + 0.5) / cols, (c // cols + 0.5) / rows)
            start = int(abs(_pb_jitter(7 * (pi + 1), 0)[0]) * (cols * rows)) % (cols * rows)
            chosen = [start]
            while len(chosen) < n:
                best, bestd = None, -1.0
                for c in range(cols * rows):
                    if c in chosen:
                        continue
                    d = min(math.hypot(ctr(c)[0] - ctr(k)[0], ctr(c)[1] - ctr(k)[1])
                            for k in chosen)
                    if d > bestd + 1e-12:
                        best, bestd = c, d
                chosen.append(best)
            sparse_cells = sorted(chosen)
        # 0.17 left the liquid looking like the solid at every width: the eye
        # could not tell "irregular" from "regular", which is the only thing
        # those two panels differ by. The suite now measures the disorder too.
        jit = {"lattice": 0.0, "close": 0.40, "sparse": 0.34}[mode]
        drawn = []
        for i, key in enumerate(units):
            cell = sparse_cells[i] if sparse_cells is not None else i
            cx = (cell % cols + 0.5) / cols
            cy = (cell // cols + 0.5) / rows
            dx, dy = _pb_jitter(pi + 1, i)
            cx += dx * jit / cols
            cy += dy * jit / rows
            parts = specs[key]["parts"]
            # Every atom bonds to the molecule's CENTRE atom, not to the atom
            # before it. Joining first to last drew water as H-H with the
            # oxygen sitting on the line between them -- a bond that does not
            # exist, in a figure whose whole job is to be read literally.
            ctr = specs[key].get("center", 0)
            pos = [(cx + at["dx"] / cols * 0.5, cy + at["dy"] / rows * 0.5) for at in parts]
            for ai, at in enumerate(parts):
                drawn.append({"el": at["el"], "x": pos[ai][0], "y": pos[ai][1],
                              "r": els[at["el"]]["r"], "fill": els[at["el"]]["fill"],
                              "symbol": els[at["el"]].get("symbol", ""),
                              "species": key,
                              "bonds": [pos[ctr]] if (len(parts) > 1 and ai != ctr) else []})
        free = []
        for bg in pan.get("background", []):
            # Spread over the WHOLE box on a grid of their own. Stepping these
            # along the particle grid sent most of them past the right edge and
            # below the bottom, where the renderer dropped them: a "sea" of
            # twenty-six electrons arrived as eight, in rows.
            m = int(bg["count"])
            bcols = max(1, int(math.ceil(math.sqrt(m * 1.6))))
            brows = max(1, int(math.ceil(m / bcols)))
            for k in range(m):
                dx, dy = _pb_jitter(100 + pi, k)
                ex = min(0.96, max(0.04, (k % bcols + 0.5) / bcols + dx * 0.55 / bcols))
                ey = min(0.94, max(0.06, (k // bcols + 0.5) / brows + dy * 0.55 / brows))
                # Delocalized means not attached to any one ion, so an electron
                # that lands on an ion core is pushed clear of it rather than
                # drawn on top -- which would read as a bond.
                for d in drawn:
                    sep = math.hypot(ex - d["x"], ey - d["y"])
                    if sep < d["r"] * 1.25:
                        if sep < 1e-9:
                            ex, ey = ex + d["r"] * 1.3, ey
                        else:
                            f = d["r"] * 1.3 / sep
                            ex = min(0.97, max(0.03, d["x"] + (ex - d["x"]) * f))
                            ey = min(0.96, max(0.04, d["y"] + (ey - d["y"]) * f))
                free.append({"el": bg["key"], "x": ex, "y": ey,
                             "r": els[bg["key"]]["r"], "fill": els[bg["key"]]["fill"],
                             "symbol": els[bg["key"]].get("symbol", "")})
        atoms = {}
        for sp in pan["species"]:
            for el, k in specs[sp["key"]]["atoms"].items():
                atoms[el] = atoms.get(el, 0) + k * int(sp["count"])
        panels.append({"label": pan["label"], "mode": mode, "particles": drawn,
                       "background": free, "caption": pan.get("caption"),
                       "counts": {sp["key"]: int(sp["count"]) for sp in pan["species"]},
                       "atoms": atoms})
    return {"curves": [], "areas": [], "legend": [], "frame": "bare",
            "panels_pb": panels, "arrow_after": p.get("arrow_after"),
            "unit_note": p.get("unit_note"),
            "x_range": (0.0, 1.0), "y_range": (0.0, 1.0)}


FAMILIES: dict[str, Callable[[dict], dict]] = {
    "mb_distribution": f_mb_distribution,
    "energy_profile": f_energy_profile,
    "stick_spectrum": f_stick_spectrum,
    "pe_vs_distance": f_pe_vs_distance,
    "approach_equilibrium": f_approach_equilibrium,
    "titration_curve": f_titration_curve,
    "categorical_bars": f_categorical_bars,
    "pie_chart": f_pie_chart,
    "dotplot": f_dotplot,
    "stem_leaf": f_stem_leaf,
    "boxplot": f_boxplot,
    "xy_series": f_xy_series,
    "kinematic_panels": f_kinematic_panels,
    "arrow_diagram": f_arrow_diagram,
    "particulate_box": f_particulate_box,
}


# ------------------------------------------------------------- SVG output ---
def wrap(text: str, per_line: int) -> list[str]:
    """Greedy wrap. A compact figure is 340 units wide: an unwrapped title runs
    straight off the canvas, which is how MAXWELL-BOLTZMANN ENERGY DIST... got
    clipped in the first compact render."""
    out, line = [], ""
    for w in text.split():
        trial = f"{line} {w}".strip()
        if len(trial) > per_line and line:
            out.append(line)
            line = w
        else:
            line = trial
    if line:
        out.append(line)
    return out


def text_w(t: str, size: float) -> float:
    """Approximate rendered width. 0.55em per character is close enough for
    Helvetica digits and lower case, and it is the same constant verify.py uses,
    so a label that the suite calls off-canvas is one this code also avoided."""
    return 0.55 * size * len(t)


def fit(t: str, size: float, maxw: float, floor: float = 7.5) -> float:
    """Shrink until it fits, never below `floor`."""
    while size > floor and text_w(t, size) > maxw:
        size -= 0.5
    return size


def esc(s: str) -> str:
    return (s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;"))


def render(spec: dict, layout: str = "expanded") -> str:
    lay = LAYOUTS[layout]
    W, H = lay["W"], lay["H"]
    L, R, T, B = lay["L"], lay["R"], lay["T"], lay["B"]
    F, SW, SHOW_ANN = lay["f"], lay["stroke"], lay["annotations"]
    # Unpacked because an f-string cannot reuse its own quote character inside {}.
    FT, FS, FA, FK, FN, FM, FL, FO, FG = (
        F["title"], F["sub"], F["axis"], F["tick"], F["ann"],
        F["mark"], F["legend"], F["note"], F["flag"])
    g = FAMILIES[spec["family"]](spec["params"])
    x0, x1 = g["x_range"]
    y0, y1 = g["y_range"]
    pw, ph = W - L - R, H - T - B
    rev = g.get("x_reversed", False)
    # A pie chart and a stem-and-leaf plot have no axes to draw. They still get
    # the title, subtitle, ILLUSTRATIVE flag and note, so only the frame goes.
    bare = g.get("frame") == "bare"
    no_y = g.get("hide_y_axis", False)

    # The left margin has to fit the widest y tick label plus the rotated axis
    # title, or they overprint. A percentage axis ("100%") is far wider than the
    # chemistry batch's "0.25", which is why a fixed margin survived that batch
    # and collided on the very first AP Statistics figure.
    tick_w = 0.0
    if not bare and not no_y and not g.get("hide_y_ticks"):
        ylabels = [spec.get("y_tick_fmt", "{:.0f}").format(v)
                   for v in (g.get("y_ticks") or nice_ticks(y0, y1))]
        tick_w = 0.55 * FK * max((len(t) for t in ylabels), default=1)
        need = 10 + tick_w + FA * 1.6 + 6
        if need > L:
            L = int(math.ceil(need))
            pw = W - L - R
    # Place the rotated title clear of the tick labels rather than at a fixed
    # inset: "100%" is twice as wide as "0.25", and a constant that fits one
    # runs the title straight through the other.
    ylab_dx = L - max(FA * 0.62, L - 10 - tick_w - FA * 0.78)

    # The legend sits above the plot, so its height is part of the top margin.
    # Four thermodynamic processes do not fit on one 340-unit row at a readable
    # size, and stacking the overflow row upward printed it over the subtitle.
    leg = g.get("legend", [])
    sw_w = 26 if SHOW_ANN else 18
    leg_pad = 10 if SHOW_ANN else 7
    leg_gap = 22 if SHOW_ANN else 14
    legf = FL
    rows_leg: list[list] = []
    if leg:
        item_w = lambda t, f: sw_w + leg_pad + text_w(t, f) + leg_gap
        while legf > 9 and L + sum(item_w(t, legf) for t, _ in leg) - leg_gap > W - R:
            legf -= 0.5
        cur, cw_ = [], L
        for it in leg:
            w_ = item_w(it[0], legf)
            if cur and cw_ + w_ - leg_gap > W - R:
                rows_leg.append(cur)
                cur, cw_ = [], L
            cur.append(it)
            cw_ += w_
        if cur:
            rows_leg.append(cur)
    leg_row_h = legf + 7
    # The title block stays where it is; only the plot and the legend move down,
    # so a wrapped legend opens a gap between the subtitle and the axes instead
    # of pushing the whole figure into its own heading.
    T0 = T
    T += max(0, len(rows_leg) - 1) * leg_row_h
    ph = H - T - B

    def sx(x):
        t = (x - x0) / (x1 - x0)
        return L + (1 - t if rev else t) * pw

    def sy(y):
        return T + ph - (y - y0) / (y1 - y0) * ph

    o = [
        f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {W} {H}" width="{W}" height="{H}" '
        f'role="img" aria-labelledby="ttl desc" font-family="Helvetica Neue, Arial, sans-serif">',
        f'<title id="ttl">{esc(spec["title"])}</title>',
        f'<desc id="desc">{esc(spec["alt"])}</desc>',
        f'<rect width="{W}" height="{H}" fill="{BG}"/>',
    ]
    # gridlines
    if not bare and not no_y:
        for y in (g.get("y_ticks") or nice_ticks(y0, y1)):
            if y0 < y < y1:
                o.append(f'<line x1="{L}" y1="{sy(y):.1f}" x2="{L+pw}" y2="{sy(y):.1f}" stroke="{GRID}" stroke-width="0.8"/>')
    # shaded areas
    for a in g.get("areas", []):
        if not a["pts"]:
            continue
        d = (f'M {sx(a["x0"]):.1f},{sy(0):.1f} ' +
             " ".join(f'L {sx(x):.1f},{sy(y):.1f}' for x, y in a["pts"]) +
             f' L {sx(a["pts"][-1][0]):.1f},{sy(0):.1f} Z')
        o.append(f'<path d="{d}" fill="{a["fill"]}" fill-opacity="{a["op"]}"/>')
    # stacked panels: x(t), v(t), a(t) sharing one time axis. Each panel gets
    # its own y mapping inside a band of the plot area, its own baseline, and
    # its own name at the left -- the shared x axis is drawn once, below.
    if g.get("panels"):
        pn = g["panels"]
        gap = ph * 0.07
        bh = (ph - gap * (len(pn) - 1)) / len(pn)
        for pi, pan in enumerate(pn):
            top = T + pi * (bh + gap)
            py0, py1 = pan["y_range"]
            psy = lambda v, top=top, py0=py0, py1=py1: top + bh - (v - py0) / (py1 - py0) * bh
            zero = psy(0) if py0 <= 0 <= py1 else None
            o.append(f'<rect x="{L}" y="{top:.1f}" width="{pw}" height="{bh:.1f}" fill="none" stroke="{GRID}" stroke-width="0.8"/>')
            if zero is not None:
                o.append(f'<line x1="{L}" y1="{zero:.1f}" x2="{L+pw}" y2="{zero:.1f}" stroke="{GRID}" stroke-width="1"/>')
            # the shaded interval, drawn on the panel it belongs to
            for sh in (g.get("shades", []) if SHOW_ANN else []):
                if sh["panel"] != pan["key"]:
                    continue
                seg = [(x, y) for x, y in pan["pts"] if sh["t0"] <= x <= sh["t1"]]
                if seg and zero is not None:
                    d = (f'M {sx(seg[0][0]):.1f},{zero:.1f} ' +
                         " ".join(f'L {sx(x):.1f},{psy(y):.1f}' for x, y in seg) +
                         f' L {sx(seg[-1][0]):.1f},{zero:.1f} Z')
                    o.append(f'<path d="{d}" fill="{LIGHT}" fill-opacity="0.6"/>')
                    o.append(f'<text x="{sx((sh["t0"]+sh["t1"])/2):.1f}" y="{(zero + psy(seg[len(seg)//2][1]))/2 + 4:.1f}" '
                             f'text-anchor="middle" font-size="{FN}" fill="{INK}">{esc(sh["label"])}</text>')
            d = "M " + " L ".join(f'{sx(x):.1f},{psy(y):.1f}' for x, y in pan["pts"])
            o.append(f'<path d="{d}" fill="none" stroke="{INK}" stroke-width="{SW}" stroke-linecap="round"/>')
            o.append(f'<text x="{L+6}" y="{top+FM+4:.1f}" font-size="{FM*1.05:.1f}" font-weight="700" fill="{INK}">{esc(pan["label"])}</text>')
            for an in (pan["annotations"] if SHOW_ANN else []):
                ax, ay = sx(an["t"]), psy(an["y"])
                if an.get("tangent"):
                    # A drawn tangent, so "slope of the tangent" is something the
                    # student can see rather than a phrase in the caption.
                    #
                    # Converting a data slope to a screen slope: dx scales by
                    # pw/(x1-x0) and dy by bh/(py1-py0), and screen y runs
                    # downward. Getting that ratio upside down drew the tangents
                    # as near-vertical lines straight off the canvas.
                    half = pw * 0.10
                    m = an["slope"] * (bh / (py1 - py0)) / (pw / (x1 - x0))
                    # Keep the segment inside its own panel even where the curve
                    # is steep: shorten it rather than let it escape the band.
                    if abs(m) * half > bh * 0.42:
                        half = bh * 0.42 / abs(m) if m else half
                    o.append(f'<line x1="{ax-half:.1f}" y1="{ay + m*half:.1f}" x2="{ax+half:.1f}" y2="{ay - m*half:.1f}" '
                             f'stroke="{GRAY}" stroke-width="1.4" stroke-dasharray="6 4"/>')
                o.append(f'<circle cx="{ax:.1f}" cy="{ay:.1f}" r="3.6" fill="{INK}"/>')
                o.append(f'<text x="{ax:.1f}" y="{ay-11:.1f}" text-anchor="middle" font-size="{FM}" fill="{INK}">{esc(an["label"])}</text>')

    # bars: bar chart, histogram, side-by-side, segmented, mosaic
    for bar in g.get("bars", []):
        bx0, bx1 = sx(bar["x0"]), sx(bar["x1"])
        by0, by1 = sy(bar["y0"]), sy(bar["y1"])
        edge = f' stroke="{bar["edge"]}" stroke-width="1.1"' if bar.get("edge") else ""
        o.append(f'<rect x="{min(bx0,bx1):.1f}" y="{min(by0,by1):.1f}" '
                 f'width="{abs(bx1-bx0):.1f}" height="{abs(by1-by0):.1f}" '
                 f'fill="{bar["fill"]}" fill-opacity="{bar["op"]}"{edge}/>')
        if bar.get("label") and SHOW_ANN:
            # Inside a tall dark segment, outside a short or pale one.
            inside = abs(by1 - by0) > FM * 2.4
            fill = BG if (inside and bar["fill"] == INK) else INK
            yy = (by0 + by1) / 2 + FM * 0.36 if inside else min(by0, by1) - 6
            o.append(f'<text x="{(bx0+bx1)/2:.1f}" y="{yy:.1f}" text-anchor="middle" '
                     f'font-size="{FM}" fill="{fill}">{esc(bar["label"])}</text>')
    # a measured horizontal span, for the histogram's bin width
    if g.get("xmeasure") and SHOW_ANN:
        m = g["xmeasure"]
        ax0, ax1, ay = sx(m["x0"]), sx(m["x1"]), sy(m["y"])
        o.append(f'<line x1="{ax0:.1f}" y1="{ay:.1f}" x2="{ax1:.1f}" y2="{ay:.1f}" stroke="{GRAY}" stroke-width="1.1"/>')
        for xx in (ax0, ax1):
            o.append(f'<line x1="{xx:.1f}" y1="{ay-5:.1f}" x2="{xx:.1f}" y2="{ay+5:.1f}" stroke="{GRAY}" stroke-width="1.1"/>')
        o.append(f'<text x="{(ax0+ax1)/2:.1f}" y="{ay-9:.1f}" text-anchor="middle" font-size="{FN}" fill="{INK}">{esc(m["label"])}</text>')
    # dotplot: one circle per observation
    for d in g.get("dots", []):
        o.append(f'<circle cx="{sx(d["x"]):.1f}" cy="{sy(d["y"]):.1f}" r="{max(3.2, SW*2.1):.1f}" '
                 f'fill="{INK}" fill-opacity="0.9"/>')
    # boxplot glyphs: box Q1-Q3, median line, whiskers, outlier marks
    for bx in g.get("boxes", []):
        yc, hh = bx["yc"], bx["h"] / 2
        top, bot, mid = sy(yc + hh), sy(yc - hh), sy(yc)
        q1, q3, md = sx(bx["q1"]), sx(bx["q3"]), sx(bx["med"])
        wl, wh = sx(bx["whisk_lo"]), sx(bx["whisk_hi"])
        o.append(f'<rect x="{q1:.1f}" y="{top:.1f}" width="{q3-q1:.1f}" height="{bot-top:.1f}" '
                 f'fill="{LIGHT}" fill-opacity="0.45" stroke="{INK}" stroke-width="{SW*0.8:.1f}"/>')
        o.append(f'<line x1="{md:.1f}" y1="{top:.1f}" x2="{md:.1f}" y2="{bot:.1f}" stroke="{INK}" stroke-width="{SW*1.3:.1f}"/>')
        for a, b in ((wl, q1), (q3, wh)):
            o.append(f'<line x1="{a:.1f}" y1="{mid:.1f}" x2="{b:.1f}" y2="{mid:.1f}" stroke="{INK}" stroke-width="{SW*0.9:.1f}"/>')
        for xx in (wl, wh):
            o.append(f'<line x1="{xx:.1f}" y1="{sy(yc+hh*0.58):.1f}" x2="{xx:.1f}" y2="{sy(yc-hh*0.58):.1f}" '
                     f'stroke="{INK}" stroke-width="{SW*0.9:.1f}"/>')
        for ov in bx["outliers"]:
            ox = sx(ov)
            o.append(f'<text x="{ox:.1f}" y="{mid + FM*0.42:.1f}" text-anchor="middle" '
                     f'font-size="{FM*1.5:.1f}" fill="{INK}">*</text>')
    # pie wedges
    for w in g.get("wedges", []):
        cx, cy = L + pw / 2, T + ph / 2
        rad = min(pw, ph) * 0.44
        a0 = math.radians(w["start"] - 90)
        a1 = math.radians(w["start"] + w["sweep"] - 90)
        px0, py0 = cx + rad * math.cos(a0), cy + rad * math.sin(a0)
        px1, py1 = cx + rad * math.cos(a1), cy + rad * math.sin(a1)
        large = 1 if w["sweep"] > 180 else 0
        o.append(f'<path d="M {cx:.1f},{cy:.1f} L {px0:.1f},{py0:.1f} '
                 f'A {rad:.1f},{rad:.1f} 0 {large} 1 {px1:.1f},{py1:.1f} Z" '
                 f'fill="{w["fill"]}" fill-opacity="{w["op"]}" stroke="{w["edge"]}" stroke-width="1.2"/>')
        am = math.radians(w["start"] + w["sweep"] / 2 - 90)
        lr = rad * (1.24 if SHOW_ANN else 1.16)
        lx, ly = cx + lr * math.cos(am), cy + lr * math.sin(am)
        anchor = "start" if math.cos(am) > 0.12 else ("end" if math.cos(am) < -0.12 else "middle")
        o.append(f'<text x="{lx:.1f}" y="{ly:.1f}" text-anchor="{anchor}" font-size="{FM}" fill="{INK}">'
                 f'{esc(w["label"])} {w["frac"]*100:.0f}%</text>')
    # particulate panels
    if g.get("panels_pb"):
        pans = g["panels_pb"]
        npan = len(pans)
        gap = pw * (0.055 if npan > 1 else 0)
        arrow_w = pw * 0.07 if g.get("arrow_after") is not None else 0.0
        bw = (pw - gap * (npan - 1) - arrow_w) / npan
        # Room under each box for its label, and above for nothing: the caption
        # belongs to the figure, not to the panel.
        lab_h = FM * 1.9 + (FN * 1.5 if any(pan.get("caption") for pan in pans) else 0.0)
        bh = min(ph - lab_h, bw * 1.25)
        by = T + max(0.0, (ph - lab_h - bh) / 2)
        for pi, pan in enumerate(pans):
            bx = L + pi * (bw + gap) + (arrow_w if (g.get("arrow_after") is not None
                                                    and pi > g["arrow_after"]) else 0.0)
            o.append(f'<rect x="{bx:.1f}" y="{by:.1f}" width="{bw:.1f}" height="{bh:.1f}" '
                     f'fill="{BG}" stroke="{GRID}" stroke-width="1.2"/>')
            scale = min(bw, bh)
            for d in pan["background"]:
                px, py = bx + d["x"] * bw, by + d["y"] * bh
                if not (bx + 2 <= px <= bx + bw - 2 and by + 2 <= py <= by + bh - 2):
                    continue
                o.append(f'<circle cx="{px:.1f}" cy="{py:.1f}" r="{max(1.4, d["r"]*scale):.1f}" '
                         f'fill="{d["fill"]}"/>')
            for d in pan["particles"]:
                px, py = bx + d["x"] * bw, by + d["y"] * bh
                for bf in d.get("bonds", []):
                    fx_, fy_ = bx + bf[0] * bw, by + bf[1] * bh
                    o.append(f'<line x1="{fx_:.1f}" y1="{fy_:.1f}" x2="{px:.1f}" y2="{py:.1f}" '
                             f'stroke="{INK}" stroke-width="{max(1.1, scale*0.012):.1f}"/>')
                o.append(f'<circle cx="{px:.1f}" cy="{py:.1f}" r="{max(1.8, d["r"]*scale):.1f}" '
                         f'fill="{d["fill"]}" stroke="{INK}" stroke-width="1"/>')
                # Drawn at EVERY layout: the plus sign is what makes the circle
                # an ion rather than an atom, and the entry's first labelled
                # part is "positive metal ions". It vanished at compact, where
                # the alt text still said each one was marked with a plus.
                if d.get("symbol") and d["r"] * scale >= FM * 0.7:
                    o.append(f'<text x="{px:.1f}" y="{py + FM*0.34:.1f}" text-anchor="middle" '
                             f'font-size="{FM*0.86:.1f}" fill="{BG}">{esc(d["symbol"])}</text>')
            o.append(f'<text x="{bx + bw/2:.1f}" y="{by + bh + FM*1.3:.1f}" text-anchor="middle" '
                     f'font-size="{FM:.1f}" fill="{INK}">{esc(pan["label"])}</text>')
            if pan.get("caption") and SHOW_ANN:
                o.append(f'<text x="{bx + bw/2:.1f}" y="{by + bh + FM*2.6:.1f}" '
                         f'text-anchor="middle" font-size="{FN*0.92:.1f}" fill="{GRAY}">'
                         f'{esc(pan["caption"])}</text>')
        if g.get("arrow_after") is not None:
            ai = g["arrow_after"]
            ax0 = L + (ai + 1) * (bw + gap) - gap + arrow_w * 0.18
            ay = by + bh / 2
            o.append(f'<line x1="{ax0:.1f}" y1="{ay:.1f}" x2="{ax0 + arrow_w*0.52:.1f}" '
                     f'y2="{ay:.1f}" stroke="{INK}" stroke-width="{SW:.1f}"/>')
            hd = arrow_w * 0.22
            o.append(f'<path d="M {ax0 + arrow_w*0.64:.1f},{ay:.1f} '
                     f'L {ax0 + arrow_w*0.64 - hd:.1f},{ay - hd*0.46:.1f} '
                     f'L {ax0 + arrow_w*0.64 - hd:.1f},{ay + hd*0.46:.1f} Z" fill="{INK}"/>')
        if g.get("unit_note") and SHOW_ANN:
            o.append(f'<text x="{L:.1f}" y="{T + ph + FO*1.4:.1f}" font-size="{FO:.1f}" '
                     f'fill="{GRAY}">{esc(g["unit_note"])}</text>')
    # vector / free-body arrows
    if g.get("vectors"):
        cx, cy = L + pw / 2, T + ph / 2
        # Leave room for the tip label on the longest arrow in every direction,
        # so a figure is not clipped merely because its biggest vector points at
        # the corner. The label, not the arrow, sets the radius.
        longest = min(pw, ph) * (0.30 if SHOW_ANN else 0.34)
        head = max(5.0, longest * 0.11)
        if g.get("axis"):
            aa = math.radians(g["axis"]["angle"])
            ax, ay = math.cos(aa), -math.sin(aa)
            ext = min(pw, ph) * 0.46
            o.append(f'<line x1="{cx - ax*ext:.1f}" y1="{cy - ay*ext:.1f}" '
                     f'x2="{cx + ax*ext:.1f}" y2="{cy + ay*ext:.1f}" stroke="{GRID}" '
                     f'stroke-width="1.1" stroke-dasharray="5 5"/>')
            # Anchor the label at whichever END of the axis leaves room for it.
            # Flipping only the x coordinate put the label at the far end's x
            # with the near end's y, straight on top of the normal-force label.
            albl = g["axis"]["label"]
            alw = 0.55 * FN * len(albl)
            best = None
            for sgn in (1.0, -1.0):
                ex, ey = cx + ax * ext * sgn, cy + ay * ext * sgn
                anc = "start" if ax * sgn >= 0 else "end"
                lx0 = ex + (6 if anc == "start" else -6)
                left = lx0 if anc == "start" else lx0 - alw
                fits = left >= 4 and left + alw <= W - 4 and 4 <= ey - 5 <= H - 4
                if fits:
                    best = (lx0, ey - 5, anc)
                    break
                if best is None:
                    best = (max(4.0, min(lx0, W - 4 - alw)), ey - 5, "start")
            o.append(f'<text x="{best[0]:.1f}" y="{best[1]:.1f}" font-size="{FN:.1f}" '
                     f'text-anchor="{best[2]}" fill="{GRAY}">{esc(albl)}</text>')
        for v in g["vectors"]:
            ang = math.radians(v["angle"])
            ux, uy = math.cos(ang), -math.sin(ang)       # SVG y grows downward
            px, py = -uy, ux                             # unit perpendicular
            off = v["offset"] * head * 0.95
            bx_, by_ = cx + px * off, cy + py * off
            ln = longest * v["frac"]
            tx, ty = bx_ + ux * ln, by_ + uy * ln
            # Stop the shaft where the head begins, or the stroke pokes through
            # the point of the arrowhead at the compact stroke width.
            sx_, sy_ = bx_ + ux * max(0.0, ln - head * 0.92), by_ + uy * max(0.0, ln - head * 0.92)
            o.append(f'<line x1="{bx_:.1f}" y1="{by_:.1f}" x2="{sx_:.1f}" y2="{sy_:.1f}" '
                     f'stroke="{INK}" stroke-width="{SW:.1f}" stroke-linecap="round"/>')
            hw = head * 0.42
            o.append(f'<path d="M {tx:.1f},{ty:.1f} '
                     f'L {tx - ux*head + px*hw:.1f},{ty - uy*head + py*hw:.1f} '
                     f'L {tx - ux*head - px*hw:.1f},{ty - uy*head - py*hw:.1f} Z" fill="{INK}"/>')
            # The label takes the arrow's whole perpendicular offset, not a
            # fraction of it: at compact the fraction left "rope 4.0 N" and
            # "friction 1.0 N" overprinting even though their arrows did not.
            lsep = off * 2.4 if off else 0.0
            lx, ly = tx + ux * 9 + px * lsep, ty + uy * 9 + py * lsep
            anc = "start" if ux > 0.18 else ("end" if ux < -0.18 else "middle")
            o.append(f'<text x="{lx:.1f}" y="{ly + (FM*0.9 if uy > 0.3 else (-FM*0.25 if uy < -0.3 else FM*0.35)):.1f}" '
                     f'text-anchor="{anc}" font-size="{FM:.1f}" fill="{INK}">{esc(v["label"])}</text>')
        if g.get("dot"):
            # Drawn last: every arrow starts here, so the dot must sit on top.
            o.append(f'<circle cx="{cx:.1f}" cy="{cy:.1f}" r="{max(3.0, head*0.34):.1f}" fill="{INK}"/>')
        if g.get("unit_note") and SHOW_ANN:
            o.append(f'<text x="{L:.1f}" y="{T + ph + FO*1.4:.1f}" font-size="{FO:.1f}" '
                     f'fill="{GRAY}">{esc(g["unit_note"])}</text>')
    # stem-and-leaf rows
    if g.get("text_rows"):
        rows = g["text_rows"]
        mono = 'font-family="SFMono-Regular, Menlo, Consolas, monospace"'
        # Fill the canvas. Capping the row height at the base font left the
        # expanded view, which is what the enlarge control opens, as a postage
        # stamp of text in a mostly empty 980x620 frame.
        widest = max((len(r["leaves"]) for r in rows), default=1) + 4
        rh = min(ph / (len(rows) + 2.2), pw * 0.92 / max(widest, 1) * 1.55)
        fs = rh * 0.62
        sx0 = L + pw * 0.26
        for i, r in enumerate(rows):
            yy = T + rh * (i + 1)
            o.append(f'<text x="{sx0:.1f}" y="{yy:.1f}" text-anchor="end" font-size="{fs:.1f}" '
                     f'{mono} fill="{INK}">{esc(r["stem"])}</text>')
            o.append(f'<line x1="{sx0+fs*0.55:.1f}" y1="{yy-rh*0.60:.1f}" x2="{sx0+fs*0.55:.1f}" y2="{yy+rh*0.16:.1f}" '
                     f'stroke="{GRAY}" stroke-width="1.1"/>')
            o.append(f'<text x="{sx0+fs*1.15:.1f}" y="{yy:.1f}" font-size="{fs:.1f}" {mono} '
                     f'fill="{INK}" letter-spacing="0.12em">{esc(r["leaves"])}</text>')
        kf = max(FN, fs * 0.52)
        o.append(f'<text x="{max(6, sx0 - text_w(g["key"], kf)):.1f}" y="{T + rh*(len(rows)+1.8):.1f}" '
                 f'font-size="{kf:.1f}" fill="{GRAY}">{esc(g["key"])}</text>')
    # horizontal reference lines
    for hl in g.get("hlines", []):
        o.append(f'<line x1="{L}" y1="{sy(hl["y"]):.1f}" x2="{L+pw}" y2="{sy(hl["y"]):.1f}" '
                 f'stroke="{GRAY}" stroke-width="1" stroke-dasharray="4 4"/>')
        o.append(f'<text x="{L+pw-4}" y="{sy(hl["y"])-8:.1f}" text-anchor="end" font-size="{FN}" fill="{GRAY}">{esc(hl["label"])}</text>')
    # sticks
    for s in g.get("sticks", []):
        o.append(f'<line x1="{sx(s["x"]):.1f}" y1="{sy(0):.1f}" x2="{sx(s["x"]):.1f}" y2="{sy(s["y"]):.1f}" '
                 f'stroke="{INK}" stroke-width="{max(4, SW*2.7):.1f}" stroke-linecap="butt"/>')
        if s["label"] and SHOW_ANN:
            o.append(f'<text x="{sx(s["x"]):.1f}" y="{sy(s["y"])-10:.1f}" text-anchor="middle" '
                     f'font-size="{FM}" fill="{INK}">{esc(s["label"])}</text>')
    # curves
    for c in g["curves"]:
        d = "M " + " L ".join(f'{sx(x):.1f},{sy(y):.1f}' for x, y in c["pts"])
        dash = ' stroke-dasharray="11 6"' if c["style"] == "dashed" else ""
        o.append(f'<path d="{d}" fill="none" stroke="{c["color"]}" stroke-width="{SW}" stroke-linecap="round"{dash}/>')
    # vertical markers
    for vi, v in enumerate(g.get("vlines", [])):
        o.append(f'<line x1="{sx(v["x"]):.1f}" y1="{T:.1f}" x2="{sx(v["x"]):.1f}" y2="{sy(y0):.1f}" '
                 f'stroke="{INK}" stroke-width="1.2" stroke-dasharray="3 4"/>')
        for txt, yy, fsz, extra in ((v.get("label"), T + 22, FN * 1.45, ' font-style="italic"'),
                                    (v.get("caption"), T + 40, FN, '')):
            # The marker's LINE is drawn unconditionally, so dropping its label
            # leaves an unexplained dashed line on the canvas: at compact the
            # catalysis figure showed two barriers and named only one, which is
            # the whole teaching point lost. The short label now survives every
            # layout for every marker; only the longer caption still drops.
            is_label = bool(extra)
            if not txt or not (is_label or SHOW_ANN or vi == 0):
                continue
            # Past the midpoint the caption has to hang to the LEFT of its
            # marker, or it runs off the canvas -- which is where "equilibrium
            # established" went at compact.
            flip = sx(v["x"]) + 8 + text_w(txt, fsz) > W - 6
            xx = sx(v["x"]) - 8 if flip else sx(v["x"]) + 8
            anc = ' text-anchor="end"' if flip else ''
            col = INK if extra else GRAY
            o.append(f'<text x="{xx:.1f}" y="{yy}" font-size="{fsz:.1f}"{extra}{anc} fill="{col}">{esc(txt)}</text>')
    # point marks
    for m in g.get("marks", []):
        px, py = sx(m["x"]), sy(m["y"])
        if not SHOW_ANN:
            o.append(f'<circle cx="{px:.1f}" cy="{py:.1f}" r="3.5" fill="{INK}"/>')
            continue
        o.append(f'<circle cx="{px:.1f}" cy="{py:.1f}" r="4" fill="{INK}"/>')
        if m["place"] == "above":
            o.append(f'<text x="{px:.1f}" y="{py-13:.1f}" text-anchor="middle" font-size="{FM}" fill="{INK}">{esc(m["label"])}</text>')
        elif m["place"] == "right":
            o.append(f'<text x="{px+10:.1f}" y="{py+4:.1f}" font-size="{FM}" fill="{INK}">{esc(m["label"])}</text>')
        else:
            o.append(f'<text x="{px:.1f}" y="{py+20:.1f}" text-anchor="middle" font-size="{FM}" fill="{INK}">{esc(m["label"])}</text>')
    # measured vertical arrows (activation energy, well depth, dH)
    for a in (g.get("arrows", []) + g.get("arrows_v", [])) if SHOW_ANN else []:
        px = sx(a["x"]) if isinstance(a["x"], (int, float)) else sx(a["x"])
        ya, yb = sy(a["y0"]), sy(a["y1"])
        o.append(f'<line x1="{px:.1f}" y1="{ya:.1f}" x2="{px:.1f}" y2="{yb:.1f}" stroke="{GRAY}" stroke-width="1.1"/>')
        for yy in (ya, yb):
            o.append(f'<line x1="{px-5:.1f}" y1="{yy:.1f}" x2="{px+5:.1f}" y2="{yy:.1f}" stroke="{GRAY}" stroke-width="1.1"/>')
        o.append(f'<text x="{px+9:.1f}" y="{(ya+yb)/2+4:.1f}" font-size="{FN}" fill="{INK}">{esc(a["label"])}</text>')
    # axes
    if not bare:
        if not no_y:
            o.append(f'<line x1="{L}" y1="{T:.1f}" x2="{L}" y2="{sy(y0):.1f}" stroke="{INK}" stroke-width="1.2"/>')
        o.append(f'<line x1="{L}" y1="{sy(y0):.1f}" x2="{L+pw}" y2="{sy(y0):.1f}" stroke="{INK}" stroke-width="1.2"/>')
        xt = spec["x_label"].upper()
        cx_title = L + pw / 2
        xf = fit(xt, FA, 2 * min(cx_title, W - cx_title) - 10)
        o.append(f'<text x="{L+pw/2:.1f}" y="{sy(y0)+(54 if SHOW_ANN else 40):.1f}" text-anchor="middle" font-size="{xf:.1f}" font-weight="700" '
                 f'fill="{INK}" letter-spacing="0.08em">{esc(xt)}</text>')
        if not no_y:
            o.append(f'<text transform="translate({L-ylab_dx:.1f},{T+ph/2:.1f}) rotate(-90)" text-anchor="middle" font-size="{FA}" '
                     f'font-weight="700" fill="{INK}" letter-spacing="0.08em">{esc(spec["y_label"].upper())}</text>')
    if not bare and not no_y and not g.get("hide_y_ticks"):
        for y in g.get("y_ticks") or nice_ticks(y0, y1):
            lbl = spec.get("y_tick_fmt", "{:.0f}").format(y)
            o.append(f'<line x1="{L-5}" y1="{sy(y):.1f}" x2="{L}" y2="{sy(y):.1f}" stroke="{GRAY}" stroke-width="0.9"/>')
            o.append(f'<text x="{L-10}" y="{sy(y)+4:.1f}" text-anchor="end" font-size="{FK}" fill="{GRAY}">{lbl}</text>')
    # x ticks: plain values, or (position, label) pairs when the axis is transformed
    for tk in ([] if bare else (g["x_ticks"] if "x_ticks" in g else nice_ticks(x0, x1))):
        pos, lbl = tk if isinstance(tk, (tuple, list)) else (tk, spec.get("x_tick_fmt", "{:.0f}").format(tk))
        o.append(f'<line x1="{sx(pos):.1f}" y1="{sy(y0):.1f}" x2="{sx(pos):.1f}" y2="{sy(y0)+5:.1f}" stroke="{GRAY}" stroke-width="0.9"/>')
        o.append(f'<text x="{sx(pos):.1f}" y="{sy(y0)+22:.1f}" text-anchor="middle" font-size="{FK}" fill="{GRAY}">{esc(lbl)}</text>')
    # furniture
    o += [
        *[f'<text x="{L}" y="{(T0-58 if FS else T0-46) + i * (FT + 3):.1f}" font-size="{FT}" font-weight="700" '
          f'fill="{INK}" letter-spacing="0.03em">{esc(ln)}</text>'
          for i, ln in enumerate(wrap(spec.get("short_title", spec["title"]).upper(),
                                      26 if not SHOW_ANN else 60))],
    ]
    if FS:
        o.append(f'<text x="{L}" y="{T0-34}" font-size="{FS}" fill="{GRAY}">{esc(spec["subtitle"])}</text>')
    if FG:
        o.append(f'<text x="{W-R}" y="{T0-58}" text-anchor="end" font-size="{FG}" font-weight="700" '
                 f'fill="{GRAY}" letter-spacing="0.1em">{"ILLUSTRATIVE" if spec.get("synthetic") else "FROM DATA"}</text>')
    if spec.get("note") and FO:
        nf = fit(spec["note"], FO, W - R - L)
        o.append(f'<text x="{W-R}" y="{H-16}" text-anchor="end" font-size="{nf:.1f}" fill="{GRAY}">{esc(spec["note"])}</text>')
    # Above the plot, under the subtitle. The bottom band already holds the
    # x-axis title and the note, and a legend placed there overprinted one or
    # the other at every size that draws both. Items are laid out by their
    # measured width: a fixed stride pushed "Higher temperature" off a compact
    # canvas.
    pad = leg_pad
    for ri, row in enumerate(rows_leg):
        lx_cursor = L
        for lbl, style in row:
            # The top margin already reserved room for every row, so the rows
            # stack upward from just above the plot without reaching the title.
            ly = T - (12 if SHOW_ANN else 10) - (len(rows_leg) - 1 - ri) * leg_row_h
            ox = lx_cursor
            lx_cursor += sw_w + leg_pad + text_w(lbl, legf) + leg_gap
            if style.startswith("swatch") or style == "solid" and g.get("bars"):
                # A filled series needs a filled key. A line swatch beside a bar
                # chart reads as a different mark than the one it labels.
                j = int(style[6:]) if style.startswith("swatch") else 0
                fill, op = _bar_fill(j, 4)
                edge = f' stroke="{INK}" stroke-width="1"' if fill != INK else ""
                o.append(f'<rect x="{ox:.1f}" y="{ly-11:.1f}" width="{sw_w}" height="{11 if SHOW_ANN else 9}" '
                         f'fill="{fill}" fill-opacity="{op}"{edge}/>')
                o.append(f'<text x="{ox+sw_w+pad:.1f}" y="{ly:.1f}" font-size="{legf:.1f}" fill="{INK}">{esc(lbl)}</text>')
                continue
            dash = ' stroke-dasharray="11 6"' if style == "dashed" else ""
            col = GRAY if style == "dashed" else INK
            o.append(f'<line x1="{ox:.1f}" y1="{ly-4:.1f}" x2="{ox+sw_w:.1f}" y2="{ly-4:.1f}" stroke="{col}" stroke-width="{SW}"{dash}/>')
            o.append(f'<text x="{ox+sw_w+pad:.1f}" y="{ly:.1f}" font-size="{legf:.1f}" fill="{INK}">{esc(lbl)}</text>')
    o.append("</svg>")
    return "\n".join(o)
