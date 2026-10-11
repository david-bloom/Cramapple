"""Lane A pilot: render every spec, assert domain properties, measure.

Run:  python3 -I scripts/lane-a-pilot/verify.py [--entries <entries.json>]

Three kinds of check:
  1. Domain properties  - chemistry/maths facts a wrong chart violates.
  2. Label coverage     - every items[] label on the authored entry is visible.
  3. Determinism        - the same spec renders byte-identical output.

Exit code 1 if any check fails. Timings are written to out/results.json.
"""
from __future__ import annotations

import argparse, json, math, os, sys, time

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import render as R  # noqa: E402
import export_figures as X  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "out")

fails: list[str] = []
checks = 0


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
    ea0 = p["markers"][0]["x"]
    if len(p["series"]) > 1:
        tails = [(ser["theta"], integrate(lambda E, t=ser["theta"]: R.mb_density(E, t), ea0, ea0 + 60 * ser["theta"]))
                 for ser in p["series"]]
        tails.sort()
        ck(sid, "hotter -> larger fraction beyond Ea",
           all(tails[i][1] < tails[i + 1][1] for i in range(len(tails) - 1)),
           f"tails={[round(t,4) for _,t in tails]}")
    if len(p["markers"]) > 1:
        th = p["series"][0]["theta"]
        xs_m = sorted(m["x"] for m in p["markers"])
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


PROPS = {"mb_distribution": p_mb, "energy_profile": p_energy_profile, "stick_spectrum": p_stick,
         "pe_vs_distance": p_pe, "approach_equilibrium": p_equilibrium, "titration_curve": p_titration}


# ------------------------------------------------------------------- main ---
def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--entries", default="/tmp/lane_a_chem.json")
    args = ap.parse_args()

    specs = {k: v for k, v in json.load(open(os.path.join(HERE, "specs.json"))).items()
             if not k.startswith("_")}
    entries = json.load(open(args.entries)) if os.path.exists(args.entries) else {}
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
        ck(sid, "x axis label is visible", spec["x_label"].upper()[:18] in svg.upper())
        ck(sid, "y axis label is visible", spec["y_label"].upper()[:18] in svg.upper())
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
        by_entry.setdefault(spec["entry_title"], {"specs": [], "covers": set()})
        by_entry[spec["entry_title"]]["specs"].append(sid)
        by_entry[spec["entry_title"]]["covers"].update(spec.get("covers", []))
        results[sid] = {"family": spec["family"], "entry": spec["entry_title"],
                        "render_ms": round(ms, 3), "bytes": len(svg.encode())}

    # Coverage is a property of the ENTRY, not of one figure: an entry whose
    # labelled parts span two charts is covered only when both are rendered.
    coverage = {}
    for title, agg in by_entry.items():
        authored = [i.get("label") for i in ((entries.get(title) or {}).get("items") or [])]
        missing = [a for a in authored if a not in agg["covers"]]
        ck(title, "every authored labelled part is covered", not missing, f"missing={missing}")
        coverage[title] = {"figures": agg["specs"], "authored_labels": len(authored),
                           "covered": len(authored) - len(missing), "missing": missing}

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
