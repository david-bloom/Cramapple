#!/usr/bin/env python3
"""Generate draw-ready AP Biology hand-drawn graph question slots.

The output is intentionally deterministic so reviewer/upload metadata can be
recreated from source. These are research seed prompts, not production-approved
content packages.

v0.2 data realism (2026-06-30)
------------------------------
v0.1 (the ``hand_drawn_graph_corpus_2026_06_29`` package, item-ID prefix
``HDG-2026-P1-*``) produced analytic, perfectly clean data: SEM was an
arithmetic formula rather than a replicate-derived statistic, most x-grids were
uniform, exponential/plateau models emitted ugly decimal table values that
forced drawers to transcribe numbers like ``15.74``, and the categorical branch
recycled only five hardcoded mean-shapes across fifty items.

v0.2 fixes this so the gold is not unrealistically clean:

- every displayed mean and SEM is derived from seeded synthetic *replicate*
  observations (mean and SEM are auditable and reproduce exactly);
- two noise scales are used: between-condition scatter moves points off the
  smooth model, and within-condition replicate spread produces a legitimate,
  irregular SEM;
- x-grids are non-uniform but clean (no ``0.15`` steps), and vary across items;
- displayed table values are round-ish (integer means, one-decimal SEM) so
  transcription is not itself the assessed task; and
- shapes are RNG-varied per item instead of a small recycled set.

This generator writes a NEW package and does NOT overwrite v0.1. The already-
captured hand-drawn pages remain bound to the frozen v0.1 ``P1`` items. v0.2
uses the ``P2`` prefix so a freshly drawn page is never ambiguous about which
gold version it belongs to.
"""

from __future__ import annotations

import csv
import json
import math
import random
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]

# --- Corpus version parameters -------------------------------------------------
# To regenerate v0.1 in place instead, point these back at the 2026_06_29 dir,
# set VERSION="v0.1-research-seed" and PHASE="P1". Default is a fresh v0.2 package
# that leaves v0.1 untouched.
DATE_TAG = "2026_06_30"
VERSION = "v0.2-research-seed"
PHASE = "P2"
SEED_BASE = 20260630
REPLICATE_N = 5

OUT_DIR = ROOT / "docs" / "research" / f"hand_drawn_graph_corpus_{DATE_TAG}"
JSONL_PATH = OUT_DIR / f"hand_drawn_graph_questions_{DATE_TAG}.jsonl"
CSV_PATH = OUT_DIR / f"hand_drawn_graph_questions_{DATE_TAG}.csv"
INTAKE_PATH = OUT_DIR / f"supabase_content_intake_payload_{DATE_TAG}.json"
README_PATH = OUT_DIR / "README.md"


MODULES = {
    "cat": ["AP Biology", "data analysis", "experimental design", "graph construction"],
    "series": ["AP Biology", "data analysis", "quantitative graphing", "response curves"],
    "estimate": ["AP Biology", "data analysis", "graph-derived estimates", "model interpretation"],
}


def rounded(value: float, places: int = 2) -> float:
    return round(value + 1e-9, places)


def make_rng(item_index: int) -> random.Random:
    """Deterministic per-item RNG so scatter reproduces exactly."""
    return random.Random(SEED_BASE * 1000 + item_index)


def _sample_mean(values: list[float]) -> float:
    return sum(values) / len(values)


def _sample_sem(values: list[float]) -> float:
    n = len(values)
    if n < 2:
        return 0.0
    mean = _sample_mean(values)
    variance = sum((v - mean) ** 2 for v in values) / (n - 1)
    return (variance ** 0.5) / (n ** 0.5)


def replicate_point(
    rng: random.Random,
    center: float,
    *,
    scatter_sigma: float,
    within_sigma: float,
    sem_floor: float = 0.3,
    allow_negative: bool = False,
    mean_min: float = 1.0,
) -> dict[str, object]:
    """Build one measured point from seeded synthetic replicates.

    ``center`` is the smooth-model value. ``scatter_sigma`` shifts the displayed
    mean off the model (between-condition noise). ``within_sigma`` sets the
    replicate spread that produces the SEM.
    """
    displayed_mean = center + rng.gauss(0.0, scatter_sigma)
    if not allow_negative:
        displayed_mean = max(mean_min, displayed_mean)
    displayed_mean = float(round(displayed_mean))

    replicates = [round(displayed_mean + rng.gauss(0.0, within_sigma), 1) for _ in range(REPLICATE_N)]
    raw_mean = _sample_mean(replicates)
    raw_sem = _sample_sem(replicates)
    displayed_sem = max(sem_floor, round(raw_sem, 1))

    return {
        "true_model_value": rounded(center, 3),
        "displayed_mean": displayed_mean,
        "displayed_sem": displayed_sem,
        "replicates": replicates,
        "raw_replicate_mean": rounded(raw_mean, 3),
        "raw_replicate_sem": rounded(raw_sem, 3),
    }


def table_to_markdown(rows: list[dict[str, object]]) -> str:
    headers = list(rows[0].keys())
    out = ["| " + " | ".join(headers) + " |", "| " + " | ".join(["---"] * len(headers)) + " |"]
    for row in rows:
        out.append("| " + " | ".join(str(row[h]) for h in headers) + " |")
    return "\n".join(out)


def common_record(
    *,
    item_id: str,
    archetype: str,
    relation_subtype: str | None,
    stem: str,
    display_table: list[dict[str, object]],
    expected_graph_spec: dict[str, object],
    criterion_definitions: list[dict[str, str]],
    synthetic_data_source: str,
    synthetic_data: dict[str, object],
    modules: list[str],
    subtopics: list[str],
) -> dict[str, object]:
    expected_filename = f"{item_id}__response-01.jpg"
    canonical_answer = (
        f"Expected graph: {expected_graph_spec['representation']}; "
        f"x-axis {expected_graph_spec['x_axis']}; "
        f"y-axis {expected_graph_spec['y_axis']}. "
        f"Required criteria: "
        f"{', '.join(c['criterion_id'] for c in criterion_definitions)}."
    )
    notes = (
        "Research seed for hand-drawn graph capture and reviewer evaluation. "
        "Do not expose criterion definitions to the person drawing the graph."
    )
    return {
        "item_id": item_id,
        "item_version": VERSION,
        "question_type": "frq",
        "frq_form": "short",
        "review_stage": "canonical_answer",
        "archetype": archetype,
        "relation_subtype": relation_subtype,
        "expected_image_filename": expected_filename,
        "student_prompt": stem,
        "stem": stem,
        "display_table": display_table,
        "expected_graph_spec": expected_graph_spec,
        "criterion_definitions": criterion_definitions,
        "canonical_answer": canonical_answer,
        "synthetic_data_source": synthetic_data_source,
        "synthetic_data": synthetic_data,
        "modules": modules,
        "subtopics": subtopics,
        "rights_status": "independently_authored_synthetic_research_seed_unverified",
        "capture_instruction": (
            "Draw one graph on one page. Write only the item ID at the top of the page, "
            "then photograph the full page with all graph evidence visible."
        ),
        "notes": notes,
    }


def categorical_means(rng: random.Random, lo: int, hi: int) -> list[int]:
    """Four distinct, well-separated means in a varied (non-recycled) order."""
    while True:
        vals = sorted(rng.randint(lo, hi) for _ in range(4))
        if all(vals[i + 1] - vals[i] >= 4 for i in range(3)):
            break
    orderings = [
        vals,
        vals[::-1],
        [vals[0], vals[2], vals[1], vals[3]],
        [vals[1], vals[0], vals[3], vals[2]],
        [vals[2], vals[0], vals[3], vals[1]],
        [vals[1], vals[3], vals[0], vals[2]],
    ]
    return list(rng.choice(orderings))


def categorical_records() -> list[dict[str, object]]:
    # (name, y_label, unit, categories, (y_lo, y_hi))
    contexts = [
        ("chlorophyll absorbance", "absorbance at 540 nm", "a.u.", ["low blue", "moderate blue", "high blue", "mixed light"], (16, 70)),
        ("leaf pore density", "stomatal density", "stomata/mm^2", ["deep shade", "partial shade", "open sun", "reflected sun"], (20, 88)),
        ("membrane leakage", "conductivity after 10 min", "uS/cm", ["isotonic", "mild salt", "moderate salt", "high salt"], (15, 80)),
        ("root tip mitosis", "mitotic cells", "%", ["cool", "room temp", "warm", "heat stress"], (8, 46)),
        ("enzyme product", "product formed in 5 min", "umol", ["pH 5", "pH 6", "pH 7", "pH 8"], (12, 78)),
        ("seed germination", "germination", "%", ["dark", "red light", "blue light", "white light"], (10, 92)),
        ("yeast respiration", "CO2 produced", "mL", ["no sugar", "glucose", "sucrose", "starch"], (6, 60)),
        ("chloroplast settling", "green layer thickness", "mm", ["control", "low salt", "medium salt", "high salt"], (8, 44)),
        ("callus growth", "mass gain", "mg", ["no auxin", "low auxin", "medium auxin", "high auxin"], (15, 85)),
        ("water loss", "mass lost in 30 min", "mg", ["still air", "fan low", "fan medium", "fan high"], (18, 90)),
    ]
    records: list[dict[str, object]] = []
    for i in range(50):
        rng = make_rng(1000 + i)
        name, y_label, unit, cats, (lo, hi) = contexts[i % len(contexts)]
        true_means = categorical_means(rng, lo, hi)

        points = []
        rows = []
        for j, cat in enumerate(cats):
            center = float(true_means[j])
            pt = replicate_point(
                rng,
                center,
                scatter_sigma=0.0,  # categorical means ARE the conditions; no off-model scatter
                within_sigma=max(0.8, 0.05 * center),
            )
            pt["category"] = cat
            points.append(pt)
            rows.append({
                "Treatment": cat,
                f"Mean {y_label} ({unit})": pt["displayed_mean"],
                f"SEM ({unit})": pt["displayed_sem"],
            })

        item_id = f"HDG-2026-{PHASE}-CAT-{i + 1:03d}"
        stem = (
            f"Researchers measured {name} for four treatment groups. Use the data table to construct a graph "
            f"that compares the group means. Include a categorical x-axis with the treatments in table order, "
            f"a y-axis labeled with units, plotted means, and symmetric error bars showing plus or minus one SEM.\n\n"
            f"Write the item ID {item_id} at the top of your page.\n\n{table_to_markdown(rows)}"
        )
        records.append(
            common_record(
                item_id=item_id,
                archetype="categorical_comparison_supplied_uncertainty",
                relation_subtype=None,
                stem=stem,
                display_table=rows,
                expected_graph_spec={
                    "representation": "categorical point-with-whisker or bar-with-whisker graph",
                    "x_axis": "treatment category in table order",
                    "y_axis": f"{y_label} ({unit})",
                    "required_uncertainty": "symmetric plus/minus one SEM bars",
                    "accepted_variants": ["points with whiskers", "bars with whiskers"],
                },
                criterion_definitions=[
                    {"criterion_id": "REPRESENTATION_TYPE", "met_rule": "Uses accepted categorical graph representation."},
                    {"criterion_id": "CATEGORY_IDENTITY", "met_rule": "All four treatments are identifiable in table order or clearly mapped."},
                    {"criterion_id": "Y_UNIT", "met_rule": "Y-axis includes the required variable and unit."},
                    {"criterion_id": "Y_SCALE", "met_rule": "Y-scale is interpretable and can represent all means and SEM bars."},
                    {"criterion_id": "PLOT_VALUES", "met_rule": "All four means are plotted at recoverable positions."},
                    {"criterion_id": "UNCERTAINTY_MARKS", "met_rule": "Each mean has centered symmetric plus/minus SEM bars."},
                ],
                synthetic_data_source=(
                    f"Seeded replicate categorical generator (seed_base={SEED_BASE}, item_seed={1000 + i}, "
                    f"n={REPLICATE_N}); means and SEM derived from synthetic replicates."
                ),
                synthetic_data={
                    "method": "seeded_replicate_v2",
                    "model": "categorical_independent_conditions",
                    "item_seed": 1000 + i,
                    "replicate_n": REPLICATE_N,
                    "points": points,
                },
                modules=MODULES["cat"],
                subtopics=[name, "categorical comparison", "SEM error bars"],
            )
        )
    return records


def continuous_records() -> list[dict[str, object]]:
    # (name, x_label, x_unit, y_label, y_unit, clean_non_uniform_x_pool)
    contexts = [
        ("enzyme reaction rate", "temperature", "deg C", "reaction rate", "umol/min", [5, 10, 15, 20, 28, 35, 42, 50, 55, 60]),
        ("photosynthetic oxygen release", "light intensity", "umol photons/m^2/s", "oxygen release", "umol O2/min", [0, 50, 100, 200, 350, 500, 700, 900, 1100, 1400]),
        ("pigment absorbance", "wavelength", "nm", "absorbance", "a.u.", [400, 430, 460, 490, 520, 550, 580, 610, 640, 660]),
        ("seedling growth", "days after planting", "days", "height", "cm", [0, 1, 2, 3, 5, 7, 9, 11, 12, 14]),
        ("heart cell contraction", "calcium concentration", "mM", "contractions per min", "beats/min", [0.2, 0.5, 1, 1.5, 2, 3, 4, 5, 6, 8]),
        ("fermentation rate", "incubation time", "min", "CO2 production rate", "mL/min", [0, 2, 5, 8, 12, 16, 20, 25, 30, 40]),
        ("aquatic plant growth", "nitrate concentration", "mg/L", "growth rate", "mg/day", [0, 2, 5, 10, 15, 25, 40, 60, 80, 100]),
        ("membrane transport", "external glucose", "mM", "uptake rate", "pmol/min", [0, 1, 2, 3, 5, 8, 12, 16, 20, 25]),
        ("cell survival", "UV exposure time", "s", "surviving cells", "%", [0, 10, 20, 30, 45, 60, 80, 100, 120, 150]),
        ("enzyme activity", "pH", "pH units", "relative activity", "%", [4, 5, 6, 7, 8, 9, 10, 11]),
    ]
    records: list[dict[str, object]] = []
    for i in range(50):
        rng = make_rng(2000 + i)
        name, x_label, x_unit, y_label, y_unit, x_pool = contexts[i % len(contexts)]
        xs = sorted(rng.sample(x_pool, 7))
        x_lo, x_hi, x_span = xs[0], xs[-1], (xs[-1] - xs[0]) or 1.0
        mode = i % 4

        if mode == 0:  # single-peak optimum
            peak_x = rng.uniform(xs[1], xs[-2])
            spread = x_span / rng.uniform(2.6, 3.6)
            amp = rng.uniform(34, 54)
            base = rng.uniform(5, 12)
            def model(x: float, *, peak_x: float = peak_x, spread: float = spread, amp: float = amp, base: float = base) -> float:
                return base + amp * math.exp(-((x - peak_x) ** 2) / (2 * spread ** 2))
            shape = f"peak(center={rounded(peak_x,2)},spread={rounded(spread,2)},amp={rounded(amp,2)},base={rounded(base,2)})"
        elif mode == 1:  # saturating rise
            ymax = rng.uniform(34, 56)
            scale = x_span / rng.uniform(2.0, 3.0)
            def model(x: float) -> float:
                return ymax * (1 - math.exp(-(x - x_lo) / scale))
            shape = f"saturating(ymax={rounded(ymax,2)},scale={rounded(scale,2)})"
        elif mode == 2:  # exponential decay
            start = rng.uniform(55, 80)
            scale = x_span / rng.uniform(1.8, 2.8)
            floor = rng.uniform(3, 9)
            def model(x: float) -> float:
                return floor + (start - floor) * math.exp(-(x - x_lo) / scale)
            shape = f"decay(start={rounded(start,2)},scale={rounded(scale,2)},floor={rounded(floor,2)})"
        else:  # roughly linear increase
            intercept = rng.uniform(10, 20)
            top = intercept + rng.uniform(28, 48)
            def model(x: float) -> float:
                return intercept + (top - intercept) * (x - x_lo) / x_span
            shape = f"linear(intercept={rounded(intercept,2)},top={rounded(top,2)})"

        points = []
        rows = []
        for x in xs:
            center = model(float(x))
            pt = replicate_point(
                rng,
                center,
                scatter_sigma=max(1.0, 0.06 * center),
                within_sigma=max(0.8, 0.05 * center),
            )
            pt["x"] = x
            points.append(pt)
            rows.append({
                f"{x_label} ({x_unit})": x,
                f"Mean {y_label} ({y_unit})": pt["displayed_mean"],
                f"SEM ({y_unit})": pt["displayed_sem"],
            })

        item_id = f"HDG-2026-{PHASE}-SER-{i + 1:03d}"
        stem = (
            f"Researchers measured {name} at several values of {x_label}. Use the data table to construct a graph "
            f"with {x_label} on the x-axis and mean {y_label} on the y-axis. Plot each mean at its measured x-value, "
            f"connect adjacent measured values, and include symmetric error bars showing plus or minus one SEM.\n\n"
            f"Write the item ID {item_id} at the top of your page.\n\n{table_to_markdown(rows)}"
        )
        records.append(
            common_record(
                item_id=item_id,
                archetype="continuous_measured_series_supplied_uncertainty",
                relation_subtype=None,
                stem=stem,
                display_table=rows,
                expected_graph_spec={
                    "representation": "continuous measured series with connected adjacent points",
                    "x_axis": f"{x_label} ({x_unit})",
                    "y_axis": f"mean {y_label} ({y_unit})",
                    "required_uncertainty": "symmetric plus/minus one SEM bars",
                    "accepted_variants": ["points connected by line segments"],
                },
                criterion_definitions=[
                    {"criterion_id": "REPRESENTATION_TYPE", "met_rule": "Uses a continuous x-axis graph with plotted points."},
                    {"criterion_id": "X_UNIT", "met_rule": "X-axis includes the required variable and unit."},
                    {"criterion_id": "Y_UNIT", "met_rule": "Y-axis includes the required variable and unit."},
                    {"criterion_id": "X_SCALE", "met_rule": "Numeric x positions are proportional and interpretable."},
                    {"criterion_id": "Y_SCALE", "met_rule": "Y-scale is interpretable and can represent all means and SEM bars."},
                    {"criterion_id": "PLOT_VALUES", "met_rule": "All measured means are plotted at recoverable coordinates."},
                    {"criterion_id": "POINT_CONNECTION", "met_rule": "Adjacent measured values are connected without replacing points."},
                    {"criterion_id": "UNCERTAINTY_MARKS", "met_rule": "Each mean has centered symmetric plus/minus SEM bars."},
                ],
                synthetic_data_source=(
                    f"Seeded replicate continuous generator (item_seed={2000 + i}, n={REPLICATE_N}); model={shape}; "
                    f"means scattered off model, SEM derived from replicates."
                ),
                synthetic_data={
                    "method": "seeded_replicate_v2",
                    "model": shape,
                    "item_seed": 2000 + i,
                    "replicate_n": REPLICATE_N,
                    "points": points,
                },
                modules=MODULES["series"],
                subtopics=[name, "continuous measured series", "SEM error bars"],
            )
        )
    return records


def estimate_records() -> list[dict[str, object]]:
    # zero-intercept: (name, x_label, x_unit, y_label, y_unit, clean_x_grid bracketing the crossing,
    #                  (intercept_lo, intercept_hi), (abs_slope_lo, abs_slope_hi))
    zero_contexts = [
        ("water movement in model cells", "external solute concentration", "M", "percent mass change", "%", [0.0, 0.1, 0.2, 0.3, 0.4, 0.6, 0.8], (0.30, 0.50), (38, 60)),
        ("dialysis bag mass change", "sucrose concentration", "M", "percent mass change", "%", [0.0, 0.1, 0.2, 0.35, 0.5, 0.7, 0.9], (0.35, 0.55), (34, 52)),
        ("plant tissue osmosis", "external salt concentration", "%", "percent mass change", "%", [0.0, 0.5, 1.0, 1.5, 2.0, 3.0, 4.0], (1.4, 2.4), (8, 14)),
        ("enzyme inhibitor response", "inhibitor concentration", "mM", "change from control", "%", [0, 2, 5, 8, 12, 18, 25], (8, 14), (2.2, 3.4)),
        ("microbial growth balance", "antibiotic concentration", "ug/mL", "net growth change", "%", [0, 1, 2, 4, 8, 12, 16], (5, 9), (4.0, 6.5)),
    ]
    # plateau: (name, x_label, x_unit, y_label, y_unit, clean_non_uniform_time_grid, (plateau_lo, plateau_hi), (rate_lo, rate_hi))
    plateau_contexts = [
        ("microbial culture density", "time", "hr", "culture density", "10^5 cells/mL", [0, 1, 2, 4, 6, 9, 12], (28, 50), (0.30, 0.55)),
        ("transport protein uptake", "substrate concentration", "mM", "uptake rate", "pmol/min", [0, 1, 2, 4, 7, 10, 14], (30, 52), (0.25, 0.50)),
        ("photosynthetic rate", "light intensity", "umol photons/m^2/s", "oxygen release", "umol O2/min", [0, 50, 120, 250, 450, 700, 1000], (26, 48), (0.004, 0.009)),
        ("enzyme product formation", "time", "min", "product concentration", "uM", [0, 2, 5, 9, 14, 20, 28], (24, 46), (0.12, 0.24)),
        ("population growth in a flask", "time", "hr", "population density", "10^5 cells/mL", [0, 1, 3, 5, 8, 11, 15], (30, 50), (0.22, 0.42)),
    ]
    records: list[dict[str, object]] = []
    for i in range(50):
        item_id = f"HDG-2026-{PHASE}-EST-{i + 1:03d}"
        rng = make_rng(3000 + i)
        if i < 25:
            name, x_label, x_unit, y_label, y_unit, xs, (ic_lo, ic_hi), (slope_lo, slope_hi) = zero_contexts[i % len(zero_contexts)]
            intercept = rounded(rng.uniform(ic_lo, ic_hi), 2)
            slope = -rng.uniform(slope_lo, slope_hi)

            points = []
            rows = []
            for x in xs:
                center = (x - intercept) * slope
                pt = replicate_point(
                    rng,
                    center,
                    scatter_sigma=max(1.2, 0.05 * abs(center) + 1.0),
                    within_sigma=max(0.8, 0.04 * abs(center) + 0.6),
                    allow_negative=True,
                )
                pt["x"] = x
                points.append(pt)
                rows.append({f"{x_label} ({x_unit})": x, f"{y_label} ({y_unit})": pt["displayed_mean"]})

            stem = (
                f"Researchers measured {name} across a range of {x_label}. Construct a graph with {x_label} "
                f"on the x-axis and {y_label} on the y-axis. Plot the paired observations, draw one best-fit "
                f"relationship, mark where the relationship crosses zero change, and report the estimated "
                f"{x_label} at zero change with units.\n\n"
                f"Write the item ID {item_id} at the top of your page.\n\n{table_to_markdown(rows)}"
            )
            records.append(
                common_record(
                    item_id=item_id,
                    archetype="continuous_relationship_graph_derived_estimate",
                    relation_subtype="zero_intercept_estimate",
                    stem=stem,
                    display_table=rows,
                    expected_graph_spec={
                        "representation": "paired-data graph with one best-fit relationship and zero-intercept annotation",
                        "x_axis": f"{x_label} ({x_unit})",
                        "y_axis": f"{y_label} ({y_unit})",
                        "required_estimate": f"x-value where {y_label} equals zero",
                        "expected_estimate_approx": intercept,
                    },
                    criterion_definitions=[
                        {"criterion_id": "REPRESENTATION_TYPE", "met_rule": "Uses a continuous paired-data graph."},
                        {"criterion_id": "X_UNIT", "met_rule": "X-axis includes required variable and unit."},
                        {"criterion_id": "Y_UNIT", "met_rule": "Y-axis includes required variable and unit."},
                        {"criterion_id": "X_SCALE", "met_rule": "Numeric x positions are proportional and interpretable."},
                        {"criterion_id": "Y_SCALE", "met_rule": "Y-axis includes zero and all observations."},
                        {"criterion_id": "PLOT_VALUES", "met_rule": "All paired observations are plotted at recoverable coordinates."},
                        {"criterion_id": "BEST_FIT_RELATIONSHIP", "met_rule": "One best-fit relationship summarizes the observations."},
                        {"criterion_id": "ZERO_INTERCEPT_ANNOTATION", "met_rule": "Annotation visibly links the zero crossing to the x-axis."},
                        {"criterion_id": "ESTIMATE_VALUE", "met_rule": "Reported estimate has value and unit consistent with graph annotation."},
                    ],
                    synthetic_data_source=(
                        f"Seeded replicate zero-intercept generator (item_seed={3000 + i}, n={REPLICATE_N}); "
                        f"true intercept={intercept}, slope={rounded(slope, 2)}; observations scattered about the line."
                    ),
                    synthetic_data={
                        "method": "seeded_replicate_v2",
                        "model": f"linear(intercept={intercept},slope={rounded(slope,3)})",
                        "item_seed": 3000 + i,
                        "replicate_n": REPLICATE_N,
                        "true_intercept": intercept,
                        "points": points,
                    },
                    modules=MODULES["estimate"],
                    subtopics=[name, "zero-intercept estimate", "paired data"],
                )
            )
        else:
            name, x_label, x_unit, y_label, y_unit, xs, (pl_lo, pl_hi), (rate_lo, rate_hi) = plateau_contexts[i % len(plateau_contexts)]
            plateau = rng.randint(pl_lo, pl_hi)
            rate = rng.uniform(rate_lo, rate_hi)

            points = []
            rows = []
            for x in xs:
                center = plateau * (1 - math.exp(-rate * x))
                pt = replicate_point(
                    rng,
                    center,
                    scatter_sigma=max(0.8, 0.05 * center),
                    within_sigma=max(0.7, 0.04 * center),
                    mean_min=0.0,
                )
                pt["x"] = x
                points.append(pt)
                rows.append({f"{x_label} ({x_unit})": x, f"{y_label} ({y_unit})": pt["displayed_mean"]})

            stem = (
                f"Researchers measured {name} over increasing {x_label}. Construct a graph with {x_label} "
                f"on the x-axis and {y_label} on the y-axis. Plot the paired observations, draw a smooth trend "
                f"that remains consistent with the data, mark the level-off region, and report the estimated "
                f"level-off value with units.\n\n"
                f"Write the item ID {item_id} at the top of your page.\n\n{table_to_markdown(rows)}"
            )
            records.append(
                common_record(
                    item_id=item_id,
                    archetype="continuous_relationship_graph_derived_estimate",
                    relation_subtype="plateau_estimate",
                    stem=stem,
                    display_table=rows,
                    expected_graph_spec={
                        "representation": "paired-data graph with smooth trend and level-off annotation",
                        "x_axis": f"{x_label} ({x_unit})",
                        "y_axis": f"{y_label} ({y_unit})",
                        "required_estimate": f"level-off value of {y_label}",
                        "expected_estimate_approx": float(plateau),
                    },
                    criterion_definitions=[
                        {"criterion_id": "REPRESENTATION_TYPE", "met_rule": "Uses a continuous paired-data graph."},
                        {"criterion_id": "X_UNIT", "met_rule": "X-axis includes required variable and unit."},
                        {"criterion_id": "Y_UNIT", "met_rule": "Y-axis includes required variable and unit."},
                        {"criterion_id": "X_SCALE", "met_rule": "Numeric x positions are proportional and interpretable."},
                        {"criterion_id": "Y_SCALE", "met_rule": "Y-scale is interpretable and represents all observations."},
                        {"criterion_id": "PLOT_VALUES", "met_rule": "All paired observations are plotted at recoverable coordinates."},
                        {"criterion_id": "BEST_FIT_RELATIONSHIP", "met_rule": "Smooth trend remains consistent with plotted observations."},
                        {"criterion_id": "PLATEAU_ANNOTATION", "met_rule": "Annotation visibly identifies the level-off region."},
                        {"criterion_id": "ESTIMATE_VALUE", "met_rule": "Reported estimate has value and unit consistent with graph annotation."},
                    ],
                    synthetic_data_source=(
                        f"Seeded replicate plateau generator (item_seed={3000 + i}, n={REPLICATE_N}); "
                        f"true plateau={plateau}, rate={rounded(rate, 3)}; observations scattered about the trend."
                    ),
                    synthetic_data={
                        "method": "seeded_replicate_v2",
                        "model": f"saturating(plateau={plateau},rate={rounded(rate,3)})",
                        "item_seed": 3000 + i,
                        "replicate_n": REPLICATE_N,
                        "true_plateau": float(plateau),
                        "points": points,
                    },
                    modules=MODULES["estimate"],
                    subtopics=[name, "plateau estimate", "paired data"],
                )
            )
    return records


def write_outputs(records: list[dict[str, object]]) -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    with JSONL_PATH.open("w", encoding="utf-8") as f:
        for record in records:
            f.write(json.dumps(record, sort_keys=True) + "\n")

    csv_fields = [
        "item_id",
        "item_version",
        "question_type",
        "frq_form",
        "review_stage",
        "archetype",
        "relation_subtype",
        "expected_image_filename",
        "stem",
        "canonical_answer",
        "modules",
        "subtopics",
        "display_table_json",
        "expected_graph_spec_json",
        "criterion_definitions_json",
        "synthetic_data_json",
        "rights_status",
        "notes",
    ]
    with CSV_PATH.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=csv_fields)
        writer.writeheader()
        for record in records:
            writer.writerow({
                "item_id": record["item_id"],
                "item_version": record["item_version"],
                "question_type": record["question_type"],
                "frq_form": record["frq_form"],
                "review_stage": record["review_stage"],
                "archetype": record["archetype"],
                "relation_subtype": record["relation_subtype"] or "",
                "expected_image_filename": record["expected_image_filename"],
                "stem": record["stem"],
                "canonical_answer": record["canonical_answer"],
                "modules": "|".join(record["modules"]),  # type: ignore[arg-type]
                "subtopics": "|".join(record["subtopics"]),  # type: ignore[arg-type]
                "display_table_json": json.dumps(record["display_table"], sort_keys=True),
                "expected_graph_spec_json": json.dumps(record["expected_graph_spec"], sort_keys=True),
                "criterion_definitions_json": json.dumps(record["criterion_definitions"], sort_keys=True),
                "synthetic_data_json": json.dumps(record["synthetic_data"], sort_keys=True),
                "rights_status": record["rights_status"],
                "notes": record["notes"],
            })

    INTAKE_PATH.write_text(
        json.dumps(
            {
                "subject_key": "ap_biology",
                "upload_format": "json",
                "parser_version": f"hand-drawn-graph-research-seed-{VERSION}",
                "original_filename": JSONL_PATH.name,
                "raw_template": f"hand_drawn_graph_corpus_{DATE_TAG}",
                "parsed_template": {
                    "artifact_type": "hand_drawn_graph_question_slots",
                    "record_count": len(records),
                    "source_jsonl": JSONL_PATH.name,
                    "source_csv": CSV_PATH.name,
                },
                "rows": records,
            },
            indent=2,
            sort_keys=True,
        )
        + "\n",
        encoding="utf-8",
    )

    counts: dict[str, int] = {}
    for record in records:
        counts[record["archetype"]] = counts.get(record["archetype"], 0) + 1  # type: ignore[index]

    README_PATH.write_text(
        "\n".join([
            f"# Hand-Drawn Graph Corpus Seed {VERSION} - {DATE_TAG.replace('_', '-')}",
            "",
            "This package contains 150 draw-ready AP Biology graph-construction question slots.",
            "",
            f"Item-ID prefix: `HDG-2026-{PHASE}-*`. This package does **not** overwrite the",
            "v0.1 `2026_06_29` corpus (prefix `HDG-2026-P1-*`), which stays frozen and bound",
            "to the hand-drawn pages already captured for it.",
            "",
            "## Counts",
            "",
            *[f"- `{key}`: {value}" for key, value in sorted(counts.items())],
            "",
            "## Data realism (changed from v0.1)",
            "",
            "- Every displayed mean and SEM is derived from seeded synthetic replicate",
            "  observations stored per point in `synthetic_data.points` (auditable and",
            "  exactly reproducible).",
            "- Two noise scales: between-condition scatter moves points off the smooth",
            "  model; within-condition replicate spread produces an irregular, realistic SEM.",
            "- Non-uniform but clean x-grids that vary across items (no fractional steps).",
            "- Round-ish displayed values (integer means, one-decimal SEM) so number",
            "  transcription is not itself the assessed task.",
            "- RNG-varied shapes per item instead of a small recycled set.",
            "",
            "## Files",
            "",
            f"- `{JSONL_PATH.name}`: full metadata, best source for Supabase/content-intake payloads.",
            f"- `{CSV_PATH.name}`: spreadsheet-friendly export with JSON-encoded table/spec fields.",
            f"- `{INTAKE_PATH.name}`: wrapper payload shaped for the current `content-intake` Edge Function.",
            f"- `scripts/generate_hand_drawn_graph_corpus.py`: deterministic generator "
            f"(seed_base={SEED_BASE}).",
            "",
            "## Workflow",
            "",
            "1. Give each drawer the `student_prompt`/`stem` and ask them to write the `item_id` on the page.",
            "2. Save each photo using `expected_image_filename` or preserve that ID in upload metadata.",
            "3. Upload images only after storage, consent, and retention rules are approved.",
            "4. Send reviewers the image plus the matching row payload; keep `criterion_definitions` hidden from drawers.",
            "5. Review capture quality before scoring graph criteria.",
            "",
            "## Status",
            "",
            "Research seed only. These items are independently authored synthetic prompts but have not yet passed Learning Quality, rights/similarity, accessibility, or production release review.",
            "",
        ]),
        encoding="utf-8",
    )


def main() -> None:
    records = categorical_records() + continuous_records() + estimate_records()
    assert len(records) == 150
    assert len({r["item_id"] for r in records}) == 150
    write_outputs(records)
    print(f"Wrote {len(records)} records")
    print(JSONL_PATH)
    print(CSV_PATH)
    print(README_PATH)


if __name__ == "__main__":
    main()
