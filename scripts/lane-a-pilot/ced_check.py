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

import argparse, copy, json, os, pathlib, re, sys, time

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


def gaps_controls(specs: dict) -> dict:
    """Controls for the Lane A gap batch (the entries outside kind='diagram').

    Three of the five -- G2, G3, G5 -- pass verify.py cleanly, which is what
    measures whether the readers add anything over the suite.
    """
    c = {}

    # G1 the stated work contradicts the area. verify.py CATCHES this.
    s = copy.deepcopy(specs["phys-work-force-displacement"])
    s["note"] = "Area = 24 J: the rectangle is 16 J and the triangle is 8 J."
    s["alt"] = s["alt"].replace("32 joules in total", "24 joules in total")
    c["CONTROL-G1-work-area-contradicts-note"] = s

    # G2 the extrapolated temperature is labelled -173 on the axis while the
    # line still reaches zero at -273. The tick text is not a property, so this
    # PASSES verify.py and teaches a wrong absolute zero.
    s = copy.deepcopy(specs["phys2-zero-pressure-temperature"])
    s["params"]["x_ticks"] = [[-273.15, "\u2212173"], [-150.0, "\u2212150"],
                              [0.0, "0"], [100.0, "100"]]
    s["params"]["series"][0]["marks"][0]["label"] = "P = 0 at \u2212173 \u00b0C"
    s["alt"] = s["alt"].replace("minus 273 degrees", "minus 173 degrees")
    c["CONTROL-G2-zero-pressure-mislabelled"] = s

    # G3 the classic misconception asserted in the figure's own text: that the
    # HEIGHT of the force curve reads off the work. The points are untouched,
    # so this PASSES verify.py.
    s = copy.deepcopy(specs["phys-work-force-displacement"])
    s["subtitle"] = "Read the height of the curve to get the work done so far"
    s["alt"] = s["alt"].replace(
        "Reading a value off the curve gives a force, not a work; only the area is the work.",
        "Reading the height of the curve at any displacement gives the work done up to that point.")
    c["CONTROL-G3-work-read-as-height"] = s

    # G4 the "ohmic" element is bent, so it has no constant resistance while
    # still being called ohmic. verify.py CATCHES this.
    s = copy.deepcopy(specs["phys2-ohmic-iv"])
    for sr in s["params"]["series"]:
        if sr["label"] == "ohmic element":
            sr["points"] = [[v, round(0.20 * (v / 5.0) ** 0.7, 6)]
                            for v in (0.0, 1.25, 2.5, 3.75, 5.0)]
    c["CONTROL-G4-ohmic-element-is-bent"] = s

    # G5 the catalysed barrier put ABOVE the uncatalysed one: a catalyst shown
    # RAISING the activation energy. p_mb compares marker POSITIONS, not which
    # position is labelled catalysed, so this PASSES verify.py.
    s = copy.deepcopy(specs["chem-mb-catalysis"])
    s["params"]["markers"] = [{"x": 1.9, "label": "Ea", "caption": "uncatalysed"},
                              {"x": 3.4, "label": "Ea'", "caption": "catalysed"}]
    c["CONTROL-G5-catalyst-raises-activation-energy"] = s

    return c


def arrow_controls(specs: dict) -> dict:
    """Controls for the Lane B arrow grammar.

    B2, B3 and B5 pass verify.py cleanly. All three are LABEL errors, which is
    the shape of mistake this grammar is most exposed to: the geometry is
    generated from magnitudes and angles and is therefore self-consistent by
    construction, while the words beside it are free to say anything.
    """
    c = {}

    # B1 the forces no longer balance, while the text still says they do.
    # verify.py CATCHES this.
    s = copy.deepcopy(specs["phys-free-body-diagram"])
    for a in s["params"]["arrows"]:
        if a["label"].startswith("rope"):
            a["magnitude"], a["label"] = 3.5, "rope 3.5 N"
    c["CONTROL-B1-free-body-does-not-balance"] = s

    # B2 the normal force's LABEL says 10.0 N while the arrow is drawn at
    # 8.7 N. The suite reads magnitudes, not words, so this PASSES.
    s = copy.deepcopy(specs["phys-free-body-diagram"])
    for a in s["params"]["arrows"]:
        if a["label"].startswith("normal"):
            a["label"] = "normal 10.0 N"
    s["alt"] = s["alt"].replace("8.7 newtons", "10.0 newtons")
    c["CONTROL-B2-normal-force-mislabelled"] = s

    # B3 the SHORTEST arrow labelled the LARGEST magnitude, which contradicts
    # the entry's whole claim that length is proportional to magnitude. The
    # geometry is untouched, so this PASSES verify.py.
    s = copy.deepcopy(specs["phys-vector-arrows"])
    for a in s["params"]["arrows"]:
        if a["label"] == "3.0 m/s":
            a["label"] = "9.0 m/s"
    s["alt"] = s["alt"].replace("labelled 3.0 metres per second", "labelled 9.0 metres per second")
    c["CONTROL-B3-shortest-arrow-largest-label"] = s

    # B4 the weight drawn AND its two components drawn beside it: the exact
    # error "Whole forces only" names. verify.py CATCHES this.
    s = copy.deepcopy(specs["phys-free-body-diagram"])
    s["params"]["arrows"] += [
        {"label": "weight along slope 5.0 N", "magnitude": 5.0, "angle_deg": 210},
        {"label": "weight across slope 8.7 N", "magnitude": 8.660254, "angle_deg": 300},
    ]
    c["CONTROL-B4-weight-drawn-with-its-components"] = s

    # B5 the axis labelled PERPENDICULAR to the incline while the dashed line
    # is still drawn parallel to it. The suite does not read the axis label
    # against its angle, so this PASSES.
    s = copy.deepcopy(specs["phys-free-body-diagram"])
    s["params"]["axis"] = {"angle_deg": 30.0, "label": "y axis, across the incline"}
    c["CONTROL-B5-axis-labelled-across-but-drawn-along"] = s

    return c


def particulate_controls(specs: dict) -> dict:
    """Controls for the Lane B particulate batch.

    P2, P3 and P5 pass verify.py cleanly. Like the arrow grammar, the geometry
    is generated from counts and is self-consistent by construction, so the
    errors that survive the suite are the ones stated in words beside it.
    """
    c = {}

    # P1 atoms are not conserved: two waters become one. CAUGHT by the suite.
    s = copy.deepcopy(specs["chem-particulate-balanced-equation"])
    s["params"]["panels"][1]["species"] = [{"key": "H2O", "count": 1}]
    s["params"]["panels"][1]["caption"] = "1 H\u2082O"
    c["CONTROL-P1-atoms-not-conserved"] = s

    # P2 concentration redefined as the AMOUNT of solute rather than the ratio,
    # in the figure's own note. The counts are untouched, so this PASSES.
    s = copy.deepcopy(specs["chem-particulate-solution"])
    s["note"] = "The box with more solute particles is the more concentrated, whatever its volume."
    s["alt"] = s["alt"].replace(
        "Both boxes are equally full, so what differs between them is the proportion of solute, "
        "not how much liquid there is.",
        "The right-hand box is more concentrated because it contains more solute particles in total.")
    c["CONTROL-P2-concentration-as-amount"] = s

    # P3 the classic equilibrium misconception, asserted in the figure's text:
    # that the reaction stops. The counts are untouched, so this PASSES.
    s = copy.deepcopy(specs["chem-particulate-reversible"])
    s["subtitle"] = "A \u21cc B: at equilibrium the forward reaction has stopped"
    s["alt"] = s["alt"].replace(
        "The reactant has not run out: some A is still present, which is what distinguishes "
        "equilibrium from a reaction that goes to completion.",
        "Once equilibrium is reached the forward reaction has stopped, so no more A turns into B.")
    c["CONTROL-P3-equilibrium-means-reaction-stopped"] = s

    # P4 the equilibrium counts no longer give the stated K. CAUGHT.
    s = copy.deepcopy(specs["chem-particulate-reversible"])
    s["params"]["panels"][1]["species"] = [{"key": "A", "count": 8}, {"key": "B", "count": 8}]
    s["params"]["panels"][1]["caption"] = "8 A, 8 B"
    c["CONTROL-P4-counts-do-not-give-stated-k"] = s

    # P5 the electrons described as belonging to the nearest ion, which is the
    # opposite of delocalized. The drawing is untouched, so this PASSES.
    s = copy.deepcopy(specs["chem-sea-of-electrons"])
    s["alt"] = s["alt"].replace(
        "The dots are not drawn on or beside any particular ion: they are spread across the whole "
        "box, because in a metal the valence electrons are delocalized and belong to the solid as "
        "a whole rather than to individual atoms.",
        "Each dot sits beside the ion it belongs to, because every valence electron stays with its "
        "own metal atom.")
    s["note"] = "Each electron stays with the ion it came from."
    c["CONTROL-P5-electrons-localized-on-ions"] = s

    return c


def field_controls(specs: dict) -> dict:
    """Controls for the Lane B field-map and circuit-symbol batch.

    F2, F3 and F5 pass verify.py cleanly.
    """
    c = {}

    # F1 two LIKE charges, while the text still says lines arrive at the
    # negative one. verify.py CATCHES this.
    s = copy.deepcopy(specs["phys-electric-field-map"])
    s["params"]["charges"] = [{"q": 1.0, "x": 0.28, "y": 0.5},
                              {"q": 1.0, "x": 0.72, "y": 0.5}]
    c["CONTROL-F1-two-like-charges-called-a-dipole"] = s

    # F2 the field described as pointing towards INCREASING potential, which
    # is backwards. The geometry is untouched, so this PASSES.
    s = copy.deepcopy(specs["phys2-equipotential-map"])
    s["note"] = "Field vectors point towards higher potential, up the potential hill."
    s["alt"] = s["alt"].replace("points towards lower potential",
                                "points towards higher potential")
    c["CONTROL-F2-field-points-up-the-potential-hill"] = s

    # F3 the figure's text licensing crossing field lines. PASSES the suite,
    # because nothing about the drawn lines changed.
    s = copy.deepcopy(specs["phys-electric-field-map"])
    s["note"] = "Where the field is strong the lines may cross one another."
    s["alt"] = s["alt"].replace(
        "No two lines ever cross, because the field has only one direction at each point.",
        "Close to the charges the lines cross one another, which is how a strong field is shown.")
    c["CONTROL-F3-field-lines-may-cross"] = s

    # F4 the isolines equally spaced in RADIUS while the figure's own note
    # says each is a fixed step lower in potential. For a point charge V goes
    # as 1/r, so equal radius steps are not equal potential steps. The suite
    # checks that potential falls outwards, not that the steps are equal, so
    # this PASSES it -- and unlike the control it replaces, a student can see
    # the claim and act on it.
    #
    # The control it replaces listed the same four isoline radii in a shuffled
    # ORDER. That draws the same four circles, so the picture a student sees is
    # identical and nothing false is taught. gemini-3.5-flash accepted it and
    # was right to; the control was the defect, not the reader. A control has
    # to be a mistake the figure can actually make to someone reading it.
    s = copy.deepcopy(specs["phys2-equipotential-map"])
    s["params"]["isoline_radii"] = [0.14, 0.24, 0.34, 0.44]
    s["note"] = "Equally spaced circles, so each one is the same step lower in potential than the last."
    s["alt"] = s["alt"].replace(
        "every point on one circle is at the same potential, and the potential falls as the circles "
        "get larger",
        "every point on one circle is at the same potential, and because the circles are equally "
        "spaced the potential falls by the same amount from each circle to the next")
    c["CONTROL-F4-equal-radii-read-as-equal-potential-steps"] = s

    # F5 the ammeter marked V and the voltmeter marked A. Both letters are
    # still present and still distinct, so this PASSES the suite while telling
    # a student the wrong symbol for each meter.
    s = copy.deepcopy(specs["phys2-circuit-symbols"])
    for sy in s["params"]["symbols"]:
        if sy["label"].startswith("Ammeter"):
            sy["letter"] = "V"
        elif sy["label"].startswith("Voltmeter"):
            sy["letter"] = "A"
    c["CONTROL-F5-meter-letters-swapped"] = s

    return c


def density_controls(specs: dict) -> dict:
    """Controls for the AP Statistics density batch.

    D2, D3 and D5 pass verify.py cleanly.
    """
    c = {}

    # D1 the middle band narrowed to +/-1.5 while the text still calls it 95%.
    # The area check CATCHES this.
    s = copy.deepcopy(specs["stats-empirical-rule"])
    for sh in s["params"]["shade"]:
        if sh["from"] == -2.0:
            sh["from"], sh["to"] = -1.5, 1.5
    s["params"]["area_checks"][1]["from"] = -1.5
    s["params"]["area_checks"][1]["to"] = 1.5
    c["CONTROL-D1-95-band-is-not-95"] = s

    # D2 the classic misreading, asserted in the figure's own text: that the
    # HEIGHT of the curve at a value is the probability of that value. The
    # geometry is untouched, so this PASSES.
    s = copy.deepcopy(specs["stats-normal-area"])
    s["note"] = "Total area is 1, and the height of the curve at a value is the density, the probability of that value."
    s["alt"] = s["alt"].replace(
        "The height of the curve is a density, not a probability: at any single value the curve "
        "has a height but the interval has no width, so the probability of exactly that value is "
        "zero.",
        "The height of the curve at any single value is the density, which is the probability of "
        "getting exactly that value.")
    c["CONTROL-D2-height-read-as-probability"] = s

    # D3 the right-tail figure relabelled as the LESS-THAN alternative while
    # still shading the right tail. The shading is untouched, so this PASSES
    # the suite and tells a student to shade the wrong side.
    s = copy.deepcopy(specs["stats-pvalue-right-tail"])
    s["title"] = "p-value for Ha: less than"
    s["short_title"] = "Ha: <, right tail"
    s["subtitle"] = "For a less-than alternative the p-value is the area above the statistic"
    s["labels"] = ["Ha: <"]
    s["covers"] = ["Ha: <"]
    s["alt"] = s["alt"].replace("greater-than form", "less-than form")
    s["caption"] = s["caption"].replace("\u201cgreater than\u201d", "\u201cless than\u201d")
    c["CONTROL-D3-less-than-shaded-on-the-right"] = s

    # D4 the critical value's shading moved to the TAILS while the text still
    # says the middle C%. verify.py CATCHES this.
    s = copy.deepcopy(specs["stats-critical-value-z"])
    s["params"]["shade"] = [{"from": None, "to": -1.96}, {"from": 1.96, "to": None}]
    c["CONTROL-D4-critical-value-shades-the-tails"] = s

    # D5 the chi-square family described as symmetric and able to go negative.
    # The curves are untouched, so this PASSES.
    s = copy.deepcopy(specs["stats-chi-square-shapes"])
    s["note"] = "Symmetric about its mean, and defined for negative values as well as positive."
    s["alt"] = s["alt"].replace(
        "Every curve lies entirely to the right of zero, because a chi-square statistic is a sum "
        "of squares and can never be negative.",
        "Each curve extends to both sides of zero and is symmetric about its centre.")
    s["alt"] = s["alt"].replace(
        "so all three are skewed right rather than symmetric", "so all three are symmetric")
    c["CONTROL-D5-chi-square-called-symmetric"] = s

    return c


def function_plot_controls(specs: dict) -> dict:
    """Controls for the AP Precalculus / Calculus AB function_plot batch.

    F2, F3 and F5 pass verify.py cleanly.
    """
    c = {}

    # P1 the "even multiplicity" zero made simple, so the graph CROSSES where
    # the figure says it is tangent. verify.py CATCHES this.
    s = copy.deepcopy(specs["precalc-even-multiplicity-zero"])
    s["params"]["curves"][0]["coeffs"] = [2.0, 1.0, -2.0, 1.0]   # (x+2)(x-1)(x-?) no longer tangent
    c["CONTROL-P1-tangent-zero-actually-crosses"] = s

    # P2 the transformation rule stated backwards in the figure's own text:
    # f(x + h) said to move the graph h units in the SAME direction as the
    # sign. The curves are untouched, so this PASSES.
    s = copy.deepcopy(specs["precalc-transformations-additive"])
    s["note"] = "Inside the function, the shift goes the SAME way as the sign."
    s["alt"] = s["alt"].replace(
        "A change to the output moves the graph the way the sign reads; a change to the input "
        "moves it the opposite way, so adding a negative number inside shifts right rather than "
        "left.",
        "A change to the input moves the graph the way the sign reads, so adding a negative number "
        "inside shifts the graph left.")
    c["CONTROL-P2-inside-shift-stated-backwards"] = s

    # P3 the hole described as a point the function DOES take. The open circle
    # is untouched, so this PASSES the suite while contradicting the drawing.
    s = copy.deepcopy(specs["precalc-hole"])
    s["note"] = "The function is defined at x = 2, where r(2) = 4."
    s["alt"] = s["alt"].replace(
        "The circle is drawn open, not filled, because the function does not take that value: a "
        "filled dot would say the opposite.",
        "The circle marks the value the function takes at x equals two, namely four.")
    c["CONTROL-P3-hole-called-a-value"] = s

    # P4 the sequence joined into a curve, which asserts values between the
    # whole numbers. verify.py CATCHES this.
    s = copy.deepcopy(specs["precalc-sequence"])
    s["params"]["curves"] = [{"kind": "polynomial", "coeffs": [1.0, 2.0]}]
    c["CONTROL-P4-sequence-drawn-as-a-curve"] = s

    # P5 the cotangent described as having the same excluded band as the
    # secant and cosecant, which it does not. The curve is untouched: PASSES.
    s = copy.deepcopy(specs["precalc-cotangent-graph"])
    s["note"] = "Range excludes everything strictly between \u22121 and 1, as for secant and cosecant."
    s["alt"] = s["alt"].replace(
        "Unlike the secant and the cosecant there is no excluded band: a cotangent branch passes "
        "through every real value between its two asymptotes.",
        "Like the secant and the cosecant, no part of the graph lies strictly between minus one "
        "and one.")
    c["CONTROL-P5-cotangent-given-an-excluded-band"] = s

    return c


def laneb_gap_controls(specs: dict) -> dict:
    """Controls for the five Lane B gap figures.

    These three families are built so that the DRAWING cannot be wrong -- the
    DNA pairing is derived, the membrane's geometry follows from the kind of
    inclusion, every arrow in the cell follows from which side the anode is on.
    So the errors a reader has to catch here are the ones that live in the gap
    between a correct drawing and the words wrapped around it, which is exactly
    where a property test cannot go. G2, G3 and G4 pass verify.py cleanly.
    """
    c = {}

    # G1 the double helix described as parallel rather than antiparallel, which
    # is the entry's whole second item. verify.py CATCHES this.
    s = copy.deepcopy(specs["bio-dna-antiparallel"])
    s["alt"] = s["alt"].replace(
        "The arrowheads point opposite ways: the top strand's 3' end is on the right and the "
        "bottom strand's 3' end is on the left, which is what antiparallel means.",
        "The arrowheads point the same way, because both strands run from their 5' end on the "
        "left to their 3' end on the right.")
    s["note"] = "Both strands run 5' to 3' in the same direction."
    c["CONTROL-G1-strands-called-parallel"] = s

    # G2 the proton gradient reversed in the text: high in the matrix, low
    # outside. The drawing is untouched, so this PASSES the suite -- and it
    # reverses the direction ATP synthase actually runs.
    s = copy.deepcopy(specs["bio-mitochondrion"])
    s["alt"] = s["alt"].replace(
        "it has the lower proton concentration and the higher pH",
        "it has the high proton concentration and the lower pH")
    s["alt"] = s["alt"].replace(
        "The narrow region between the two membranes holds the high proton concentration.",
        "The narrow region between the two membranes holds the lower proton concentration.")
    s["note"] = "Protons high in the matrix, low outside the inner membrane."
    s["params"]["labels_at"][0]["label"] = "intermembrane space \u2014 low H\u207a"
    s["params"]["labels_at"][1]["label"] = "matrix \u2014 Krebs cycle, high H\u207a"
    c["CONTROL-G2-proton-gradient-reversed"] = s

    # G3 the carbohydrate chains said to be on the cytoplasmic face, while the
    # figure draws every one of them on the extracellular face. The geometry is
    # untouched, so this PASSES.
    s = copy.deepcopy(specs["bio-fluid-mosaic"])
    s["alt"] = s["alt"].replace(
        "both carbohydrate chains are on the extracellular face, never the cytoplasmic one",
        "both carbohydrate chains are on the cytoplasmic face, never the extracellular one")
    s["note"] = "Heads to the water, tails to each other; the sugar chains are all on the inside face."
    c["CONTROL-G3-sugars-put-on-the-inside-face"] = s

    # G4 the anode moved to the right-hand half-cell, so every derived arrow
    # follows it -- but the labels still call the LEFT electrode the anode. The
    # electrons now run toward the electrode labelled "anode -- oxidation".
    # Everything the suite checks is internally consistent, so this PASSES.
    s = copy.deepcopy(specs["chem-electrochemical-cell"])
    s["params"]["anode_side"] = "right"
    c["CONTROL-G4-anode-label-on-the-cathode"] = s

    # G5 each granum drawn as a single thylakoid, which denies that a granum is
    # a STACK of them -- the entry's own distinction. verify.py CATCHES this.
    s = copy.deepcopy(specs["bio-chloroplast"])
    s["params"]["discs_per_stack"] = 1
    s["params"]["unit_note"] = "each granum is a single thylakoid disc"
    c["CONTROL-G5-granum-drawn-as-one-disc"] = s

    return c


def next1_controls(specs: dict) -> dict:
    """Controls for the first batch of the chart-shaped lane outside kind='diagram'.

    Two figures, both on families that already existed, both on entries that author
    no items[] (DECISION-0116 route b). N1, N2 and N4 pass verify.py cleanly, so they measure
    whether a reader adds anything over the suite; N3 and N5 are ones the suite catches.
    """
    c = {}

    # N1 the series labels swapped: the BROADER curve is called the lower
    # temperature. Geometry and thetas are untouched, so the suite passes, and a
    # student would learn that cooling spreads the energy out.
    s = copy.deepcopy(specs["chem-mb-entropy"])
    s["params"]["series"][0]["label"], s["params"]["series"][1]["label"] = \
        "Higher temperature", "Lower temperature"
    c["CONTROL-N1-temperature-labels-swapped"] = s

    # N2 the conclusion reversed in words: the drawing is untouched.
    s = copy.deepcopy(specs["chem-mb-entropy"])
    s["subtitle"] = "The same gas at two temperatures: the hotter distribution is narrower"
    s["note"] = "A narrower distribution means the energy is less dispersed, so the entropy is smaller at higher temperature."
    s["alt"] = s["alt"].replace(
        "The higher-temperature curve has a lower peak and is broader and shifted to higher energy, so the kinetic energy is spread over a wider range of values.",
        "The higher-temperature curve has a taller peak and is narrower, so the kinetic energy is concentrated in a smaller range of values.")
    c["CONTROL-N2-dispersal-conclusion-reversed"] = s

    # N3 both curves drawn at the SAME temperature but still labelled lower and
    # higher: the picture shows no broadening at all while the words promise it.
    # (Run 1 used a speed-for-energy axis relabelling here; both readers accepted
    # it, correctly -- a distribution that broadens with temperature broadens
    # whether it is plotted against speed or energy, so nothing false was taught.
    # The control was the defect, per protocol 4c. verify.py CATCHES this one.)
    s = copy.deepcopy(specs["chem-mb-entropy"])
    s["params"]["series"][1]["theta"] = s["params"]["series"][0]["theta"]
    c["CONTROL-N3-both-curves-the-same-temperature"] = s

    # N4 the reaction coordinate defined as elapsed time. The drawing is the same
    # curve; the entry's whole point is that the axis is a path of motions, not a
    # clock. The suite does not read the axis title, so this passes.
    s = copy.deepcopy(specs["chem-reaction-coordinate"])
    s["x_label"] = "time"
    s["subtitle"] = "The axis along which time passes as the reaction runs"
    s["alt"] = s["alt"].replace(
        "The horizontal axis is the reaction coordinate, the path of the motions that turn reactants into products.",
        "The horizontal axis is time, the number of seconds since the reactants were mixed.")
    c["CONTROL-N4-coordinate-called-time"] = s

    # N5 the alt text calls the drawn exothermic profile endothermic. verify.py
    # CATCHES this one (the alt/direction check).
    s = copy.deepcopy(specs["chem-reaction-coordinate"])
    s["alt"] = s["alt"].replace("so this example is exothermic", "so this example is endothermic")
    s["alt"] = s["alt"].replace("a product level below the reactants", "a product level above the reactants")
    c["CONTROL-N5-direction-of-change-reversed"] = s

    return c


def next2_controls(specs: dict) -> dict:
    """Controls for batch 2 of the chart-shaped lane: four AP Statistics figures on the
    bar-chart family. All five pass verify.py cleanly (the family's tests pin geometry,
    not meaning), so every one measures whether a reader adds anything over the suite."""
    c = {}

    # M1 the empty bin filled in, while the words still describe a gap: the picture
    # no longer shows one.
    s = copy.deepcopy(specs["stats-gap-histogram"])
    s["params"]["counts"] = [7, 14, 9, 2, 5, 3]
    c["CONTROL-M1-gap-bin-is-not-empty"] = s

    # M2 a gap defined as the interval holding the MOST data: the drawing is the
    # same empty bin, the definition is backwards.
    s = copy.deepcopy(specs["stats-gap-histogram"])
    s["subtitle"] = "One interval between two values holds the most observations"
    s["note"] = "A gap is the interval with the most observed data, so it is the tallest bar."
    s["alt"] = s["alt"].replace(
        "so the bin from 40 to 50 years has no bar: no customer in the data is between those two ages. That empty interval between two filled ones is a gap.",
        "so the bin from 20 to 30 years has the tallest bar, which is the gap.")
    s["params"]["measure"]["label"] = "gap: most data"
    c["CONTROL-M2-gap-defined-as-the-most-data"] = s

    # M3 the two classes' numbers swapped against their labels: Class A is labelled
    # as the 40-student class but carries Class B's relative frequencies.
    s = copy.deepcopy(specs["stats-compare-two-datasets"])
    s["params"]["table"] = [s["params"]["table"][1], s["params"]["table"][0]]
    c["CONTROL-M3-class-data-swapped-against-labels"] = s

    # M4 equal distributions, called different.
    s = copy.deepcopy(specs["stats-association-no"])
    s["title"] = "Distributions that differ: associated in these data"
    s["subtitle"] = "The pass rate differs between the two levels"
    s["note"] = "Compare the distribution of the response within each level of the other variable; here the two differ."
    s["alt"] = s["alt"].replace("are the same, so in these data the variables are not associated",
                                "differ, so in these data the variables are associated")
    c["CONTROL-M4-equal-distributions-called-different"] = s

    # M5 association read as causation: the picture and the data are untouched; the
    # words add a claim an association cannot support.
    s = copy.deepcopy(specs["stats-association-yes"])
    s["note"] = "Students with a part-time job pass less often, which shows that the job causes them to fail."
    s["alt"] = s["alt"].replace("so in these data the variables are associated.",
                                "so the part-time job causes the lower pass rate.")
    c["CONTROL-M5-association-read-as-causation"] = s

    return c


def next3_controls(specs: dict) -> dict:
    """Controls for batch 3: six AP Statistics density figures on skew direction and on the
    mean versus the median. The curve checks in verify.py read the CURVE, so a control that
    changes only the words passes the suite; all five here are of that kind."""
    c = {}

    # K1 a right-skewed curve called skewed left, with the tail text changed to match.
    s = copy.deepcopy(specs["stats-skew-right"])
    s["title"] = "Skewed left: the longer tail is on the left"
    s["subtitle"] = "The tail toward smaller values is longer"
    s["note"] = "Skew is named for the longer tail; here the longer tail is on the left."
    s["alt"] = s["alt"].replace("a long tail stretching to the right toward larger values", "a long tail stretching to the left toward smaller values").replace("The right tail is clearly longer than the left tail, so the distribution is skewed right.", "The left tail is clearly longer than the right tail, so the distribution is skewed left.")
    s["params"]["texts"][0]["label"] = "longer left tail"
    c["CONTROL-K1-right-skewed-curve-called-skewed-left"] = s

    # K2 the two dashed lines named the wrong way round: the picture shows the mean left
    # of the median in a right-skewed curve.
    s = copy.deepcopy(specs["stats-mean-median-right"])
    s["params"]["texts"][0]["label"], s["params"]["texts"][1]["label"] = "mean (left line)", "median (right line)"
    s["alt"] = s["alt"].replace("The median is the left line, at about 3.4, and the mean is the right line, at about 4.0, so the mean is larger than the median.", "The mean is the left line, at about 3.4, and the median is the right line, at about 4.0, so the mean is smaller than the median.")
    c["CONTROL-K2-mean-and-median-lines-swapped"] = s

    # K3 the conclusion reversed in the words of a left-skewed figure.
    s = copy.deepcopy(specs["stats-mean-median-left"])
    s["note"] = "In a left-skewed distribution the mean is usually larger than the median."
    s["subtitle"] = "The long left tail pulls the mean toward larger values (figure 1 of 3)"
    s["alt"] = s["alt"].replace("so the mean is smaller than the median. The long left tail pulls the mean toward smaller values.", "so the mean is larger than the median. The long left tail pulls the mean toward larger values.")
    c["CONTROL-K3-left-skew-mean-called-larger"] = s

    # K4 the classic misconception: skew named for the side where the peak is.
    s = copy.deepcopy(specs["stats-skew-left"])
    s["title"] = "Skewed right: the peak is on the right"
    s["note"] = "Skew is named for the side where most of the data are, so a peak on the right means skewed right."
    s["alt"] = s["alt"].replace("The left tail is clearly longer than the right tail, so the distribution is skewed left. The skew is named for the longer tail, not for the side where the peak is.", "The peak is on the right, so the distribution is skewed right. The skew is named for the side where the peak is.")
    s["params"]["texts"][0]["label"] = "peak on the right"
    c["CONTROL-K4-skew-named-for-the-peak-side"] = s

    # K5 mean and median called far apart on a figure that draws one line.
    s = copy.deepcopy(specs["stats-mean-median-symmetric"])
    s["note"] = "In a symmetric distribution the mean is usually much larger than the median."
    s["alt"] = s["alt"].replace("The mean and the median are at the same place, so they are close together.", "The mean is much larger than the median, so they are far apart.")
    c["CONTROL-K5-symmetric-mean-called-far-from-median"] = s

    return c


CONTROL_SETS = {"chem-": controls, "stats-": stats_controls, "lane-a-rest": physics_controls,
                "lane-a-gaps": gaps_controls,
                "lane-b-arrows": arrow_controls,
                "lane-b-particulate": particulate_controls,
                "lane-b-fields": field_controls,
                "stats-density": density_controls,
                "function-plot": function_plot_controls,
                "lane-b-gaps": laneb_gap_controls,
                "lane-a-next1": next1_controls,
                "lane-a-next2": next2_controls,
                "lane-a-next3": next3_controls}


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
    ctl_specs = CONTROL_SETS[args.controls or args.prefix](allspecs)

    # A control has to be a mistake a READER can see. One control changed only
    # the order of a figure's isoline radii: the same four circles are drawn,
    # so the picture is identical and nothing false is taught. A reader
    # accepted it, correctly, and voided a batch that was sound. Refuse to run
    # a control whose rendered output is a pure reordering of the original's
    # elements, or whose text is unchanged when its drawing is.
    import render as _R
    for cid, cs in ctl_specs.items():
        base = allspecs.get(cs["figure_id"])
        if not base:
            continue
        a, b = _R.render(base), _R.render(cs)
        if a == b:
            raise SystemExit(f"control {cid} renders identically to {cs['figure_id']}: "
                             f"it tests nothing")
        # Whole elements, not fragments: splitting on ">" shreds each tag into
        # an attribute part and a text part, so two figures that swap the
        # CONTENTS of two elements compare equal and a real control is refused.
        els = lambda v: sorted(re.findall(r"<[^>]+>[^<]*", v))
        if els(a) == els(b) and \
           (cs.get("alt"), cs.get("note"), cs.get("subtitle")) == \
           (base.get("alt"), base.get("note"), base.get("subtitle")):
            raise SystemExit(
                f"control {cid} only REORDERS what {cs['figure_id']} draws and says nothing "
                f"different: a student sees the same figure, so accepting it is correct and "
                f"the control would void the batch for no reason")

    items = {**specs, **ctl_specs}
    if args.only:
        items = {k: v for k, v in items.items() if args.only in k}

    log_dir = HERE / "out" / "ced_check_logs"
    out, t0 = {}, time.time()
    for sid, spec in items.items():
        # Keyed by subject AND title: two published entries are both called
        # "Vector arrow representation", so a title-only lookup would show the
        # reader the wrong subject's claim.
        entry = entries.get(f"{spec.get('subject_key')}::{spec['entry_title']}", {})
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
