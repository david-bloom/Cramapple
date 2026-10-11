"""The one review step the pilot still owed: are the illustrative values defensible?

The property tests in verify.py pin relationships (MB peaks at theta/2, pH = pKa
at half-equivalence). They cannot tell whether a *label* contradicts the numbers
it sits next to, or whether an illustrative value teaches the wrong thing. That
is what this checks, and only that.

One review step, two independent readers, no veto and no patch loop. Both
readers are non-Anthropic families, because an Anthropic model would be marking
its own author's homework.

Five planted controls are deliberately wrong. Three of them (C2, C4, C5) pass
verify.py cleanly, so they measure whether a model reader adds anything over the
test suite. If any control is accepted, the batch is void.

    python3 -I scripts/lane-a-pilot/ced_check.py [--models a,b] [--only id]
"""
from __future__ import annotations

import argparse, copy, json, os, pathlib, sys, time

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE.parent / "content-seed" / "task0067-reference-pilot-2026-10-09"))
from gateway import chat_json  # noqa: E402

# The ratified slate. gemini-3.8-flash is deliberately NOT here: section 4c of
# the protocol records that the newer model accepted a control with high
# confidence and voided its batch, while 3.5-flash scored 5/5.
MODELS = ["openai/gpt-6.1-sol", "google/gemini-3.5-flash"]

SYSTEM = """You review figures for an AP study product (chemistry, statistics or physics).

You are given one figure described as: the authored reference entry it illustrates
(its claim and its labelled parts), and the exact parameters the figure was drawn
from. The figure is generated deterministically from those parameters, so the
parameters ARE the figure.

Judge one thing only: would a student who reads this figure learn something false?

Reject if any of these hold:
- a numeric value is wrong for what it claims to be (chemically, physically or statistically)
- a label contradicts the numbers it describes
- the stated relationship between series is not the relationship the numbers produce
- the title, subtitle or alt text asserts something the parameters do not show
- the figure contradicts the entry's own caution

Do NOT reject for: values being illustrative rather than measured (that is
intended and disclosed), styling, layout, axis ranges, or missing content that
the entry does not name.

Reply as JSON only:
{"verdict": "accept" | "reject",
 "issues": [{"what": "<the specific error>", "why": "<why it is wrong>"}],
 "confidence": "high" | "medium" | "low"}
Use an empty issues list when you accept."""


def controls(specs: dict) -> dict:
    """Five deliberately wrong figures. Each changes exactly one thing."""
    c = {}

    # C1 pH = pKa asserted at the equivalence point. The entry's caution forbids this.
    s = copy.deepcopy(specs["chem-titration"])
    s["params"]["eq_label"] = "equivalence point: pH = pKa = 4.76"
    s["params"]["half_label"] = "half-equivalence point"
    s["subtitle"] = "Weak acid with strong base: pH = pKa at the equivalence point"
    c["CONTROL-1-titration-pka-at-equivalence"] = s

    # C2 temperature labels swapped against their thetas. verify.py PASSES this.
    s = copy.deepcopy(specs["chem-mb-energy"])
    s["params"]["series"][0]["theta"], s["params"]["series"][1]["theta"] = 1.48, 0.78
    c["CONTROL-2-mb-temperature-labels-swapped"] = s

    # C3 abundances swapped: mass 25 becomes dominant, still labelled magnesium.
    s = copy.deepcopy(specs["chem-mass-spectrum"])
    s["params"]["peaks"][0]["y"], s["params"]["peaks"][1]["y"] = 10.00, 78.99
    s["params"]["peaks"][0]["label"] = "24Mg  10.00%"
    s["params"]["peaks"][1]["label"] = "25Mg  78.99%"
    c["CONTROL-3-mass-spectrum-abundances-swapped"] = s

    # C4 second barrier made the larger one; alt text still says the first is. PASSES verify.py.
    s = copy.deepcopy(specs["chem-energy-profile-multistep"])
    s["params"]["nodes"][1]["e"], s["params"]["nodes"][3]["e"] = 105, 130
    c["CONTROL-4-multistep-rate-determining-contradiction"] = s

    # C5 nitrogen PES with 2s=3 and 2p=2 electrons. Sums to 7, so PASSES verify.py.
    s = copy.deepcopy(specs["chem-pes"])
    s["params"]["peaks"][1]["y"], s["params"]["peaks"][2]["y"] = 3, 2
    c["CONTROL-5-pes-wrong-subshell-electron-counts"] = s
    return c


def stats_controls(specs: dict) -> dict:
    """Five deliberately wrong AP Statistics figures, each changing one thing.

    Four of the five (S1, S2, S4, S5) pass verify.py cleanly, because they are
    prose contradicting the drawing rather than bad geometry. That is the point:
    they measure whether a reader adds anything over the property suite.
    """
    c = {}

    # S1 the subtitle calls 40% "half". Prose only, so the suite passes it.
    s = copy.deepcopy(specs["stats-pie-chart"])
    s["subtitle"] = "Half of the students take the bus, so that slice is half the circle"
    s["alt"] = s["alt"].replace("bus 40%", "bus 50%, which is half the circle")
    c["CONTROL-S1-pie-forty-percent-called-half"] = s

    # S2 claims the whisker reaches the maximum and denies the outliers that
    # the same values produce. Prose only; the suite passes it.
    s = copy.deepcopy(specs["stats-boxplot"])
    s["note"] = "The right whisker reaches the maximum value of 62 minutes; there are no outliers."
    s["alt"] = ("A horizontal boxplot of the nightly homework times of 22 students. The box runs from "
                "the first quartile at 18 minutes to the third quartile at 30 minutes, with the median "
                "line inside it at 22.5 minutes. The whiskers run all the way out to the minimum of 12 "
                "minutes and the maximum of 62 minutes, because no value in this data set is an outlier. "
                "Illustrative data.")
    c["CONTROL-S2-boxplot-whisker-claimed-at-maximum"] = s

    # S3 unequal bins while the note still claims a 10-minute width. This one
    # the property suite DOES catch.
    s = copy.deepcopy(specs["stats-histogram"])
    s["params"]["bin_edges"] = [0, 10, 20, 35, 45, 50, 60]
    c["CONTROL-S3-histogram-unequal-bins-claimed-equal"] = s

    # S4 the sophomore split is changed in the data but not in the alt text.
    s = copy.deepcopy(specs["stats-two-cat-segmented"])
    s["params"]["table"] = [[24, 40, 30], [16, 20, 20]]
    c["CONTROL-S4-segmented-alt-contradicts-the-table"] = s

    # S5 drawn as a segmented chart with equal widths while the title, caption
    # and alt all say mosaic with widths showing group size. Suite passes it,
    # because as a segmented chart the geometry is correct.
    s = copy.deepcopy(specs["stats-two-cat-mosaic"])
    s["params"]["mode"] = "segmented"
    c["CONTROL-S5-mosaic-drawn-with-equal-widths"] = s
    return c


def physics_controls(specs: dict) -> dict:
    """Five deliberately wrong physics / precalculus figures.

    Four of the five (P1, P2, P3, P4) pass verify.py cleanly: they are prose
    contradicting a correct drawing, or a label swap the geometry checks cannot
    see. P5 is caught by the suite, which is the control that confirms the two
    gates are not simply duplicating each other.
    """
    c = {}

    # P1 the sign of the work, which the entry's own caution rules on.
    s = copy.deepcopy(specs["phys2-pv-isotherm-work"])
    s["subtitle"] = "Area under the path is the work done ON the gas, positive as it expands"
    s["alt"] = s["alt"].replace(
        "its area is the magnitude of the work for the process",
        "its area is the work done on the gas, which is positive here because the gas expands")
    c["CONTROL-P1-pv-work-sign-inverted"] = s

    # P2 the alt denies the loop rule the drawing obeys.
    s = copy.deepcopy(specs["phys2-potential-around-loop"])
    s["alt"] = s["alt"].replace(
        "returning to zero. The trace ends at the same potential it started at, because the net "
        "change around a closed loop is zero.",
        "ending one volt higher than it started, because the battery adds energy on each trip "
        "around the loop.")
    c["CONTROL-P2-loop-net-change-nonzero-claim"] = s

    # P3 claims a trend in residuals that have none -- and the absence of a
    # pattern is the entry's entire justification for the model.
    s = copy.deepcopy(specs["precalc-residual-plot"])
    s["alt"] = s["alt"].replace(
        "with no curve, no fanning and no trend across the plot. That absence of a pattern is what "
        "justifies the model as an appropriate fit.",
        "rising steadily from left to right in a clear upward trend, which is what justifies the "
        "model as an appropriate fit.")
    c["CONTROL-P3-residual-trend-claimed-and-misread"] = s

    # P4 temperature labels swapped against their thetas. The suite sorts by
    # theta, so it passes; a reader should see the hotter gas drawn as the
    # taller, narrower curve.
    s = copy.deepcopy(specs["phys2-mb-qualitative"])
    s["params"]["series"][0]["label"] = "hotter gas"
    s["params"]["series"][1]["label"] = "cooler gas"
    c["CONTROL-P4-mb-temperature-labels-swapped"] = s

    # P5 the drawn tangent does not have the slope it claims.
    s = copy.deepcopy(specs["physcmech-xva-graphs"])
    for an in s["params"]["annotations"]:
        if an["panel"] == "v":
            an["slope"] = 3.0          # a is 1.5
    c["CONTROL-P5-tangent-slope-wrong"] = s
    return c


CONTROL_SETS = {"chem-": controls, "stats-": stats_controls, "lane-a-rest": physics_controls}


def prompt_for(sid: str, spec: dict, entry: dict) -> str:
    parts = "\n".join(f"  - {i.get('label')}: {i.get('meaning')}" for i in (entry.get("items") or []))
    return f"""AUTHORED REFERENCE ENTRY
title: {entry.get('title', spec['entry_title'])}
claim: {entry.get('body', '(not available)')}
labelled parts:
{parts or '  (none)'}
caution: {entry.get('caution') or '(none)'}

FIGURE AS DRAWN
chart family: {spec['family']}
title: {spec['title']}
subtitle: {spec['subtitle']}
x axis: {spec['x_label']}
y axis: {spec['y_label']}
alt text: {spec['alt']}
note: {spec.get('note') or '(none)'}
values are illustrative: {bool(spec.get('synthetic'))}

EXACT DRAWING PARAMETERS
{json.dumps(spec['params'], indent=2)}"""


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--models", default=",".join(MODELS))
    ap.add_argument("--entries", default=str(HERE / "prod_entries.json"))
    ap.add_argument("--prefix", default="chem-",
                    help="comma-separated figure id prefixes for the batch")
    ap.add_argument("--controls", default=None, help="which control set (defaults to --prefix)")
    ap.add_argument("--only", default=None)
    ap.add_argument("--max-tokens", type=int, default=4000,
                    help="Reasoning models spend budget before emitting JSON; 1200 truncated them.")
    args = ap.parse_args()
    models = [m.strip() for m in args.models.split(",") if m.strip()]

    allspecs = {k: v for k, v in json.load(open(HERE / "specs.json")).items() if not k.startswith("_")}
    prefixes = tuple(x.strip() for x in args.prefix.split(",") if x.strip())
    specs = {k: v for k, v in allspecs.items() if k.startswith(prefixes)}
    if not specs:
        raise SystemExit(f"no figures with prefix {args.prefix!r}")
    entries = {k: v for k, v in json.load(open(args.entries)).items() if not k.startswith("_")}
    items = {**specs, **CONTROL_SETS[args.controls or args.prefix](allspecs)}
    if args.only:
        items = {k: v for k, v in items.items() if args.only in k}

    log_dir = HERE / "out" / "ced_check_logs"
    out, t0 = {}, time.time()
    for sid, spec in items.items():
        entry = entries.get(spec["entry_title"], {})
        user = prompt_for(sid, spec, entry)
        out[sid] = {"is_control": sid.startswith("CONTROL"), "verdicts": {}}
        for m in models:
            try:
                parsed, _ = chat_json(m, SYSTEM, user, log_dir, f"{sid}:{m}",
                                      max_tokens=args.max_tokens, temperature=0.0)
            except Exception as e:
                parsed = {"verdict": "error", "issues": [{"what": repr(e)[:200], "why": "call failed"}]}
            out[sid]["verdicts"][m] = parsed
            v = parsed.get("verdict", "?")
            print(f"  {sid[:52]:52} {m.split('/')[-1][:18]:18} {v}")

    # Controls gate, then the real figures.
    ctl = {k: v for k, v in out.items() if v["is_control"]}
    real = {k: v for k, v in out.items() if not v["is_control"]}
    leaked = [k for k, v in ctl.items()
              if not all(x.get("verdict") == "reject" for x in v["verdicts"].values())]
    flagged = {k: v for k, v in real.items()
               if any(x.get("verdict") != "accept" for x in v["verdicts"].values())}

    usage = {}
    for f in sorted(log_dir.glob("*.jsonl")) if log_dir.exists() else []:
        for line in f.read_text().splitlines():
            r = json.loads(line)
            u = usage.setdefault(r["model"], {"calls": 0, "prompt": 0, "completion": 0, "seconds": 0.0})
            u["calls"] += 1
            u["prompt"] += (r.get("usage") or {}).get("prompt_tokens", 0)
            u["completion"] += (r.get("usage") or {}).get("completion_tokens", 0)
            u["seconds"] += r.get("seconds", 0)

    summary = {"models": models, "figures": len(real), "controls": len(ctl),
               "controls_leaked": leaked, "flagged": list(flagged),
               "wall_seconds": round(time.time() - t0, 1), "usage": usage, "detail": out}
    (HERE / "out" / "ced_check.json").write_text(json.dumps(summary, indent=2))

    print(f"\ncontrols: {len(ctl) - len(leaked)}/{len(ctl)} correctly rejected")
    if leaked:
        print("  BATCH VOID - controls accepted:", leaked)
    print(f"figures: {len(real) - len(flagged)}/{len(real)} accepted by both readers")
    for k, v in flagged.items():
        print(f"  FLAGGED {k}")
        for m, x in v["verdicts"].items():
            if x.get("verdict") != "accept":
                for i in x.get("issues", []):
                    print(f"    [{m.split('/')[-1]}] {i.get('what')}")
    print(f"wall: {summary['wall_seconds']}s")
    for m, u in usage.items():
        print(f"  {m}: {u['calls']} calls, {u['prompt']} in / {u['completion']} out")
    return 1 if leaked else 0


if __name__ == "__main__":
    sys.exit(main())
