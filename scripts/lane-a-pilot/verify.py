"""Lane A pilot: render every spec, assert domain properties, measure.

Run:  python3 -I scripts/lane-a-pilot/verify.py [--entries <entries.json>]

Three kinds of check:
  1. Domain properties  - chemistry/maths facts a wrong chart violates.
  2. Label coverage     - every items[] label on the authored entry is visible.
  3. Determinism        - the same spec renders byte-identical output.

Exit code 1 if any check fails. Timings are written to out/results.json.
"""
from __future__ import annotations

import argparse, hashlib, json, math, os, re, sys, time

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import render as R  # noqa: E402
import export_figures as X  # noqa: E402
import build_clipboard_test as C  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "out")

fails: list[str] = []
checks = 0


def ekey(subject: str | None, title: str) -> str:
    """Entries are identified by SUBJECT AND TITLE, never by title alone.

    Two published entries are both called "Vector arrow representation" -- AP
    Physics 1 1.1 and AP Physics C Mechanics 1.1 -- so a title-only key drops
    one of them and silently asserts the survivor's items[] for both. The same
    concept authored twice in sibling subjects is the norm in this corpus, not
    an accident, so the composite key is the right one everywhere.
    """
    return f"{subject}::{title}"


def ck(spec_id: str, name: str, ok: bool, detail: str = "") -> None:
    global checks
    checks += 1
    if not ok:
        fails.append(f"{spec_id}: {name}" + (f" — {detail}" if detail else ""))


def integrate(f, a, b, n=20000):
    h = (b - a) / n
    return sum(f(a + (i + 0.5) * h) for i in range(n)) * h


# ------------------------------------------------------------- properties ---
def p_mb(sid, s, svg):
    p = s["params"]
    for ser in p["series"]:
        th = ser["theta"]
        xs = [i * 0.001 for i in range(1, 20001)]
        mode = max(xs, key=lambda x: R.mb_density(x, th))
        ck(sid, f"MB mode at theta/2 ({ser['label']})", abs(mode - th / 2) < 0.02,
           f"mode={mode:.3f} expected={th/2:.3f}  (the SPEED distribution peaks elsewhere)")
        area = integrate(lambda E: R.mb_density(E, th), 1e-9, th * 60)
        ck(sid, f"MB normalised to 1 ({ser['label']})", abs(area - 1) < 0.01, f"integral={area:.4f}")
    # A qualitative distribution has no marker at all (AP Physics 2 teaches the
    # shape, not an activation energy), so the tail comparisons are made about
    # the shared mode instead when there is nothing marked.
    marks = p.get("markers", [])
    ea0 = marks[0]["x"] if marks else max(ser["theta"] for ser in p["series"]) / 2
    ck(sid, "a marker, if drawn, is inside the plotted energy range",
       all(0 < m["x"] < p["x_max"] for m in marks))
    if len(p["series"]) > 1:
        tails = [(ser["theta"], integrate(lambda E, t=ser["theta"]: R.mb_density(E, t), ea0, ea0 + 60 * ser["theta"]))
                 for ser in p["series"]]
        tails.sort()
        ck(sid, "hotter -> larger fraction in the high-energy tail",
           all(tails[i][1] < tails[i + 1][1] for i in range(len(tails) - 1)),
           f"tails={[round(t,4) for _,t in tails]}")
    if len(marks) > 1:
        th = p["series"][0]["theta"]
        xs_m = sorted(m["x"] for m in marks)
        t_lo = integrate(lambda E: R.mb_density(E, th), xs_m[0], xs_m[0] + 60 * th)
        t_hi = integrate(lambda E: R.mb_density(E, th), xs_m[-1], xs_m[-1] + 60 * th)
        ck(sid, "lower Ea -> larger fraction (catalysis)", t_lo > t_hi, f"{t_lo:.4f} vs {t_hi:.4f}")
        ck(sid, "catalyst does not change the curve", len(p["series"]) == 1,
           "a catalysis diagram must keep one temperature curve")


def p_energy_profile(sid, s, svg):
    n = s["params"]["nodes"]
    e = [x["e"] for x in n]
    for i, node in enumerate(n):
        if node.get("kind") == "ts":
            ck(sid, f"transition state {i} is a local maximum",
               e[i] > e[i - 1] and e[i] > e[i + 1], f"{e[i-1]} / {e[i]} / {e[i+1]}")
        elif 0 < i < len(n) - 1:
            ck(sid, f"intermediate {i} is a local minimum",
               e[i] < e[i - 1] and e[i] < e[i + 1], f"{e[i-1]} / {e[i]} / {e[i+1]}")
    ts = [i for i, x in enumerate(n) if x.get("kind") == "ts"]
    for i in ts:
        ck(sid, f"Ea positive at step {i}", e[i] - e[i - 1] > 0)
    if len(ts) > 1:
        bars = [(e[i] - e[i - 1], i) for i in ts]
        ck(sid, "rate-determining step is the largest barrier",
           max(bars)[0] > sorted(bars)[-2][0], f"barriers={[b for b, _ in bars]}")
    for a in s["params"].get("arrows", []):
        if "overall" in a["label"]:
            ck(sid, "overall change spans reactants to products",
               a["from"] == 0 and a["to"] == len(n) - 1)
    exo = e[-1] < e[0]
    ck(sid, "alt text matches the direction of change",
       ("exotherm" in s["alt"].lower()) == exo, f"products {'below' if exo else 'above'} reactants")


def p_stick(sid, s, svg):
    p = s["params"]
    hs = [pk["y"] for pk in p["peaks"]]
    if "expected_average_mass" in p:
        ck(sid, "abundances sum to 100%", abs(sum(hs) - 100) < 0.05, f"sum={sum(hs)}")
        avg = sum(pk["exact_mass"] * pk["y"] / 100 for pk in p["peaks"])
        ck(sid, "weighted average mass matches the element",
           abs(avg - p["expected_average_mass"]) < 0.01, f"computed={avg:.4f} expected={p['expected_average_mass']}")
    if "atomic_number" in p:
        ck(sid, "peak heights sum to the electron count",
           abs(sum(hs) - p["atomic_number"]) < 1e-9, f"sum={sum(hs)} Z={p['atomic_number']}")
        order = [pk["x"] for pk in p["peaks"]]
        ck(sid, "core subshell has the highest binding energy",
           order == sorted(order, reverse=True), f"energies={order}")
        ck(sid, "PES axis decreases to the right", p.get("x_reversed") is True)


def p_pe(sid, s, svg):
    p = s["params"]
    for ser in p["series"]:
        de, re_, a = ser["de"], ser["re"], ser["a"]
        ck(sid, f"minimum at re ({ser['label']})", abs(R.morse(re_, de, re_, a) + de) < 1e-9)
        xs = [re_ * 0.6 + i * (re_ * 1.4) / 400 for i in range(401)]
        lo = min(xs, key=lambda r: R.morse(r, de, re_, a))
        ck(sid, f"re is the global minimum ({ser['label']})", abs(lo - re_) < 1.0, f"found {lo:.1f} vs {re_}")
        ck(sid, f"energy -> 0 at large separation ({ser['label']})",
           abs(R.morse(re_ * 20, de, re_, a)) < de * 0.01)
        ck(sid, f"energy rises steeply at short range ({ser['label']})",
           R.morse(re_ * 0.45, de, re_, a) > de * 0.3)
    if len(p["series"]) > 1:
        by_de = sorted(p["series"], key=lambda x: x["de"])
        ck(sid, "higher bond order -> shorter bond and deeper well",
           all(by_de[i]["re"] > by_de[i + 1]["re"] for i in range(len(by_de) - 1)),
           f"{[(x['label'], x['re'], x['de']) for x in by_de]}")


def p_equilibrium(sid, s, svg):
    p = s["params"]
    for ser in p["series"]:
        s0, sinf, k, t1 = ser["start"], ser["end"], p["k"], p["t_max"]
        f = lambda t: sinf + (s0 - sinf) * math.exp(-k * t)
        ck(sid, f"{ser['label']} is monotonic", all(
            (f(i * t1 / 200) - f((i + 1) * t1 / 200)) * (s0 - sinf) >= -1e-12 for i in range(200)))
        ck(sid, f"{ser['label']} levels off", abs(f(t1) - sinf) < abs(s0 - sinf) * 0.02 + 1e-9,
           f"end={f(t1):.4f} target={sinf}")
    if p.get("conserve", True):
        tot0 = sum(x["start"] for x in p["series"])
        totinf = sum(x["end"] for x in p["series"])
        ck(sid, "no matter appears or vanishes", abs(tot0 - totinf) < 1e-9, f"{tot0} -> {totinf}")
    else:
        ends = [x["end"] for x in p["series"]]
        ck(sid, "forward and reverse rates become equal",
           max(ends) - min(ends) < 1e-9, f"ends={ends}")


def p_titration(sid, s, svg):
    p = s["params"]
    ph = lambda v: R.titration_ph(v, p["v_eq"], p["pka"], p["c"], p["strong"])
    half = p["v_eq"] / 2
    ck(sid, "pH = pKa at the half-equivalence point", abs(ph(half) - p["pka"]) < 1e-9,
       f"pH({half})={ph(half):.4f} pKa={p['pka']}")
    ck(sid, "equivalence point is basic for a weak acid",
       ph(p["v_eq"]) > 7.0 if not p["strong"] else abs(ph(p["v_eq"]) - 7) < 1e-9, f"pH={ph(p['v_eq']):.2f}")
    vs = [i * p["v_max"] / 500 for i in range(1, 501)]
    ck(sid, "pH increases monotonically", all(ph(vs[i]) <= ph(vs[i + 1]) + 1e-9 for i in range(len(vs) - 1)))
    ck(sid, "pH stays inside 0-14", all(0 <= ph(v) <= 14 for v in vs))
    ck(sid, "half-equivalence precedes equivalence", half < p["v_eq"])


def p_categorical_bars(sid, s, svg):
    """The distinctions between these displays ARE the teaching points.

    A bar chart whose bars touch is a histogram, and a histogram whose bars are
    separated says the variable is categorical. A segmented bar chart and a
    mosaic plot differ in exactly one way, the bar widths. So each of those is
    asserted rather than trusted to the drawing code.
    """
    p = s["params"]
    g = R.FAMILIES["categorical_bars"](p)
    bars = g["bars"]
    mode = p["mode"]

    if mode == "bar":
        ck(sid, "one bar per category", len(bars) == len(p["categories"]))
        gaps = [bars[i + 1]["x0"] - bars[i]["x1"] for i in range(len(bars) - 1)]
        ck(sid, "bars are SEPARATED: the variable is categorical",
           all(gp > 1e-9 for gp in gaps), f"gaps={gaps}")
        ck(sid, "bar heights are the frequencies",
           [b["y1"] for b in bars] == list(p["counts"]))
        ck(sid, "every bar starts at zero", all(b["y0"] == 0 for b in bars))

    elif mode == "histogram":
        edges, counts = p["bin_edges"], p["counts"]
        ck(sid, "one bar per bin", len(bars) == len(counts))
        gaps = [abs(bars[i + 1]["x0"] - bars[i]["x1"]) for i in range(len(bars) - 1)]
        ck(sid, "bars are CONTIGUOUS: the variable is quantitative",
           all(gp < 1e-9 for gp in gaps), f"gaps={gaps}")
        ck(sid, "bins are in increasing order",
           all(edges[i + 1] > edges[i] for i in range(len(edges) - 1)))
        ck(sid, "bar heights are the bin frequencies",
           [b["y1"] for b in bars] == list(counts))
        widths = [round(edges[i + 1] - edges[i], 9) for i in range(len(counts))]
        ck(sid, "equal bin widths, so height alone carries frequency",
           len(set(widths)) == 1, f"widths={widths}")
        if "measure" in p:
            m, w = g["xmeasure"], widths[0]
            ck(sid, "the bin-width annotation spans exactly one bin",
               abs((m["x1"] - m["x0"]) - w) < 1e-9)
            ck(sid, "the bin-width annotation sits inside the plot",
               g["y_range"][0] <= m["y"] <= g["y_range"][1])

    elif mode == "grouped":
        levels, table = p["levels"], p["table"]
        ck(sid, "one bar per category and level",
           len(bars) == len(levels) * len(p["categories"]))
        ck(sid, "bar heights are the table counts",
           sorted(b["y1"] for b in bars) == sorted(v for row in table for v in row))
        # Bars pair up inside a category and the categories stay apart.
        k = len(levels)
        groups = [bars[i * k:(i + 1) * k] for i in range(len(p["categories"]))]
        ck(sid, "a gap separates the categories",
           all(groups[i + 1][0]["x0"] - groups[i][-1]["x1"] > 1e-9 for i in range(len(groups) - 1)))

    elif mode in ("segmented", "mosaic"):
        levels, table = p["levels"], p["table"]
        cats = p["categories"]
        totals = [sum(table[j][i] for j in range(len(levels))) for i in range(len(cats))]
        grand = sum(totals)
        per_cat = [bars[i * len(levels):(i + 1) * len(levels)] for i in range(len(cats))]
        for i, col in enumerate(per_cat):
            ck(sid, f"segments of {cats[i]} fill the bar exactly",
               abs(col[-1]["y1"] - 1.0) < 1e-9 and abs(col[0]["y0"]) < 1e-9,
               f"top={col[-1]['y1']}")
            ck(sid, f"segment heights are the conditional proportions ({cats[i]})",
               all(abs((col[j]["y1"] - col[j]["y0"]) - table[j][i] / totals[i]) < 1e-9
                   for j in range(len(levels))))
            ck(sid, f"segments stack without gap or overlap ({cats[i]})",
               all(abs(col[j + 1]["y0"] - col[j]["y1"]) < 1e-9 for j in range(len(col) - 1)))
        widths = [round(col[0]["x1"] - col[0]["x0"], 9) for col in per_cat]
        if mode == "mosaic":
            # The one thing that makes it a mosaic and not a segmented chart.
            ck(sid, "bar WIDTHS are proportional to the category totals",
               all(abs(widths[i] / sum(widths) - totals[i] / grand) < 1e-6 for i in range(len(cats))),
               f"widths={widths} totals={totals}")
            ck(sid, "widths actually differ, so the plot is not a segmented chart in disguise",
               len(set(widths)) > 1, f"widths={widths}")
        else:
            ck(sid, "bar widths are EQUAL: a segmented chart hides category size",
               max(widths) - min(widths) < 1e-9, f"widths={widths}")


def p_pie(sid, s, svg):
    p = s["params"]
    g = R.FAMILIES["pie_chart"](p)
    w = g["wedges"]
    ck(sid, "one slice per category", len(w) == len(p["categories"]))
    ck(sid, "slices sum to exactly 360 degrees",
       abs(sum(x["sweep"] for x in w) - 360.0) < 1e-9, f"sum={sum(x['sweep'] for x in w)}")
    ck(sid, "all slices together are 100% of the area",
       abs(sum(x["frac"] for x in w) - 1.0) < 1e-12)
    total = sum(p["counts"])
    ck(sid, "each slice's angle is its relative frequency",
       all(abs(x["sweep"] / 360.0 - c / total) < 1e-12 for x, c in zip(w, p["counts"])))
    ck(sid, "slices do not overlap and leave no gap",
       all(abs(w[i + 1]["start"] - (w[i]["start"] + w[i]["sweep"])) < 1e-9 for i in range(len(w) - 1)))


def p_dotplot(sid, s, svg):
    p = s["params"]
    g = R.FAMILIES["dotplot"](p)
    vals = p["values"]
    ck(sid, "one dot per observation", len(g["dots"]) == len(vals), f"{len(g['dots'])} vs {len(vals)}")
    ck(sid, "a dot's position is its value",
       sorted(d["x"] for d in g["dots"]) == sorted(vals))
    for v in set(vals):
        col = [d for d in g["dots"] if d["x"] == v]
        ck(sid, f"stack at {v} is as tall as the count",
           max(d["y"] for d in col) == vals.count(v))
        ck(sid, f"stack at {v} has no gap", sorted(d["y"] for d in col) == list(range(1, len(col) + 1)))
    ck(sid, "every dot is inside the plot",
       all(g["x_range"][0] <= d["x"] <= g["x_range"][1] and g["y_range"][0] <= d["y"] <= g["y_range"][1]
           for d in g["dots"]))


def p_stem_leaf(sid, s, svg):
    p = s["params"]
    g = R.FAMILIES["stem_leaf"](p)
    div = p.get("stem_div", 10)
    rows = g["rows"]
    ck(sid, "every leaf is a single digit",
       all(0 <= l < div for _, leaves in rows for l in leaves))
    ck(sid, "stems are in order", [st for st, _ in rows] == sorted(st for st, _ in rows))
    ck(sid, "leaves are in order within each stem",
       all(leaves == sorted(leaves) for _, leaves in rows))
    rebuilt = sorted(st * div + l for st, leaves in rows for l in leaves)
    ck(sid, "the plot reconstructs the data exactly", rebuilt == sorted(p["values"]),
       f"rebuilt={rebuilt}")
    ck(sid, "no stem is skipped, so gaps in the data stay visible",
       [st for st, _ in rows] == list(range(rows[0][0], rows[-1][0] + 1)))
    ck(sid, "a key is present: without it 52 cannot be told from 5.2", bool(p.get("key", "").strip()))


def p_boxplot(sid, s, svg):
    p = s["params"]
    g = R.FAMILIES["boxplot"](p)
    b, f = g["boxes"][0], g["summary"]
    vals = sorted(p["values"])
    ck(sid, "box spans Q1 to Q3", b["q1"] == f["q1"] and b["q3"] == f["q3"] and f["q1"] < f["q3"])
    ck(sid, "median line lies inside the box", f["q1"] <= f["med"] <= f["q3"])
    ck(sid, "quartiles follow the AP halves convention",
       f["q1"] == R.median(vals[:len(vals) // 2]) and
       f["q3"] == R.median(vals[len(vals) // 2 + (len(vals) % 2):]))
    ck(sid, "fences are 1.5 IQR beyond the quartiles",
       abs(f["hi_fence"] - (f["q3"] + 1.5 * f["iqr"])) < 1e-9 and
       abs(f["lo_fence"] - (f["q1"] - 1.5 * f["iqr"])) < 1e-9)
    ck(sid, "outliers are exactly the values beyond a fence",
       f["outliers"] == [v for v in vals if v < f["lo_fence"] or v > f["hi_fence"]])
    # The error the entry's own label exists to prevent.
    ck(sid, "whiskers stop at the extreme NON-outliers, not at the fences",
       f["whisk_hi"] in vals and f["whisk_lo"] in vals and
       f["whisk_hi"] <= f["hi_fence"] and f["whisk_lo"] >= f["lo_fence"],
       f"whiskers={f['whisk_lo']}..{f['whisk_hi']} fences={f['lo_fence']}..{f['hi_fence']}")
    if f["outliers"]:
        ck(sid, "with outliers present the whisker is short of the maximum",
           f["whisk_hi"] < f["max"], f"whisk_hi={f['whisk_hi']} max={f['max']}")
        ck(sid, "every outlier is drawn", len(b["outliers"]) == len(f["outliers"]))
    ck(sid, "the whole glyph is inside the value axis",
       g["x_range"][0] <= f["whisk_lo"] and max([f["whisk_hi"]] + f["outliers"]) <= g["x_range"][1])


def p_xy_series(sid, s, svg):
    """The PV diagram, the loop potential and the residual plot share a family
    but not a science, so each asserts its own facts from the same points."""
    p = s["params"]
    g = R.FAMILIES["xy_series"](p)

    if "pv_const" in p:                       # PV figure 1: the isotherm
        pv = p["pv_const"]
        pts = p["series"][0]["points"]
        ck(sid, "PV is constant along the isotherm",
           all(abs(x * y - pv) < 1e-9 for x, y in pts),
           f"worst={max(abs(x*y-pv) for x, y in pts):.3g}")
        ck(sid, "pressure falls as volume rises",
           all(pts[i + 1][1] < pts[i][1] for i in range(len(pts) - 1)))
        # The shaded area IS the work, so check it against the integral rather
        # than trusting the fill: W = integral of P dV = PV*ln(V2/V1).
        a, b = p["work_interval"]
        exact = pv * math.log(b / a)
        trap = sum((pts[i + 1][0] - pts[i][0]) * (pts[i][1] + pts[i + 1][1]) / 2
                   for i in range(len(pts) - 1))
        ck(sid, "the shaded area equals the work integral", abs(trap - exact) / exact < 2e-4,
           f"shaded={trap:.4f} exact={exact:.4f}")
        ck(sid, "the note says the area is a magnitude, per the entry's caution",
           any(w in (s.get("note") or "").lower() for w in ("magnitude", "absolute")))

    if "work_area_check" in p:                # work as the area under F(x)
        pts = p["series"][0]["points"]
        trap = sum((pts[i + 1][0] - pts[i][0]) * (pts[i][1] + pts[i + 1][1]) / 2
                   for i in range(len(pts) - 1))
        want = p["work_area_check"]
        ck(sid, "the shaded area is the work the note states",
           abs(trap - want) < 1e-9, f"area={trap:.4f} stated={want}")
        ck(sid, "the stated work appears in the figure's own text",
           f"{want:.0f}" in (s.get("note") or "") and f"{want:.0f}" in s["alt"])
        # A force that never goes negative keeps "area = work" honest without
        # the sign discussion the entry does not author.
        ck(sid, "the force stays non-negative, so the area is unsigned",
           all(y >= 0 for _, y in pts))
        ck(sid, "the shaded series is the one actually filled",
           bool(p["series"][0].get("fill_under")))

    if "zero_pressure_check" in p:            # extrapolating P-T back to P = 0
        want = p["zero_pressure_check"]
        meas = [sr for sr in p["series"] if sr["label"] == "measured"][0]["points"]
        # The measured points must be collinear, or "extend the line" is a
        # fiction, and the line they define must hit P = 0 where the figure says.
        (x1, y1), (x2, y2) = meas[0], meas[-1]
        slope = (y2 - y1) / (x2 - x1)
        ck(sid, "the measured points are collinear",
           all(abs(y - (y1 + slope * (x - x1))) < 1e-9 for x, y in meas))
        ck(sid, "pressure rises with temperature", slope > 0)
        root = x1 - y1 / slope
        ck(sid, "the measured line reaches zero pressure at the stated temperature",
           abs(root - want) < 0.01, f"root={root:.3f} stated={want}")
        ext = [sr for sr in p["series"] if sr["label"] == "extended line"][0]["points"]
        ck(sid, "the drawn extension starts exactly at that zero-pressure point",
           abs(ext[0][0] - want) < 1e-9 and abs(ext[0][1]) < 1e-9, f"{ext[0]}")
        ck(sid, "the extension is continuous with the measured line",
           all(abs(y - (y1 + slope * (x - x1))) < 1e-9 for x, y in ext))
        # The whole point of the entry is that the value is NOT measured there.
        ck(sid, "the extension is drawn dashed, not as data",
           [sr for sr in p["series"] if sr["label"] == "extended line"][0]["style"] == "dashed")
        ck(sid, "no measured point lies in the extrapolated region",
           all(x >= 0 for x, _ in meas))

    if "ohmic_check" in p:                    # ohmic vs non-ohmic I-V
        r_ohm = p["ohmic_check"]   # not `R`: that is the render module
        oh = [sr for sr in p["series"] if sr["label"] == "ohmic element"][0]
        non = [sr for sr in p["series"] if sr["label"] == "non-ohmic element"][0]
        ck(sid, "the ohmic line passes through the origin",
           abs(oh["points"][0][0]) < 1e-12 and abs(oh["points"][0][1]) < 1e-12)
        ratios = [v / i for v, i in oh["points"][1:]]
        ck(sid, "the ohmic element has one constant resistance",
           max(ratios) - min(ratios) < 1e-9, f"spread={max(ratios)-min(ratios):.3g}")
        ck(sid, "that constant resistance is the one stated",
           abs(ratios[0] - r_ohm) < 1e-9, f"{ratios[0]} != {r_ohm}")
        # R = 1/slope, not the slope: the figure must say so, because reading
        # the slope AS the resistance is the standard error on this graph.
        slope = oh["points"][-1][1] / oh["points"][-1][0]
        ck(sid, "resistance is one over the slope, and the text says so",
           abs(1 / slope - r_ohm) < 1e-9 and "1/slope" in (s.get("note") or ""),
           f"slope={slope:.4f} 1/slope={1/slope:.3f}")
        nr = [v / i for v, i in non["points"][1:]]
        ck(sid, "the non-ohmic element has no single resistance",
           max(nr) / min(nr) > 1.5, f"ratio spread {min(nr):.2f}..{max(nr):.2f}")
        ck(sid, "the non-ohmic element also starts at the origin",
           abs(non["points"][0][0]) < 1e-12 and abs(non["points"][0][1]) < 1e-12)
        # A reader at gate 4c caught the alt text claiming the non-ohmic curve
        # "climbs away from" the straight line: the gap in fact peaks near 2.5 V
        # and then closes. Assert what the text may claim -- that the curve
        # FLATTENS, so equal steps of potential difference add less current, and
        # that its resistance therefore rises -- not that it diverges.
        npts = non["points"]
        incr = [(npts[i + 1][1] - npts[i][1]) / (npts[i + 1][0] - npts[i][0])
                for i in range(len(npts) - 1)]
        ck(sid, "the non-ohmic curve flattens, as its text says",
           all(incr[i + 1] < incr[i] + 1e-12 for i in range(len(incr) - 1)),
           f"slopes={[round(i,4) for i in incr]}")
        ck(sid, "its resistance rises, so the ratio keeps climbing",
           all(nr[i + 1] > nr[i] for i in range(len(nr) - 1)),
           f"V/I={[round(r,2) for r in nr]}")
        ck(sid, "the text does not claim the two lines keep diverging",
           "climbs away" not in s["alt"] and "diverg" not in s["alt"].lower())

    if "gamma" in p:                          # PV figure 2: the four processes
        gamma, P0, V0 = p["gamma"], p["p0"], p["v0"]
        by = {sr["label"].split(" ")[0]: sr["points"] for sr in p["series"]}
        ck(sid, "isovolumetric is a vertical line",
           len({round(x, 9) for x, _ in by["isovolumetric"]}) == 1)
        ck(sid, "isobaric is a horizontal line",
           len({round(y, 9) for _, y in by["isobaric"]}) == 1)
        ck(sid, "isothermal keeps PV constant",
           all(abs(x * y - P0 * V0) < 1e-9 for x, y in by["isothermal"]))
        ck(sid, "adiabatic keeps PV^gamma constant",
           all(abs(x * y ** 1 * 0 + y * x ** gamma - P0 * V0 ** gamma) < 1e-7
               for x, y in by["adiabatic"]))
        ck(sid, "all four processes start from the same state",
           all(abs(pts[0][0] - V0) < 1e-9 and abs(pts[0][1] - P0) < 1e-9
               for k, pts in by.items() if k != "isovolumetric" or True))
        # The distinguishing fact: through one point the adiabat is steeper.
        iso_slope = -P0 / V0
        adi_slope = -gamma * P0 / V0
        ck(sid, "the adiabat is steeper than the isotherm at the shared point",
           abs(adi_slope) > abs(iso_slope), f"adiabat={adi_slope:.3f} isotherm={iso_slope:.3f}")
        ck(sid, "the adiabat lies below the isotherm as the gas expands",
           all(ya < yi + 1e-12 for (_, ya), (_, yi)
               in zip(by["adiabatic"][1:], by["isothermal"][1:])))

    # Keyed on an explicit params marker, like every other block here. It used
    # to key on "has a zero line and is not the PV figure", which quietly
    # claimed every later zero-line chart -- the work-area and P-T figures both
    # arrived and were asked to obey Kirchhoff's loop rule.
    if "loop_check" in p or p["series"][0].get("kind") == "scatter":
        pts = p["series"][0]["points"]
        if p["series"][0].get("kind") == "scatter":      # residual plot
            xs = [x for x, _ in pts]
            rs = [y for _, y in pts]
            ck(sid, "residuals sum to about zero", abs(sum(rs)) < 0.35 * max(abs(r) for r in rs),
               f"sum={sum(rs):.3f}")
            ck(sid, "residuals fall on both sides of zero",
               any(r > 0 for r in rs) and any(r < 0 for r in rs))
            mx, mr = sum(xs) / len(xs), sum(rs) / len(rs)
            cov = sum((x - mx) * (r - mr) for x, r in zip(xs, rs))
            sx_ = math.sqrt(sum((x - mx) ** 2 for x in xs))
            sr_ = math.sqrt(sum((r - mr) ** 2 for r in rs))
            # "Without pattern" is the entry's own justification for the model,
            # so a trend against x would contradict the figure's whole point.
            ck(sid, "no linear trend in the residuals", abs(cov / (sx_ * sr_)) < 0.25,
               f"r={cov / (sx_ * sr_):.3f}")
            # A strict +,-,+,- alternation is ALSO a pattern, which both model
            # readers caught and this test originally did not: it only looked
            # for a trend. "Without pattern" has to mean more than "no slope".
            runs, cur = [], 1
            for i in range(1, len(rs)):
                if (rs[i] > 0) == (rs[i - 1] > 0):
                    cur += 1
                else:
                    runs.append(cur)
                    cur = 1
            runs.append(cur)
            ck(sid, "signs do not alternate perfectly, which would be a pattern too",
               max(runs) >= 2, f"runs={runs}")
            ck(sid, "no long run of same-sign residuals either", max(runs) <= 3, f"runs={runs}")
            ck(sid, "a zero reference line is drawn", "residual = 0" in svg or "= 0" in svg)
        else:                                            # potential around a loop
            ck(sid, "the loop returns to the potential it started at",
               abs(pts[-1][1] - pts[0][1]) < 1e-9, f"start={pts[0][1]} end={pts[-1][1]}")
            rises = sum(max(0.0, pts[i + 1][1] - pts[i][1]) for i in range(len(pts) - 1))
            drops = sum(max(0.0, pts[i][1] - pts[i + 1][1]) for i in range(len(pts) - 1))
            ck(sid, "rises and drops cancel: Kirchhoff's loop rule",
               abs(rises - drops) < 1e-9, f"rises={rises} drops={drops}")
            ck(sid, "position never goes backwards along the loop",
               all(pts[i + 1][0] >= pts[i][0] for i in range(len(pts) - 1)))
            # Both model readers caught element names sitting under the flat
            # wire rather than under the step they name, so it is a check now.
            steps = [pts[i + 1][0] for i in range(len(pts) - 1)
                     if abs(pts[i + 1][1] - pts[i][1]) > 1e-9]
            named = [x for x, lbl in p.get("x_ticks", []) if lbl.lower() != "end"]
            ck(sid, "each element's tick sits at the step it names",
               all(any(abs(x - sxp) < 1e-6 for sxp in steps) for x in named),
               f"ticks={named} steps={steps}")

    gx0, gx1 = g["x_range"]
    gy0, gy1 = g["y_range"]
    for sr in p["series"]:
        ck(sid, "every plotted point is inside the axes",
           all(gx0 - 1e-9 <= x <= gx1 + 1e-9 and gy0 - 1e-9 <= y <= gy1 + 1e-9
               for x, y in sr["points"]))


def p_kinematic_panels(sid, s, svg):
    """The three panels must be ONE motion. Each authored label is a calculus
    relationship between them, so each is checked numerically rather than
    assumed from having drawn a parabola above a line."""
    p = s["params"]
    g = R.FAMILIES["kinematic_panels"](p)
    x0, v0, a, t1 = p["x0"], p["v0"], p["a"], p["t_max"]
    xf = lambda t: x0 + v0 * t + 0.5 * a * t * t
    vf = lambda t: v0 + a * t
    pan = {q["key"]: q for q in g["panels"]}
    ck(sid, "three panels: x, v and a", set(pan) == {"x", "v", "a"})

    h = 1e-5
    for t in (0.5, 2.0, 3.0, 4.5):
        ck(sid, f"slope of x-t equals v at t={t}",
           abs((xf(t + h) - xf(t - h)) / (2 * h) - vf(t)) < 1e-4)
        ck(sid, f"slope of v-t equals a at t={t}",
           abs((vf(t + h) - vf(t - h)) / (2 * h) - a) < 1e-4)

    t0, t2 = 2.0, 4.0
    n = 20000
    area_v = sum(vf(t0 + (i + 0.5) * (t2 - t0) / n) * (t2 - t0) / n for i in range(n))
    ck(sid, "area under v-t is the displacement", abs(area_v - (xf(t2) - xf(t0))) < 1e-6,
       f"area={area_v:.6f} dx={xf(t2) - xf(t0):.6f}")
    ck(sid, "area under a-t is the change in velocity",
       abs(a * (t2 - t0) - (vf(t2) - vf(t0))) < 1e-9)

    shades = p.get("shades", [])
    ck(sid, "an area is shaded on both the v-t and the a-t panel",
       {sh["panel"] for sh in shades} == {"v", "a"}, f"{[sh['panel'] for sh in shades]}")
    for sh in shades:
        ck(sid, f"the shaded interval on {sh['panel']}-t is inside the time axis",
           0 <= sh["t0"] < sh["t1"] <= t1)
        band = next(q for q in g["panels"] if q["key"] == sh["panel"])
        ck(sid, f"the {sh['panel']}-t panel shows zero, so there is a baseline to shade to",
           band["y_range"][0] <= 0 <= band["y_range"][1], f"range={band['y_range']}")
    # Declared coverage is not rendered coverage: count the shapes, do not
    # trust the spec. Each shade must actually produce a filled region.
    drawn = R.render(s, "expanded").count('fill-opacity="0.6"')
    ck(sid, "every requested area is actually drawn", drawn == len(shades),
       f"drawn={drawn} requested={len(shades)}")
    for an in p.get("annotations", []):
        want = vf(an["t"]) if an["panel"] == "x" else a
        ck(sid, f"the drawn tangent on {an['panel']}-t has the true slope",
           abs(an["slope"] - want) < 1e-9, f"drawn={an['slope']} true={want}")
        # The DRAWN slope, read back off the SVG. The check above compares the
        # spec's number with the maths; this one catches the renderer turning a
        # correct number into a wrong line, which is what an inverted data-to-
        # screen conversion did -- two near-vertical dashes off the canvas.
        lay = R.LAYOUTS["expanded"]
        gg = R.FAMILIES["kinematic_panels"](p)
        pan_i = [q["key"] for q in gg["panels"]].index(an["panel"])
        phh = lay["H"] - lay["T"] - lay["B"]
        gap = phh * 0.07
        bh = (phh - gap * (len(gg["panels"]) - 1)) / len(gg["panels"])
        py0, py1 = gg["panels"][pan_i]["y_range"]
        pww = lay["W"] - lay["L"] - lay["R"]
        want_screen = an["slope"] * (bh / (py1 - py0)) / (pww / p["t_max"])
        dashed = [m.group(1) for m in re.finditer(r'<line([^>]*)/>', R.render(s, "expanded"))
                  if 'stroke-dasharray="6 4"' in m.group(1)]
        got = []
        for at in dashed:
            x1_, y1_, x2_, y2_ = (float(re.search(rf'\b{k}="(-?[\d.]+)"', at).group(1))
                                  for k in ("x1", "y1", "x2", "y2"))
            if abs(x2_ - x1_) > 1e-9:
                got.append(-(y2_ - y1_) / (x2_ - x1_))
        ck(sid, f"the tangent DRAWN on {an['panel']}-t has the true slope on screen",
           any(abs(gv - want_screen) < 0.02 for gv in got),
           f"drawn={[round(v,3) for v in got]} expected={want_screen:.3f}")
        ck(sid, f"the {an['panel']}-t annotation sits on its own curve",
           abs(an["y"] - (xf(an["t"]) if an["panel"] == "x" else vf(an["t"]))) < 1e-9)
    for q in g["panels"]:
        lo, hi = q["y_range"]
        ck(sid, f"the {q['key']} curve stays inside its panel",
           all(lo - 1e-9 <= y <= hi + 1e-9 for _, y in q["pts"]))


def p_arrow_diagram(sid, s, svg):
    """What a wrong arrow diagram violates.

    These are drawing conventions rather than science, but they are no less
    checkable: an arrow twice as long as another claims twice the magnitude
    whether or not its author meant it to.
    """
    p = s["params"]
    g = R.FAMILIES["arrow_diagram"](p)
    vs = g["vectors"]

    ck(sid, "every arrow has a magnitude and a direction", len(vs) >= 2 and
       all(v["magnitude"] > 0 for v in vs))

    if p.get("proportionality_check"):
        # ONE constant of proportionality, which is the entry's own claim.
        # Checked as a ratio between every pair, not against the scale the
        # family computed, or it would only be testing its own arithmetic.
        ks = [v["frac"] / v["magnitude"] for v in vs]
        ck(sid, "one scale for every arrow: length is proportional to magnitude",
           max(ks) - min(ks) < 1e-12, f"scales={[round(k,6) for k in ks]}")
        big = max(vs, key=lambda v: v["magnitude"])
        ck(sid, "the longest arrow is the largest magnitude",
           all(v["frac"] <= big["frac"] + 1e-12 for v in vs))
        # The drawn angle must BE the stated angle: a figure that rounds an
        # arrow to the nearest convenient direction teaches that direction.
        for v, a in zip(vs, p["arrows"]):
            ck(sid, f"the drawn angle for '{v['label']}' is the angle specified",
               abs(v["angle"] - (float(a["angle_deg"]) % 360.0)) < 1e-9)

    if p.get("equilibrium_check"):
        rx = sum(v["magnitude"] * math.cos(math.radians(v["angle"])) for v in vs)
        ry = sum(v["magnitude"] * math.sin(math.radians(v["angle"])) for v in vs)
        mag = max(v["magnitude"] for v in vs)
        ck(sid, "the forces sum to zero, as the figure's text claims",
           abs(rx) < 1e-6 * mag and abs(ry) < 1e-6 * mag,
           f"resultant=({rx:.6f}, {ry:.6f})")
        ck(sid, "the text says the forces balance",
           any(w in (s.get("note") or "").lower() + s["alt"].lower()
               for w in ("add to zero", "equilibrium", "at rest")))

    if p.get("whole_forces_check"):
        # "Whole forces only" is the entry's own labelled part, and the error it
        # forbids is drawing a force AND its components, which counts that force
        # twice. The first version of this check compared an arrow's magnitude
        # against another's projection, and fired on the normal force -- whose
        # magnitude EQUALS the weight's projection whenever the block is in
        # equilibrium across the slope. That is physics, not a drawing error.
        #
        # What a decomposition actually looks like is three arrows drawn
        # together where two perpendicular ones SUM to the third.
        def comp(v):
            return (v["magnitude"] * math.cos(math.radians(v["angle"])),
                    v["magnitude"] * math.sin(math.radians(v["angle"])))
        tol = 1e-6 * max(v["magnitude"] for v in vs)
        bad = []
        for i, a in enumerate(vs):
            for j, b in enumerate(vs):
                if j <= i:
                    continue
                perp = abs(abs(((a["angle"] - b["angle"] + 180) % 360) - 180) - 90) < 1e-6
                if not perp:
                    continue
                ax_, ay_ = comp(a)
                bx_, by_ = comp(b)
                for c in vs:
                    if c is a or c is b:
                        continue
                    cx_, cy_ = comp(c)
                    if abs(ax_ + bx_ - cx_) < tol and abs(ay_ + by_ - cy_) < tol:
                        bad.append(f"{a['label']} + {b['label']} is {c['label']}")
        ck(sid, "whole forces only: no force is drawn beside its own components",
           not bad, "; ".join(sorted(set(bad))[:3]))
        ck(sid, "every arrow starts at the dot", bool(g["dot"]))

    # Same-direction forces must not be drawn on top of each other: that is the
    # entry's labelled part, and it is the one thing an offset of zero breaks.
    groups = {}
    for v in vs:
        groups.setdefault(round(v["angle"], 6), []).append(v)
    for ang, grp in groups.items():
        if len(grp) > 1:
            offs = sorted(v["offset"] for v in grp)
            ck(sid, f"forces at {ang:g} deg are drawn side by side, not overlapping",
               all(offs[i + 1] - offs[i] > 0.5 for i in range(len(offs) - 1)),
               f"offsets={offs}")
    # A reader at gate 4c caught the tension the ENTRY itself authors: "all
    # force arrows originate at the dot" and "same-direction forces are drawn
    # side by side, not overlapping" cannot both hold exactly. The sideways
    # shift is a drafting device, so it is bounded -- an arrow stays visibly
    # anchored to the dot -- and any figure using it must say so in its text
    # rather than claim every arrow starts precisely there.
    if any(v["offset"] for v in vs):
        ck(sid, "a side-by-side shift stays small enough to read as one origin",
           all(abs(v["offset"]) <= 1.0 for v in vs),
           f"offsets={[v['offset'] for v in vs]}")
        ck(sid, "the text explains the sideways shift rather than denying it",
           ("either side" in s["alt"] or "side by side" in s["alt"])
           and "starts at that dot" not in s["alt"],
           "alt must not claim every arrow starts precisely at the dot")


def _on_segment(atom, a, b, tol: float = 0.35) -> bool:
    """Does `atom` sit on the line from a to b, within a fraction of its radius?"""
    ax, ay = a
    bx_, by_ = b
    dx, dy = bx_ - ax, by_ - ay
    L2 = dx * dx + dy * dy
    if L2 < 1e-12:
        return False
    t = ((atom["x"] - ax) * dx + (atom["y"] - ay) * dy) / L2
    if not (0.08 < t < 0.92):
        return False
    px, py = ax + t * dx, ay + t * dy
    return math.hypot(atom["x"] - px, atom["y"] - py) < atom["r"] * tol


def p_particulate_box(sid, s, svg):
    """Counts, ratios and conservation: what a wrong particulate box violates.

    These are the entries' own labelled parts, not decoration. "Atom
    conservation" is a labelled part of the balanced-equation entry, and it is
    exactly machine-checkable once a species knows its atoms.
    """
    p = s["params"]
    g = R.FAMILIES["particulate_box"](p)
    pans = g["panels_pb"]

    ck(sid, "every panel has particles in it", all(pan["particles"] for pan in pans))
    # A bond must join two atoms of the SAME molecule and must not be drawn
    # through a third: water was drawn H-H with the oxygen on the line.
    for pan in pans:
        for d in pan["particles"]:
            for bf in d.get("bonds", []):
                others = [e for e in pan["particles"]
                          if e is not d and e["species"] == d["species"]
                          and math.hypot(e["x"] - bf[0], e["y"] - bf[1]) < 1e-9]
                ck(sid, f"each bond in '{pan['label']}' ends on an atom of its own molecule",
                   bool(others), f"{d['el']} bond ends at {bf}")
                through = [e for e in pan["particles"]
                           if e is not d and e not in others
                           and _on_segment(e, (d["x"], d["y"]), bf)]
                ck(sid, f"no bond in '{pan['label']}' is drawn through another atom",
                   not through, f"{[e['el'] for e in through]} lies on a bond")
    # A particle drawn outside its own box is not in the picture at all.
    for pan in pans:
        out = [d for d in pan["particles"]
               if not (-0.02 <= d["x"] <= 1.02 and -0.02 <= d["y"] <= 1.02)]
        ck(sid, f"every particle in '{pan['label']}' is inside its box", not out,
           f"{len(out)} stray")

    if p.get("atom_conservation_check"):
        # The entry's own labelled part. Counted from the species' declared
        # atoms, so it checks the chemistry rather than the circle count.
        before, after = pans[0]["atoms"], pans[-1]["atoms"]
        ck(sid, "every element is conserved across the arrow", before == after,
           f"before={before} after={after}")
        ck(sid, "the reaction actually rearranges something",
           pans[0]["counts"] != pans[-1]["counts"],
           "reactants and products are the same molecules")
        ck(sid, "no element appears in the products that was not in the reactants",
           set(after) <= set(before))
        for el, n in before.items():
            ck(sid, f"the figure's text states the {el} count", str(n) in (s.get("note") or ""))

    if p.get("phase_check"):
        by = {pan["label"]: pan for pan in pans}
        ck(sid, "all three phases are drawn", set(by) == {"solid", "liquid", "gas"})
        ck(sid, "solid and liquid hold comparable molar volume: the same count in the same box",
           len(by["solid"]["particles"]) == len(by["liquid"]["particles"]),
           f"solid={len(by['solid']['particles'])} liquid={len(by['liquid']['particles'])}")
        ck(sid, "the gas is far sparser than either condensed phase",
           len(by["gas"]["particles"]) * 2 < len(by["solid"]["particles"]),
           f"gas={len(by['gas']['particles'])}")
        ck(sid, "the solid is the regular arrangement and the liquid is not",
           by["solid"]["mode"] == "lattice" and by["liquid"]["mode"] == "close")
        # Spacing, measured rather than asserted: mean nearest-neighbour
        # distance must actually be larger in the gas, or "far apart" is a word
        # in the caption that the drawing does not keep.
        def nn(pan):
            pts = [(d["x"], d["y"]) for d in pan["particles"]]
            return sum(min(math.hypot(a[0] - b[0], a[1] - b[1])
                           for b in pts if b is not a) for a in pts) / len(pts)
        # "Regular" versus "irregular" is the only difference between those two
        # panels, so it is measured rather than asserted by a mode name: the
        # spread of nearest-neighbour distances is near zero in a lattice and
        # must be clearly non-zero in the liquid.
        def disorder(pan):
            pts = [(d["x"], d["y"]) for d in pan["particles"]]
            ds = [min(math.hypot(a[0] - b[0], a[1] - b[1]) for b in pts if b is not a)
                  for a in pts]
            m = sum(ds) / len(ds)
            return (sum((d - m) ** 2 for d in ds) / len(ds)) ** 0.5 / m
        ck(sid, "the solid's arrangement is regular", disorder(by["solid"]) < 0.02,
           f"spread={disorder(by['solid']):.4f}")
        ck(sid, "the liquid's arrangement is visibly irregular, not a lattice",
           disorder(by["liquid"]) > 0.12,
           f"spread={disorder(by['liquid']):.4f} -- too close to a lattice to read as a liquid")
        ck(sid, "gas particles really are further apart than liquid particles",
           nn(by["gas"]) > nn(by["liquid"]) * 1.4,
           f"gas={nn(by['gas']):.3f} liquid={nn(by['liquid']):.3f}")
        # A gas must show no arrangement at all. Stepping evenly through the
        # grid put all five on one diagonal, which reads as a pattern -- so
        # check they are not close to collinear, by the area of the triangle
        # each triple spans relative to the box.
        gp = [(d["x"], d["y"]) for d in by["gas"]["particles"]]
        tri = max(abs((b[0]-a[0])*(c[1]-a[1]) - (c[0]-a[0])*(b[1]-a[1])) / 2
                  for i, a in enumerate(gp) for j, b in enumerate(gp[i+1:], i+1)
                  for c in gp[j+1:])
        ck(sid, "the gas shows no arrangement: its particles are not collinear",
           tri > 0.02, f"largest triangle spans {tri:.4f} of the box")

    if p.get("solution_check"):
        tot = p["solution_check"]["total"]
        for pan in pans:
            ck(sid, f"'{pan['label']}' holds the stated total number of particles",
               sum(pan["counts"].values()) == tot,
               f"{sum(pan['counts'].values())} != {tot}")
        fracs = [pan["counts"].get("solute", 0) / tot for pan in pans]
        ck(sid, "the concentrated solution really is more concentrated",
           fracs[-1] > fracs[0], f"{fracs}")
        ck(sid, "both boxes are equally full, so the ratio is what differs",
           len({sum(pan["counts"].values()) for pan in pans}) == 1)
        # "Dissolved" means surrounded by solvent. Filling the cells in the
        # order the species were listed clumped every solute particle into the
        # top rows -- undissolved solute, in a figure about solutions -- so the
        # nearest neighbour of each solute particle must be solvent.
        for pan in pans:
            sol = [d for d in pan["particles"] if d["species"] == "solute"]
            clumped = []
            for a in sol:
                nearest = min((b for b in pan["particles"] if b is not a),
                              key=lambda b: math.hypot(a["x"] - b["x"], a["y"] - b["y"]))
                if nearest["species"] == "solute":
                    clumped.append(a)
            ck(sid, f"every solute particle in '{pan['label']}' is surrounded by solvent",
               not clumped, f"{len(clumped)} of {len(sol)} sit next to another solute")

    if p.get("equilibrium_k_check"):
        c = p["equilibrium_k_check"]
        eq = pans[c["panel"]]["counts"]
        num, den = eq.get(c["numerator"], 0), eq.get(c["denominator"], 0)
        ck(sid, "some reactant remains at equilibrium, so it is not completion",
           den > 0, "an empty reactant box is a reaction that went to completion")
        ck(sid, "the particle counts at equilibrium give the stated K",
           den > 0 and abs(num / den - c["k"]) < 1e-9,
           f"{num}/{den} != {c['k']}")
        ck(sid, "the total number of particles is unchanged by the reaction",
           sum(pans[0]["counts"].values()) == sum(eq.values()),
           "A becomes B one for one, so the count cannot change")
        ck(sid, "the figure's text shows how K is read off the counts",
           f"{num}/{den}" in (s.get("note") or ""))

    if p.get("same_matter_check"):
        # A reader at gate 4c read the parameters and found species A declared
        # with atoms {"A": 1} and B with {"B": 1}: as data, one element turning
        # into another. A one-for-one conversion has to be the same matter in
        # two forms, and the figure has to say which.
        comps = {json.dumps(sp_["atoms"], sort_keys=True) for sp_ in p["species"].values()}
        ck(sid, "a one-for-one conversion keeps the same matter in both forms",
           len(comps) == 1, f"species declare different compositions: {sorted(comps)}")
        ck(sid, "the text says what kind of change this is",
           "isomer" in (s["subtitle"] + s["caption"] + s["alt"]).lower(),
           "two particle types converting one for one needs naming, or it reads as transmutation")

    if p.get("sea_check"):
        pan = pans[0]
        ck(sid, "the ions are in a regular array", pan["mode"] == "lattice")
        ck(sid, "the ions are drawn as positive",
           all(d.get("symbol") == "+" for d in pan["particles"]))
        ck(sid, "there are more electrons drawn than ions, and they are free",
           len(pan["background"]) > len(pan["particles"]),
           "delocalized electrons must not be one-per-ion, which is what a bond looks like")
        # Delocalized means not attached: no electron may sit on an ion.
        close = [b for b in pan["background"]
                 for d in pan["particles"]
                 if math.hypot(b["x"] - d["x"], b["y"] - d["y"]) < d["r"] * 0.8]
        ck(sid, "no electron is drawn sitting on an ion", not close,
           f"{len(close)} electrons overlap an ion core")


def _seg_cross(a, b, c, d) -> bool:
    def o(p, q, r):
        return (q[1] - p[1]) * (r[0] - q[0]) - (q[0] - p[0]) * (r[1] - q[1])
    o1, o2, o3, o4 = o(a, b, c), o(a, b, d), o(c, d, a), o(c, d, b)
    return (o1 > 0) != (o2 > 0) and (o3 > 0) != (o4 > 0)


def p_field_map(sid, s, svg):
    """The facts a wrong field map violates, taken from the entries' own labels."""
    p = s["params"]
    g = R.FAMILIES["field_map"](p)
    ch = p["charges"]

    for v in g["fm_vectors"]:
        ex, ey = R._fm_field(ch, v["x"], v["y"])
        m = math.hypot(ex, ey)
        ck(sid, "every drawn vector points along the computed field",
           abs(v["ux"] - ex / m) < 1e-9 and abs(v["uy"] - ey / m) < 1e-9)

    if p.get("dipole_check"):
        pos = [c for c in ch if c["q"] > 0]
        neg = [c for c in ch if c["q"] < 0]
        lines = g["fm_lines"]
        ck(sid, "field lines are drawn", len(lines) >= 6)
        # The entry's own labelled part: lines point away from positive and
        # toward negative.
        starts_ok = all(any(math.hypot(L[0][0] - c["x"], L[0][1] - c["y"]) < 0.05 for c in pos)
                        for L in lines)
        ck(sid, "every field line begins on a positive charge", starts_ok)
        ends = [L[-1] for L in lines]
        on_neg = sum(1 for e in ends
                     if any(math.hypot(e[0] - c["x"], e[1] - c["y"]) < 0.06 for c in neg))
        ck(sid, "field lines end on the negative charge", on_neg >= len(lines) * 0.6,
           f"{on_neg} of {len(lines)} reach it; the rest leave the frame")
        # Lines never cross: the field has ONE direction at each point, and a
        # map that crosses is asserting two.
        crossings = 0
        for i in range(len(lines)):
            for j in range(i + 1, len(lines)):
                A, B = lines[i][::6], lines[j][::6]
                for k in range(len(A) - 1):
                    for l in range(len(B) - 1):
                        if _seg_cross(A[k], A[k + 1], B[l], B[l + 1]):
                            crossings += 1
        ck(sid, "no two field lines cross", crossings == 0, f"{crossings} crossings")
        ck(sid, "the figure's text says why they cannot cross",
           "cross" in (s.get("note") or "").lower())
        # Spacing stands for magnitude: the field must be stronger where the
        # lines are closer, which is the claim the picture makes.
        near = [v for v in g["fm_vectors"]
                if min(math.hypot(v["x"] - c["x"], v["y"] - c["y"]) for c in ch) < 0.26]
        far = [v for v in g["fm_vectors"]
               if min(math.hypot(v["x"] - c["x"], v["y"] - c["y"]) for c in ch) > 0.38]
        if near and far:
            ck(sid, "the field really is stronger near the charges",
               min(v["mag"] for v in near) > max(v["mag"] for v in far),
               f"near>={min(v['mag'] for v in near):.3f} far<={max(v['mag'] for v in far):.3f}")

    if p.get("isoline_check"):
        isos = g["fm_isolines"]
        ck(sid, "isolines are drawn", len(isos) >= 3)
        # An isoline is a line of EQUAL potential: sample right round it.
        for iso in isos:
            vs = [R._fm_potential(ch, iso["cx"] + iso["r"] * math.cos(t * math.pi / 8),
                                  iso["cy"] + iso["r"] * math.sin(t * math.pi / 8))
                  for t in range(16)]
            ck(sid, f"potential is constant along the isoline at r={iso['r']}",
               max(vs) - min(vs) < 1e-9, f"spread={max(vs)-min(vs):.3g}")
        rs = [iso["r"] for iso in isos]
        ck(sid, "the isolines are drawn at increasing radius", rs == sorted(rs))
        ck(sid, "potential falls as the isolines get larger",
           all(isos[i]["v"] > isos[i + 1]["v"] for i in range(len(isos) - 1)),
           f"V={[round(i['v'],3) for i in isos]}")
        # The entry's labelled parts: perpendicular, and no component ALONG.
        worst = 0.0
        for v in g["fm_vectors"]:
            c = ch[0]
            tx, ty = -(v["y"] - c["y"]), (v["x"] - c["x"])      # tangent to the circle
            tm = math.hypot(tx, ty)
            if tm < 1e-9:
                continue
            worst = max(worst, abs(v["ux"] * tx / tm + v["uy"] * ty / tm))
        ck(sid, "every field vector is perpendicular to its isoline",
           worst < 1e-9, f"largest component along an isoline = {worst:.3g}")
        ck(sid, "field vectors point towards lower potential",
           all(R._fm_potential(ch, v["x"] + v["ux"] * 0.01, v["y"] + v["uy"] * 0.01)
               < R._fm_potential(ch, v["x"], v["y"]) for v in g["fm_vectors"]))
        ck(sid, "the figure's text states that no work is done along an isoline",
           "no work" in (s.get("note") or "").lower() + s["alt"].lower())


def p_circuit_symbols(sid, s, svg):
    """A symbol key is right when every symbol the entry names is present,
    distinct, and drawn the way the entry defines it."""
    p = s["params"]
    g = R.FAMILIES["circuit_symbols"](p)
    cells = g["cs_cells"]
    if not p.get("symbol_sheet_check"):
        return
    ck(sid, "every labelled part of the entry has a cell",
       [c["label"] for c in cells] == s["labels"],
       f"{[c['label'] for c in cells]}")
    ck(sid, "no label is repeated", len({c["label"] for c in cells}) == len(cells))
    # Two meters share one glyph and are told apart ONLY by their letter, so a
    # missing letter would draw the ammeter and the voltmeter identically.
    meters = [sy for sy in p["symbols"] if sy["glyph"] == "meter"]
    ck(sid, "each meter carries the letter that distinguishes it",
       all(sy.get("letter") for sy in meters)
       and len({sy["letter"] for sy in meters}) == len(meters),
       f"{[sy.get('letter') for sy in meters]}")
    # Checked in the DRAWING, not only in the spec: the letter was declared
    # correctly and then dropped on the way to the canvas, so the ammeter and
    # the voltmeter rendered as two identical empty circles while this gate
    # read the parameters and passed.
    for sy in meters:
        ck(sid, f"the {sy['label']} really is drawn with its letter",
           f">{sy['letter']}</text>" in svg, "the circle renders empty without it")
    var = [c for c in cells if c["variable"]]
    ck(sid, "exactly one cell shows the variable-element notation", len(var) == 1)
    # The entry defines a variable element as a STANDARD symbol plus the
    # diagonal arrow, so it must reuse a glyph that appears elsewhere in the
    # sheet rather than be a shape of its own.
    ck(sid, "the variable element is a standard symbol with an arrow across it",
       bool(var) and var[0]["base"] in {c["glyph"] for c in cells if not c["variable"]},
       "it must reuse a symbol the sheet already shows")
    ck(sid, "the figure's text says the arrow is a notation, not a component",
       "notation" in (s.get("note") or "").lower())
    ck(sid, "every cell is drawn and labelled",
       svg.count("</text>") >= len(cells))


def p_density_curve(sid, s, svg):
    """A density curve's claim is about AREA, so the areas are integrated.

    Every shaded band declares the probability it is supposed to be, and that
    number is checked against the integral of the density over the band AND
    against the figure's own text. A fill that does not mean what the caption
    says is the characteristic failure of this family.
    """
    p = s["params"]
    g = R.FAMILIES["density_curve"](p)
    lo, hi = p["x_range"]

    def dens(c, x):
        return (R._normal_pdf(x, c["mu"], c["sigma"]) if c["kind"] == "normal"
                else R._chi2_pdf(x, c["df"]))

    for ci, c in enumerate(p["curves"]):
        # Wide limits, not the drawn window: a density that only integrates to
        # 1 inside the frame is not a density.
        a, b = (c["mu"] - 12 * c["sigma"], c["mu"] + 12 * c["sigma"]) if c["kind"] == "normal" \
            else (1e-9, 60.0 + 12.0 * c["df"])
        tot = integrate(lambda x, c=c: dens(c, x), a, b)
        ck(sid, f"curve {ci} is a density: it integrates to 1", abs(tot - 1) < 2e-3,
           f"integral={tot:.5f}")
        ck(sid, f"curve {ci} is never negative",
           all(y >= 0 for _, y in g["curves"][ci]["pts"]))

    for chk in p.get("area_checks", []):
        a = lo if chk.get("from") is None else chk["from"]
        b = hi if chk.get("to") is None else chk["to"]
        # Integrate to the real tail, not to the edge of the frame, or a
        # one-sided p-value is silently short by whatever the window cut off.
        c = p["curves"][chk.get("curve", 0)]
        if chk.get("from") is None:
            a = c["mu"] - 12 * c["sigma"] if c["kind"] == "normal" else 1e-9
        if chk.get("to") is None:
            b = c["mu"] + 12 * c["sigma"] if c["kind"] == "normal" else 60.0 + 12.0 * c["df"]
        got = integrate(lambda x, c=c: dens(c, x), a, b)
        ck(sid, f"the shaded area from {chk.get('from')} to {chk.get('to')} is the stated probability",
           abs(got - chk["expect"]) < chk["tol"], f"area={got:.4f} stated={chk['expect']}")
        ck(sid, f"the figure's text states {chk['says']}",
           chk["says"] in (s.get("note") or "") + s["caption"] + s["alt"],
           "a probability the picture shows must be readable without measuring it")

    if p.get("total_area_check"):
        ck(sid, "the text says the total area is 1",
           "total area" in (s.get("note") or "").lower() + s["alt"].lower()
           and " 1" in (s.get("note") or "") + s["alt"])
        ck(sid, "the text distinguishes a density from a probability",
           "density" in s["alt"].lower() and "height" in s["alt"].lower())

    if "normal_shape_check" in p:
        mu, sig = p["normal_shape_check"]["mu"], p["normal_shape_check"]["sigma"]
        xs = [lo + (hi - lo) * i / 4000 for i in range(4001)]
        peak = max(xs, key=lambda x: R._normal_pdf(x, mu, sig))
        ck(sid, "the curve peaks at the mean", abs(peak - mu) < (hi - lo) / 2000,
           f"peak={peak:.4f} mu={mu}")
        ck(sid, "the curve is symmetric about the mean",
           all(abs(R._normal_pdf(mu - t, mu, sig) - R._normal_pdf(mu + t, mu, sig)) < 1e-12
               for t in (0.3 * sig, sig, 2 * sig, 3 * sig)))
        # sigma is the distance to the inflection point, which is what the
        # entry means by "spread set by the standard deviation".
        d2 = lambda x: (R._normal_pdf(x + 1e-4, mu, sig) - 2 * R._normal_pdf(x, mu, sig)
                        + R._normal_pdf(x - 1e-4, mu, sig))
        ck(sid, "the curve changes its bend exactly one standard deviation from the mean",
           d2(mu + 0.8 * sig) < 0 < d2(mu + 1.2 * sig),
           "the inflection point is not at mu + sigma")
        ck(sid, "it is unimodal: the density rises then falls, once",
           sum(1 for i in range(1, len(xs) - 1)
               if R._normal_pdf(xs[i], mu, sig) > R._normal_pdf(xs[i - 1], mu, sig)
               and R._normal_pdf(xs[i], mu, sig) > R._normal_pdf(xs[i + 1], mu, sig)) == 1)

    if p.get("standard_normal_check"):
        c = p["curves"][0]
        ck(sid, "the standard normal really has mean 0 and standard deviation 1",
           c["mu"] == 0.0 and c["sigma"] == 1.0, f"mu={c['mu']} sigma={c['sigma']}")
        ck(sid, "the axis is labelled in standard deviations, not raw units",
           "standard deviation" in s["x_label"].lower() or s["x_label"].strip().startswith("z"))

    if p.get("nested_bands_check"):
        bands = [(sh["from"], sh["to"]) for sh in p["shade"]]
        # Each band must CONTAIN the next, or "95%" reads as a slice sitting
        # beside the 68% rather than including it -- the standard misreading.
        for i in range(len(bands) - 1):
            ck(sid, f"band {i} contains band {i+1}",
               bands[i][0] <= bands[i + 1][0] and bands[i][1] >= bands[i + 1][1],
               f"{bands[i]} does not contain {bands[i+1]}")
        ck(sid, "the text says each percentage is the whole area inside its band",
           "whole area" in (s.get("note") or "").lower() or "not an extra" in (s.get("note") or "").lower())

    if "symmetric_tails_check" in p:
        z = p["symmetric_tails_check"]["z"]
        c = p["curves"][0]
        left = integrate(lambda x: dens(c, x), c["mu"] - 12 * c["sigma"], -z)
        right = integrate(lambda x: dens(c, x), z, c["mu"] + 12 * c["sigma"])
        ck(sid, "the two tails left outside z* are equal", abs(left - right) < 1e-6,
           f"{left:.5f} vs {right:.5f}")
        ck(sid, "the shaded region is the MIDDLE, not the tails",
           p["shade"][0]["from"] == -z and p["shade"][0]["to"] == z)

    if "tail_check" in p:
        t = p["tail_check"]
        sh = p["shade"][0]
        if t["side"] == "right":
            ck(sid, "the shading runs from the statistic to the right tail",
               sh.get("from") == t["z"] and sh.get("to") is None, f"{sh}")
        else:
            ck(sid, "the shading runs from the left tail to the statistic",
               sh.get("to") == t["z"] and sh.get("from") is None, f"{sh}")
        ck(sid, "exactly one tail is shaded", len(p["shade"]) == 1)

    if "two_tailed_check" in p:
        z = p["two_tailed_check"]["z"]
        ck(sid, "both tails are shaded", len(p["shade"]) == 2)
        c = p["curves"][0]
        one = integrate(lambda x: dens(c, x), z, c["mu"] + 12 * c["sigma"])
        both = 2 * one
        ck(sid, "the two-sided p-value is exactly twice the one-sided one",
           abs(both - 2 * one) < 1e-12 and abs(both - 0.1616) < 0.008, f"2x{one:.4f}={both:.4f}")
        ck(sid, "the text says the two-sided value is twice the one-sided",
           "twice" in (s.get("note") or "").lower() + s["alt"].lower())

    if "chi_square_check" in p:
        dfs = [c["df"] for c in p["curves"]]
        ck(sid, "every chi-square curve has even degrees of freedom, so its gamma is exact",
           all(df % 2 == 0 for df in dfs), f"{dfs}")
        for ci, c in enumerate(p["curves"]):
            # The support is positive: nothing to the LEFT of zero. At zero
            # itself df = 2 has density 1/2, because that case is an
            # exponential -- asserting zero there is what produced a spike.
            ck(sid, f"df={c['df']} has no density left of zero",
               R._chi2_pdf(-1.0, c["df"]) == 0.0 and R._chi2_pdf(-1e-9, c["df"]) == 0.0)
            ck(sid, f"df={c['df']} is finite at zero, not asymptotic",
               R._chi2_pdf(0.0, c["df"]) < 1.0)
            ck(sid, f"df={c['df']} never turns negative",
               all(R._chi2_pdf(x / 10.0, c["df"]) >= 0 for x in range(0, 220)))
        # Right-skewed, and LESS so as df rises: the entry's own claim. Measured
        # as the standardised third moment, not asserted.
        def skew(df):
            m, v = float(df), 2.0 * df
            sd = math.sqrt(v)
            return integrate(lambda x, df=df: ((x - m) / sd) ** 3 * R._chi2_pdf(x, df),
                             1e-9, m + 14 * sd)
        sk = [(c["df"], skew(c["df"])) for c in p["curves"]]
        ck(sid, "every chi-square curve is skewed right", all(v > 0.2 for _, v in sk),
           f"{[(d, round(v,3)) for d, v in sk]}")
        ordered = sorted(sk)
        ck(sid, "the skew falls as the degrees of freedom rise",
           all(ordered[i][1] > ordered[i + 1][1] for i in range(len(ordered) - 1)),
           f"{[(d, round(v,3)) for d, v in ordered]}")
        # Both readers at gate 4c caught the alt text saying every curve "rises
        # and then falls". A chi-square with df = 2 is an exponential: it is at
        # its highest where the axis starts and only falls. The mode is at
        # max(df - 2, 0), so the text has to match which curves actually rise.
        xs_m = [lo + (hi - lo) * i / 4000 for i in range(4001)]
        modes = {c["df"]: max(xs_m, key=lambda x, c=c: R._chi2_pdf(x, c["df"]))
                 for c in p["curves"]}
        for df, m in modes.items():
            ck(sid, f"df={df} peaks where theory says, at max(df-2, 0)",
               abs(m - max(df - 2, 0)) < (hi - lo) / 1000, f"mode at {m:.3f}")
        if any(m < 1e-9 for m in modes.values()):
            ck(sid, "the text does not claim every curve rises to a peak",
               "each one rises" not in s["alt"].lower(),
               "a df=2 chi-square is an exponential: it never rises")
            ck(sid, "the text says which curve is highest at the left edge",
               "highest where the axis starts" in s["alt"]
               or "highest at the left" in s["caption"])

    if "same_z_check" in p:
        zs = []
        for m in p["same_z_check"]:
            c = p["curves"][m["curve"]]
            zs.append((m["x"] - c["mu"]) / c["sigma"])
        ck(sid, "the marked values are at the SAME z-score in their own distributions",
           max(zs) - min(zs) < 1e-12, f"z-scores={zs}")
        ck(sid, "the two distributions really do differ",
           len({(c["mu"], c["sigma"]) for c in p["curves"]}) == len(p["curves"]))
        # Same z in a normal distribution IS the same percentile, which is the
        # entry's point; check it rather than assert it.
        pcts = []
        for m in p["same_z_check"]:
            c = p["curves"][m["curve"]]
            pcts.append(integrate(lambda x, c=c: dens(c, x), c["mu"] - 12 * c["sigma"], m["x"]))
        ck(sid, "and therefore at the same percentile", max(pcts) - min(pcts) < 1e-6,
           f"percentiles={[round(v,5) for v in pcts]}")


def p_function_plot(sid, s, svg):
    """What a wrong function plot violates.

    These entries are about the SHAPE of a graph, so the checks are about
    shape: measured concavity, a zero that really is a zero, a tangency that
    touches without crossing, a hole the curve does not take, a secant whose
    slope is the stated average rate of change. Measured from the function the
    renderer actually evaluates, never asserted.
    """
    p = s["params"]
    g = R.FAMILIES["function_plot"](p)
    ev = lambda ci, x: R._fp_eval(p["curves"][ci], x)

    ck(sid, "something is drawn", bool(g["curves"]) or bool(g["dots"]))
    for c in g["curves"]:
        ck(sid, "every drawn point is inside the plotted range",
           all(g["y_range"][0] - 1e-9 <= y <= g["y_range"][1] + 1e-9 for _, y in c["pts"]),
           "a curve leaves the axes")

    def second_diff(ci, x, h=1e-3):
        a, b, c_ = ev(ci, x - h), ev(ci, x), ev(ci, x + h)
        return None if None in (a, b, c_) else a - 2 * b + c_

    if "concavity_check" in p:
        for name, (lo, hi) in p["concavity_check"].items():
            xs = [lo + (hi - lo) * i / 20 for i in range(21)]
            d2 = [second_diff(0, x) for x in xs]
            ok = all(v is not None and (v > 0 if name == "up" else v < 0) for v in d2)
            ck(sid, f"the graph really is concave {name} on [{lo}, {hi}]", ok,
               f"second differences: {[None if v is None else round(v, 6) for v in d2[:4]]}")
        ck(sid, "the text names both concavities",
           "concave up" in s["alt"].lower() and "concave down" in s["alt"].lower())

    if "inflection_check" in p:
        x = p["inflection_check"]
        left, right = second_diff(0, x - 0.4), second_diff(0, x + 0.4)
        ck(sid, "concavity really changes sign at the marked point",
           left is not None and right is not None and left * right < 0,
           f"second differences {left} and {right}")
        # Not an extremum: the classic confusion this figure exists to prevent.
        slope = (ev(0, x + 1e-4) - ev(0, x - 1e-4)) / 2e-4
        ck(sid, "the inflection point is not a maximum or a minimum", abs(slope) > 1e-6,
           f"slope there is {slope:.2e}")

    if "zeros_check" in p:
        for z in p["zeros_check"]:
            ck(sid, f"x = {z} really is a zero", abs(ev(0, z)) < 1e-9, f"f({z}) = {ev(0, z)}")
        ck(sid, "every zero is marked on the figure",
           all(any(abs(m["x"] - z) < 1e-9 for m in p.get("marks", [])) for z in p["zeros_check"]))
        ck(sid, "the text says a zero is an input, not a point",
           "input" in s["alt"].lower())

    if "secant_slopes_check" in p:
        want = p["secant_slopes_check"]
        got = [(ev(sc.get("curve", 0), sc["to"]) - ev(sc.get("curve", 0), sc["from"]))
               / (sc["to"] - sc["from"]) for sc in p["secants"]]
        ck(sid, "each secant's slope is the stated average rate of change",
           all(abs(a - b) < 1e-9 for a, b in zip(got, want)), f"{got} vs {want}")
        widths = [round(sc["to"] - sc["from"], 9) for sc in p["secants"]]
        ck(sid, "the intervals really are equal width", len(set(widths)) == 1, f"{widths}")
        ck(sid, "the slopes are increasing, which is what makes it concave up",
           all(got[i] < got[i + 1] for i in range(len(got) - 1)), f"{got}")
        for v in want:
            ck(sid, f"the figure states the slope {v:g}",
               f"{v:g}" in (s.get("note") or "") + " ".join(
                   t["label"] for t in p.get("texts", [])))

    if "tangency_check" in p:
        a = p["tangency_check"]["x"]
        ck(sid, f"the graph touches zero at x = {a}", abs(ev(0, a)) < 1e-9)
        # Tangent means it does NOT cross: same sign either side.
        lo, hi = ev(0, a - 0.3), ev(0, a + 0.3)
        ck(sid, "the output signs are the same either side, so it does not cross",
           lo * hi > 0, f"f({a}-0.3)={lo:.4f}, f({a}+0.3)={hi:.4f}")
        slope = (ev(0, a + 1e-4) - ev(0, a - 1e-4)) / 2e-4
        ck(sid, "the graph is tangent there: the slope is zero", abs(slope) < 1e-6,
           f"slope {slope:.2e}")
        other = p["tangency_check"].get("crosses")
        if other is not None:
            lo2, hi2 = ev(0, other - 0.3), ev(0, other + 0.3)
            ck(sid, f"the odd-multiplicity zero at x = {other} DOES cross", lo2 * hi2 < 0,
               "the contrast is the whole point")

    if "hole_check" in p:
        h = p["hole_check"]
        pt = [d for d in g["open_dots"] if abs(d["x"] - h["x"]) < 1e-9]
        ck(sid, "the hole is drawn as an OPEN circle", len(pt) == 1,
           "a filled dot asserts the opposite of a hole")
        ck(sid, "the open circle sits at the limit the function approaches",
           bool(pt) and abs(pt[0]["y"] - h["y"]) < 1e-9, f"{pt}")
        # The limit from both sides is that value, which is the entry's formula.
        near = [ev(0, h["x"] - 1e-5), ev(0, h["x"] + 1e-5)]
        ck(sid, "both one-sided limits approach it",
           all(v is not None and abs(v - h["y"]) < 1e-3 for v in near), f"{near}")
        ck(sid, "no filled point is drawn at the hole",
           not any(abs(d["x"] - h["x"]) < 1e-9 for d in g["dots"]))

    if "monotone_check" in p:
        want = p["monotone_check"]
        lo, hi = p["x_range"]
        xs = [lo + (hi - lo) * i / 200 for i in range(201)]
        ys = [ev(0, x) for x in xs]
        if want == "increasing":
            ck(sid, "the function is increasing everywhere drawn",
               all(ys[i] < ys[i + 1] for i in range(len(ys) - 1)))
        else:
            ck(sid, "the function is decreasing everywhere drawn",
               all(ys[i] > ys[i + 1] for i in range(len(ys) - 1)))
        d2 = [second_diff(0, x) for x in xs[1:-1]]
        ck(sid, "its concavity never changes, so it has no point of inflection",
           all(v > 0 for v in d2) or all(v < 0 for v in d2))
        ck(sid, "and it has no maximum or minimum inside the window",
           not any((ys[i] - ys[i - 1]) * (ys[i + 1] - ys[i]) < 0 for i in range(1, len(ys) - 1)))

    if "reflection_check" in p:
        r = p["reflection_check"]
        # (s, t) on one curve means (t, s) on the other: that IS the reflection.
        for x in r["sample_x"]:
            y = ev(r["a"], x)
            back = ev(r["b"], y)
            ck(sid, f"reflecting ({x:g}, {y:g}) over y = x lands back on the other curve",
               back is not None and abs(back - x) < 1e-6, f"got {back}")
        ck(sid, "the mirror line y = x is drawn",
           any(c.get("kind") == "identity" for c in p["curves"]))

    if "asymptote_check" in p:
        for xa in p.get("asymptotes_x", []):
            near = ev(0, xa + p["asymptote_check"].get("eps", 1e-3))
            ck(sid, f"the function really blows up at the asymptote x = {xa:g}",
               near is None or abs(near) > p["asymptote_check"].get("big", 50.0),
               f"value just past it is {near}")
        ck(sid, "the curve is broken at each asymptote, not drawn through it",
           len(g["curves"]) >= len(p.get("asymptotes_x", [])),
           "a line through an asymptote asserts a value the function does not take")

    if "range_gap_check" in p:
        gap = p["range_gap_check"]
        ys = [y for c in g["curves"] for _, y in c["pts"]]
        inside = [y for y in ys if gap[0] + 1e-9 < y < gap[1] - 1e-9]
        ck(sid, f"no point is drawn inside the excluded range ({gap[0]:g}, {gap[1]:g})",
           not inside, f"{len(inside)} points inside the gap")

    if "degree_points_check" in p:
        d = p["degree_points_check"]
        ck(sid, "the stated number of points is drawn", len(g["dots"]) == d["degree"] + 1,
           f"{len(g['dots'])} points for degree {d['degree']}")
        ck(sid, "their inputs are distinct", len({round(x, 9) for x in d["xs"]}) == len(d["xs"]))
        ck(sid, "every point really lies on the drawn polynomial",
           all(any(abs(dot["x"] - x) < 1e-9 and abs(dot["y"] - ev(0, x)) < 1e-9
                   for dot in g["dots"]) for x in d["xs"]))
        ck(sid, "the polynomial is of the stated degree",
           len(p["curves"][0]["coeffs"]) - 1 == d["degree"],
           f"{len(p['curves'][0]['coeffs']) - 1} != {d['degree']}")
        # "degree n OR LESS" is the entry's claim, and the usual misreading is
        # that n + 1 points fix the degree exactly.
        ck(sid, "the text says the degree is an upper bound, not an exact value",
           "or less" in (s.get("note") or "").lower() + s["alt"].lower())

    if "decreasing_between_check" in p:
        for lo, hi in p["decreasing_between_check"]["intervals"]:
            xs = [lo + (hi - lo) * i / 120 for i in range(121)]
            ys = [ev(0, x) for x in xs]
            ck(sid, f"the graph falls the whole way across [{lo:.2f}, {hi:.2f}]",
               all(a is not None and b is not None and a > b for a, b in zip(ys, ys[1:])),
               "a branch that turns is not 'decreasing between consecutive asymptotes'")
        ck(sid, "the text says it decreases rather than turning",
           "decreasing" in (s.get("note") or "").lower() + s["alt"].lower())

    if "window_pair_check" in p:
        w = p["window_pair_check"]
        # The first version counted turning points and asserted the wide window
        # had none. That was the CHECK being wrong, not the figure: the turning
        # points exist at every scale. What the entry claims is that scale can
        # HIDE them, so what has to be measured is whether the feature is big
        # enough to see in this window.
        lo, hi = -0.4, 0.4
        xs = [lo + (hi - lo) * i / 8000 for i in range(8001)]
        ys = [ev(0, x) for x in xs]
        turns = [i for i in range(1, len(ys) - 1)
                 if (ys[i] - ys[i - 1]) * (ys[i + 1] - ys[i]) < 0]
        ck(sid, "the function really does turn twice, at every scale", len(turns) == 2,
           f"counted {len(turns)}")
        feature = max(ys[i] for i in turns) - min(ys[i] for i in turns)
        span = p["y_range"][1] - p["y_range"][0]
        frac = feature / span
        if w["visible"]:
            ck(sid, "in this window the feature fills enough of the frame to be seen",
               frac > 0.2, f"it spans {frac:.3f} of the height")
        else:
            # Thinner than the drawn line: not "hard to see", invisible.
            ck(sid, "in this window the feature is thinner than the line that draws it",
               frac < 0.002, f"it spans {frac:.5f} of the height")
        ck(sid, "both windows draw one and the same function",
           p["curves"][0]["coeffs"] == w["coeffs"], "the pair proves nothing otherwise")
        ck(sid, "the text says the difference is scale, not accuracy",
           "scale" in s["alt"].lower())

    if "sequence_check" in p:
        ck(sid, "a sequence is drawn as discrete points, with no curve joining them",
           not g["curves"] and len(g["dots"]) > 1,
           "joining them asserts values between the whole numbers")
        xs = sorted(d["x"] for d in g["dots"])
        ck(sid, "its inputs are the whole numbers",
           all(abs(x - round(x)) < 1e-12 for x in xs) and xs[0] >= 0)
        ck(sid, "the text says why it is points rather than a curve",
           "discrete" in s["alt"].lower())


PROPS = {"xy_series": p_xy_series, "kinematic_panels": p_kinematic_panels,
    "arrow_diagram": p_arrow_diagram,
    "particulate_box": p_particulate_box,
    "field_map": p_field_map,
    "circuit_symbols": p_circuit_symbols,
    "density_curve": p_density_curve,
    "function_plot": p_function_plot,
         "categorical_bars": p_categorical_bars, "pie_chart": p_pie, "dotplot": p_dotplot,
         "stem_leaf": p_stem_leaf, "boxplot": p_boxplot,
         "mb_distribution": p_mb, "energy_profile": p_energy_profile, "stick_spectrum": p_stick,
         "pe_vs_distance": p_pe, "approach_equilibrium": p_equilibrium, "titration_curve": p_titration}


# ------------------------------------------------------------------- main ---
def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--entries", default=os.path.join(HERE, "prod_entries.json"))
    args = ap.parse_args()

    specs = {k: v for k, v in json.load(open(os.path.join(HERE, "specs.json"))).items()
             if not k.startswith("_")}
    # The coverage gate is only as real as this file. It used to default to a
    # scratch path outside the repository, so once that file was gone the gate
    # passed with nothing to check -- refuse to run rather than report that.
    entries = {k: v for k, v in json.load(open(args.entries)).items() if not k.startswith("_")}
    os.makedirs(OUT, exist_ok=True)

    results, by_entry, unpublished, t_all = {}, {}, [], time.perf_counter()
    for sid, spec in specs.items():
        t0 = time.perf_counter()
        svg = R.render(spec)
        ms = (time.perf_counter() - t0) * 1000
        open(os.path.join(OUT, f"{sid}.svg"), "w").write(svg)

        ck(sid, "renders deterministically", R.render(spec) == svg)

        # Every figure is titled, labelled and recallable (Product Owner, 2026-10-10):
        # the same figure may be shown beside different entries or questions, so its
        # identity and labels live on the figure, not on whichever entry links to it.
        ck(sid, "has a stable figure_id", spec.get("figure_id") == sid)
        ck(sid, "is titled", bool(spec.get("title", "").strip()))
        ck(sid, "has a caption", bool(spec.get("caption", "").strip()))
        ck(sid, "has labelled parts", len(spec.get("labels") or []) > 0)
        ck(sid, "declares where it is used, or why nowhere",
           bool(spec.get("used_by")) or bool(spec.get("unpublished")))
        for u in spec.get("used_by", []):
            ck(sid, "each use names a kind and an id", bool(u.get("kind")) and bool(u.get("id")))

        # Three layouts, because the side pane is 272-460px and the question pane ~680px.
        for lay, px in (("compact", 272), ("full", 680), ("expanded", 980)):
            alt_svg = R.render(spec, lay)
            ck(sid, f"renders in the {lay} layout", "<svg" in alt_svg)
            ck(sid, f"{lay} re-renders identically", R.render(spec, lay) == alt_svg)
            vb = R.LAYOUTS[lay]["W"]
            smallest = min(v for k, v in R.LAYOUTS[lay]["f"].items() if v)
            eff = smallest * px / vb
            ck(sid, f"{lay} text is legible at {px}px", eff >= 8.5,
               f"smallest type renders at {eff:.1f}px")
            ck(sid, f"{lay} title fits the canvas",
               all(len(l) <= 62 for l in R.wrap(spec.get("short_title", spec["title"]).upper(),
                                                26 if lay == "compact" else 60)))

        # An annotation outside the axes is silently invisible: the bond-energy
        # arrow was placed beyond r_max and vanished, while `covers` still
        # claimed the entry's "Depth of the energy well" was shown. Declared
        # coverage is not rendered coverage, so check the geometry.
        geo = R.FAMILIES[spec["family"]](spec["params"])
        gx0, gx1 = geo["x_range"]
        gy0, gy1 = geo["y_range"]
        for kind in ("marks", "arrows", "arrows_v", "vlines"):
            for a in geo.get(kind, []):
                ck(sid, f"{kind} annotation '{a.get('label') or a.get('caption') or '?'}' is inside the plot",
                   gx0 <= a["x"] <= gx1, f"x={a['x']} not in [{gx0}, {gx1}]")
                for key in ("y", "y0", "y1"):
                    if key in a:
                        ck(sid, f"{kind} '{a.get('label') or '?'}' {key} is inside the plot",
                           gy0 <= a[key] <= gy1, f"{key}={a[key]} not in [{gy0:.3g}, {gy1:.3g}]")
        for c in geo["curves"]:
            ck(sid, "curve stays inside the plotted range",
               all(gy0 - 1e-9 <= y <= gy1 + 1e-9 for _, y in c["pts"]), "a curve leaves the axes")
        # Not every Lane A figure is a Cartesian chart. A pie chart and a
        # stem-and-leaf plot draw no axes at all, and a dotplot and a boxplot
        # draw no y axis, so demanding both labels on the canvas would fail
        # them for being drawn correctly. What must hold instead: an axis that
        # IS drawn carries its label, and an axis that is NOT drawn has its
        # meaning carried in the alt text, which is where a reader who never
        # sees the picture gets it.
        # Nothing may be drawn outside the canvas, at ANY layout. The data
        # geometry checks above cannot see this: they work in data coordinates,
        # while a title, an axis label or a tick is placed in canvas units. It
        # is here because the compact layout centred the rotated y-axis title on
        # x=0, so half of it rendered off the left edge -- in every figure,
        # including the ten already published. A green suite said nothing.
        for lay_name, lay_cfg in R.LAYOUTS.items():
            lsvg = R.render(spec, lay_name)
            cw, chh = lay_cfg["W"], lay_cfg["H"]
            offenders = []
            for tm in re.finditer(r'<text([^>]*)>([^<]*)</text>', lsvg):
                at, tx = tm.group(1), tm.group(2).strip()
                fx = re.search(r'\bx="(-?[\d.]+)"', at)
                fy = re.search(r'\by="(-?[\d.]+)"', at)
                if not (fx and fy and tx):
                    continue
                fsz = re.search(r'font-size="([\d.]+)"', at)
                size = float(fsz.group(1)) if fsz else 11.0
                anc = re.search(r'text-anchor="(\w+)"', at)
                a = anc.group(1) if anc else "start"
                wdt = 0.55 * size * len(tx)
                lx = float(fx.group(1)) - (wdt / 2 if a == "middle" else wdt if a == "end" else 0)
                # The EXTENT has to fit, not just the anchor: a centred x-axis
                # title whose anchor sits mid-canvas can still run off both ends.
                if lx < 0 or lx + wdt > cw or not (0 <= float(fy.group(1)) <= chh):
                    offenders.append((tx[:24], round(lx, 1), round(lx + wdt, 1)))
            for mx, my in re.findall(r'transform="translate\((-?[\d.]+),\s*(-?[\d.]+)\)', lsvg):
                # A rotated label is centred on this point, so it needs real
                # clearance from the edge, not merely a non-negative coordinate.
                if not (8 <= float(mx) <= cw - 8 and 0 <= float(my) <= chh):
                    offenders.append(("rotated", mx, my))
            # Lines and circles too, not only text. The original pilot defect
            # was an ARROW rendered off-canvas, and a text-only check would have
            # missed it -- as it missed a mis-converted tangent slope that drew
            # two near-vertical dashed lines straight off the bottom edge.
            # <path> too. Field lines and arrowheads are paths, and a check
            # that reads only text, lines and circles cannot see a curve that
            # leaves the canvas -- which is the defect this gate exists for.
            for pm in re.finditer(r'<path[^>]*\sd="([^"]*)"', lsvg):
                d_ = pm.group(1)
                # Only straight-segment paths are parsed: in an arc command the
                # radii and the two flags are not coordinates, and reading every
                # number as an alternating x/y flagged the pie chart's wedges
                # for its own sweep flags. An arc path is simply not checked
                # here, and the geometry tests cover those families instead.
                if re.search(r'[AaCcQqSsTt]', d_):
                    continue
                nums = [float(t) for t in re.findall(r'-?\d+(?:\.\d+)?', d_)]
                pxs, pys = nums[0::2], nums[1::2]
                if any(v < -0.5 or v > cw + 0.5 for v in pxs) or \
                   any(v < -0.5 or v > chh + 0.5 for v in pys):
                    offenders.append(("path", round(min(pxs or [0]), 1),
                                      round(max(pxs or [0]), 1)))
            for tag, xs_, ys_ in (
                ("line", ("x1", "x2"), ("y1", "y2")),
                ("circle", ("cx",), ("cy",)),
            ):
                for mm in re.finditer(rf"<{tag}([^>]*)/>", lsvg):
                    at = mm.group(1)
                    pts_x = [float(re.search(rf'\b{a}="(-?[\d.]+)"', at).group(1))
                             for a in xs_ if re.search(rf'\b{a}="(-?[\d.]+)"', at)]
                    pts_y = [float(re.search(rf'\b{a}="(-?[\d.]+)"', at).group(1))
                             for a in ys_ if re.search(rf'\b{a}="(-?[\d.]+)"', at)]
                    if any(v < -0.5 or v > cw + 0.5 for v in pts_x) or \
                       any(v < -0.5 or v > chh + 0.5 for v in pts_y):
                        offenders.append((tag, pts_x, pts_y))
            ck(sid, f"nothing is drawn outside the {lay_name} canvas", not offenders,
               f"{offenders[:4]} canvas={cw}x{chh}")

            # Overprinting is the other defect the eye keeps finding and the
            # suite kept missing: "catalyseduncatalysed" and "25Mg 10.00 26Mg
            # 11.01%" both shipped through a green run. Estimate each label's
            # box and assert no two collide. Helvetica digits and lower case
            # average about 0.55em, which is close enough to catch a real
            # overlap without flagging a kerning-width near miss.
            boxes = []
            for m in re.finditer(r'<text([^>]*)>([^<]*)</text>', lsvg):
                attrs, txt = m.group(1), m.group(2).strip()
                if not txt:
                    continue
                if "translate(" in attrs:
                    # A rotated axis title: same box, width and height swapped.
                    tm = re.search(r'translate\((-?[\d.]+),\s*(-?[\d.]+)\)', attrs)
                    fsz_r = re.search(r'font-size="([\d.]+)"', attrs)
                    if tm:
                        szr = float(fsz_r.group(1)) if fsz_r else 11.0
                        cx, cy = float(tm.group(1)), float(tm.group(2))
                        hh = 0.55 * szr * len(txt) / 2
                        boxes.append((cx - szr * 0.6, cy - hh, cx + szr * 0.6, cy + hh, txt))
                    continue
                fx = re.search(r'\bx="(-?[\d.]+)"', attrs)
                fy = re.search(r'\by="(-?[\d.]+)"', attrs)
                fsz = re.search(r'font-size="([\d.]+)"', attrs)
                if not (fx and fy):
                    continue
                size = float(fsz.group(1)) if fsz else 11.0
                wdt = 0.55 * size * len(txt)
                anc = re.search(r'text-anchor="(\w+)"', attrs)
                a = anc.group(1) if anc else "start"
                x = float(fx.group(1)) - (wdt / 2 if a == "middle" else wdt if a == "end" else 0)
                y = float(fy.group(1))
                boxes.append((x, y - size * 0.78, x + wdt, y + size * 0.22, txt))
            clashes = []
            for i in range(len(boxes)):
                for j in range(i + 1, len(boxes)):
                    a, b = boxes[i], boxes[j]
                    ox = min(a[2], b[2]) - max(a[0], b[0])
                    oy = min(a[3], b[3]) - max(a[1], b[1])
                    if ox > 1.5 and oy > 1.5:
                        clashes.append(f"{a[4]!r}~{b[4]!r}")
            ck(sid, f"no two labels overprint at {lay_name}", not clashes, "; ".join(clashes[:3]))

        bare = geo.get("frame") == "bare"
        no_y = geo.get("hide_y_axis", False)
        for which, drawn in (("x", not bare), ("y", not bare and not no_y)):
            lab = spec[f"{which}_label"].strip()
            if drawn:
                ck(sid, f"{which} axis label is visible", lab.upper()[:18] in svg.upper())
            elif lab:
                # Compare bare words: "stem (tens digit)" must match an alt that
                # says "the stems ... are the tens digits", so punctuation is
                # stripped and a stem-of-the-word match counts.
                words = [w for w in "".join(c if c.isalnum() else " " for c in lab.lower()).split()
                         if len(w) >= 4]
                alt = spec["alt"].lower()
                ck(sid, f"{which} axis is not drawn, so its meaning is in the alt text",
                   any(w in alt or w[:-1] in alt or w + "s" in alt for w in words),
                   f"none of {words} appears in alt")
        # Glyphs the figure font does not carry. U+2225 PARALLEL TO renders as a
        # plain "I" in Helvetica, so "F-parallel" reached the eye pass reading
        # "FI" -- a different symbol, stated to a student as fact. Caught by eye
        # at 460px; a check now, because the next one will not be noticed.
        UNDRAWABLE = {"\u2225": "PARALLEL TO", "\u2016": "DOUBLE VERTICAL LINE",
                      "\u29f8": "BIG SOLIDUS", "\u2a2f": "VECTOR CROSS PRODUCT"}
        drawn = " ".join(str(x) for x in (
            spec.get("title", ""), spec.get("short_title", ""), spec.get("subtitle", ""),
            spec.get("caption", ""), spec.get("x_label", ""), spec.get("y_label", ""),
            spec.get("note", "") or "", " ".join(spec.get("labels", [])),
            " ".join(str(t) for _, t in spec["params"].get("x_ticks", []) or []),
            " ".join(m.get("label", "") for sr in spec["params"].get("series", []) or []
                     for m in sr.get("marks", []) or []),
            " ".join(h.get("label", "") for h in spec["params"].get("hlines", []) or []),
        ))
        bad = sorted({f"{g} ({n})" for g, n in UNDRAWABLE.items() if g in drawn})
        ck(sid, "every drawn string uses glyphs the figure font can render", not bad, f"{bad}")

        ck(sid, "has accessible title and description", "<title" in svg and "<desc" in svg and len(spec["alt"]) > 80)
        ck(sid, "illustrative data is disclosed",
           (not spec.get("synthetic")) or "illustrative" in (svg + spec["alt"]).lower())
        PROPS[spec["family"]](sid, spec, svg)

        ck(sid, "is keyed to a published entry row, or says why not",
           bool(spec.get("reference_entry_id")) or bool(spec.get("unpublished")),
           "no reference_entry_id and no unpublished note")
        if not spec.get("reference_entry_id"):
            unpublished.append(sid)
            continue
        # Coverage is owed to EVERY entry this figure is used by, not only to the
        # one it was authored against. One figure legitimately serves two entries
        # -- the same concept is authored twice in sibling subjects, and the RPC
        # does not filter a figure by subject_key -- and the second entry's
        # labelled parts went unchecked while only `entry_title` was read here.
        uses = [u for u in spec.get("used_by", []) if u.get("title")]
        used_titles = [ekey(u.get("subject_key") or spec.get("subject_key"), u["title"])
                       for u in uses]
        # Carrying the contract is a property of the USE, not of the figure: the
        # kinematics panels serve an entry with four authored parts AND two
        # formula entries with none, so one figure-level flag could only be
        # wrong for one of them.
        for u in uses or [{"title": spec["entry_title"],
                           "labels_carry_contract": spec.get("labels_carry_contract")}]:
            t = ekey(u.get("subject_key") or spec.get("subject_key"), u["title"])
            by_entry.setdefault(t, {"specs": [], "covers": set(), "labels": set(),
                                    "carriers": []})
            by_entry[t]["specs"].append(sid)
            by_entry[t]["covers"].update(spec.get("covers", []))
            by_entry[t]["labels"].update(spec.get("labels", []))
            if u.get("labels_carry_contract") or spec.get("labels_carry_contract"):
                by_entry[t]["carriers"].append(sid)
        results[sid] = {"family": spec["family"], "entry": spec["entry_title"],
                        "used_by": used_titles,
                        "render_ms": round(ms, 3), "bytes": len(svg.encode())}

    # Coverage is a property of the ENTRY, not of one figure: an entry whose
    # labelled parts span two charts is covered only when both are rendered.
    coverage = {}
    for title, agg in by_entry.items():
        # `title` is the composite key; its readable half is after the "::".
        authored = [i.get("label") for i in ((entries.get(title) or {}).get("items") or [])]
        # A missing fixture is not a clean pass. An entry the corpus really does
        # author with no labelled parts is a legitimate state, though -- a
        # vocabulary entry can host a figure -- so test for the KEY, not for a
        # non-empty list, or such an entry could never pass.
        ck(title, "authored items[] are present to check against",
           "items" in (entries.get(title) or {}),
           f"entry absent from or stripped in {os.path.basename(args.entries)}")
        # The fixture stands in for Production, so it has to be provably the
        # array that was read from there: md5(label>>meaning joined on '|'),
        # the digest the fixture was built by. A retyped or edited items[]
        # changes the digest and fails here instead of quietly redefining
        # what the coverage gate asserts.
        ent = entries.get(title) or {}
        if "items_md5" in ent:
            calc = hashlib.md5("|".join(
                f"{i.get('label','')}\u00bb{i.get('meaning','')}"
                for i in (ent.get("items") or [])).encode()).hexdigest()
            ck(title, "fixture items[] still match their recorded digest",
               calc == ent["items_md5"], f"{calc} != {ent['items_md5']}")
        if "body_md5" in ent:
            ck(title, "fixture body still matches its recorded digest",
               hashlib.md5((ent.get("body") or "").encode()).hexdigest() == ent["body_md5"])
        # DECISION-0116 (Product Owner, 2026-10-11): when the entry authors no
        # labelled parts, the FIGURE'S OWN `labels` are the contract. That used
        # to print a note and assert nothing, which is how ~19 candidate entries
        # could have carried figures that promised nothing. Route (b) is now a
        # deliberate, per-figure declaration with a gate behind it, because the
        # figures table is a side door into the corpus that the reference-pack
        # checkers do not watch -- see the handoff's SS3.2.
        carries = "items" in (entries.get(title) or {}) and not authored
        if carries:
            ck(title, "a figure declares it carries the contract (DECISION-0116)",
               bool(agg["carriers"]),
               "entry authors no items[]; set labels_carry_contract on its figure")
            ck(title, "the carried contract is non-empty", bool(agg["labels"]),
               "a figure carrying the contract must declare labelled parts")
            # Self-declared, but not self-serving: `covers` is what the coverage
            # gate reads and `labels` is what the student is promised, so a
            # figure may not promise a part it does not also declare it draws.
            uncovered = sorted(l for l in agg["labels"] if l not in agg["covers"])
            ck(title, "every carried label is also declared covered", not uncovered,
               f"labels not in covers: {uncovered}")
            # DECISION-0116 makes the two-reader gate the only check standing
            # where the reference-pack checkers do not, and ced_check.py shows
            # the reader the entry's `body` as its claim. With no body in the
            # fixture that prompt said "claim: (not available)" -- the reader
            # would be judging the figure against nothing at all.
            ck(title, "the entry's claim is in the fixture for the reader gate",
               bool((entries.get(title) or {}).get("body")),
               "route (b) needs the published body in prod_entries.json")
        missing = [a for a in authored if a not in agg["covers"]]
        ck(title, "every authored labelled part is covered", not missing, f"missing={missing}")
        coverage[title] = {"figures": agg["specs"], "authored_labels": len(authored),
                           "covered": len(authored) - len(missing), "missing": missing,
                           "contract": "figure_labels" if carries else "entry_items",
                           "carried_labels": sorted(agg["labels"]) if carries else []}

    # Copy notes: the notice fires only when a figure is actually in the copy,
    # and every figure survives the export as text even when the drawing does not.
    allf = list(specs.values())
    # Settled by a real Google Docs paste on 2026-10-10: PNG works, inline SVG
    # both fails and leaks the SVG's text nodes into the document.
    rast = {f["figure_id"]: "data:image/png;base64,iVBORw0KGgo=" for f in allf}
    ck("export", "no notice when every figure rasterised", X.copy_notice(allf, rast) is None)
    ck("export", "notice fires only for figures that failed to rasterise",
       (X.copy_notice(allf, {k: v for k, v in list(rast.items())[1:]}) or "").startswith("1 diagram"))
    ck("export", "notice counts the failures",
       "2 diagrams" in (X.copy_notice(allf, {k: v for k, v in list(rast.items())[2:]}) or ""))
    ck("export", "no blanket Google Docs warning any more",
       "Google Docs" not in (X.copy_notice(allf, {}) or ""))
    h, t = X.figures_section(allf, rast)
    ck("export", "inline SVG never reaches the clipboard HTML", "<svg" not in h,
       "Docs flattens SVG text nodes into the document")
    ck("export", "each figure is exported as a PNG image",
       h.count("<img src=\"data:image/png") == len(allf))
    ck("export", "a figure that fails to rasterise still exports its text",
       "<img" not in X.figures_section(allf[:1], {})[0] and allf[0]["alt"][:40] in X.figures_section(allf[:1], {})[0])
    for f in allf:
        ck("export", f"{f['figure_id']} keeps its title in the export", f["title"] in h and f["title"] in t)
        ck("export", f"{f['figure_id']} keeps its description in the export", f["alt"][:60] in t)
        for lab in f["labels"]:
            ck("export", f"{f['figure_id']} keeps the label '{lab[:28]}' as text", lab in t)
    ck("export", "the export carries a Figures heading", ">Figures</h2>" in h and t.startswith("Figures"))

    # The historical paste-comparison page intentionally includes an inline
    # SVG control even though production never does. Exercise its separate
    # builder so an export API change cannot leave the fixture crashing.
    control_h, control_t, control_svgs = C.comparison_figure_section(allf[:2])
    ck("clipboard fixture", "inline-SVG comparison variant still builds",
       control_h.count("<svg") == 2 and len(control_svgs) == 2)
    ck("clipboard fixture", "comparison variant keeps the text fallback",
       all(f["title"] in control_t and f["alt"] in control_t for f in allf[:2]))

    total_ms = (time.perf_counter() - t_all) * 1000
    fams = sorted({s["family"] for s in specs.values()})
    summary = {"entries": len(specs), "families": len(fams), "family_names": fams,
               "checks_run": checks, "checks_failed": len(fails), "failures": fails,
               "total_render_ms": round(total_ms, 2),
               "mean_render_ms": round(total_ms / len(specs), 3),
               "entries_covered": len(by_entry), "coverage": coverage,
               "unpublished_figures": unpublished, "per_spec": results}
    json.dump(summary, open(os.path.join(OUT, "results.json"), "w"), indent=2)

    labels = sum(c["authored_labels"] for c in coverage.values())
    print(f"{len(specs)} figures; {len(by_entry)} PUBLISHED entries covered "
          f"({labels} labelled parts) from {len(fams)} renderer families")
    if unpublished:
        print(f"  not production-eligible (no published entry): {', '.join(unpublished)}")
    print(f"{checks} checks, {len(fails)} failed")
    print(f"render: {total_ms:.1f} ms total, {total_ms/len(specs):.2f} ms mean")
    for f in fails:
        print("  FAIL", f)
    return 1 if fails else 0


if __name__ == "__main__":
    sys.exit(main())
