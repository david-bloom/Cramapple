#!/usr/bin/env python3
"""Expand prompt-only drawn-response rows into full packages and images.

This script reads docs/research/DRAWN_RESPONSE_FRQs_v1.1.md, parses the
80 prompt-only rows in the Additional Question Bank, generates a full item
package for each, appends the generated packages to the markdown file, and
renders two graph-image variants per generated item:

* full_credit
* partial_<criterion_label>

The renderer is intentionally deterministic so the markdown package text
and the image corpus remain synchronized.
"""

from __future__ import annotations

import math
import random
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.font_manager import FontProperties
from matplotlib.ticker import MultipleLocator
import numpy as np

plt.rcParams["path.sketch"] = (1, 100, 2)


ROOT = Path("/Users/davidbloom/Documents/Cramapple")
MD_PATH = ROOT / "docs/research/DRAWN_RESPONSE_FRQs_v1.1.md"
OUT_DIR = ROOT / "docs/research/DRAWN_RESPONSE_FRQs_v1.1_images"
FONT_PATH = Path("/System/Library/Fonts/Supplemental/Bradley Hand Bold.ttf")

PROMPT_ROW_RE = re.compile(
    r"^- `(?P<item_id>DRG-P2-\d{2})` \| (?P<archetype>[^|]+) \| (?P<summary>[^|]+) \| (?P<instruction>.+)$"
)


@dataclass
class GeneratedItem:
    item_id: str
    draft_number: int
    archetype: str
    summary: str
    instruction: str
    student_prompt: str
    item_version: str
    synthetic_data_source: str
    display_table: str
    expected_graph_spec: list[str]
    criterion_definitions: list[str]
    accepted_variants: list[str]
    contradictions: list[str]
    development_tolerances: str
    minimum_feedback: list[str]
    rights_and_similarity_record: str
    plot_kind: str
    plot_payload: dict
    partial_variant_tag: str


def parse_prompt_rows(md_text: str) -> list[dict[str, str]]:
    rows: list[dict[str, str]] = []
    in_bank = False
    for line in md_text.splitlines():
        if line.strip() == "## Additional Question Bank - 80 New Draft Prompts":
            in_bank = True
            continue
        if not in_bank:
            continue
        m = PROMPT_ROW_RE.match(line.strip())
        if m:
            rows.append(m.groupdict())
    return rows


def title_case_words(text: str) -> str:
    return " ".join(w[:1].upper() + w[1:] if w else w for w in text.split())


def clean_label(text: str) -> str:
    text = text.replace("umol", "umol")
    text = text.replace("m2", "m2")
    text = text.replace("degC", "degC")
    return text


def seed_for(item_id: str) -> int:
    return int(item_id.split("-")[-1]) * 9173 + 41


def split_summary(summary: str) -> tuple[str, str]:
    if ":" in summary:
        left, right = summary.split(":", 1)
        return left.strip(), right.strip()
    return summary.strip(), ""


def parse_list(text: str) -> list[str]:
    cleaned = text.replace("`", "").strip()
    cleaned = cleaned.replace(" and ", ", ")
    return [part.strip() for part in cleaned.split(",") if part.strip()]


def parse_numeric_list(text: str) -> tuple[list[float], str]:
    cleaned = text.replace("`", "").strip()
    parts = [p.strip() for p in cleaned.split(",")]
    unit = ""
    values: list[float] = []
    for i, part in enumerate(parts):
        if not part:
            continue
        tokens = part.split()
        if i == len(parts) - 1 and len(tokens) > 1:
            try:
                values.append(float(tokens[0]))
                unit = " ".join(tokens[1:])
                continue
            except ValueError:
                pass
        try:
            values.append(float(part))
        except ValueError:
            # Handle mixed textual categories.
            return [], ""
    return values, unit


def parse_numeric_token(token: str) -> tuple[float, str]:
    token = token.strip().replace("`", "")
    m = re.match(r"^(-?\d+(?:\.\d+)?)(.*)$", token)
    if not m:
        raise ValueError(f"Could not parse numeric token: {token}")
    return float(m.group(1)), m.group(2).strip()


def fmt_num(value: float, digits: int = 1) -> str:
    if abs(value) >= 1000 or (0 < abs(value) < 0.01):
        return f"{value:.{digits}g}"
    return f"{value:.{digits}f}".rstrip("0").rstrip(".") if digits > 0 else str(int(round(value)))


def irregular_replicates(mean: float, sem_target: float, n: int, rng: random.Random) -> list[float]:
    raw = [rng.uniform(-1.2, 1.2) for _ in range(n)]
    raw_mean = sum(raw) / n
    raw = [x - raw_mean for x in raw]
    spread = max(sem_target * math.sqrt(n), 0.15)
    max_abs = max(abs(x) for x in raw) or 1.0
    scaled = [x / max_abs * spread for x in raw]
    return [mean + x for x in scaled]


def compute_mean_sem(values: list[float]) -> tuple[float, float]:
    mean = sum(values) / len(values)
    if len(values) < 2:
        return mean, 0.0
    sd = math.sqrt(sum((v - mean) ** 2 for v in values) / (len(values) - 1))
    sem = sd / math.sqrt(len(values))
    return mean, sem


def infer_categorical_units(metric: str, summary: str) -> str:
    low = f"{metric} {summary}".lower()
    if "stomatal density" in low:
        return "stomata/mm2"
    if "membrane leakage" in low:
        return "absorbance at 540 nm"
    if "catalase" in low or "enzyme activity" in low:
        return "umol product/min"
    if "root hair density" in low:
        return "hairs/mm2"
    if "chlorophyll content" in low:
        return "relative units"
    if "pollen tube length" in low:
        return "mm"
    if "seedling biomass" in low or "biomass" in low:
        return "g"
    if "guard-cell aperture" in low or "stomatal aperture" in low:
        return "um"
    if "leaf thickness" in low:
        return "mm"
    if "electrolyte leakage" in low:
        return "%"
    if "enzyme secretion" in low:
        return "arbitrary units"
    if "algal pigment density" in low:
        return "relative units"
    if "xylem cavitation" in low:
        return "%"
    if "leaf area" in low:
        return "cm2"
    if "transpiration" in low:
        return "mg H2O/cm2/min"
    if "pigment ratio" in low:
        return "ratio"
    if "chloroplast count" in low:
        return "chloroplasts/cell"
    if "germination percentage" in low or "enzyme inhibition" in low:
        return "%"
    return "arbitrary units"


def infer_series_units(summary: str) -> tuple[str, str]:
    low = summary.lower()
    if "reaction rate" in low:
        return "temperature (degC)", "umol product/min"
    if "photosynthesis rate" in low:
        return "light intensity (umol photons/m2/s)", "umol CO2/m2/s"
    if "heart rate recovery" in low:
        return "time (min)", "beats/min"
    if "transpiration rate" in low:
        return "wind speed (km/h)", "mg H2O/cm2/min"
    if "membrane potential" in low:
        return "time (s)", "mV"
    if "oxygen consumption" in low:
        return "temperature (degC)", "mL O2/min"
    if "leaf fluorescence" in low:
        return "time (min)", "a.u."
    if "nutrient uptake" in low:
        return "time (hr)", "mg/g/hr"
    if "stomatal aperture" in low:
        return "humidity (%)", "um"
    if "enzyme rate" in low:
        return "pH", "a.u."
    if "chlorophyll fluorescence" in low:
        return "light intensity", "a.u."
    if "growth rate" in low:
        return "salinity (mM)", "mm/day"
    if "phloem transport" in low:
        return "sucrose concentration (%)", "mg/hr"
    if "microbial respiration" in low:
        return "temperature (degC)", "CO2 release rate"
    if "atp yield" in low:
        return "exercise duration (min)", "a.u."
    if "water potential" in low:
        return "soil moisture (%)", "MPa"
    if "virus replication" in low:
        return "time (hr)", "viral genomes/mL"
    if "enzyme fluorescence" in low:
        return "metal concentration (mM)", "a.u."
    if "seedling elongation" in low:
        return "photoperiod (hr)", "mm"
    if "algal photosynthesis" in low:
        return "water depth (m)", "umol O2/m2/s"
    return "independent variable", "response units"


def infer_relationship_units(summary: str) -> tuple[str, str]:
    low = summary.lower()
    if "mass change" in low:
        return "solute concentration (M)", "percent mass change"
    if "turgor change" in low:
        return "salinity (mM)", "percent turgor change"
    if "inhibitor" in low:
        return "inhibitor concentration (uM)", "enzyme activity"
    if "humidity" in low:
        return "humidity (%)", "wilting index"
    if "k+" in low or "potassium" in low:
        return "extracellular K+ concentration (mM)", "membrane-potential shift"
    if "auxin" in low:
        return "auxin concentration (ng/mL)", "root growth change"
    if "nitrate" in low:
        return "nitrate concentration (mg/L)", "germination success"
    if "co2" in low:
        return "CO2 enrichment (ppm)", "photosynthetic delta"
    if "peg" in low:
        return "PEG concentration (%)", "osmotic mass change"
    if "aba" in low:
        return "ABA concentration (uM)", "stomatal aperture change"
    if "gibberellin" in low:
        return "gibberellin concentration (uM)", "cell elongation change"
    if "temperature acclimation" in low:
        return "acclimation temperature (degC)", "respiration change"
    if "cold-exposure" in low:
        return "cold-exposure duration (min)", "electrolyte leakage change"
    if "salinity" in low:
        return "salinity (mM)", "biomass change"
    if "ph " in low or low.endswith("ph"):
        return "pH", "pigment loss"
    if "substrate-analog" in low:
        return "substrate-analog concentration (mM)", "enzyme kcat change"
    if "photoperiod" in low:
        return "photoperiod (hr)", "seedling height change"
    if "phosphate" in low:
        return "phosphate concentration (mg/L)", "nitrate uptake change"
    if "light attenuation" in low:
        return "light attenuation (absorbance)", "algal mass change"
    if "wind speed" in low:
        return "wind speed (km/h)", "transpiration change"
    return "x", "y"


def infer_plateau_units(summary: str) -> tuple[str, str]:
    low = summary.lower()
    if "bacterial culture density" in low or "yeast density" in low or "protist density" in low or "plankton density" in low:
        return "time (hr)", "10^5 cells/mL"
    if "algae biomass" in low:
        return "time (hr)", "biomass units"
    if "leaf area expansion" in low:
        return "time (days)", "cm2"
    if "seedling height" in low or "root length" in low:
        return "time (days)", "cm"
    if "coral colony coverage" in low or "biofilm coverage" in low:
        return "time", "%"
    if "fungal colony diameter" in low or "moss mat depth" in low:
        return "time", "mm"
    if "tadpole mass" in low:
        return "time (weeks)", "g"
    if "antibody titer" in low:
        return "time (days)", "titer"
    if "metabolite concentration" in low:
        return "time (hr)", "concentration"
    if "cumulative oxygen production" in low:
        return "time (hr)", "umol O2"
    return "time", "response units"


def choose_categorical_trend(summary: str) -> str:
    low = summary.lower()
    if any(k in low for k in ["pH", "ph", "temperature"]):
        return "peak"
    if any(k in low for k in ["salt", "salinity", "aba", "uv", "heat", "drought", "inhibitor", "cold", "stress"]):
        return "decrease"
    if any(k in low for k in ["light", "co2", "sucrose", "fertilizer", "nutrient", "phosphate", "nitrogen", "water", "moisture"]):
        return "increase_plateau"
    if "humidity" in low or "wind" in low:
        return "decrease"
    if "color" in low or "filter" in low:
        return "mixed"
    return "increase"


def generate_categorical_item(row: dict[str, str], draft_number: int) -> GeneratedItem:
    item_id = row["item_id"]
    lead, values_text = split_summary(row["summary"])
    metric = lead.replace("Mean ", "").strip()
    categories = parse_list(values_text)
    if not categories:
        categories = ["Group 1", "Group 2", "Group 3", "Group 4"]
    y_unit = infer_categorical_units(metric, row["summary"])
    rng = random.Random(seed_for(item_id))
    trend = choose_categorical_trend(row["summary"])
    if trend == "peak":
        base = rng.uniform(12, 24)
        peak = base + rng.uniform(10, 18)
        means = [base + 0.2, peak - 1.0, peak + 0.8, base + 3.0]
    elif trend == "decrease":
        start = rng.uniform(45, 65)
        means = [start, start - rng.uniform(6, 10), start - rng.uniform(12, 18), start - rng.uniform(16, 22)]
    elif trend == "increase_plateau":
        start = rng.uniform(10, 18)
        means = [start, start + rng.uniform(8, 12), start + rng.uniform(18, 24), start + rng.uniform(22, 30)]
    elif trend == "mixed":
        base = rng.uniform(18, 30)
        means = [base + 2, base - 1.5, base + 5.5, base + 1.0]
    else:
        base = rng.uniform(15, 28)
        means = [base + i * rng.uniform(4, 8) for i in range(4)]

    data_rows = []
    table_lines = ["| Treatment | Mean | SEM |", "| --- | ---: | ---: |"]
    for idx, (cat, mean_target) in enumerate(zip(categories, means)):
        sem_target = rng.uniform(0.4, 1.2)
        reps = irregular_replicates(mean_target, sem_target, 5, rng)
        mean, sem = compute_mean_sem(reps)
        mean = round(mean, 1)
        sem = round(sem, 1)
        data_rows.append((cat, reps, mean, sem))
        table_lines.append(f"| {cat} | {fmt_num(mean, 1)} | {fmt_num(sem, 1)} |")

    item = GeneratedItem(
        item_id=item_id,
        draft_number=draft_number,
        archetype=row["archetype"].strip(),
        summary=row["summary"].strip(),
        instruction=row["instruction"].strip(),
        student_prompt=(
            f"Researchers measured {metric.lower()}. "
            f"Using the data provided, construct an appropriately scaled and labeled graph to compare "
            f"mean {metric.lower()} across the four treatments. Plot the group means and include "
            f"symmetric error bars representing plus or minus 1 SEM around each mean."
        ),
        item_version="v1.0-generated",
        synthetic_data_source=(
            "Method b, explicit synthetic replicates. Five observations per group. "
            "The replicate values are intentionally irregular rather than consecutive-integer sequences."
        ),
        display_table="\n".join(table_lines),
        expected_graph_spec=[
            "Categorical x-axis in the stated order.",
            f"Y-axis labeled `{y_unit}` and starting at 0.",
            "Plot one mean per treatment.",
            "Add symmetric vertical error bars of plus or minus 1 SEM.",
            "Either point-with-whisker or bar-with-whisker is acceptable.",
        ],
        criterion_definitions=[
            " `REPRESENTATION_TYPE`: Uses an accepted categorical-comparison graph rather than a table or unordered sketch.",
            " `X_VARIABLE`: Places the treatment categories on the x-axis.",
            f" `Y_VARIABLE`: Places mean {metric.lower()} on the y-axis.",
            " `X_UNIT`: Uses category labels only, not a numeric x unit.",
            f" `Y_UNIT`: Labels the y-axis with `{y_unit}`.",
            " `X_SCALE`: Keeps the four treatment labels in the table order.",
            " `Y_SCALE`: Starts the y-axis at zero.",
            " `CATEGORY_IDENTITY`: Preserves the four treatment names distinctly and in order.",
            " `PLOT_VALUES`: Places each mean at its correct height.",
            " `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars for each mean.",
        ],
        accepted_variants=[
            "Point-with-whisker and bar-with-whisker are both acceptable.",
            "Category labels may wrap onto two lines if needed.",
            "SEM bars may be capped or uncapped if still symmetric.",
        ],
        contradictions=[
            "Treating the groups as a continuous numeric x-axis.",
            "Starting the y-axis above zero.",
            "Omitting the SEM bars or showing one-sided bars only.",
        ],
        development_tolerances=(
            "Proposed development tolerances, not validated thresholds: mean placement within 0.1 units; "
            "SEM within 0.1; axes and labels legible at normal page scale; y-axis baseline exactly at zero."
        ),
        minimum_feedback=[
            " `REPRESENTATION_TYPE`: Switch to a graph with plotted means and error bars instead of only listing the table.",
            " `X_VARIABLE`: Put the treatment names across the horizontal axis.",
            f" `Y_VARIABLE`: Move {metric.lower()} to the vertical axis.",
            " `X_UNIT`: Use category labels, not a numeric unit, on the x-axis.",
            f" `Y_UNIT`: Add `{y_unit}` to the y-axis label.",
            " `X_SCALE`: Keep the treatments in the provided order.",
            " `Y_SCALE`: Redraw the vertical axis so it starts at zero.",
            " `CATEGORY_IDENTITY`: Make sure each treatment name is still distinct and not collapsed into one label.",
            " `PLOT_VALUES`: Place each mean at the correct height from the table.",
            " `UNCERTAINTY_MARKS`: Add symmetric error bars that match the SEM values.",
        ],
        rights_and_similarity_record=(
            "Original content, independently generated for this draft. Novelty and similarity status: "
            "unverified, pending qualified human source-isolation and similarity review."
        ),
        plot_kind="categorical",
        plot_payload={
            "categories": categories,
            "rows": data_rows,
            "y_unit": y_unit,
            "metric": metric,
        },
        partial_variant_tag="partial_missing_uncertainty_marks",
    )
    return item


def generate_series_item(row: dict[str, str], draft_number: int) -> GeneratedItem:
    item_id = row["item_id"]
    summary = row["summary"].strip()
    lead, values_text = split_summary(summary)
    x_label, y_unit = infer_series_units(summary)
    rng = random.Random(seed_for(item_id))
    raw_values = values_text.replace("`", "")
    x_tokens = [p.strip() for p in raw_values.split(",")]
    x_values: list[float] = []
    x_unit = ""
    for i, token in enumerate(x_tokens):
        value, trailing = parse_numeric_token(token)
        x_values.append(value)
        if i == len(x_tokens) - 1 and trailing:
            x_unit = trailing.lstrip()
    if not x_unit:
        x_unit = x_label.split("(")[-1].rstrip(")") if "(" in x_label else x_label

    low = summary.lower()
    n = len(x_values)
    x_min = min(x_values)
    x_max = max(x_values)
    x_mid = x_values[n // 2]
    if any(k in low for k in ["reaction rate", "oxygen consumption", "enzyme rate", "microbial respiration"]):
        # Bell-shaped response.
        peak = rng.uniform(35, 60)
        center = x_values[n // 2]
        width = max((x_max - x_min) / 3.5, 1.0)
        targets = [max(1.0, peak * math.exp(-((x - center) / width) ** 2) + rng.uniform(-1.0, 1.0)) for x in x_values]
    elif any(k in low for k in ["photosynthesis rate", "chlorophyll fluorescence", "phloem transport", "seedling elongation", "nutrient uptake"]):
        plateau = rng.uniform(35, 55)
        scale = max((x_max - x_min) / 4.0, 1.0)
        targets = [plateau * (1 - math.exp(-(x - x_min) / (scale + 1e-6))) + rng.uniform(-0.8, 0.8) for x in x_values]
        targets = [max(0.5, t) for t in targets]
    elif any(k in low for k in ["heart rate recovery", "membrane potential", "virus replication", "atp yield"]):
        start = rng.uniform(60, 90)
        end = rng.uniform(8, 18)
        targets = [start - (start - end) * ((i) / (n - 1)) + rng.uniform(-1.2, 1.2) for i in range(n)]
    elif any(k in low for k in ["transpiration rate", "stomatal aperture", "water potential", "growth rate", "algal photosynthesis"]):
        start = rng.uniform(5, 15)
        end = rng.uniform(35, 60)
        if "water potential" in low or "algal photosynthesis" in low or "stomatal aperture" in low:
            targets = [end - (end - start) * ((i) / (n - 1)) + rng.uniform(-1.0, 1.0) for i in range(n)]
        else:
            targets = [start + (end - start) * ((i) / (n - 1)) + rng.uniform(-1.0, 1.0) for i in range(n)]
    elif any(k in low for k in ["temperature", "salinity", "depth"]):
        peak = rng.uniform(30, 50)
        center = x_values[n // 2]
        width = max((x_max - x_min) / 3.5, 1.0)
        targets = [max(1.0, peak * math.exp(-((x - center) / width) ** 2) + rng.uniform(-1.0, 1.0)) for x in x_values]
    else:
        base = rng.uniform(8, 18)
        targets = [base + i * rng.uniform(4, 7) + rng.uniform(-0.8, 0.8) for i in range(n)]

    rows = []
    table_lines = [f"| {x_label} | Mean {y_unit} | SEM |", "| --- | ---: | ---: |"]
    for x, target in zip(x_values, targets):
        reps = irregular_replicates(target, rng.uniform(0.25, 0.8), 4, rng)
        mean, sem = compute_mean_sem(reps)
        mean = round(mean, 1)
        sem = round(sem, 1)
        rows.append((x, reps, mean, sem))
        x_text = str(int(x)) if float(x).is_integer() else fmt_num(x, 1)
        table_lines.append(f"| {x_text} | {fmt_num(mean, 1)} | {fmt_num(sem, 1)} |")

    item = GeneratedItem(
        item_id=item_id,
        draft_number=draft_number,
        archetype=row["archetype"].strip(),
        summary=summary,
        instruction=row["instruction"].strip(),
        student_prompt=(
            f"Researchers measured {lead.lower()}. Using the data provided, construct an appropriately scaled and labeled "
            f"graph of mean {y_unit.lower()} versus {x_label}. Plot the means at their measured values, connect adjacent "
            f"measured points in order, and include symmetric error bars representing plus or minus 1 SEM around each mean."
        ),
        item_version="v1.0-generated",
        synthetic_data_source=(
            "Method b, explicit synthetic replicates. Four observations per measurement point. "
            "The replicate values are intentionally irregular rather than consecutive-integer sequences."
        ),
        display_table="\n".join(table_lines),
        expected_graph_spec=[
            f"X-axis is {x_label} with actual numeric spacing.",
            f"Y-axis is {y_unit} and starts at zero.",
            "Plot the mean at each measured x-value.",
            "Add symmetric plus or minus 1 SEM bars.",
            "Connect adjacent measured points from left to right with straight segments.",
        ],
        criterion_definitions=[
            " `REPRESENTATION_TYPE`: Uses the required measured-series graph.",
            f" `X_VARIABLE`: Places {x_label} on the x-axis.",
            f" `Y_VARIABLE`: Places mean {y_unit} on the y-axis.",
            f" `X_UNIT`: Labels the x-axis in {x_unit}.",
            f" `Y_UNIT`: Labels the y-axis in {y_unit}.",
            " `X_SCALE`: Uses actual numeric spacing between measurement values.",
            " `Y_SCALE`: Starts the y-axis at zero.",
            " `PLOT_VALUES`: Places each mean at the correct x-value and height.",
            " `UNCERTAINTY_MARKS`: Draws symmetric plus or minus 1 SEM bars.",
            " `POINT_CONNECTION`: Connects adjacent measured points in order.",
        ],
        accepted_variants=[
            "Straight-line segments between adjacent measured values are acceptable.",
            "The x-axis may use whole-number or rotated tick labels if needed for space.",
            "The final segment may appear nearly flat if the data plateau.",
        ],
        contradictions=[
            "Spacing the x-values evenly as if they were categories.",
            "Replacing the measured values with a smooth spline that moves the points.",
            "Leaving off the error bars.",
        ],
        development_tolerances=(
            "Proposed development tolerances, not validated thresholds: each mean within 0.1 units; "
            "SEM within 0.1; x positions must match the stated measurement values; y-axis baseline at zero."
        ),
        minimum_feedback=[
            " `REPRESENTATION_TYPE`: Use a measured-series graph, not a category chart.",
            f" `X_VARIABLE`: Put {x_label} on the horizontal axis.",
            f" `Y_VARIABLE`: Put {y_unit} on the vertical axis.",
            f" `X_UNIT`: Label the x-axis in {x_unit}.",
            f" `Y_UNIT`: Label the y-axis in {y_unit}.",
            " `X_SCALE`: Space the x-values according to their numeric distance.",
            " `Y_SCALE`: Start the vertical axis at zero.",
            " `PLOT_VALUES`: Place each point at the right x-value and y-value.",
            " `UNCERTAINTY_MARKS`: Add the SEM bars around each mean.",
            " `POINT_CONNECTION`: Connect the measured points in order.",
        ],
        rights_and_similarity_record=(
            "Original content, independently generated for this draft. Novelty and similarity status: "
            "unverified, pending qualified human source-isolation and similarity review."
        ),
        plot_kind="series",
        plot_payload={
            "x_values": x_values,
            "rows": rows,
            "x_label": x_label,
            "y_unit": y_unit,
            "x_unit": x_unit,
        },
        partial_variant_tag="partial_missing_uncertainty_marks",
    )
    return item


def generate_relationship_item(row: dict[str, str], draft_number: int) -> GeneratedItem:
    item_id = row["item_id"]
    summary = row["summary"].strip()
    lead, values_text = split_summary(summary)
    x_label, y_label = infer_relationship_units(summary)
    rng = random.Random(seed_for(item_id))
    target_match = re.search(r"near `?([0-9.]+)\s*([A-Za-z%/+]+)`?", summary)
    if target_match:
        intercept = float(target_match.group(1))
        x_unit = target_match.group(2)
    else:
        intercept = rng.uniform(0.5, 20.0)
        x_unit = "units"
    if x_unit == "units":
        if x_label == "pH":
            x_unit = "pH"
        elif "(" in x_label and ")" in x_label:
            x_unit = x_label.split("(", 1)[1].split(")", 1)[0]
    if "%" in summary and x_unit != "%":
        x_unit = "%"

    if "zero-crossing" in summary or "crossing zero" in summary:
        x_values = [intercept - 0.4, intercept - 0.2, intercept, intercept + 0.2, intercept + 0.4, intercept + 0.6]
    else:
        x_values = [intercept - 4, intercept - 2, intercept - 1, intercept + 1, intercept + 2, intercept + 4]
    slope = rng.uniform(-18, -8) if any(k in summary.lower() for k in ["mass change", "turgor", "growth change", "photosynthetic delta", "biomass change"]) else rng.uniform(8, 18)
    y_values = [round(slope * (x - intercept) + rng.uniform(-1.0, 1.0), 1) for x in x_values]
    rows = list(zip(x_values, y_values))
    table_lines = [f"| {x_label} | {y_label} |", "| --- | ---: |"]
    for x, y in rows:
        table_lines.append(f"| {fmt_num(x, 1)} | {fmt_num(y, 1)} |")

    item = GeneratedItem(
        item_id=item_id,
        draft_number=draft_number,
        archetype=row["archetype"].strip(),
        summary=summary,
        instruction=row["instruction"].strip(),
        student_prompt=(
            f"Researchers measured {lead.lower()}. Using the data provided, plot the paired observations on linear axes, "
            f"draw one best-fit line, mark the x-intercept where the response crosses zero, and estimate the "
            f"{x_label} where the response is zero. Include units with your estimate."
        ),
        item_version="v1.0-generated",
        synthetic_data_source=(
            "Method b, explicit synthetic paired observations. One observation was recorded at each x-value; "
            "no replicate averaging was used."
        ),
        display_table="\n".join(table_lines),
        expected_graph_spec=[
            "Plot the paired observations on linear axes.",
            "Y-axis includes zero and all positive and negative observations.",
            "Draw one best-fit line through the trend.",
            f"Mark the x-intercept where the response crosses zero, near `{fmt_num(intercept, 1)} {x_unit}`.",
            f"Label the intercept estimate in {x_unit}.",
        ],
        criterion_definitions=[
            " `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.",
            f" `X_VARIABLE`: Places {x_label} on the x-axis.",
            f" `Y_VARIABLE`: Places {y_label} on the y-axis.",
            f" `X_UNIT`: Labels the x-axis in {x_unit}.",
            f" `Y_UNIT`: Labels the y-axis in {y_label}.",
            " `X_SCALE`: Uses a linear x-axis with correct numeric spacing.",
            " `Y_SCALE`: Includes zero and both positive and negative values.",
            " `PLOT_VALUES`: Places each paired observation at the correct coordinates.",
            " `BEST_FIT_RELATIONSHIP`: Draws one best-fit line instead of connect-the-dots.",
            " `ZERO_INTERCEPT_ANNOTATION`: Marks the x-intercept on the graph.",
            f" `ESTIMATE_VALUE`: Reports the zero-change estimate in {x_unit}.",
        ],
        accepted_variants=[
            "The best-fit line may be drawn by eye or with a straightedge.",
            "The intercept may be annotated with an arrow or bracket.",
            "The estimate may be reported to one or two decimal places if consistent with the graph.",
        ],
        contradictions=[
            "Connecting the points in table order instead of fitting one relationship.",
            "Reporting the intercept in the response variable unit rather than the x-axis unit.",
            "Omitting negative y-values from the scale.",
        ],
        development_tolerances=(
            "Proposed development tolerances, not validated thresholds: plotted coordinates within 0.1 units; "
            "intercept estimate within 0.05 x-units; y-axis must include zero and the negative data."
        ),
        minimum_feedback=[
            " `REPRESENTATION_TYPE`: Draw the graph of paired observations instead of leaving the answer as a table.",
            f" `X_VARIABLE`: Put {x_label} on the x-axis.",
            f" `Y_VARIABLE`: Put {y_label} on the y-axis.",
            f" `X_UNIT`: Add {x_unit} to the x-axis label.",
            f" `Y_UNIT`: Label the response axis as {y_label}.",
            " `X_SCALE`: Use a linear x-axis with the correct spacing.",
            " `Y_SCALE`: Extend the y-axis to show zero and the negative values.",
            " `PLOT_VALUES`: Place each point at the right x-value and response value.",
            " `BEST_FIT_RELATIONSHIP`: Add one overall best-fit line through the pattern.",
            " `ZERO_INTERCEPT_ANNOTATION`: Mark where the line crosses zero.",
            f" `ESTIMATE_VALUE`: State the zero-change estimate in {x_unit}.",
        ],
        rights_and_similarity_record=(
            "Original content, independently generated for this draft. Novelty and similarity status: "
            "unverified, pending qualified human source-isolation and similarity review."
        ),
        plot_kind="relationship",
        plot_payload={
            "x_values": x_values,
            "y_values": y_values,
            "x_label": x_label,
            "y_label": y_label,
            "x_unit": x_unit,
            "intercept": intercept,
        },
        partial_variant_tag="partial_missing_zero_intercept_annotation",
    )
    return item


def generate_plateau_item(row: dict[str, str], draft_number: int) -> GeneratedItem:
    item_id = row["item_id"]
    summary = row["summary"].strip()
    lead, values_text = split_summary(summary)
    x_label, y_unit = infer_plateau_units(summary)
    rng = random.Random(seed_for(item_id))
    vals = re.findall(r"\d+(?:\.\d+)?", values_text)
    x_values = [float(v) for v in vals]
    if not x_values:
        x_values = [0, 4, 8, 12, 16, 20, 24, 32]
    plateau = rng.uniform(12, 28)
    base = rng.uniform(1.0, 3.5)
    k = rng.uniform(0.14, 0.28)
    midpoint = x_values[len(x_values) // 2]
    y_values = [round(base + (plateau - base) * (1 - math.exp(-k * x)) + rng.uniform(-0.2, 0.2), 1) for x in x_values]
    table_lines = [f"| {x_label} | {y_unit} |", "| --- | ---: |"]
    for x, y in zip(x_values, y_values):
        table_lines.append(f"| {fmt_num(x, 1)} | {fmt_num(y, 1)} |")

    item = GeneratedItem(
        item_id=item_id,
        draft_number=draft_number,
        archetype=row["archetype"].strip(),
        summary=summary,
        instruction=row["instruction"].strip(),
        student_prompt=(
            f"Researchers measured {lead.lower()}. Using the data provided, plot the paired observations on linear axes, "
            f"draw a smooth trend that rises and then levels off, visually indicate the level-off region, and estimate the "
            f"population value around which the curve levels off. Include units with your estimate."
        ),
        item_version="v1.0-generated",
        synthetic_data_source=(
            "Method b, explicit synthetic paired observations. One observation was recorded at each x-value; "
            "no replicate averaging was used."
        ),
        display_table="\n".join(table_lines),
        expected_graph_spec=[
            "Plot paired observations on linear axes.",
            f"Use one linear y-axis with the display unit `{y_unit}`.",
            "Draw a smooth trend that rises and then levels off.",
            "Mark the level-off region with a visible annotation.",
            f"Estimate the plateau value in `{y_unit}`.",
        ],
        criterion_definitions=[
            " `REPRESENTATION_TYPE`: Uses the required relationship-and-estimate graph.",
            f" `X_VARIABLE`: Places {x_label} on the x-axis.",
            f" `Y_VARIABLE`: Places the response on the y-axis.",
            f" `X_UNIT`: Labels the x-axis in the time or measurement unit shown in the table.",
            f" `Y_UNIT`: Labels the y-axis in `{y_unit}`.",
            " `X_SCALE`: Uses a linear x-axis with correct spacing.",
            " `Y_SCALE`: Uses one linear y-axis with the display unit.",
            " `PLOT_VALUES`: Places each observation at the correct x-value and height.",
            " `BEST_FIT_RELATIONSHIP`: Draws one smooth overall growth trend.",
            " `PLATEAU_ANNOTATION`: Marks the region where the curve levels off.",
            f" `ESTIMATE_VALUE`: Reports the plateau estimate in `{y_unit}`.",
        ],
        accepted_variants=[
            "The smooth trend may be a hand-drawn curve or a best-fit smooth line.",
            "The plateau annotation may be a bracket, arrow, or shaded band.",
            "The estimate may be written with equivalent wording if the unit is preserved.",
        ],
        contradictions=[
            "Using a log y-axis or scientific-notation-only scale.",
            "Drawing straight connect-the-dots segments instead of a smooth trend.",
            "Calling the plateau a fixed species constant rather than a condition-specific level-off.",
        ],
        development_tolerances=(
            "Proposed development tolerances, not validated thresholds: plotted points within 0.1 density units; "
            "plateau estimate within 0.5 display units; annotation must clearly identify the level-off region."
        ),
        minimum_feedback=[
            " `REPRESENTATION_TYPE`: Draw the growth graph rather than only describing the trend.",
            f" `X_VARIABLE`: Put {x_label} on the horizontal axis.",
            f" `Y_VARIABLE`: Put the response on the vertical axis.",
            f" `X_UNIT`: Label the x-axis in the measurement unit shown.",
            f" `Y_UNIT`: Use `{y_unit}` on the y-axis.",
            " `X_SCALE`: Keep the x-axis linear and evenly scaled.",
            " `Y_SCALE`: Use one linear y-axis with the display unit, not scientific notation only.",
            " `PLOT_VALUES`: Place each measured value at the right x-value and y-value.",
            " `BEST_FIT_RELATIONSHIP`: Add one smooth overall trend through the points.",
            " `PLATEAU_ANNOTATION`: Mark the region where the curve levels off.",
            f" `ESTIMATE_VALUE`: Give the level-off value with units.",
        ],
        rights_and_similarity_record=(
            "Original content, independently generated for this draft. Novelty and similarity status: "
            "unverified, pending qualified human source-isolation and similarity review."
        ),
        plot_kind="plateau",
        plot_payload={
            "x_values": x_values,
            "y_values": y_values,
            "x_label": x_label,
            "y_unit": y_unit,
            "plateau": round(plateau, 1),
        },
        partial_variant_tag="partial_missing_plateau_annotation",
    )
    return item


def package_for_row(row: dict[str, str], draft_number: int) -> GeneratedItem:
    archetype = row["archetype"].strip().lower()
    instruction = row["instruction"].strip().lower()
    if "level-off" in instruction or "plateau" in instruction:
        return generate_plateau_item(row, draft_number)
    if archetype.startswith("categorical"):
        return generate_categorical_item(row, draft_number)
    if archetype.startswith("continuous"):
        return generate_series_item(row, draft_number)
    if archetype.startswith("relationship"):
        return generate_relationship_item(row, draft_number)
    raise ValueError(f"Unknown archetype: {row['archetype']}")


def md_escape(text: str) -> str:
    return text.replace("`", "\\`")


def render_package_block(item: GeneratedItem) -> str:
    lines = [
        "",
        f"## Draft {item.draft_number} - {item.item_id}",
        "",
        "### item_id",
        f"`{item.item_id}`",
        "",
        "### item_version",
        f"`{item.item_version}`",
        "",
        "### student_prompt",
        item.student_prompt,
        "",
        "### synthetic_data_source",
        item.synthetic_data_source,
        "",
        "### display_table",
        "",
        item.display_table,
        "",
        "### expected_graph_spec",
    ]
    for bullet in item.expected_graph_spec:
        lines.append(f"- {bullet}")
    lines += ["", "### criterion_definitions"]
    for bullet in item.criterion_definitions:
        lines.append(f"- {bullet.strip()}")
    lines += ["", "### accepted_variants"]
    for bullet in item.accepted_variants:
        lines.append(f"- {bullet.strip()}")
    lines += ["", "### contradictions"]
    for bullet in item.contradictions:
        lines.append(f"- {bullet.strip()}")
    lines += ["", "### development_tolerances", item.development_tolerances, "", "### minimum_feedback"]
    for bullet in item.minimum_feedback:
        lines.append(f"- {bullet.strip()}")
    lines += ["", "### rights_and_similarity_record", item.rights_and_similarity_record, ""]
    return "\n".join(lines)


def render_package_section(items: list[GeneratedItem]) -> str:
    blocks = ["", "---", "", "## Generated Full Item Packages", ""]
    blocks.append(
        "The following packages are expanded from the 80 prompt-only rows in the Additional Question Bank. "
        "They follow the same field set as the initial six drafts and are generated deterministically from the prompt rows."
    )
    for item in items:
        blocks.append(render_package_block(item))
    return "\n".join(blocks)


def roughen_rc(rc: float, pct: float = 0.02) -> float:
    return max(0.0, min(1.0, rc + random.uniform(-pct, pct)))


def setup_axes(ax, xlim, ylim, x_major=None, x_minor=None, y_major=None, y_minor=None):
    ax.set_xlim(*xlim)
    ax.set_ylim(*ylim)
    ax.set_facecolor("#fbfbf8")
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)
    ax.spines["left"].set_linewidth(1.8)
    ax.spines["bottom"].set_linewidth(1.8)
    if x_major is not None:
        ax.xaxis.set_major_locator(MultipleLocator(x_major))
    if x_minor is not None:
        ax.xaxis.set_minor_locator(MultipleLocator(x_minor))
    if y_major is not None:
        ax.yaxis.set_major_locator(MultipleLocator(y_major))
    if y_minor is not None:
        ax.yaxis.set_minor_locator(MultipleLocator(y_minor))
    ax.grid(which="major", color="#cfd3d8", linewidth=0.9)
    ax.grid(which="minor", color="#e5e8ec", linewidth=0.55)
    ax.set_axisbelow(True)


def font_props(size: int = 14) -> FontProperties:
    if FONT_PATH.exists():
        return FontProperties(fname=str(FONT_PATH), size=size)
    return FontProperties(size=size)


def render_categorical(item: GeneratedItem, variant_tag: str, out_path: Path):
    payload = item.plot_payload
    categories = payload["categories"]
    rows = payload["rows"]
    y_unit = payload["y_unit"]
    metric = payload["metric"]
    means = [r[2] for r in rows]
    sems = [r[3] for r in rows]
    fig, ax = plt.subplots(figsize=(8.5, 11), dpi=160)
    setup_axes(ax, (-0.7, len(categories) - 0.3), (0, max(m + s for m, s in zip(means, sems)) * 1.25), y_major=5, y_minor=1)
    x = np.arange(len(categories))
    if variant_tag.startswith("partial_"):
        ax.plot(x, means, color="#1c1c1c", linewidth=1.8, marker="o", markersize=4.5)
    else:
        ax.errorbar(
            x,
            means,
            yerr=sems,
            fmt="o",
            color="#1c1c1c",
            ecolor="#1c1c1c",
            elinewidth=1.3,
            capsize=4,
            markersize=4.5,
        )
    ax.set_xticks(x)
    ax.set_xticklabels(categories, fontproperties=font_props(13), rotation=20, ha="right")
    ax.set_ylabel(y_unit, fontproperties=font_props(15))
    ax.set_xlabel("treatment", fontproperties=font_props(15))
    ax.tick_params(axis="y", labelsize=11)
    ax.tick_params(axis="x", labelsize=11)
    for line in ax.get_xgridlines() + ax.get_ygridlines():
        line.set_alpha(0.9)
    fig.tight_layout(pad=1.2)
    fig.savefig(out_path, facecolor=fig.get_facecolor())
    plt.close(fig)


def render_series(item: GeneratedItem, variant_tag: str, out_path: Path):
    payload = item.plot_payload
    x_values = payload["x_values"]
    rows = payload["rows"]
    x_label = payload["x_label"]
    y_unit = payload["y_unit"]
    x_unit = payload["x_unit"]
    xs = np.array(x_values, dtype=float)
    ys = np.array([r[2] for r in rows], dtype=float)
    sems = np.array([r[3] for r in rows], dtype=float)
    xpad = (xs.max() - xs.min()) * 0.08 or 1.0
    ypad = (ys.max() + sems.max()) * 0.15 or 1.0
    fig, ax = plt.subplots(figsize=(8.5, 11), dpi=160)
    setup_axes(ax, (xs.min() - xpad, xs.max() + xpad), (0, (ys + sems).max() + ypad), y_major=None, y_minor=None)
    # Major/minor spacing is adapted to the data range for a graph-paper feel.
    xrng = xs.max() - xs.min()
    if xrng <= 15:
        ax.xaxis.set_major_locator(MultipleLocator(max(xrng / 5, 1)))
        ax.xaxis.set_minor_locator(MultipleLocator(max(xrng / 20, 0.25)))
    elif xrng <= 100:
        ax.xaxis.set_major_locator(MultipleLocator(max(xrng / 5, 5)))
        ax.xaxis.set_minor_locator(MultipleLocator(max(xrng / 20, 1)))
    else:
        ax.xaxis.set_major_locator(MultipleLocator(max(xrng / 5, 50)))
        ax.xaxis.set_minor_locator(MultipleLocator(max(xrng / 20, 10)))
    yrng = (ys + sems).max()
    ax.yaxis.set_major_locator(MultipleLocator(max(yrng / 5, 5)))
    ax.yaxis.set_minor_locator(MultipleLocator(max(yrng / 20, 1)))
    if variant_tag.startswith("partial_"):
        ax.plot(xs, ys, color="#222222", linewidth=1.8, marker="o", markersize=4.0)
    else:
        ax.errorbar(xs, ys, yerr=sems, color="#222222", ecolor="#222222", elinewidth=1.2, capsize=4, fmt="o-", linewidth=1.8, markersize=4.0)
    ax.set_xlabel(x_label, fontproperties=font_props(15))
    ax.set_ylabel(y_unit, fontproperties=font_props(15))
    ax.tick_params(axis="both", labelsize=11)
    fig.tight_layout(pad=1.2)
    fig.savefig(out_path, facecolor=fig.get_facecolor())
    plt.close(fig)


def render_relationship(item: GeneratedItem, variant_tag: str, out_path: Path):
    payload = item.plot_payload
    xs = np.array(payload["x_values"], dtype=float)
    ys = np.array(payload["y_values"], dtype=float)
    x_label = payload["x_label"]
    y_label = payload["y_label"]
    x_unit = payload["x_unit"]
    xpad = (xs.max() - xs.min()) * 0.15 or 1.0
    ypad = max(abs(ys).max() * 0.2, 3.0)
    fig, ax = plt.subplots(figsize=(8.5, 11), dpi=160)
    setup_axes(ax, (xs.min() - xpad, xs.max() + xpad), (min(ys.min() - ypad, -ypad), max(ys.max() + ypad, ypad)), y_major=None, y_minor=None)
    ax.xaxis.set_major_locator(MultipleLocator(max((xs.max() - xs.min()) / 5, 1)))
    ax.xaxis.set_minor_locator(MultipleLocator(max((xs.max() - xs.min()) / 20, 0.25)))
    yrange = max(abs(ys.min()), abs(ys.max()))
    ax.yaxis.set_major_locator(MultipleLocator(max(yrange / 4, 5)))
    ax.yaxis.set_minor_locator(MultipleLocator(max(yrange / 16, 1)))
    ax.scatter(xs, ys, color="#222222", s=18, zorder=3)
    slope, intercept = np.polyfit(xs, ys, 1)
    xline = np.linspace(xs.min() - xpad * 0.6, xs.max() + xpad * 0.6, 200)
    yline = slope * xline + intercept
    ax.plot(xline, yline, color="#222222", linewidth=1.8)
    if not variant_tag.startswith("partial_"):
        xi = -intercept / slope
        ax.axvline(xi, color="#222222", linestyle="--", linewidth=1.1)
        ax.annotate(
            f"{fmt_num(xi, 1)} {x_unit}",
            xy=(xi, 0),
            xytext=(xi + xpad * 0.08, ypad * 0.35),
            fontproperties=font_props(13),
            arrowprops=dict(arrowstyle="->", linewidth=1.0, color="#222222"),
        )
    ax.set_xlabel(x_label, fontproperties=font_props(15))
    ax.set_ylabel(y_label, fontproperties=font_props(15))
    ax.tick_params(axis="both", labelsize=11)
    fig.tight_layout(pad=1.2)
    fig.savefig(out_path, facecolor=fig.get_facecolor())
    plt.close(fig)


def smooth_curve(x: np.ndarray, y: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
    degree = min(3, len(x) - 1)
    coeffs = np.polyfit(x, y, degree)
    x_dense = np.linspace(x.min(), x.max(), 300)
    y_dense = np.polyval(coeffs, x_dense)
    return x_dense, y_dense


def render_plateau(item: GeneratedItem, variant_tag: str, out_path: Path):
    payload = item.plot_payload
    xs = np.array(payload["x_values"], dtype=float)
    ys = np.array(payload["y_values"], dtype=float)
    x_label = payload["x_label"]
    y_unit = payload["y_unit"]
    plateau = payload["plateau"]
    xpad = (xs.max() - xs.min()) * 0.08 or 1.0
    ypad = (ys.max() - ys.min()) * 0.18 or 1.0
    fig, ax = plt.subplots(figsize=(8.5, 11), dpi=160)
    setup_axes(ax, (xs.min() - xpad, xs.max() + xpad), (0, ys.max() + ypad), y_major=None, y_minor=None)
    xrng = xs.max() - xs.min()
    ax.xaxis.set_major_locator(MultipleLocator(max(xrng / 5, 1)))
    ax.xaxis.set_minor_locator(MultipleLocator(max(xrng / 20, 0.25)))
    ax.yaxis.set_major_locator(MultipleLocator(max(ys.max() / 5, 5)))
    ax.yaxis.set_minor_locator(MultipleLocator(max(ys.max() / 20, 1)))
    x_dense, y_dense = smooth_curve(xs, ys)
    ax.plot(x_dense, y_dense, color="#222222", linewidth=1.9)
    ax.scatter(xs, ys, color="#222222", s=18, zorder=3)
    if not variant_tag.startswith("partial_"):
        plateau_start = xs[int(len(xs) * 0.6)]
        ax.annotate(
            "",
            xy=(plateau_start, plateau),
            xytext=(plateau_start + (xs.max() - xs.min()) * 0.18, plateau + 0.8),
            arrowprops=dict(arrowstyle="-[", linewidth=1.2, color="#222222"),
        )
        ax.text(
            plateau_start + (xs.max() - xs.min()) * 0.07,
            plateau + 1.0,
            "level-off",
            fontproperties=font_props(13),
        )
    ax.set_xlabel(x_label, fontproperties=font_props(15))
    ax.set_ylabel(y_unit, fontproperties=font_props(15))
    ax.tick_params(axis="both", labelsize=11)
    fig.tight_layout(pad=1.2)
    fig.savefig(out_path, facecolor=fig.get_facecolor())
    plt.close(fig)


def render_image(item: GeneratedItem, variant_tag: str, out_dir: Path):
    out_dir.mkdir(parents=True, exist_ok=True)
    out_path = out_dir / f"{item.item_id}_master_{variant_tag}.png"
    if item.plot_kind == "categorical":
        render_categorical(item, variant_tag, out_path)
    elif item.plot_kind == "series":
        render_series(item, variant_tag, out_path)
    elif item.plot_kind == "relationship":
        render_relationship(item, variant_tag, out_path)
    elif item.plot_kind == "plateau":
        render_plateau(item, variant_tag, out_path)
    else:
        raise ValueError(item.plot_kind)
    return out_path


def main() -> int:
    md_text = MD_PATH.read_text(encoding="utf-8")
    rows = parse_prompt_rows(md_text)
    if len(rows) != 80:
        raise SystemExit(f"Expected 80 prompt-only rows, found {len(rows)}")
    items = [package_for_row(row, draft_number=11 + idx) for idx, row in enumerate(rows)]

    # Append the generated packages to the markdown file, replacing any prior generated section.
    generated_section = render_package_section(items)
    if "## Generated Full Item Packages" in md_text:
        md_text = md_text.split("## Generated Full Item Packages", 1)[0].rstrip() + "\n"
    md_text = md_text.rstrip() + "\n" + generated_section.lstrip() + "\n"
    MD_PATH.write_text(md_text, encoding="utf-8")

    # Render two variants per generated item.
    for item in items:
        render_image(item, "full_credit", OUT_DIR)
        render_image(item, item.partial_variant_tag, OUT_DIR)

    print(f"Updated {MD_PATH}")
    print(f"Rendered {len(items) * 2} images into {OUT_DIR}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
