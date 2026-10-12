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
MINUS = "\u2212"  # an f-string expression may not contain a backslash escape

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


def _hyp(a: float, b: float) -> float:
    """sqrt(a*a + b*b), spelled out.

    NOT math.hypot: these values become drawn coordinates, and the app's
    renderer must agree byte for byte. Python's hypot and JavaScript's are both
    carefully written and need not agree in the last bit, while an explicit
    multiply-add-sqrt is IEEE-identical in both.
    """
    return math.sqrt(a * a + b * b)


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
                    d = min(_hyp(ctr(c)[0] - ctr(k)[0], ctr(c)[1] - ctr(k)[1])
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
                    sep = _hyp(ex - d["x"], ey - d["y"])
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


def _fm_field(charges: list, x: float, y: float) -> tuple[float, float]:
    """Coulomb superposition in box coordinates, k = 1.

    The field is COMPUTED, not sketched. Every property the entries name --
    lines leaving positive and arriving at negative, spacing standing for
    magnitude, isolines meeting the field at right angles -- is then a fact
    about this function rather than about how carefully someone drew curves.
    """
    ex = ey = 0.0
    for c in charges:
        dx, dy = x - c["x"], y - c["y"]
        r2 = dx * dx + dy * dy
        if r2 < 1e-9:
            continue
        r = math.sqrt(r2)
        ex += c["q"] * dx / (r2 * r)
        ey += c["q"] * dy / (r2 * r)
    return ex, ey


def _fm_potential(charges: list, x: float, y: float) -> float:
    v = 0.0
    for c in charges:
        r = _hyp(x - c["x"], y - c["y"])
        v += c["q"] / max(r, 1e-6)
    return v


def f_field_map(p: dict) -> dict:
    """Electric field maps and equipotential maps: one geometry, two readings.

    Field lines and isolines are complementary representations of the same
    field -- the AP Physics 2 entry says exactly that, and either can be built
    from the other -- so they are one family. Lines are traced by stepping
    along the computed field; isolines for a single charge are circles, which
    makes "perpendicular to the field everywhere" exact rather than
    approximate.
    """
    ch = p["charges"]
    lines, vectors, isos = [], [], []

    if p.get("field_lines"):
        per = p.get("lines_per_unit_charge", 8)
        for c in ch:
            if c["q"] <= 0:
                continue
            n = max(1, int(round(per * c["q"])))
            for i in range(n):
                a = 2 * math.pi * (i + 0.5) / n
                x, y = c["x"] + 0.035 * math.cos(a), c["y"] + 0.035 * math.sin(a)
                pts = [(x, y)]
                for _ in range(900):
                    ex, ey = _fm_field(ch, x, y)
                    m = _hyp(ex, ey)
                    if m < 1e-9:
                        break
                    x, y = x + 0.004 * ex / m, y + 0.004 * ey / m
                    if not (0.0 <= x <= 1.0 and 0.0 <= y <= 1.0):
                        # Stop exactly ON the box edge. A 2% margin put real
                        # ink outside the frame the figure draws, and the
                        # canvas check could not see it because field lines
                        # are <path> elements.
                        pts.append((min(1.0, max(0.0, x)), min(1.0, max(0.0, y))))
                        break
                    if any(q["q"] < 0 and _hyp(x - q["x"], y - q["y"]) < 0.035 for q in ch):
                        pts.append((x, y))
                        break
                    pts.append((x, y))
                lines.append(pts)

    for gx, gy in p.get("vector_points", []):
        ex, ey = _fm_field(ch, gx, gy)
        m = _hyp(ex, ey)
        if m < 1e-12:
            continue
        vectors.append({"x": gx, "y": gy, "ux": ex / m, "uy": ey / m, "mag": m})

    for r in p.get("isoline_radii", []):
        c = ch[0]
        isos.append({"cx": c["x"], "cy": c["y"], "r": r,
                     "v": _fm_potential(ch, c["x"] + r, c["y"])})

    return {"curves": [], "areas": [], "legend": [], "frame": "bare",
            "fm_charges": ch, "fm_lines": lines, "fm_vectors": vectors,
            "fm_isolines": isos, "unit_note": p.get("unit_note"),
            "x_range": (0.0, 1.0), "y_range": (0.0, 1.0)}


def f_circuit_symbols(p: dict) -> dict:
    """A symbol library, drawn as a legend sheet rather than as a circuit.

    AP Physics 2 11.2 authors eight labelled parts and every one of them is a
    SYMBOL, not a component in a working circuit. Drawing a circuit that
    happens to contain them would teach the circuit; what the entry asks for is
    the key. Each cell is one symbol with its name under it, and the variable
    element is deliberately the standard symbol plus the diagonal arrow, which
    is the entry's own definition of it.
    """
    cells = []
    for i, sym in enumerate(p["symbols"]):
        cells.append({"glyph": sym["glyph"], "label": sym["label"],
                      "variable": bool(sym.get("variable")),
                      "base": sym.get("base"), "index": i,
                      # Carried through: the ammeter and the voltmeter are the
                      # SAME glyph and are told apart only by this letter.
                      # Dropping it drew two identical empty circles.
                      "letter": sym.get("letter", "")})
    known = {"battery", "bulb", "switch", "capacitor", "resistor", "meter", "wire"}
    for c in cells:
        if c["glyph"] not in known:
            raise ValueError(f"no drawing for circuit symbol {c['glyph']!r}")
    cols = p.get("columns", 4)
    return {"curves": [], "areas": [], "legend": [], "frame": "bare",
            "cs_cells": cells, "cs_cols": cols, "unit_note": p.get("unit_note"),
            "x_range": (0.0, 1.0), "y_range": (0.0, 1.0)}


def _normal_pdf(x: float, mu: float, sigma: float) -> float:
    z = (x - mu) / sigma
    return math.exp(-0.5 * z * z) / (sigma * math.sqrt(2.0 * math.pi))


def _chi2_pdf(x: float, df: int) -> float:
    """Chi-square density, restricted to EVEN degrees of freedom.

    With df even, k = df/2 is an integer, so gamma(k) is (k-1)! exactly and the
    x**(k-1) term is a repeated multiplication. Both are then identical in
    Python and JavaScript; `pow` with a float exponent need not be, and these
    values become drawn coordinates.
    """
    if df % 2 or df < 2:
        raise ValueError("density_curve draws chi-square for EVEN df only")
    if x < 0:
        return 0.0
    # NOT `x <= 0`. With df = 2 the chi-square IS an exponential, whose density
    # at zero is 1/2, and zeroing it drew a near-vertical spike from the axis
    # that read as an asymptote. For df > 2 the x**(k-1) factor makes the
    # density zero at zero on its own. "Takes only positive values" is about
    # the SUPPORT, not about the density at the boundary.
    k = df // 2
    g = 1.0
    for i in range(2, k):
        g *= i
    num = 1.0
    for _ in range(k - 1):
        num *= x
    den = 1.0
    for _ in range(k):
        den *= 2.0
    return num * math.exp(-x / 2.0) / (den * g)


def f_density_curve(p: dict) -> dict:
    """Probability density curves, with the area under them shaded.

    One family for most of what AP Statistics draws: the normal curve, the
    standard normal, the empirical rule's bands, probability as an area, a
    critical value bounding the middle C%, the tail a p-value lives in, and the
    chi-square family's skew. The entries differ; the geometry does not.

    It emits only `curves` and `areas`, which the renderer already draws, so
    the family adds no drawing code -- and the claim it makes, that a shaded
    region IS a probability, is checked against the integral rather than
    trusted to the fill.
    """
    x0, x1 = p["x_range"]
    n = p.get("samples", 600)
    xs = [x0 + (x1 - x0) * i / n for i in range(n + 1)]

    def dens(c, x):
        if c["kind"] == "normal":
            return _normal_pdf(x, c["mu"], c["sigma"])
        return _chi2_pdf(x, c["df"])

    curves, legend = [], []
    for c in p["curves"]:
        style = c.get("style", "solid")
        pts = [(x, dens(c, x)) for x in xs]
        curves.append({"pts": pts, "style": style,
                       "color": INK if style == "solid" else GRAY})
        if c.get("label"):
            legend.append((c["label"], style))

    # Shading belongs to the first curve unless a band names another.
    areas = []
    for sh in p.get("shade", []):
        c = p["curves"][sh.get("curve", 0)]
        a = x0 if sh.get("from") is None else sh["from"]
        b = x1 if sh.get("to") is None else sh["to"]
        pts = [(x, dens(c, x)) for x in xs if a <= x <= b]
        if not pts:
            continue
        areas.append({"pts": pts, "x0": pts[0][0],
                      "fill": sh.get("fill", LIGHT), "op": sh.get("op", 0.55)})

    marks = []
    for m in p.get("marks", []):
        c = p["curves"][m.get("curve", 0)]
        marks.append({"x": m["x"], "y": m.get("y", dens(c, m["x"])),
                      "label": m["label"], "place": m.get("place", "above")})

    vlines = [{"x": v["x"], "label": v.get("label"), "caption": v.get("caption")}
              for v in p.get("vlines", [])]

    ymax = max(y for c in curves for _, y in c["pts"]) * 1.18
    # Free text placed in DATA coordinates. The empirical rule's three nested
    # bands were shaded and unlabelled, so nothing said which was 68, 95 or
    # 99.7 -- the three parts the entry actually authors.
    texts = [{"x": t["x"], "y": t["y"], "label": t["label"],
              "anchor": t.get("anchor", "middle")} for t in p.get("texts", [])]
    out = {"curves": curves, "areas": areas, "marks": marks, "vlines": vlines,
           "texts": texts, "legend": legend, "x_range": (x0, x1), "y_range": (0.0, ymax)}
    if "x_ticks" in p:
        out["x_ticks"] = [(v, lbl) for v, lbl in p["x_ticks"]]
    if p.get("hide_y_ticks", True):
        # A density axis is a density, not a count, and its numbers teach
        # nothing: the entries are about the AREA. The axis label carries the
        # meaning and the y ticks would only invite reading heights.
        out["hide_y_ticks"] = True
    return out


def _fp_eval(c: dict, x: float) -> float | None:
    """Evaluate one typed function at x. None means "not defined here".

    Functions are TYPED with numeric parameters, never parsed from a string:
    a spec cannot smuggle in an expression, and the two renderers evaluate the
    same arithmetic in the same order. Exponentials are written with exp(k*x)
    rather than b**x because `pow` with a float exponent need not agree between
    Python and JavaScript, while exp does -- the same reasoning as the
    chi-square density.
    """
    k = c["kind"]
    if k == "polynomial":
        y = 0.0
        for a in reversed(c["coeffs"]):          # Horner: exact, order fixed
            y = y * x + a
        return y
    if k == "exponential":                        # a*exp(r*x) + d
        return c["a"] * math.exp(c["r"] * x) + c.get("d", 0.0)
    if k == "logarithm":                          # a*ln(x)/ln_base + d, x > 0
        if x <= 0:
            return None
        return c["a"] * math.log(x) / c.get("ln_base", 1.0) + c.get("d", 0.0)
    if k == "sine":                               # a*sin(b*x + p) + d
        return c["a"] * math.sin(c["b"] * x + c.get("p", 0.0)) + c.get("d", 0.0)
    if k == "identity":
        return x
    if k in ("tangent", "secant", "cosecant", "cotangent"):
        t = c.get("b", 1.0) * x
        co, si = math.cos(t), math.sin(t)
        cut = c.get("cut", 12.0)                  # clip the blow-up near a pole
        if k == "tangent":
            if abs(co) < 1e-12:
                return None
            y = c.get("a", 1.0) * si / co
        elif k == "secant":
            if abs(co) < 1e-12:
                return None
            y = c.get("a", 1.0) / co
        elif k == "cosecant":
            if abs(si) < 1e-12:
                return None
            y = c.get("a", 1.0) / si
        else:
            if abs(si) < 1e-12:
                return None
            y = c.get("a", 1.0) * co / si
        return y if abs(y) <= cut else None
    raise ValueError(f"function_plot has no kind {k!r}")


def f_function_plot(p: dict) -> dict:
    """A function drawn over a domain, with one feature marked.

    Fifteen AP Precalculus and AP Calculus AB entries are this one picture:
    concavity, a zero, an inflection point, a hole, a tangency, a reflection,
    an asymptote, a transformation, a sequence's discrete points. The entries
    differ; the geometry does not. AP Precalculus has no `kind='diagram'`
    entries at all, which is why the original lane filter left the whole
    subject with a single figure.

    A curve BREAKS where its function is undefined -- at a pole, left of a
    logarithm's domain -- rather than being joined across the gap, because a
    line drawn through an asymptote asserts a value the function does not take.
    """
    x0, x1 = p["x_range"]
    n = p.get("samples", 600)
    xs = [x0 + (x1 - x0) * i / n for i in range(n + 1)]

    # Nothing is drawn outside the declared window. A per-curve `y_clip` on its
    # MAGNITUDE is not enough: a logarithm diving to -4.9 passes |y| <= 5 and
    # still leaves a frame whose floor is -1. The window is the authority.
    win = p.get("y_range")
    curves, legend = [], []
    for c in p["curves"]:
        style = c.get("style", "solid")
        run: list[tuple[float, float]] = []
        pieces: list[list[tuple[float, float]]] = []
        for x in xs:
            y = _fp_eval(c, x)
            if y is not None and win is not None and not (win[0] <= y <= win[1]):
                y = None
            if y is None or (c.get("y_clip") is not None and abs(y) > c["y_clip"]):
                if len(run) > 1:
                    pieces.append(run)
                run = []
                continue
            run.append((x, y))
        if len(run) > 1:
            pieces.append(run)
        for piece in pieces:
            curves.append({"pts": piece, "style": style,
                           "color": INK if style == "solid" else GRAY})
        if c.get("label"):
            legend.append((c["label"], style))

    def at(ci: int, x: float) -> float:
        y = _fp_eval(p["curves"][ci], x)
        if y is None:
            raise ValueError(f"curve {ci} is not defined at {x}")
        return y

    # A secant is just a two-point curve, so it needs no primitive of its own.
    for sc in p.get("secants", []):
        a, b = sc["from"], sc["to"]
        ci = sc.get("curve", 0)
        # Dashed so it reads as a chord rather than part of the function, but
        # in INK: in grey it disappeared against the curve it is drawn across,
        # which left "the secants get steeper" invisible.
        curves.append({"pts": [(a, at(ci, a)), (b, at(ci, b))], "style": "dashed",
                       "color": INK})

    marks = [{"x": m["x"], "y": m.get("y", at(m.get("curve", 0), m["x"])),
              "label": m["label"], "place": m.get("place", "above")}
             for m in p.get("marks", [])]
    dots = [{"x": d["x"], "y": d["y"]} for d in p.get("points", [])]
    # An OPEN circle is a point the graph does not take: a hole. Filling it
    # would assert the opposite of what the entry is about.
    open_dots = [{"x": d["x"], "y": d["y"]} for d in p.get("open_points", [])]
    vlines = [{"x": v, "label": None, "caption": None} for v in p.get("asymptotes_x", [])]
    hlines = [{"y": h["y"], "label": h["label"]} for h in p.get("asymptotes_y", [])]
    texts = [{"x": t["x"], "y": t["y"], "label": t["label"],
              "anchor": t.get("anchor", "middle")} for t in p.get("texts", [])]

    ys = [y for c in curves for _, y in c["pts"]] + [d["y"] for d in dots + open_dots]
    yr = p.get("y_range") or (min(ys) - (max(ys) - min(ys)) * 0.12,
                              max(ys) + (max(ys) - min(ys)) * 0.12)
    out = {"curves": curves, "areas": [], "marks": marks, "dots": dots,
           "open_dots": open_dots, "vlines": vlines, "hlines": hlines,
           "texts": texts, "legend": legend,
           "x_range": (x0, x1), "y_range": (yr[0], yr[1])}
    if "x_ticks" in p:
        out["x_ticks"] = [(v, lbl) for v, lbl in p["x_ticks"]]
    if "y_ticks" in p:
        out["y_ticks"] = p["y_ticks"]
    return out


# Fraction of the inner membrane's height left free of cristae, so a label
# can cross the matrix without a fold running through it.
CLEAR_BAND = (0.42, 0.58)


def f_organelle(p: dict) -> dict:
    """A double-membraned organelle as labelled regions: the chloroplast and
    the mitochondrion.

    Deliberately NOT an anatomical drawing. Every labelled part these two
    entries author is a REGION and the process that happens in it -- stroma,
    grana, thylakoid membranes; matrix, inner membrane, intermembrane space --
    so the contract is "is each region present, enclosed by the right boundary,
    and labelled", which a grammar satisfies exactly and an illustration only
    satisfies incidentally. The two organelles differ in one thing, the shape of
    the inner membrane system, so they are one family with a mode.

    Geometry is in a 0..1 box, like the particulate and field families.
    """
    mode = p["mode"]
    if mode not in ("grana", "cristae"):
        raise ValueError("organelle draws 'grana' (chloroplast) or 'cristae' (mitochondrion)")
    outer = {"x": 0.04, "y": 0.10, "w": 0.92, "h": 0.80, "r": 0.30}
    inner = {"x": outer["x"] + 0.045, "y": outer["y"] + 0.055,
             "w": outer["w"] - 0.09, "h": outer["h"] - 0.11, "r": 0.26}
    stacks, folds = [], []
    if mode == "grana":
        # Stacks of thylakoids, evenly spaced inside the inner membrane.
        n = int(p.get("stacks", 4))
        discs = int(p.get("discs_per_stack", 4))
        for i in range(n):
            cx = inner["x"] + inner["w"] * (i + 0.5) / n
            for d in range(discs):
                h = 0.030
                gap = 0.014
                total = discs * h + (discs - 1) * gap
                y0 = inner["y"] + inner["h"] / 2 - total / 2 + d * (h + gap)
                stacks.append({"x": cx - 0.075, "y": y0, "w": 0.15, "h": h})
    else:
        # Cristae: folds of the inner membrane, which is what makes its area
        # larger than the outer one -- the entry's own point about ATP yield.
        # Each fold is a flat-tipped finger, not a spike: a spike reads as a
        # dart thrown into the matrix, which is not what a crista is. The depths
        # are chosen so that folds from the top stop above CLEAR_BAND and folds
        # from the bottom stop below it, leaving a band right across the matrix
        # that no fold crosses -- that is where the matrix label can sit without
        # a line running through it. p_organelle asserts the band is really clear.
        n = int(p.get("folds", 5))
        for i in range(n):
            cx = inner["x"] + inner["w"] * (i + 0.5) / n
            up = i % 2 == 0
            # The base sits ON the inner membrane, not near it: a crista that
            # floats free of the membrane it is a fold of is just a box.
            folds.append({"x": cx, "y0": inner["y"] + (0.0 if up else inner["h"]),
                          "y1": inner["y"] + inner["h"] * (CLEAR_BAND[0] if up else CLEAR_BAND[1]),
                          "w": inner["w"] / n * 0.44})
    labels = [{"x": l["x"], "y": l["y"], "label": l["label"],
               "anchor": l.get("anchor", "middle")} for l in p.get("labels_at", [])]
    leaders = [{"x0": l["x"], "y0": l["y"], "x1": l["to"][0], "y1": l["to"][1]}
               for l in p.get("labels_at", []) if l.get("to")]
    return {"curves": [], "areas": [], "legend": [], "frame": "bare",
            "org_outer": outer, "org_inner": inner, "org_stacks": stacks,
            "org_folds": folds, "org_labels": labels, "org_leaders": leaders,
            "unit_note": p.get("unit_note"),
            "x_range": (0.0, 1.0), "y_range": (0.0, 1.0)}


# A base pairs with exactly one other base, and the number of hydrogen bonds
# that join them is a property of the pair, not a drawing choice.
PAIRING = {"A": "T", "T": "A", "C": "G", "G": "C"}
HBONDS = {frozenset(("A", "T")): 2, frozenset(("C", "G")): 3}


def f_dna_ladder(p: dict) -> dict:
    """Two nucleotide strands, paired base to base, running in opposite
    directions.

    The entry authors four things -- two strands, opposite 5' to 3' orientation,
    A-T pairs and C-G pairs -- and all four are *relations*, not shapes. So the
    spec names one strand's bases and the renderer DERIVES the other from the
    pairing rule: a figure that cannot draw a wrong pair cannot ship one. The
    direction arrows are derived the same way, from a single orientation flag.

    Geometry is in a 0..1 box.
    """
    bases = [b.upper() for b in p["strand"]]
    for b in bases:
        if b not in PAIRING:
            raise ValueError(f"{b!r} is not a DNA base")
    n = len(bases)
    if n < 4:
        raise ValueError("a ladder needs at least four base pairs to read as one")
    y_top, y_bot = 0.30, 0.70          # the two sugar-phosphate backbones
    bh = 0.105                          # height of a base block
    x0, x1 = 0.09, 0.91
    step = (x1 - x0) / n
    rungs = []
    for i, b in enumerate(bases):
        cx = x0 + step * (i + 0.5)
        partner = PAIRING[b]
        nb = HBONDS[frozenset((b, partner))]
        # The hydrogen bonds are drawn in the gap BETWEEN the two base blocks,
        # evenly spread, so two of them and three of them are told apart at a
        # glance -- which is the only visible difference between A-T and C-G.
        g0, g1 = y_top + bh, y_bot - bh
        bonds = [{"x": cx - 0.030 + 0.060 * (j + 0.5) / nb, "y0": g0, "y1": g1}
                 for j in range(nb)]
        rungs.append({"x": cx, "top": b, "bottom": partner,
                      "y_top": y_top, "y_bot": y_bot, "h": bh,
                      "w": step * 0.58, "bonds": bonds})
    # One flag decides both arrows, so they cannot be made to agree.
    top_left_to_right = bool(p.get("top_strand_left_to_right", True))
    strands = [
        {"y": y_top, "x0": x0, "x1": x1, "left_to_right": top_left_to_right,
         "five_prime_x": x0 if top_left_to_right else x1,
         "three_prime_x": x1 if top_left_to_right else x0},
        {"y": y_bot, "x0": x0, "x1": x1, "left_to_right": not top_left_to_right,
         "five_prime_x": x1 if top_left_to_right else x0,
         "three_prime_x": x0 if top_left_to_right else x1},
    ]
    labels = [{"x": l["x"], "y": l["y"], "label": l["label"],
               "anchor": l.get("anchor", "middle")} for l in p.get("labels_at", [])]
    leaders = [{"x0": l["x"], "y0": l["y"], "x1": l["to"][0], "y1": l["to"][1]}
               for l in p.get("labels_at", []) if l.get("to")]
    return {"curves": [], "areas": [], "legend": [], "frame": "bare",
            "dna_rungs": rungs, "dna_strands": strands,
            "dna_labels": labels, "dna_leaders": leaders,
            "unit_note": p.get("unit_note"),
            "x_range": (0.0, 1.0), "y_range": (0.0, 1.0)}


# Where the bilayer sits in the 0..1 box. The extracellular side is ABOVE it,
# which is what makes "the sugar chains are all on one side" a thing you can
# see rather than a thing the caption claims.
BILAYER = {"head_top": 0.40, "head_bot": 0.62, "head_r": 0.021, "mid": 0.51}


def f_membrane_bilayer(p: dict) -> dict:
    """The fluid mosaic membrane as a bilayer with named things embedded in it.

    The entry's five parts are a bilayer plus four kinds of inclusion, and each
    one is defined by WHERE it sits: a transmembrane protein crosses both
    leaflets, a steroid sits among the tails, and the carbohydrate of a
    glycoprotein or a glycolipid is on the outside face. So position is the
    content here, and every inclusion's geometry is derived from its kind --
    the spec chooses the kind and the x, never the y.

    Geometry is in a 0..1 box.
    """
    ht, hb, hr, mid = (BILAYER["head_top"], BILAYER["head_bot"],
                       BILAYER["head_r"], BILAYER["mid"])
    incl, chains = [], []
    for it in p.get("inclusions", []):
        kind, cx = it["kind"], float(it["x"])
        if kind in ("protein", "glycoprotein"):
            w = float(it.get("w", 0.075))
            box = {"x": cx - w / 2, "y": ht - 0.055, "w": w, "h": (hb - ht) + 0.11,
                   "r": 0.02, "kind": kind}
        elif kind == "steroid":
            # Among the fatty-acid tails, inside the bilayer: never poking out
            # into the water on either side.
            w = float(it.get("w", 0.026))
            box = {"x": cx - w / 2, "y": ht + hr + 0.012, "w": w,
                   "h": (hb - hr - 0.012) - (ht + hr + 0.012), "r": 0.012, "kind": kind}
        elif kind == "glycolipid":
            box = {"x": cx - hr, "y": ht - hr, "w": hr * 2, "h": hr * 2,
                   "r": hr, "kind": kind}
        else:
            raise ValueError(f"unknown membrane inclusion {kind!r}")
        incl.append(box)
        if kind in ("glycoprotein", "glycolipid"):
            # A branched carbohydrate, drawn upward from the top of the
            # inclusion -- so on the extracellular face, for both kinds.
            base_y = box["y"]
            stem = 0.055
            segs = [{"x0": cx, "y0": base_y, "x1": cx, "y1": base_y - stem}]
            nodes = [{"x": cx, "y": base_y - stem, "r": 0.013}]
            for dx in (-0.038, 0.038):
                segs.append({"x0": cx, "y0": base_y - stem,
                             "x1": cx + dx, "y1": base_y - stem - 0.042})
                nodes.append({"x": cx + dx, "y": base_y - stem - 0.042, "r": 0.013})
            chains.append({"segments": segs, "nodes": nodes, "kind": kind})
    # Phospholipids fill the rest of both leaflets. One is dropped wherever an
    # inclusion stands, rather than drawn through it.
    n = int(p.get("lipids", 26))
    heads, tails = [], []
    # A glycolipid IS a lipid: it sits in the leaflet with fatty acid tails like
    # its neighbours, and the sugar chain is what makes it a glyco- one. Drawn
    # as a bare head it reads as a bead stuck on the surface.
    for b in incl:
        if b["kind"] == "glycolipid":
            cx = b["x"] + b["w"] / 2
            for dx in (-0.007, 0.007):
                tails.append({"x0": cx + dx, "y0": ht + hr,
                              "x1": cx + dx * 1.6, "y1": mid - 0.004})
    for i in range(n):
        cx = 0.03 + (0.94) * (i + 0.5) / n
        if any(b["x"] - 0.012 <= cx <= b["x"] + b["w"] + 0.012 for b in incl):
            continue
        for y, sgn in ((ht, 1.0), (hb, -1.0)):
            heads.append({"x": cx, "y": y, "r": hr})
            for dx in (-0.007, 0.007):
                tails.append({"x0": cx + dx, "y0": y + sgn * hr,
                              "x1": cx + dx * 1.6, "y1": mid - sgn * 0.004})
    labels = [{"x": l["x"], "y": l["y"], "label": l["label"],
               "anchor": l.get("anchor", "middle")} for l in p.get("labels_at", [])]
    leaders = [{"x0": l["x"], "y0": l["y"], "x1": l["to"][0], "y1": l["to"][1]}
               for l in p.get("labels_at", []) if l.get("to")]
    return {"curves": [], "areas": [], "legend": [], "frame": "bare",
            "mb_heads": heads, "mb_tails": tails, "mb_incl": incl,
            "mb_chains": chains, "mb_labels": labels, "mb_leaders": leaders,
            "mb_side_labels": p.get("side_labels", []),
            "unit_note": p.get("unit_note"),
            "x_range": (0.0, 1.0), "y_range": (0.0, 1.0)}


def f_electrochemical_cell(p: dict) -> dict:
    """A galvanic cell drawn as the four things the entry says a cell diagram
    is read for: the electrodes, the two half-cell solutions, the salt bridge
    and the measuring device.

    The whole point of the entry is DIRECTION -- which electrode is the anode,
    which way the electrons go, which way the ions go -- so the spec states one
    fact, which side the anode is on, and every arrow is derived from it.
    Electrons always leave the anode; cations always move toward the cathode.
    Nothing here can be drawn inconsistently with itself.

    Geometry is in a 0..1 box.
    """
    anode_side = p.get("anode_side", "left")
    if anode_side not in ("left", "right"):
        raise ValueError("anode_side is 'left' or 'right'")
    beaker_y0, beaker_y1 = 0.44, 0.93
    level = 0.54                              # the solution surface
    wire_y = 0.13
    cells = []
    for side, bx0, bx1 in (("left", 0.05, 0.42), ("right", 0.58, 0.95)):
        ex = (bx0 + bx1) / 2
        role = "anode" if side == anode_side else "cathode"
        cells.append({
            "side": side, "role": role,
            "beaker": {"x": bx0, "y": beaker_y0, "w": bx1 - bx0, "h": beaker_y1 - beaker_y0},
            "solution": {"x": bx0, "y": level, "w": bx1 - bx0, "h": beaker_y1 - level},
            "level": level,
            "electrode": {"x": ex - 0.026, "y": 0.215, "w": 0.052, "h": 0.545},
            "electrode_x": ex,
            "label": p.get(f"{role}_label", role),
            "solution_label": p.get(f"{role}_solution", ""),
        })
    lx = [c for c in cells if c["side"] == "left"][0]["electrode_x"]
    rx = [c for c in cells if c["side"] == "right"][0]["electrode_x"]
    meter = {"x": 0.5, "y": wire_y, "r": 0.052, "glyph": p.get("meter", "V"),
             "label": p.get("meter_label", "voltmeter")}
    wires = [{"x0": lx, "y0": 0.215, "x1": lx, "y1": wire_y},
             {"x0": lx, "y0": wire_y, "x1": meter["x"] - meter["r"], "y1": wire_y},
             {"x0": meter["x"] + meter["r"], "y0": wire_y, "x1": rx, "y1": wire_y},
             {"x0": rx, "y0": wire_y, "x1": rx, "y1": 0.215}]
    # Electrons leave the anode and travel the external circuit to the cathode.
    a_x = lx if anode_side == "left" else rx
    c_x = rx if anode_side == "left" else lx
    sgn = 1.0 if c_x > a_x else -1.0
    # Below the wire, not above it: above, its label and the meter's label are
    # both competing for the same strip of sky and they overprint.
    e_arrow = {"x0": a_x + sgn * 0.085, "y0": wire_y + 0.075,
               "x1": a_x + sgn * 0.185, "y1": wire_y + 0.075,
               "label": "e\u207b", "to": "cathode"}
    # The bridge dips below the surface in both beakers and touches neither
    # electrode: it joins the SOLUTIONS, which is what lets charge balance.
    bx_l, bx_r = lx + 0.115, rx - 0.115
    bridge = {"x_left": bx_l, "x_right": bx_r, "y_top": 0.355, "y_dip": level + 0.15}
    # Stacked, not side by side: two labels centred on the same line, one of
    # them pointing each way, print straight through each other.
    ions = [{"x0": 0.5, "y0": 0.265,
             "x1": 0.5 + (0.085 if c_x > 0.5 else -0.085), "y1": 0.265,
             "label": "cations \u2192 cathode", "to": "cathode"},
            {"x0": 0.5, "y0": 0.335,
             "x1": 0.5 + (0.085 if a_x > 0.5 else -0.085), "y1": 0.335,
             "label": "anions \u2192 anode", "to": "anode"}]
    # `ann` marks a label the compact size drops. 340 units is not enough for
    # every phrase this diagram wants to say, and the compact rule is that only
    # what carries the teaching point survives.
    labels = [{"x": l["x"], "y": l["y"], "label": l["label"],
               "anchor": l.get("anchor", "middle"), "ann": bool(l.get("ann"))}
              for l in p.get("labels_at", [])]
    leaders = [{"x0": l["x"], "y0": l["y"], "x1": l["to"][0], "y1": l["to"][1],
                "ann": bool(l.get("ann"))}
               for l in p.get("labels_at", []) if l.get("to")]
    return {"curves": [], "areas": [], "legend": [], "frame": "bare",
            "ec_cells": cells, "ec_meter": meter, "ec_wires": wires,
            "ec_electron": e_arrow, "ec_bridge": bridge, "ec_ions": ions,
            "ec_bridge_label": p.get("bridge_label", "salt bridge"),
            "ec_labels": labels, "ec_leaders": leaders,
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
    "field_map": f_field_map,
    "circuit_symbols": f_circuit_symbols,
    "density_curve": f_density_curve,
    "function_plot": f_function_plot,
    "organelle": f_organelle,
    "dna_ladder": f_dna_ladder,
    "membrane_bilayer": f_membrane_bilayer,
    "electrochemical_cell": f_electrochemical_cell,
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
        # The ids are per FIGURE, not the literals "ttl"/"desc". Several of
        # these SVGs are inline on one page -- the notes sheet shows a figures
        # section -- and repeating id="ttl" is invalid and points every
        # figure's accessible name at whichever one parsed first. The app's
        # renderer already did this; the parity check found that this one did
        # not.
        f'role="img" aria-labelledby="{spec["figure_id"]}-t {spec["figure_id"]}-d" '
        f'font-family="Helvetica Neue, Arial, sans-serif">',
        f'<title id="{spec["figure_id"]}-t">{esc(spec["title"])}</title>',
        f'<desc id="{spec["figure_id"]}-d">{esc(spec["alt"])}</desc>',
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
    # free text in data coordinates (band labels, mostly)
    for t in g.get("texts", []):
        o.append(f'<text x="{sx(t["x"]):.1f}" y="{sy(t["y"]):.1f}" text-anchor="{t["anchor"]}" '
                 f'font-size="{FM:.1f}" fill="{INK}">{esc(t["label"])}</text>')
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
    # organelle: outer envelope, inner membrane, and the region labels
    if g.get("org_outer"):
        ox, oy = L, T
        X = lambda u: ox + u * pw
        Y = lambda v: oy + v * ph
        for box, sw_, fill in ((g["org_outer"], SW, BG), (g["org_inner"], SW * 0.9, BG)):
            o.append(f'<rect x="{X(box["x"]):.1f}" y="{Y(box["y"]):.1f}" '
                     f'width="{box["w"]*pw:.1f}" height="{box["h"]*ph:.1f}" '
                     f'rx="{box["r"]*min(pw, ph)*0.5:.1f}" fill="{fill}" stroke="{INK}" '
                     f'stroke-width="{sw_:.1f}"/>')
        for st in g.get("org_stacks", []):
            o.append(f'<rect x="{X(st["x"]):.1f}" y="{Y(st["y"]):.1f}" '
                     f'width="{st["w"]*pw:.1f}" height="{st["h"]*ph:.1f}" rx="{min(pw,ph)*0.012:.1f}" '
                     f'fill="{LIGHT}" fill-opacity="0.75" stroke="{INK}" stroke-width="1"/>')
        for fo in g.get("org_folds", []):
            o.append(f'<path d="M {X(fo["x"]-fo["w"]/2):.1f},{Y(fo["y0"]):.1f} '
                     f'L {X(fo["x"]-fo["w"]/2):.1f},{Y(fo["y1"]):.1f} '
                     f'L {X(fo["x"]+fo["w"]/2):.1f},{Y(fo["y1"]):.1f} '
                     f'L {X(fo["x"]+fo["w"]/2):.1f},{Y(fo["y0"]):.1f}" fill="none" '
                     f'stroke="{INK}" stroke-width="{SW*0.9:.1f}" stroke-linejoin="round"/>')
        for ld in g.get("org_leaders", []):
            o.append(f'<line x1="{X(ld["x0"]):.1f}" y1="{Y(ld["y0"]):.1f}" '
                     f'x2="{X(ld["x1"]):.1f}" y2="{Y(ld["y1"]):.1f}" stroke="{GRAY}" '
                     f'stroke-width="1"/>')
        for lb in g.get("org_labels", []):
            o.append(f'<text x="{X(lb["x"]):.1f}" y="{Y(lb["y"]):.1f}" text-anchor="{lb["anchor"]}" '
                     f'font-size="{FM:.1f}" fill="{INK}">{esc(lb["label"])}</text>')
        if g.get("unit_note") and SHOW_ANN:
            o.append(f'<text x="{L:.1f}" y="{T + ph + FO*1.4:.1f}" font-size="{FO:.1f}" '
                     f'fill="{GRAY}">{esc(g["unit_note"])}</text>')
    # DNA: two backbones, base blocks, and the hydrogen bonds between them
    if g.get("dna_rungs"):
        ox, oy = L, T
        X = lambda u: ox + u * pw
        Y = lambda v: oy + v * ph
        for st in g["dna_strands"]:
            o.append(f'<line x1="{X(st["x0"]):.1f}" y1="{Y(st["y"]):.1f}" '
                     f'x2="{X(st["x1"]):.1f}" y2="{Y(st["y"]):.1f}" stroke="{INK}" '
                     f'stroke-width="{SW*1.2:.1f}" stroke-linecap="round"/>')
            # The arrowhead is the 5' to 3' direction, drawn at the 3' end.
            tipx = st["three_prime_x"]
            back = -0.028 if st["left_to_right"] else 0.028
            o.append(f'<path d="M {X(tipx):.1f},{Y(st["y"]):.1f} '
                     f'L {X(tipx+back):.1f},{Y(st["y"]-0.030):.1f} '
                     f'L {X(tipx+back):.1f},{Y(st["y"]+0.030):.1f} Z" fill="{INK}"/>')
            for which, xx in (("5'", st["five_prime_x"]), ("3'", st["three_prime_x"])):
                dx = -0.035 if xx < 0.5 else 0.035
                o.append(f'<text x="{X(xx+dx):.1f}" y="{Y(st["y"]+0.016):.1f}" '
                         f'text-anchor="middle" font-size="{FM:.1f}" fill="{INK}">{which}</text>')
        for r in g["dna_rungs"]:
            for b, yb in ((r["top"], r["y_top"]), (r["bottom"], r["y_bot"] - r["h"])):
                o.append(f'<rect x="{X(r["x"]-r["w"]/2):.1f}" y="{Y(yb):.1f}" '
                         f'width="{r["w"]*pw:.1f}" height="{r["h"]*ph:.1f}" '
                         f'rx="{min(pw,ph)*0.010:.1f}" fill="{LIGHT}" fill-opacity="0.7" '
                         f'stroke="{INK}" stroke-width="1"/>')
                o.append(f'<text x="{X(r["x"]):.1f}" y="{Y(yb+r["h"]*0.70):.1f}" '
                         f'text-anchor="middle" font-size="{FM:.1f}" fill="{INK}">{b}</text>')
            for bd in r["bonds"]:
                o.append(f'<line x1="{X(bd["x"]):.1f}" y1="{Y(bd["y0"]):.1f}" '
                         f'x2="{X(bd["x"]):.1f}" y2="{Y(bd["y1"]):.1f}" stroke="{GRAY}" '
                         f'stroke-width="1" stroke-dasharray="2 2"/>')
        for ld in g.get("dna_leaders", []):
            o.append(f'<line x1="{X(ld["x0"]):.1f}" y1="{Y(ld["y0"]):.1f}" '
                     f'x2="{X(ld["x1"]):.1f}" y2="{Y(ld["y1"]):.1f}" stroke="{GRAY}" '
                     f'stroke-width="1"/>')
        for lb in g.get("dna_labels", []):
            o.append(f'<text x="{X(lb["x"]):.1f}" y="{Y(lb["y"]):.1f}" text-anchor="{lb["anchor"]}" '
                     f'font-size="{FM:.1f}" fill="{INK}">{esc(lb["label"])}</text>')
        if g.get("unit_note") and SHOW_ANN:
            o.append(f'<text x="{L:.1f}" y="{T + ph + FO*1.4:.1f}" font-size="{FO:.1f}" '
                     f'fill="{GRAY}">{esc(g["unit_note"])}</text>')

    # membrane: the bilayer and the things embedded in it
    if g.get("mb_heads"):
        ox, oy = L, T
        X = lambda u: ox + u * pw
        Y = lambda v: oy + v * ph
        for t in g["mb_tails"]:
            o.append(f'<line x1="{X(t["x0"]):.1f}" y1="{Y(t["y0"]):.1f}" '
                     f'x2="{X(t["x1"]):.1f}" y2="{Y(t["y1"]):.1f}" stroke="{GRAY}" '
                     f'stroke-width="1"/>')
        for h in g["mb_heads"]:
            o.append(f'<circle cx="{X(h["x"]):.1f}" cy="{Y(h["y"]):.1f}" '
                     f'r="{h["r"]*min(pw,ph):.1f}" fill="{BG}" stroke="{INK}" stroke-width="1"/>')
        for b in g["mb_incl"]:
            fill = LIGHT if b["kind"] == "steroid" else BG
            o.append(f'<rect x="{X(b["x"]):.1f}" y="{Y(b["y"]):.1f}" '
                     f'width="{b["w"]*pw:.1f}" height="{b["h"]*ph:.1f}" '
                     f'rx="{b["r"]*min(pw,ph):.1f}" fill="{fill}" stroke="{INK}" '
                     f'stroke-width="{SW*0.8:.1f}"/>')
        for ch in g["mb_chains"]:
            for sg in ch["segments"]:
                o.append(f'<line x1="{X(sg["x0"]):.1f}" y1="{Y(sg["y0"]):.1f}" '
                         f'x2="{X(sg["x1"]):.1f}" y2="{Y(sg["y1"]):.1f}" stroke="{INK}" '
                         f'stroke-width="1"/>')
            for nd in ch["nodes"]:
                o.append(f'<circle cx="{X(nd["x"]):.1f}" cy="{Y(nd["y"]):.1f}" '
                         f'r="{nd["r"]*min(pw,ph):.1f}" fill="{BG}" stroke="{INK}" '
                         f'stroke-width="1"/>')
        for sl in g.get("mb_side_labels", []):
            o.append(f'<text x="{X(sl["x"]):.1f}" y="{Y(sl["y"]):.1f}" '
                     f'text-anchor="{sl.get("anchor","start")}" font-size="{FO:.1f}" '
                     f'fill="{GRAY}">{esc(sl["label"])}</text>')
        for ld in g.get("mb_leaders", []):
            o.append(f'<line x1="{X(ld["x0"]):.1f}" y1="{Y(ld["y0"]):.1f}" '
                     f'x2="{X(ld["x1"]):.1f}" y2="{Y(ld["y1"]):.1f}" stroke="{GRAY}" '
                     f'stroke-width="1"/>')
        for lb in g.get("mb_labels", []):
            o.append(f'<text x="{X(lb["x"]):.1f}" y="{Y(lb["y"]):.1f}" text-anchor="{lb["anchor"]}" '
                     f'font-size="{FM:.1f}" fill="{INK}">{esc(lb["label"])}</text>')
        if g.get("unit_note") and SHOW_ANN:
            o.append(f'<text x="{L:.1f}" y="{T + ph + FO*1.4:.1f}" font-size="{FO:.1f}" '
                     f'fill="{GRAY}">{esc(g["unit_note"])}</text>')

    # electrochemical cell: two half-cells, the external circuit and the bridge
    if g.get("ec_cells"):
        ox, oy = L, T
        X = lambda u: ox + u * pw
        Y = lambda v: oy + v * ph
        for c in g["ec_cells"]:
            sol, bk = c["solution"], c["beaker"]
            o.append(f'<rect x="{X(sol["x"]):.1f}" y="{Y(sol["y"]):.1f}" '
                     f'width="{sol["w"]*pw:.1f}" height="{sol["h"]*ph:.1f}" '
                     f'fill="{LIGHT}" fill-opacity="0.7"/>')
            # Open-topped: a beaker with a lid is a sealed vessel.
            o.append(f'<path d="M {X(bk["x"]):.1f},{Y(bk["y"]):.1f} '
                     f'L {X(bk["x"]):.1f},{Y(bk["y"]+bk["h"]):.1f} '
                     f'L {X(bk["x"]+bk["w"]):.1f},{Y(bk["y"]+bk["h"]):.1f} '
                     f'L {X(bk["x"]+bk["w"]):.1f},{Y(bk["y"]):.1f}" fill="none" '
                     f'stroke="{INK}" stroke-width="{SW:.1f}" stroke-linejoin="round"/>')
            o.append(f'<line x1="{X(bk["x"]):.1f}" y1="{Y(c["level"]):.1f}" '
                     f'x2="{X(bk["x"]+bk["w"]):.1f}" y2="{Y(c["level"]):.1f}" '
                     f'stroke="{GRAY}" stroke-width="1"/>')
            e = c["electrode"]
            o.append(f'<rect x="{X(e["x"]):.1f}" y="{Y(e["y"]):.1f}" '
                     f'width="{e["w"]*pw:.1f}" height="{e["h"]*ph:.1f}" '
                     f'fill="{LIGHT}" fill-opacity="0.85" stroke="{INK}" stroke-width="{SW*0.9:.1f}"/>')
        br = g["ec_bridge"]
        o.append(f'<path d="M {X(br["x_left"]):.1f},{Y(br["y_dip"]):.1f} '
                 f'L {X(br["x_left"]):.1f},{Y(br["y_top"]):.1f} '
                 f'L {X(br["x_right"]):.1f},{Y(br["y_top"]):.1f} '
                 f'L {X(br["x_right"]):.1f},{Y(br["y_dip"]):.1f}" fill="none" '
                 f'stroke="{GRAY}" stroke-width="{SW*2.2:.1f}" stroke-linejoin="round" '
                 f'stroke-linecap="round" stroke-opacity="0.9"/>')
        for w in g["ec_wires"]:
            o.append(f'<line x1="{X(w["x0"]):.1f}" y1="{Y(w["y0"]):.1f}" '
                     f'x2="{X(w["x1"]):.1f}" y2="{Y(w["y1"]):.1f}" stroke="{INK}" '
                     f'stroke-width="{SW*0.9:.1f}"/>')
        mt = g["ec_meter"]
        o.append(f'<circle cx="{X(mt["x"]):.1f}" cy="{Y(mt["y"]):.1f}" '
                 f'r="{mt["r"]*min(pw,ph):.1f}" fill="{BG}" stroke="{INK}" '
                 f'stroke-width="{SW:.1f}"/>')
        o.append(f'<text x="{X(mt["x"]):.1f}" y="{Y(mt["y"])+FM*0.36:.1f}" '
                 f'text-anchor="middle" font-size="{FM*1.05:.1f}" fill="{INK}">'
                 f'{esc(mt["glyph"])}</text>')
        # The ion arrows and their captions go together: at compact the captions
        # are dropped, and three unexplained arrows are worse than two fewer.
        # The electron arrow stays, because "e-" is two characters wide.
        for ar in [g["ec_electron"]] + (g["ec_ions"] if SHOW_ANN else []):
            # Every one of these arrows is horizontal, so the head is two
            # points back from the tip: no trigonometry, and nothing for a
            # port to round differently.
            hx = min(pw, ph) * 0.024
            ax0, ay0 = X(ar["x0"]), Y(ar["y0"])
            ax1, ay1 = X(ar["x1"]), Y(ar["y1"])
            back = -hx if ax1 > ax0 else hx
            o.append(f'<line x1="{ax0:.1f}" y1="{ay0:.1f}" x2="{ax1+back*0.6:.1f}" '
                     f'y2="{ay1:.1f}" stroke="{INK}" stroke-width="{SW*0.9:.1f}"/>')
            o.append(f'<path d="M {ax1:.1f},{ay1:.1f} L {ax1+back:.1f},{ay1-hx*0.62:.1f} '
                     f'L {ax1+back:.1f},{ay1+hx*0.62:.1f} Z" fill="{INK}"/>')
            if SHOW_ANN or ar is g["ec_electron"]:
                mx = (ar["x0"] + ar["x1"]) / 2
                o.append(f'<text x="{X(mx):.1f}" y="{Y(ar["y0"])-FO*0.55:.1f}" '
                         f'text-anchor="middle" font-size="{FO:.1f}" fill="{GRAY}">'
                         f'{esc(ar["label"])}</text>')
        for ld in g.get("ec_leaders", []):
            if ld.get("ann") and not SHOW_ANN:
                continue
            o.append(f'<line x1="{X(ld["x0"]):.1f}" y1="{Y(ld["y0"]):.1f}" '
                     f'x2="{X(ld["x1"]):.1f}" y2="{Y(ld["y1"]):.1f}" stroke="{GRAY}" '
                     f'stroke-width="1"/>')
        for lb in g.get("ec_labels", []):
            if lb.get("ann") and not SHOW_ANN:
                continue
            o.append(f'<text x="{X(lb["x"]):.1f}" y="{Y(lb["y"]):.1f}" text-anchor="{lb["anchor"]}" '
                     f'font-size="{FM:.1f}" fill="{INK}">{esc(lb["label"])}</text>')
        if g.get("unit_note") and SHOW_ANN:
            o.append(f'<text x="{L:.1f}" y="{T + ph + FO*1.4:.1f}" font-size="{FO:.1f}" '
                     f'fill="{GRAY}">{esc(g["unit_note"])}</text>')

    # circuit symbol sheet
    if g.get("cs_cells"):
        cells, cols = g["cs_cells"], g["cs_cols"]
        rows_n = int(math.ceil(len(cells) / cols))
        cw_ = pw / cols
        chh_ = ph / rows_n
        sw_ = max(1.3, SW * 0.9)
        for c in cells:
            r_, q_ = divmod(c["index"], cols)
            ox = L + q_ * cw_ + cw_ / 2
            oy = T + r_ * chh_ + chh_ * 0.42
            half = min(cw_ * 0.30, chh_ * 0.26)
            lead = half * 0.52
            def wire(x1, x2, yy=None):
                yy = oy if yy is None else yy
                o.append(f'<line x1="{x1:.1f}" y1="{yy:.1f}" x2="{x2:.1f}" y2="{yy:.1f}" '
                         f'stroke="{INK}" stroke-width="{sw_:.1f}" stroke-linecap="round"/>')
            glyph = c["base"] or c["glyph"]
            if glyph == "resistor":
                wire(ox - half, ox - half + lead)
                zig, n_ = [], 6
                for k in range(n_ + 1):
                    zx = ox - half + lead + k * (2 * (half - lead)) / n_
                    zy = oy + (0 if k in (0, n_) else (half * 0.40 if k % 2 else -half * 0.40))
                    zig.append(f"{zx:.1f},{zy:.1f}")
                o.append(f'<path d="M {" L ".join(zig)}" fill="none" stroke="{INK}" '
                         f'stroke-width="{sw_:.1f}" stroke-linejoin="round"/>')
                wire(ox + half - lead, ox + half)
            elif glyph == "battery":
                wire(ox - half, ox - half * 0.30)
                for dx_, hh_, wd in ((-half * 0.30, half * 0.62, sw_ * 1.5),
                                     (half * 0.02, half * 0.30, sw_ * 1.5)):
                    o.append(f'<line x1="{ox + dx_:.1f}" y1="{oy - hh_:.1f}" '
                             f'x2="{ox + dx_:.1f}" y2="{oy + hh_:.1f}" stroke="{INK}" '
                             f'stroke-width="{wd:.1f}"/>')
                wire(ox + half * 0.02, ox + half)
            elif glyph == "capacitor":
                wire(ox - half, ox - half * 0.16)
                for dx_ in (-half * 0.16, half * 0.16):
                    o.append(f'<line x1="{ox + dx_:.1f}" y1="{oy - half*0.58:.1f}" '
                             f'x2="{ox + dx_:.1f}" y2="{oy + half*0.58:.1f}" stroke="{INK}" '
                             f'stroke-width="{sw_*1.5:.1f}"/>')
                wire(ox + half * 0.16, ox + half)
            elif glyph == "bulb":
                rr = half * 0.52
                wire(ox - half, ox - rr)
                o.append(f'<circle cx="{ox:.1f}" cy="{oy:.1f}" r="{rr:.1f}" fill="none" '
                         f'stroke="{INK}" stroke-width="{sw_:.1f}"/>')
                k = rr * 0.707
                for sx_, sy_ in ((-k, -k), (-k, k)):
                    o.append(f'<line x1="{ox + sx_:.1f}" y1="{oy + sy_:.1f}" '
                             f'x2="{ox - sx_:.1f}" y2="{oy - sy_:.1f}" stroke="{INK}" '
                             f'stroke-width="{sw_*0.8:.1f}"/>')
                wire(ox + rr, ox + half)
            elif glyph == "switch":
                wire(ox - half, ox - half * 0.42)
                o.append(f'<line x1="{ox - half*0.42:.1f}" y1="{oy:.1f}" '
                         f'x2="{ox + half*0.34:.1f}" y2="{oy - half*0.62:.1f}" '
                         f'stroke="{INK}" stroke-width="{sw_:.1f}" stroke-linecap="round"/>')
                for dx_ in (-half * 0.42, half * 0.42):
                    o.append(f'<circle cx="{ox + dx_:.1f}" cy="{oy:.1f}" r="{sw_*1.1:.1f}" '
                             f'fill="{INK}"/>')
                wire(ox + half * 0.42, ox + half)
            elif glyph == "meter":
                rr = half * 0.52
                wire(ox - half, ox - rr)
                o.append(f'<circle cx="{ox:.1f}" cy="{oy:.1f}" r="{rr:.1f}" fill="none" '
                         f'stroke="{INK}" stroke-width="{sw_:.1f}"/>')
                o.append(f'<text x="{ox:.1f}" y="{oy + FM*0.36:.1f}" text-anchor="middle" '
                         f'font-size="{FM:.1f}" fill="{INK}">{esc(c.get("letter", ""))}</text>')
                wire(ox + rr, ox + half)
            if c["variable"]:
                # The entry's own definition: the standard symbol with a
                # diagonal strikethrough arrow across it.
                x1_, y1_ = ox - half * 0.78, oy + half * 0.86
                x2_, y2_ = ox + half * 0.78, oy - half * 0.86
                o.append(f'<line x1="{x1_:.1f}" y1="{y1_:.1f}" x2="{x2_:.1f}" y2="{y2_:.1f}" '
                         f'stroke="{INK}" stroke-width="{sw_:.1f}"/>')
                ang = math.atan2(y2_ - y1_, x2_ - x1_)
                hd = half * 0.30
                o.append(f'<path d="M {x2_:.1f},{y2_:.1f} '
                         f'L {x2_ - hd*math.cos(ang-0.45):.1f},{y2_ - hd*math.sin(ang-0.45):.1f} '
                         f'L {x2_ - hd*math.cos(ang+0.45):.1f},{y2_ - hd*math.sin(ang+0.45):.1f} Z" '
                         f'fill="{INK}"/>')
            for li, ltxt in enumerate(wrap(c["label"], max(10, int(cw_ / (FM * 0.52))))):
                o.append(f'<text x="{ox:.1f}" y="{T + r_*chh_ + chh_*0.80 + li*FM*1.15:.1f}" '
                         f'text-anchor="middle" font-size="{FM*0.95:.1f}" fill="{INK}">'
                         f'{esc(ltxt)}</text>')
        if g.get("unit_note") and SHOW_ANN:
            o.append(f'<text x="{L:.1f}" y="{T + ph + FO*1.4:.1f}" font-size="{FO:.1f}" '
                     f'fill="{GRAY}">{esc(g["unit_note"])}</text>')
    # electric field / equipotential maps
    if g.get("fm_charges") is not None and (g.get("fm_lines") or g.get("fm_vectors")
                                            or g.get("fm_isolines")):
        side = min(pw, ph)
        bx = L + (pw - side) / 2
        by = T + (ph - side) / 2
        o.append(f'<rect x="{bx:.1f}" y="{by:.1f}" width="{side:.1f}" height="{side:.1f}" '
                 f'fill="{BG}" stroke="{GRID}" stroke-width="1.2"/>')
        fx = lambda u: bx + u * side
        fy = lambda v: by + v * side
        for iso in g.get("fm_isolines", []):
            o.append(f'<circle cx="{fx(iso["cx"]):.1f}" cy="{fy(iso["cy"]):.1f}" '
                     f'r="{iso["r"]*side:.1f}" fill="none" stroke="{GRAY}" '
                     f'stroke-width="1.1" stroke-dasharray="5 4"/>')
        for pts in g.get("fm_lines", []):
            d = "M " + " L ".join(f"{fx(x):.1f},{fy(y):.1f}" for x, y in pts)
            o.append(f'<path d="{d}" fill="none" stroke="{GRAY}" stroke-width="{SW*0.72:.1f}"/>')
            # One arrowhead per line, at its midpoint, so direction is readable
            # without an arrow every few units turning the map into hatching.
            mi = len(pts) // 2
            if mi > 1:
                (x0_, y0_), (x1_, y1_) = pts[mi - 1], pts[mi]
                ang = math.atan2(fy(y1_) - fy(y0_), fx(x1_) - fx(x0_))
                hx, hy = fx(x1_), fy(y1_)
                hd = max(4.0, side * 0.022)
                o.append(f'<path d="M {hx:.1f},{hy:.1f} '
                         f'L {hx - hd*math.cos(ang - 0.42):.1f},{hy - hd*math.sin(ang - 0.42):.1f} '
                         f'L {hx - hd*math.cos(ang + 0.42):.1f},{hy - hd*math.sin(ang + 0.42):.1f} Z" '
                         f'fill="{GRAY}"/>')
        vmax = max((v["mag"] for v in g.get("fm_vectors", [])), default=1.0)
        for v in g.get("fm_vectors", []):
            ln = side * 0.052 * (0.45 + 0.55 * min(1.0, (v["mag"] / vmax) ** 0.4))
            x0_, y0_ = fx(v["x"]), fy(v["y"])
            x1_, y1_ = x0_ + v["ux"] * ln, y0_ + v["uy"] * ln
            o.append(f'<line x1="{x0_:.1f}" y1="{y0_:.1f}" x2="{x1_:.1f}" y2="{y1_:.1f}" '
                     f'stroke="{INK}" stroke-width="{SW*0.8:.1f}"/>')
            hd = max(3.0, ln * 0.34)
            ang = math.atan2(v["uy"], v["ux"])
            o.append(f'<path d="M {x1_:.1f},{y1_:.1f} '
                     f'L {x1_ - hd*math.cos(ang - 0.45):.1f},{y1_ - hd*math.sin(ang - 0.45):.1f} '
                     f'L {x1_ - hd*math.cos(ang + 0.45):.1f},{y1_ - hd*math.sin(ang + 0.45):.1f} Z" '
                     f'fill="{INK}"/>')
        for c in g["fm_charges"]:
            r = max(5.0, side * 0.038)
            o.append(f'<circle cx="{fx(c["x"]):.1f}" cy="{fy(c["y"]):.1f}" r="{r:.1f}" '
                     f'fill="{BG}" stroke="{INK}" stroke-width="1.6"/>')
            sign = "+" if c["q"] > 0 else MINUS
            o.append(f'<text x="{fx(c["x"]):.1f}" y="{fy(c["y"]) + r*0.42:.1f}" '
                     f'text-anchor="middle" font-size="{r*1.35:.1f}" fill="{INK}">'
                     f'{sign}</text>')
        if g.get("unit_note") and SHOW_ANN:
            o.append(f'<text x="{L:.1f}" y="{T + ph + FO*1.4:.1f}" font-size="{FO:.1f}" '
                     f'fill="{GRAY}">{esc(g["unit_note"])}</text>')
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
        if s["label"]:
            # Adjacent peaks sit about 58 units apart, so a full "25Mg 10.00%"
            # overprints its neighbour at compact. Dropping the label there
            # leaves a spectrum of unidentified sticks, which is worse: compact
            # keeps the isotope and the value stays readable off the y axis.
            # The app's renderer already did this; the parity check found that
            # this one did not.
            lbl = s["label"] if SHOW_ANN else s["label"].split(" ")[0]
            o.append(f'<text x="{sx(s["x"]):.1f}" y="{sy(s["y"])-10:.1f}" text-anchor="middle" '
                     f'font-size="{FM}" fill="{INK}">{esc(lbl)}</text>')
    # curves
    for c in g["curves"]:
        d = "M " + " L ".join(f'{sx(x):.1f},{sy(y):.1f}' for x, y in c["pts"])
        dash = ' stroke-dasharray="11 6"' if c["style"] == "dashed" else ""
        o.append(f'<path d="{d}" fill="none" stroke="{c["color"]}" stroke-width="{SW}" stroke-linecap="round"{dash}/>')
    # open circles: a point the graph does NOT take, such as a hole. Painted
    # AFTER the curves on purpose -- before them the curve's stroke runs
    # straight through the white interior, and the gap the circle is there to
    # show disappears.
    for d in g.get("open_dots", []):
        o.append(f'<circle cx="{sx(d["x"]):.1f}" cy="{sy(d["y"]):.1f}" r="{max(3.4, SW*2.2):.1f}" '
                 f'fill="{BG}" stroke="{INK}" stroke-width="{max(1.4, SW*0.8):.1f}"/>')
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
            # One decimal, like every other coordinate in this file. It used to
            # print the raw value, so a y that happened to be an int rendered
            # as "116" here and "116.0" three lines above -- which the parity
            # check against the app's renderer reported as a difference.
            o.append(f'<text x="{xx:.1f}" y="{yy:.1f}" font-size="{fsz:.1f}"{extra}{anc} fill="{col}">{esc(txt)}</text>')
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
