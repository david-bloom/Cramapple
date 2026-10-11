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
                 "annotations": False, "stroke": 2.0},
    "full":     {"W": 680, "H": 440, "L": 84, "R": 44, "T": 76, "B": 92,
                 "f": {"title": 17, "sub": 12, "axis": 12, "tick": 10.5, "ann": 11,
                       "mark": 11, "legend": 11, "note": 10, "flag": 9.5},
                 "annotations": True, "stroke": 2.3},
    "expanded": {"W": 980, "H": 620, "L": 112, "R": 60, "T": 104, "B": 128,
                 "f": {"title": 20, "sub": 12.5, "axis": 12.5, "tick": 10.5, "ann": 11.5,
                       "mark": 11.5, "legend": 11.5, "note": 10.5, "flag": 10},
                 "annotations": True, "stroke": 2.6},
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
    for m in p["markers"]:
        vlines.append({"x": m["x"], "label": m["label"], "caption": m.get("caption", "")})
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


FAMILIES: dict[str, Callable[[dict], dict]] = {
    "mb_distribution": f_mb_distribution,
    "energy_profile": f_energy_profile,
    "stick_spectrum": f_stick_spectrum,
    "pe_vs_distance": f_pe_vs_distance,
    "approach_equilibrium": f_approach_equilibrium,
    "titration_curve": f_titration_curve,
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
            o.append(f'<text x="{sx(s["x"]):.1f}" y="{sy(s["y"])-10:.1f}" text-anchor="middle" '
                     f'font-size="{FM}" fill="{INK}">{esc(s["label"])}</text>')
    # curves
    for c in g["curves"]:
        d = "M " + " L ".join(f'{sx(x):.1f},{sy(y):.1f}' for x, y in c["pts"])
        dash = ' stroke-dasharray="11 6"' if c["style"] == "dashed" else ""
        o.append(f'<path d="{d}" fill="none" stroke="{c["color"]}" stroke-width="{SW}" stroke-linecap="round"{dash}/>')
    # vertical markers
    for v in g.get("vlines", []):
        o.append(f'<line x1="{sx(v["x"]):.1f}" y1="{T}" x2="{sx(v["x"]):.1f}" y2="{sy(y0):.1f}" '
                 f'stroke="{INK}" stroke-width="1.2" stroke-dasharray="3 4"/>')
        if v.get("label"):
            o.append(f'<text x="{sx(v["x"])+8:.1f}" y="{T+22}" font-size="{FN*1.45:.1f}" font-style="italic" fill="{INK}">{esc(v["label"])}</text>')
        if v.get("caption"):
            o.append(f'<text x="{sx(v["x"])+8:.1f}" y="{T+40}" font-size="{FN}" fill="{GRAY}">{esc(v["caption"])}</text>')
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
    o += [
        f'<line x1="{L}" y1="{T}" x2="{L}" y2="{sy(y0):.1f}" stroke="{INK}" stroke-width="1.2"/>',
        f'<line x1="{L}" y1="{sy(y0):.1f}" x2="{L+pw}" y2="{sy(y0):.1f}" stroke="{INK}" stroke-width="1.2"/>',
        f'<text x="{L+pw/2:.1f}" y="{sy(y0)+(54 if SHOW_ANN else 40):.1f}" text-anchor="middle" font-size="{FA}" font-weight="700" '
        f'fill="{INK}" letter-spacing="0.08em">{esc(spec["x_label"].upper())}</text>',
        f'<text transform="translate({L-46},{T+ph/2:.1f}) rotate(-90)" text-anchor="middle" font-size="{FA}" '
        f'font-weight="700" fill="{INK}" letter-spacing="0.08em">{esc(spec["y_label"].upper())}</text>',
    ]
    if not g.get("hide_y_ticks"):
        for y in g.get("y_ticks") or nice_ticks(y0, y1):
            lbl = spec.get("y_tick_fmt", "{:.0f}").format(y)
            o.append(f'<line x1="{L-5}" y1="{sy(y):.1f}" x2="{L}" y2="{sy(y):.1f}" stroke="{GRAY}" stroke-width="0.9"/>')
            o.append(f'<text x="{L-10}" y="{sy(y)+4:.1f}" text-anchor="end" font-size="{FK}" fill="{GRAY}">{lbl}</text>')
    # x ticks: plain values, or (position, label) pairs when the axis is transformed
    for tk in (g["x_ticks"] if "x_ticks" in g else nice_ticks(x0, x1)):
        pos, lbl = tk if isinstance(tk, (tuple, list)) else (tk, spec.get("x_tick_fmt", "{:.0f}").format(tk))
        o.append(f'<line x1="{sx(pos):.1f}" y1="{sy(y0):.1f}" x2="{sx(pos):.1f}" y2="{sy(y0)+5:.1f}" stroke="{GRAY}" stroke-width="0.9"/>')
        o.append(f'<text x="{sx(pos):.1f}" y="{sy(y0)+22:.1f}" text-anchor="middle" font-size="{FK}" fill="{GRAY}">{esc(lbl)}</text>')
    # furniture
    o += [
        *[f'<text x="{L}" y="{(T-58 if FS else T-46) + i * (FT + 3):.1f}" font-size="{FT}" font-weight="700" '
          f'fill="{INK}" letter-spacing="0.03em">{esc(ln)}</text>'
          for i, ln in enumerate(wrap(spec.get("short_title", spec["title"]).upper(),
                                      26 if not SHOW_ANN else 60))],
    ]
    if FS:
        o.append(f'<text x="{L}" y="{T-34}" font-size="{FS}" fill="{GRAY}">{esc(spec["subtitle"])}</text>')
    if FG:
        o.append(f'<text x="{W-R}" y="{T-58}" text-anchor="end" font-size="{FG}" font-weight="700" '
                 f'fill="{GRAY}" letter-spacing="0.1em">{"ILLUSTRATIVE" if spec.get("synthetic") else "FROM DATA"}</text>')
    if spec.get("note") and FO:
        o.append(f'<text x="{W-R}" y="{H-16}" text-anchor="end" font-size="{FO}" fill="{GRAY}">{esc(spec["note"])}</text>')
    for i, (lbl, style) in enumerate(g.get("legend", [])):
        ox, ly = L + i * (230 if SHOW_ANN else 148), H - (46 if SHOW_ANN else 12)
        dash = ' stroke-dasharray="11 6"' if style == "dashed" else ""
        col = GRAY if style == "dashed" else INK
        o.append(f'<line x1="{ox}" y1="{ly-4}" x2="{ox+(34 if SHOW_ANN else 22)}" y2="{ly-4}" stroke="{col}" stroke-width="{SW}"{dash}/>')
        o.append(f'<text x="{ox+(44 if SHOW_ANN else 28)}" y="{ly}" font-size="{FL}" fill="{INK}">{esc(lbl)}</text>')
    o.append("</svg>")
    return "\n".join(o)
