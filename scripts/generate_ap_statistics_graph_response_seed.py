#!/usr/bin/env python3
"""Generate a small AP Statistics graph-response research seed set.

The set is independently authored synthetic practice content. It is intended
for hand-drawn graph grading experiments, not production AP exam claims.
"""

from __future__ import annotations

import csv
import json
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parents[1]
OUT_DIR = ROOT / "docs/research/ap_statistics_graph_response_seed_2026_07_02"
IMG_DIR = OUT_DIR / "reference_images"
JSONL_PATH = OUT_DIR / "ap_statistics_graph_response_seed_2026_07_02.jsonl"
CSV_PATH = OUT_DIR / "ap_statistics_graph_response_seed_2026_07_02.csv"
README_PATH = OUT_DIR / "README.md"


def table_md(rows: list[dict[str, object]]) -> str:
    headers = list(rows[0].keys())
    lines = [
        "| " + " | ".join(headers) + " |",
        "| " + " | ".join(["---"] * len(headers)) + " |",
    ]
    for row in rows:
        lines.append("| " + " | ".join(str(row[h]) for h in headers) + " |")
    return "\n".join(lines)


WIDTH = 1200
HEIGHT = 800
MARGIN_LEFT = 140
MARGIN_RIGHT = 80
MARGIN_TOP = 90
MARGIN_BOTTOM = 130


def font(size: int) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    candidates = [
        "/System/Library/Fonts/Supplemental/Arial.ttf",
        "/System/Library/Fonts/Helvetica.ttc",
        "/Library/Fonts/Arial.ttf",
    ]
    for candidate in candidates:
        try:
            return ImageFont.truetype(candidate, size)
        except OSError:
            pass
    return ImageFont.load_default()


def canvas(title: str, x_label: str = "", y_label: str = "") -> tuple[Image.Image, ImageDraw.ImageDraw]:
    img = Image.new("RGB", (WIDTH, HEIGHT), "white")
    d = ImageDraw.Draw(img)
    d.text((WIDTH / 2, 32), title, fill="black", font=font(30), anchor="ma")
    x0, y0 = MARGIN_LEFT, HEIGHT - MARGIN_BOTTOM
    x1, y1 = WIDTH - MARGIN_RIGHT, MARGIN_TOP
    d.line((x0, y0, x1, y0), fill="black", width=3)
    d.line((x0, y0, x0, y1), fill="black", width=3)
    if x_label:
        d.text(((x0 + x1) / 2, HEIGHT - 52), x_label, fill="black", font=font(24), anchor="ma")
    if y_label:
        d.text((MARGIN_LEFT, MARGIN_TOP - 32), y_label, fill="black", font=font(22), anchor="la")
    return img, d


def x_map(value: float, min_value: float, max_value: float) -> float:
    return MARGIN_LEFT + (value - min_value) / (max_value - min_value) * (WIDTH - MARGIN_LEFT - MARGIN_RIGHT)


def y_map(value: float, min_value: float, max_value: float) -> float:
    return HEIGHT - MARGIN_BOTTOM - (value - min_value) / (max_value - min_value) * (HEIGHT - MARGIN_TOP - MARGIN_BOTTOM)


def save_image(img: Image.Image, path: Path) -> None:
    img.save(path)


def boxplot_image(path: Path) -> None:
    img, d = canvas("Delivery Times by Route Type", "Route type", "Delivery time (minutes)")
    stats = [("Rural routes", 24, 28, 31, 38, 42), ("Urban routes", 30, 33, 37, 45, 49)]
    y_min, y_max = 20, 52
    for tick in range(20, 55, 5):
        y = y_map(tick, y_min, y_max)
        d.line((MARGIN_LEFT - 8, y, MARGIN_LEFT, y), fill="black", width=2)
        d.text((MARGIN_LEFT - 16, y), str(tick), fill="black", font=font(18), anchor="rm")
        d.line((MARGIN_LEFT, y, WIDTH - MARGIN_RIGHT, y), fill="#dddddd", width=1)
    for i, (label, mn, q1, med, q3, mx) in enumerate(stats):
        x = MARGIN_LEFT + (i + 1) * (WIDTH - MARGIN_LEFT - MARGIN_RIGHT) / 3
        box_w = 120
        y_mn, y_q1, y_med, y_q3, y_mx = [y_map(v, y_min, y_max) for v in (mn, q1, med, q3, mx)]
        d.line((x, y_mn, x, y_q1), fill="black", width=4)
        d.line((x, y_q3, x, y_mx), fill="black", width=4)
        d.line((x - 45, y_mn, x + 45, y_mn), fill="black", width=4)
        d.line((x - 45, y_mx, x + 45, y_mx), fill="black", width=4)
        d.rectangle((x - box_w / 2, y_q3, x + box_w / 2, y_q1), outline="#4c78a8", width=5)
        d.line((x - box_w / 2, y_med, x + box_w / 2, y_med), fill="#c1121f", width=5)
        d.text((x, HEIGHT - MARGIN_BOTTOM + 32), label, fill="black", font=font(20), anchor="ma")
    save_image(img, path)


def segmented_bar_image(path: Path) -> None:
    groups = ["Underclass", "Upperclass"]
    categories = ["Never", "Monthly", "Weekly"]
    values = [[0.20, 0.45, 0.35], [0.12, 0.38, 0.50]]
    colors = ["#8ab6d6", "#f6c177", "#a7c957"]
    img, d = canvas("Homework App Use by Class Group", "Relative frequency", "")
    bar_h = 110
    for gi, group in enumerate(groups):
        y = MARGIN_TOP + 180 + gi * 180
        x = MARGIN_LEFT
        for ci, category in enumerate(categories):
            w = values[gi][ci] * (WIDTH - MARGIN_LEFT - MARGIN_RIGHT)
            d.rectangle((x, y, x + w, y + bar_h), fill=colors[ci], outline="white", width=3)
            d.text((x + w / 2, y + bar_h / 2), category, fill="black", font=font(20), anchor="mm")
            x += w
        d.text((MARGIN_LEFT - 20, y + bar_h / 2), group, fill="black", font=font(22), anchor="rm")
    for tick in [0, 0.25, 0.5, 0.75, 1.0]:
        x = x_map(tick, 0, 1)
        d.line((x, HEIGHT - MARGIN_BOTTOM, x, HEIGHT - MARGIN_BOTTOM + 10), fill="black", width=2)
        d.text((x, HEIGHT - MARGIN_BOTTOM + 28), f"{tick:.2g}", fill="black", font=font(18), anchor="ma")
    save_image(img, path)


def mosaic_image(path: Path) -> None:
    rows = [
        ("Phone", {"Low": 24, "Medium": 36, "High": 40}),
        ("Laptop", {"Low": 18, "Medium": 52, "High": 30}),
        ("Tablet", {"Low": 30, "Medium": 30, "High": 20}),
    ]
    total = sum(sum(counts.values()) for _, counts in rows)
    colors = {"Low": "#b8d8ba", "Medium": "#f4d35e", "High": "#ee964b"}
    img, d = canvas("Stress Level by Primary Study Device", "Primary study device", "Conditional proportion")
    x = MARGIN_LEFT
    plot_w = WIDTH - MARGIN_LEFT - MARGIN_RIGHT
    plot_h = HEIGHT - MARGIN_TOP - MARGIN_BOTTOM
    for device, counts in rows:
        width = sum(counts.values()) / total * plot_w
        y_bottom = HEIGHT - MARGIN_BOTTOM
        for level, count in counts.items():
            height = count / sum(counts.values()) * plot_h
            y_top = y_bottom - height
            d.rectangle((x, y_top, x + width, y_bottom), fill=colors[level], outline="white", width=4)
            d.text((x + width / 2, (y_top + y_bottom) / 2), level, fill="black", font=font(20), anchor="mm")
            y_bottom = y_top
        d.text((x + width / 2, HEIGHT - MARGIN_BOTTOM + 28), device, fill="black", font=font(20), anchor="ma")
        x += width
    for tick in [0, 0.25, 0.5, 0.75, 1.0]:
        y = y_map(tick, 0, 1)
        d.line((MARGIN_LEFT - 8, y, MARGIN_LEFT, y), fill="black", width=2)
        d.text((MARGIN_LEFT - 16, y), f"{tick:.2g}", fill="black", font=font(18), anchor="rm")
    save_image(img, path)


def dotplot_image(path: Path) -> None:
    values = [4, 5, 5, 6, 6, 6, 7, 7, 8, 11, 12, 14]
    counts = {v: values.count(v) for v in sorted(set(values))}
    img, d = canvas("Wait Times for 12 Customers", "Minutes waiting", "")
    for x, count in counts.items():
        for level in range(count):
            cx = x_map(x, 4, 14)
            cy = HEIGHT - MARGIN_BOTTOM - 30 - level * 42
            d.ellipse((cx - 14, cy - 14, cx + 14, cy + 14), fill="#4c78a8")
    for tick in range(4, 15):
        x = x_map(tick, 4, 14)
        d.line((x, HEIGHT - MARGIN_BOTTOM, x, HEIGHT - MARGIN_BOTTOM + 10), fill="black", width=2)
        d.text((x, HEIGHT - MARGIN_BOTTOM + 28), str(tick), fill="black", font=font(18), anchor="ma")
    save_image(img, path)


def scatterplot_image(path: Path) -> None:
    points = list(zip([2, 3, 4, 5, 6, 7, 8, 9, 10], [41, 45, 48, 53, 55, 59, 65, 68, 72]))
    img, d = canvas("Quiz Score vs. Hours Studied", "Hours studied", "Quiz score")
    for tick in range(2, 11, 2):
        x = x_map(tick, 2, 10)
        d.line((x, HEIGHT - MARGIN_BOTTOM, x, HEIGHT - MARGIN_BOTTOM + 10), fill="black", width=2)
        d.text((x, HEIGHT - MARGIN_BOTTOM + 28), str(tick), fill="black", font=font(18), anchor="ma")
    for tick in range(40, 76, 5):
        y = y_map(tick, 40, 75)
        d.line((MARGIN_LEFT - 8, y, MARGIN_LEFT, y), fill="black", width=2)
        d.text((MARGIN_LEFT - 16, y), str(tick), fill="black", font=font(18), anchor="rm")
        d.line((MARGIN_LEFT, y, WIDTH - MARGIN_RIGHT, y), fill="#e5e5e5", width=1)
    d.line((x_map(2, 2, 10), y_map(41, 40, 75), x_map(10, 2, 10), y_map(72, 40, 75)), fill="#d95f02", width=5)
    for px, py in points:
        cx, cy = x_map(px, 2, 10), y_map(py, 40, 75)
        d.ellipse((cx - 11, cy - 11, cx + 11, cy + 11), fill="#4c78a8")
    save_image(img, path)


def annotation_image(path: Path) -> None:
    xs = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50]
    ys = [0.02, 0.07, 0.18, 0.39, 0.61, 0.78, 0.88, 0.94, 0.97, 0.99]
    img, d = canvas("Probability Condition by Sample Size", "Sample size", "Probability condition is met")
    for tick in range(0, 51, 10):
        x = x_map(tick, 0, 50)
        d.line((x, HEIGHT - MARGIN_BOTTOM, x, HEIGHT - MARGIN_BOTTOM + 10), fill="black", width=2)
        d.text((x, HEIGHT - MARGIN_BOTTOM + 28), str(tick), fill="black", font=font(18), anchor="ma")
    for tick in [0, 0.25, 0.5, 0.75, 1.0]:
        y = y_map(tick, 0, 1)
        d.line((MARGIN_LEFT - 8, y, MARGIN_LEFT, y), fill="black", width=2)
        d.text((MARGIN_LEFT - 16, y), f"{tick:.2g}", fill="black", font=font(18), anchor="rm")
        d.line((MARGIN_LEFT, y, WIDTH - MARGIN_RIGHT, y), fill="#e5e5e5", width=1)
    mapped = [(x_map(x, 0, 50), y_map(y, 0, 1)) for x, y in zip(xs, ys)]
    d.line(mapped, fill="#4c78a8", width=5, joint="curve")
    tx, ty = x_map(20, 0, 50), y_map(0.39, 0, 1)
    d.line((tx - 20, ty - 20, tx + 20, ty + 20), fill="#c1121f", width=6)
    d.line((tx - 20, ty + 20, tx + 20, ty - 20), fill="#c1121f", width=6)
    d.text((tx + 28, ty - 12), "n = 20, p ~ 0.39", fill="#c1121f", font=font(22), anchor="lm")
    save_image(img, path)


def boxplot_image_2(path: Path) -> None:
    img, d = canvas("Commute Times by Transportation Type", "Transportation type", "Commute time (minutes)")
    stats = [("Bus", 18, 24, 29, 41, 55), ("Bike", 12, 16, 19, 25, 31)]
    y_min, y_max = 10, 60
    for tick in range(10, 65, 10):
        y = y_map(tick, y_min, y_max)
        d.line((MARGIN_LEFT - 8, y, MARGIN_LEFT, y), fill="black", width=2)
        d.text((MARGIN_LEFT - 16, y), str(tick), fill="black", font=font(18), anchor="rm")
        d.line((MARGIN_LEFT, y, WIDTH - MARGIN_RIGHT, y), fill="#dddddd", width=1)
    for i, (label, mn, q1, med, q3, mx) in enumerate(stats):
        x = MARGIN_LEFT + (i + 1) * (WIDTH - MARGIN_LEFT - MARGIN_RIGHT) / 3
        box_w = 120
        y_mn, y_q1, y_med, y_q3, y_mx = [y_map(v, y_min, y_max) for v in (mn, q1, med, q3, mx)]
        d.line((x, y_mn, x, y_q1), fill="black", width=4)
        d.line((x, y_q3, x, y_mx), fill="black", width=4)
        d.line((x - 45, y_mn, x + 45, y_mn), fill="black", width=4)
        d.line((x - 45, y_mx, x + 45, y_mx), fill="black", width=4)
        d.rectangle((x - box_w / 2, y_q3, x + box_w / 2, y_q1), outline="#4c78a8", width=5)
        d.line((x - box_w / 2, y_med, x + box_w / 2, y_med), fill="#c1121f", width=5)
        d.text((x, HEIGHT - MARGIN_BOTTOM + 32), label, fill="black", font=font(20), anchor="ma")
    save_image(img, path)


def segmented_bar_image_2(path: Path) -> None:
    groups = ["Before lesson", "After lesson"]
    categories = ["Incorrect", "Partially correct", "Correct"]
    values = [[0.30, 0.42, 0.28], [0.14, 0.30, 0.56]]
    colors = ["#ef9a9a", "#ffd166", "#8ac926"]
    img, d = canvas("Simulation Explanation Quality", "Relative frequency", "")
    bar_h = 110
    for gi, group in enumerate(groups):
        y = MARGIN_TOP + 180 + gi * 180
        x = MARGIN_LEFT
        for ci, category in enumerate(categories):
            w = values[gi][ci] * (WIDTH - MARGIN_LEFT - MARGIN_RIGHT)
            d.rectangle((x, y, x + w, y + bar_h), fill=colors[ci], outline="white", width=3)
            d.text((x + w / 2, y + bar_h / 2), category, fill="black", font=font(18), anchor="mm")
            x += w
        d.text((MARGIN_LEFT - 20, y + bar_h / 2), group, fill="black", font=font(22), anchor="rm")
    for tick in [0, 0.25, 0.5, 0.75, 1.0]:
        x = x_map(tick, 0, 1)
        d.line((x, HEIGHT - MARGIN_BOTTOM, x, HEIGHT - MARGIN_BOTTOM + 10), fill="black", width=2)
        d.text((x, HEIGHT - MARGIN_BOTTOM + 28), f"{tick:.2g}", fill="black", font=font(18), anchor="ma")
    save_image(img, path)


def mosaic_image_2(path: Path) -> None:
    rows = [
        ("Morning", {"Low": 36, "Medium": 42, "High": 12}),
        ("Afternoon", {"Low": 28, "Medium": 50, "High": 32}),
        ("Evening", {"Low": 16, "Medium": 38, "High": 46}),
    ]
    total = sum(sum(counts.values()) for _, counts in rows)
    colors = {"Low": "#b8d8ba", "Medium": "#f4d35e", "High": "#ee964b"}
    img, d = canvas("Caffeine Use by Study Time", "Usual study time", "Conditional proportion")
    x = MARGIN_LEFT
    plot_w = WIDTH - MARGIN_LEFT - MARGIN_RIGHT
    plot_h = HEIGHT - MARGIN_TOP - MARGIN_BOTTOM
    for time, counts in rows:
        width = sum(counts.values()) / total * plot_w
        y_bottom = HEIGHT - MARGIN_BOTTOM
        for level, count in counts.items():
            height = count / sum(counts.values()) * plot_h
            y_top = y_bottom - height
            d.rectangle((x, y_top, x + width, y_bottom), fill=colors[level], outline="white", width=4)
            d.text((x + width / 2, (y_top + y_bottom) / 2), level, fill="black", font=font(20), anchor="mm")
            y_bottom = y_top
        d.text((x + width / 2, HEIGHT - MARGIN_BOTTOM + 28), time, fill="black", font=font(20), anchor="ma")
        x += width
    for tick in [0, 0.25, 0.5, 0.75, 1.0]:
        y = y_map(tick, 0, 1)
        d.line((MARGIN_LEFT - 8, y, MARGIN_LEFT, y), fill="black", width=2)
        d.text((MARGIN_LEFT - 16, y), f"{tick:.2g}", fill="black", font=font(18), anchor="rm")
    save_image(img, path)


def dotplot_image_2(path: Path) -> None:
    values = [68, 70, 71, 72, 72, 73, 74, 74, 75, 76, 78, 82]
    counts = {v: values.count(v) for v in sorted(set(values))}
    img, d = canvas("Plant Heights After 4 Weeks", "Height (cm)", "")
    for x, count in counts.items():
        for level in range(count):
            cx = x_map(x, 68, 82)
            cy = HEIGHT - MARGIN_BOTTOM - 30 - level * 42
            d.ellipse((cx - 14, cy - 14, cx + 14, cy + 14), fill="#4c78a8")
    for tick in range(68, 83, 2):
        x = x_map(tick, 68, 82)
        d.line((x, HEIGHT - MARGIN_BOTTOM, x, HEIGHT - MARGIN_BOTTOM + 10), fill="black", width=2)
        d.text((x, HEIGHT - MARGIN_BOTTOM + 28), str(tick), fill="black", font=font(18), anchor="ma")
    save_image(img, path)


def scatterplot_image_2(path: Path) -> None:
    points = list(zip([12, 14, 15, 17, 18, 20, 21, 23, 25], [88, 84, 82, 79, 77, 73, 70, 66, 63]))
    img, d = canvas("Battery Charge vs. Screen Brightness", "Screen brightness (%)", "Battery remaining (%)")
    for tick in range(10, 26, 5):
        x = x_map(tick, 10, 26)
        d.line((x, HEIGHT - MARGIN_BOTTOM, x, HEIGHT - MARGIN_BOTTOM + 10), fill="black", width=2)
        d.text((x, HEIGHT - MARGIN_BOTTOM + 28), str(tick), fill="black", font=font(18), anchor="ma")
    for tick in range(60, 91, 5):
        y = y_map(tick, 60, 90)
        d.line((MARGIN_LEFT - 8, y, MARGIN_LEFT, y), fill="black", width=2)
        d.text((MARGIN_LEFT - 16, y), str(tick), fill="black", font=font(18), anchor="rm")
        d.line((MARGIN_LEFT, y, WIDTH - MARGIN_RIGHT, y), fill="#e5e5e5", width=1)
    d.line((x_map(12, 10, 26), y_map(88, 60, 90), x_map(25, 10, 26), y_map(63, 60, 90)), fill="#d95f02", width=5)
    for px, py in points:
        cx, cy = x_map(px, 10, 26), y_map(py, 60, 90)
        d.ellipse((cx - 11, cy - 11, cx + 11, cy + 11), fill="#4c78a8")
    save_image(img, path)


def annotation_image_2(path: Path) -> None:
    xs = [0, 5, 10, 15, 20, 25, 30, 35, 40]
    ys = [0.12, 0.20, 0.34, 0.52, 0.69, 0.81, 0.89, 0.94, 0.97]
    img, d = canvas("Detection Rate by Added Sample Size", "Added sample size", "Detection rate")
    for tick in range(0, 41, 5):
        x = x_map(tick, 0, 40)
        d.line((x, HEIGHT - MARGIN_BOTTOM, x, HEIGHT - MARGIN_BOTTOM + 10), fill="black", width=2)
        d.text((x, HEIGHT - MARGIN_BOTTOM + 28), str(tick), fill="black", font=font(18), anchor="ma")
    for tick in [0, 0.25, 0.5, 0.75, 1.0]:
        y = y_map(tick, 0, 1)
        d.line((MARGIN_LEFT - 8, y, MARGIN_LEFT, y), fill="black", width=2)
        d.text((MARGIN_LEFT - 16, y), f"{tick:.2g}", fill="black", font=font(18), anchor="rm")
        d.line((MARGIN_LEFT, y, WIDTH - MARGIN_RIGHT, y), fill="#e5e5e5", width=1)
    mapped = [(x_map(x, 0, 40), y_map(y, 0, 1)) for x, y in zip(xs, ys)]
    d.line(mapped, fill="#4c78a8", width=5, joint="curve")
    tx, ty = x_map(25, 0, 40), y_map(0.81, 0, 1)
    d.line((tx - 20, ty - 20, tx + 20, ty + 20), fill="#c1121f", width=6)
    d.line((tx - 20, ty + 20, tx + 20, ty - 20), fill="#c1121f", width=6)
    d.text((tx + 28, ty - 12), "n = 25, rate ~ 0.81", fill="#c1121f", font=font(22), anchor="lm")
    save_image(img, path)


def build_records() -> list[dict[str, object]]:
    records: list[dict[str, object]] = []

    def add(record: dict[str, object]) -> None:
        record["item_version"] = "v0.1-research-seed"
        record["question_type"] = "frq"
        record["frq_form"] = "short"
        record["review_stage"] = "canonical_answer"
        record["rights_status"] = "independently_authored_synthetic_research_seed_unverified"
        record["modules"] = ["AP Statistics", "data analysis", "graphical displays"]
        record["notes"] = (
            "Original research seed for hand-drawn AP Statistics graph-response grading. "
            "Do not expose criterion definitions to the person drawing the graph."
        )
        record["student_prompt"] = record["stem"]
        records.append(record)

    box_rows = [
        {"Route type": "Rural", "Min": 24, "Q1": 28, "Median": 31, "Q3": 38, "Max": 42},
        {"Route type": "Urban", "Min": 30, "Q1": 33, "Median": 37, "Q3": 45, "Max": 49},
    ]
    add({
        "item_id": "APSTATS-HDG-2026-GRAPH-001",
        "archetype": "boxplot_construction_interpretation",
        "subtopics": ["boxplots", "five-number summaries", "distribution comparison"],
        "stem": (
            "A logistics teacher recorded delivery times for two route types. Construct side-by-side boxplots "
            "from the five-number summaries, using one common horizontal or vertical scale. Then write one "
            "sentence comparing the centers and one sentence comparing the variability.\n\n"
            f"{table_md(box_rows)}"
        ),
        "display_table": box_rows,
        "canonical_answer": (
            "Side-by-side boxplots with rural min/Q1/median/Q3/max at 24/28/31/38/42 and urban at "
            "30/33/37/45/49. Urban routes have the higher median delivery time; urban routes also have "
            "greater variability by IQR and range."
        ),
        "criterion_definitions": [
            {"criterion_id": "BOXPLOT_SCALE", "met_rule": "Uses one interpretable common scale for both groups."},
            {"criterion_id": "FIVE_NUMBER_VALUES", "met_rule": "Both boxplots recover the listed five-number summaries."},
            {"criterion_id": "CENTER_COMPARISON", "met_rule": "Correctly compares medians in context."},
            {"criterion_id": "VARIABILITY_COMPARISON", "met_rule": "Correctly compares IQR or range in context."},
        ],
        "expected_graph_spec": {"representation": "side-by-side boxplots", "x_axis": "route type", "y_axis": "delivery time (minutes)"},
        "expected_image_filename": "APSTATS-HDG-2026-GRAPH-001__reference.png",
    })

    segmented_rows = [
        {"Class group": "Underclass", "Never": 20, "Monthly": 45, "Weekly": 35},
        {"Class group": "Upperclass", "Never": 12, "Monthly": 38, "Weekly": 50},
    ]
    add({
        "item_id": "APSTATS-HDG-2026-GRAPH-002",
        "archetype": "segmented_bar_graph_construction",
        "subtopics": ["segmented bar graphs", "relative frequency", "categorical association"],
        "stem": (
            "A school surveyed students about how often they use a homework planning app. Complete a segmented "
            "bar graph using relative frequencies for each class group. Then identify which group has the larger "
            "relative frequency of weekly app use.\n\n"
            f"{table_md(segmented_rows)}"
        ),
        "display_table": segmented_rows,
        "canonical_answer": (
            "Underclass segmented bar: 0.20 never, 0.45 monthly, 0.35 weekly. Upperclass segmented bar: "
            "0.12 never, 0.38 monthly, 0.50 weekly. Upperclass students have the larger relative frequency "
            "of weekly app use."
        ),
        "criterion_definitions": [
            {"criterion_id": "RELATIVE_FREQUENCIES", "met_rule": "Converts counts to correct within-group relative frequencies."},
            {"criterion_id": "SEGMENTED_BARS", "met_rule": "Draws two complete segmented bars with total length 1 or 100%."},
            {"criterion_id": "CATEGORY_LABELS", "met_rule": "Segments and class groups are identifiable."},
            {"criterion_id": "COMPARISON", "met_rule": "Correctly identifies the larger weekly relative frequency."},
        ],
        "expected_graph_spec": {"representation": "segmented bar graph", "x_axis": "relative frequency", "groups": ["Underclass", "Upperclass"]},
        "expected_image_filename": "APSTATS-HDG-2026-GRAPH-002__reference.png",
    })

    mosaic_rows = [
        {"Device": "Phone", "Low": 24, "Medium": 36, "High": 40},
        {"Device": "Laptop", "Low": 18, "Medium": 52, "High": 30},
        {"Device": "Tablet", "Low": 30, "Medium": 30, "High": 20},
    ]
    add({
        "item_id": "APSTATS-HDG-2026-GRAPH-003",
        "archetype": "mosaic_plot_interpretation",
        "subtopics": ["mosaic plots", "area reasoning", "conditional proportion"],
        "stem": (
            "Students were classified by primary study device and reported stress level. Draw a mosaic plot "
            "from the table so that each device width is proportional to its total count and each vertical "
            "segment shows the conditional distribution of stress level within that device. Then state which "
            "device group has the largest number of high-stress students.\n\n"
            f"{table_md(mosaic_rows)}"
        ),
        "display_table": mosaic_rows,
        "canonical_answer": (
            "Device widths are proportional to totals: Phone 100, Laptop 100, Tablet 80 out of 280. Segment "
            "heights use within-device proportions. Phone has the largest number of high-stress students: 40, "
            "compared with 30 for Laptop and 20 for Tablet."
        ),
        "criterion_definitions": [
            {"criterion_id": "WIDTHS_BY_TOTAL", "met_rule": "Device widths are proportional to device totals."},
            {"criterion_id": "HEIGHTS_BY_CONDITIONAL_PROPORTION", "met_rule": "Segment heights use within-device proportions."},
            {"criterion_id": "SEGMENT_LABELS", "met_rule": "Device and stress-level categories are identifiable."},
            {"criterion_id": "AREA_OR_COUNT_REASONING", "met_rule": "Correctly identifies Phone as largest high-stress count."},
        ],
        "expected_graph_spec": {"representation": "mosaic plot", "x_axis": "primary study device", "y_axis": "conditional stress-level proportion"},
        "expected_image_filename": "APSTATS-HDG-2026-GRAPH-003__reference.png",
    })

    dot_rows = [{"Wait time (min)": v} for v in [4, 5, 5, 6, 6, 6, 7, 7, 8, 11, 12, 14]]
    add({
        "item_id": "APSTATS-HDG-2026-GRAPH-004",
        "archetype": "dotplot_distribution_shape",
        "subtopics": ["dotplots", "shape", "outliers", "distribution description"],
        "stem": (
            "A sample of 12 customer wait times is shown below. Construct a dotplot of the data, then describe "
            "the distribution's shape and identify any possible outlier.\n\n"
            f"{table_md(dot_rows)}"
        ),
        "display_table": dot_rows,
        "canonical_answer": (
            "Dotplot places dots at 4, two at 5, three at 6, two at 7, one at 8, one at 11, one at 12, and "
            "one at 14. The distribution is right-skewed, with 14 minutes a possible high outlier."
        ),
        "criterion_definitions": [
            {"criterion_id": "DOT_COUNTS", "met_rule": "Plots the correct number of dots at each wait time."},
            {"criterion_id": "AXIS_SCALE", "met_rule": "Uses an interpretable numeric scale covering 4 through 14."},
            {"criterion_id": "SHAPE_DESCRIPTION", "met_rule": "Describes the distribution as right-skewed in context."},
            {"criterion_id": "OUTLIER_NOTE", "met_rule": "Identifies 14 minutes as a possible high outlier or unusual value."},
        ],
        "expected_graph_spec": {"representation": "dotplot", "x_axis": "wait time (minutes)"},
        "expected_image_filename": "APSTATS-HDG-2026-GRAPH-004__reference.png",
    })

    scatter_rows = [
        {"Hours studied": x, "Quiz score": y}
        for x, y in zip([2, 3, 4, 5, 6, 7, 8, 9, 10], [41, 45, 48, 53, 55, 59, 65, 68, 72])
    ]
    add({
        "item_id": "APSTATS-HDG-2026-GRAPH-005",
        "archetype": "scatterplot_regression_context",
        "subtopics": ["scatterplots", "linear association", "regression"],
        "stem": (
            "A teacher recorded hours studied and quiz score for nine students. Construct a scatterplot, sketch "
            "a reasonable least-squares trend line, and describe the direction, form, and strength of the association "
            "in context.\n\n"
            f"{table_md(scatter_rows)}"
        ),
        "display_table": scatter_rows,
        "canonical_answer": (
            "Scatterplot shows a strong positive roughly linear association between hours studied and quiz score. "
            "A reasonable trend line rises from about (2, 41) toward about (10, 72)."
        ),
        "criterion_definitions": [
            {"criterion_id": "POINTS_PLOTTED", "met_rule": "Plots all nine ordered pairs at recoverable locations."},
            {"criterion_id": "AXIS_LABELS", "met_rule": "Labels hours studied and quiz score on the correct axes."},
            {"criterion_id": "TREND_LINE", "met_rule": "Sketches a reasonable increasing line through the point cloud."},
            {"criterion_id": "ASSOCIATION_DESCRIPTION", "met_rule": "Describes strong positive roughly linear association in context."},
        ],
        "expected_graph_spec": {"representation": "scatterplot with trend line", "x_axis": "hours studied", "y_axis": "quiz score"},
        "expected_image_filename": "APSTATS-HDG-2026-GRAPH-005__reference.png",
    })

    annotation_rows = [
        {"Sample size": x, "Probability": y}
        for x, y in zip([5, 10, 15, 20, 25, 30, 35, 40, 45, 50], [0.02, 0.07, 0.18, 0.39, 0.61, 0.78, 0.88, 0.94, 0.97, 0.99])
    ]
    add({
        "item_id": "APSTATS-HDG-2026-GRAPH-006",
        "archetype": "graph_annotation_marking_value",
        "subtopics": ["graph interpretation", "marking a value", "sampling conditions"],
        "stem": (
            "The table gives values from a curve showing the probability that a sample satisfies a condition as "
            "sample size increases. Draw the curve on a graph with sample size on the x-axis and probability on "
            "the y-axis. Mark the point for sample size 20 with an X, then estimate the corresponding probability.\n\n"
            f"{table_md(annotation_rows)}"
        ),
        "display_table": annotation_rows,
        "canonical_answer": (
            "Curve increases from near 0 toward 1. The marked X should be at sample size 20 and probability "
            "about 0.39. A reasonable estimate is approximately 0.4."
        ),
        "criterion_definitions": [
            {"criterion_id": "CURVE_SHAPE", "met_rule": "Draws an increasing curve consistent with the table."},
            {"criterion_id": "AXIS_SCALE_LABELS", "met_rule": "Labels sample size and probability with interpretable scales."},
            {"criterion_id": "X_LOCATION", "met_rule": "Places X at sample size 20 and probability about 0.39."},
            {"criterion_id": "PROBABILITY_ESTIMATE", "met_rule": "Reports an estimate close to 0.39 or 0.4."},
        ],
        "expected_graph_spec": {"representation": "curve with marked point", "x_axis": "sample size", "y_axis": "probability"},
        "expected_image_filename": "APSTATS-HDG-2026-GRAPH-006__reference.png",
    })

    box_rows_2 = [
        {"Transportation": "Bus", "Min": 18, "Q1": 24, "Median": 29, "Q3": 41, "Max": 55},
        {"Transportation": "Bike", "Min": 12, "Q1": 16, "Median": 19, "Q3": 25, "Max": 31},
    ]
    add({
        "item_id": "APSTATS-HDG-2026-GRAPH-007",
        "archetype": "boxplot_construction_interpretation",
        "subtopics": ["boxplots", "five-number summaries", "distribution comparison"],
        "stem": (
            "A city planner compared commute times for students who usually ride the bus and students who "
            "usually bike. Construct side-by-side boxplots from the five-number summaries using one common "
            "scale. Then compare the typical commute time and the spread in context.\n\n"
            f"{table_md(box_rows_2)}"
        ),
        "display_table": box_rows_2,
        "canonical_answer": (
            "Side-by-side boxplots with bus min/Q1/median/Q3/max at 18/24/29/41/55 and bike at "
            "12/16/19/25/31. Bus commutes have the larger median and greater spread by both IQR and range."
        ),
        "criterion_definitions": [
            {"criterion_id": "BOXPLOT_SCALE", "met_rule": "Uses one interpretable common scale for both groups."},
            {"criterion_id": "FIVE_NUMBER_VALUES", "met_rule": "Both boxplots recover the listed five-number summaries."},
            {"criterion_id": "CENTER_COMPARISON", "met_rule": "Correctly compares medians in context."},
            {"criterion_id": "VARIABILITY_COMPARISON", "met_rule": "Correctly compares IQR or range in context."},
        ],
        "expected_graph_spec": {"representation": "side-by-side boxplots", "x_axis": "transportation type", "y_axis": "commute time (minutes)"},
        "expected_image_filename": "APSTATS-HDG-2026-GRAPH-007__reference.png",
    })

    segmented_rows_2 = [
        {"Lesson timing": "Before lesson", "Incorrect": 30, "Partially correct": 42, "Correct": 28},
        {"Lesson timing": "After lesson", "Incorrect": 14, "Partially correct": 30, "Correct": 56},
    ]
    add({
        "item_id": "APSTATS-HDG-2026-GRAPH-008",
        "archetype": "segmented_bar_graph_construction",
        "subtopics": ["segmented bar graphs", "relative frequency", "categorical association"],
        "stem": (
            "A teacher scored short written explanations before and after a simulation lesson. Complete a "
            "segmented bar graph using relative frequencies for each lesson timing group. Then state whether "
            "the relative frequency of correct explanations increased after the lesson.\n\n"
            f"{table_md(segmented_rows_2)}"
        ),
        "display_table": segmented_rows_2,
        "canonical_answer": (
            "Before lesson segmented bar: 0.30 incorrect, 0.42 partially correct, 0.28 correct. After lesson "
            "segmented bar: 0.14 incorrect, 0.30 partially correct, 0.56 correct. The relative frequency of "
            "correct explanations increased after the lesson."
        ),
        "criterion_definitions": [
            {"criterion_id": "RELATIVE_FREQUENCIES", "met_rule": "Converts counts to correct within-group relative frequencies."},
            {"criterion_id": "SEGMENTED_BARS", "met_rule": "Draws two complete segmented bars with total length 1 or 100%."},
            {"criterion_id": "CATEGORY_LABELS", "met_rule": "Segments and lesson timing groups are identifiable."},
            {"criterion_id": "COMPARISON", "met_rule": "Correctly states that correct explanations increased after the lesson."},
        ],
        "expected_graph_spec": {"representation": "segmented bar graph", "x_axis": "relative frequency", "groups": ["Before lesson", "After lesson"]},
        "expected_image_filename": "APSTATS-HDG-2026-GRAPH-008__reference.png",
    })

    mosaic_rows_2 = [
        {"Study time": "Morning", "Low": 36, "Medium": 42, "High": 12},
        {"Study time": "Afternoon", "Low": 28, "Medium": 50, "High": 32},
        {"Study time": "Evening", "Low": 16, "Medium": 38, "High": 46},
    ]
    add({
        "item_id": "APSTATS-HDG-2026-GRAPH-009",
        "archetype": "mosaic_plot_interpretation",
        "subtopics": ["mosaic plots", "area reasoning", "conditional proportion"],
        "stem": (
            "Students were grouped by usual study time and caffeine use level. Draw a mosaic plot so each study "
            "time width is proportional to its total count and each vertical segment shows the conditional "
            "distribution of caffeine use within that study time. Then identify which study-time group has the "
            "largest number of high-caffeine students.\n\n"
            f"{table_md(mosaic_rows_2)}"
        ),
        "display_table": mosaic_rows_2,
        "canonical_answer": (
            "Study-time widths are proportional to totals: Morning 90, Afternoon 110, Evening 100 out of 300. "
            "Segment heights use within-study-time proportions. Evening has the largest high-caffeine count: "
            "46, compared with 32 for Afternoon and 12 for Morning."
        ),
        "criterion_definitions": [
            {"criterion_id": "WIDTHS_BY_TOTAL", "met_rule": "Study-time widths are proportional to group totals."},
            {"criterion_id": "HEIGHTS_BY_CONDITIONAL_PROPORTION", "met_rule": "Segment heights use within-group proportions."},
            {"criterion_id": "SEGMENT_LABELS", "met_rule": "Study-time and caffeine-use categories are identifiable."},
            {"criterion_id": "AREA_OR_COUNT_REASONING", "met_rule": "Correctly identifies Evening as largest high-caffeine count."},
        ],
        "expected_graph_spec": {"representation": "mosaic plot", "x_axis": "usual study time", "y_axis": "conditional caffeine-use proportion"},
        "expected_image_filename": "APSTATS-HDG-2026-GRAPH-009__reference.png",
    })

    dot_rows_2 = [{"Height (cm)": v} for v in [68, 70, 71, 72, 72, 73, 74, 74, 75, 76, 78, 82]]
    add({
        "item_id": "APSTATS-HDG-2026-GRAPH-010",
        "archetype": "dotplot_distribution_shape",
        "subtopics": ["dotplots", "shape", "clusters", "distribution description"],
        "stem": (
            "A biology class measured the heights of 12 plants after four weeks. Construct a dotplot of the "
            "data, then describe the distribution's shape and comment on whether there is a clear outlier.\n\n"
            f"{table_md(dot_rows_2)}"
        ),
        "display_table": dot_rows_2,
        "canonical_answer": (
            "Dotplot places dots at 68, 70, 71, two at 72, one at 73, two at 74, one at 75, one at 76, "
            "one at 78, and one at 82. The distribution is roughly unimodal with a slight right tail; 82 cm "
            "is high but not clearly isolated enough to require calling it an outlier."
        ),
        "criterion_definitions": [
            {"criterion_id": "DOT_COUNTS", "met_rule": "Plots the correct number of dots at each plant height."},
            {"criterion_id": "AXIS_SCALE", "met_rule": "Uses an interpretable numeric scale covering 68 through 82."},
            {"criterion_id": "SHAPE_DESCRIPTION", "met_rule": "Describes the distribution as roughly unimodal with slight right tail or similar."},
            {"criterion_id": "OUTLIER_NOTE", "met_rule": "Does not overstate 82 cm as a definite outlier; explains it is high or possibly unusual."},
        ],
        "expected_graph_spec": {"representation": "dotplot", "x_axis": "height (cm)"},
        "expected_image_filename": "APSTATS-HDG-2026-GRAPH-010__reference.png",
    })

    scatter_rows_2 = [
        {"Screen brightness (%)": x, "Battery remaining (%)": y}
        for x, y in zip([12, 14, 15, 17, 18, 20, 21, 23, 25], [88, 84, 82, 79, 77, 73, 70, 66, 63])
    ]
    add({
        "item_id": "APSTATS-HDG-2026-GRAPH-011",
        "archetype": "scatterplot_regression_context",
        "subtopics": ["scatterplots", "negative association", "regression"],
        "stem": (
            "A technology club measured screen brightness and battery remaining after one hour for nine phones. "
            "Construct a scatterplot, sketch a reasonable least-squares trend line, and describe the direction, "
            "form, and strength of the association in context.\n\n"
            f"{table_md(scatter_rows_2)}"
        ),
        "display_table": scatter_rows_2,
        "canonical_answer": (
            "Scatterplot shows a strong negative roughly linear association between screen brightness and battery "
            "remaining. A reasonable trend line falls from about (12, 88) toward about (25, 63)."
        ),
        "criterion_definitions": [
            {"criterion_id": "POINTS_PLOTTED", "met_rule": "Plots all nine ordered pairs at recoverable locations."},
            {"criterion_id": "AXIS_LABELS", "met_rule": "Labels screen brightness and battery remaining on the correct axes."},
            {"criterion_id": "TREND_LINE", "met_rule": "Sketches a reasonable decreasing line through the point cloud."},
            {"criterion_id": "ASSOCIATION_DESCRIPTION", "met_rule": "Describes strong negative roughly linear association in context."},
        ],
        "expected_graph_spec": {"representation": "scatterplot with trend line", "x_axis": "screen brightness (%)", "y_axis": "battery remaining (%)"},
        "expected_image_filename": "APSTATS-HDG-2026-GRAPH-011__reference.png",
    })

    annotation_rows_2 = [
        {"Added sample size": x, "Detection rate": y}
        for x, y in zip([0, 5, 10, 15, 20, 25, 30, 35, 40], [0.12, 0.20, 0.34, 0.52, 0.69, 0.81, 0.89, 0.94, 0.97])
    ]
    add({
        "item_id": "APSTATS-HDG-2026-GRAPH-012",
        "archetype": "graph_annotation_marking_value",
        "subtopics": ["graph interpretation", "marking a value", "probability curve"],
        "stem": (
            "A simulation estimated the detection rate for a rare issue as additional sample size increased. "
            "Draw the curve using the table, with added sample size on the x-axis and detection rate on the "
            "y-axis. Mark the point for added sample size 25 with an X, then estimate the corresponding "
            "detection rate.\n\n"
            f"{table_md(annotation_rows_2)}"
        ),
        "display_table": annotation_rows_2,
        "canonical_answer": (
            "Curve increases from about 0.12 toward 0.97. The marked X should be at added sample size 25 "
            "and detection rate about 0.81."
        ),
        "criterion_definitions": [
            {"criterion_id": "CURVE_SHAPE", "met_rule": "Draws an increasing curve consistent with the table."},
            {"criterion_id": "AXIS_SCALE_LABELS", "met_rule": "Labels added sample size and detection rate with interpretable scales."},
            {"criterion_id": "X_LOCATION", "met_rule": "Places X at added sample size 25 and detection rate about 0.81."},
            {"criterion_id": "RATE_ESTIMATE", "met_rule": "Reports an estimate close to 0.81."},
        ],
        "expected_graph_spec": {"representation": "curve with marked point", "x_axis": "added sample size", "y_axis": "detection rate"},
        "expected_image_filename": "APSTATS-HDG-2026-GRAPH-012__reference.png",
    })

    return records


def write_outputs(records: list[dict[str, object]]) -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    IMG_DIR.mkdir(parents=True, exist_ok=True)

    with JSONL_PATH.open("w", encoding="utf-8") as f:
        for record in records:
            f.write(json.dumps(record, sort_keys=True) + "\n")

    fields = [
        "item_id",
        "archetype",
        "stem",
        "canonical_answer",
        "expected_image_filename",
        "criterion_definitions",
        "display_table",
        "expected_graph_spec",
        "subtopics",
    ]
    with CSV_PATH.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        for record in records:
            row = {}
            for field in fields:
                value = record.get(field)
                row[field] = json.dumps(value) if isinstance(value, (list, dict)) else value
            writer.writerow(row)

    README_PATH.write_text(
        """# AP Statistics Graph-Response Seed Set - 2026-07-02

This package contains twelve original AP Statistics graph-response FRQs for
hand-drawn grading experiments. It is research seed content only; it has not
passed Learning Quality, rights/similarity, accessibility, or production
release review.

## Source Rationale

The six archetypes match graph forms confirmed in publicly available College
Board AP Statistics free-response materials and Chief Reader Reports for
2023-2025. The set contains two original FRQs for each archetype:

- boxplot construction / interpretation;
- segmented bar graph construction;
- mosaic plot interpretation;
- dotplot distribution-shape reasoning;
- scatterplot / regression-context reasoning;
- graph annotation / marking a value.

Normal-curve shading is intentionally excluded from this v0.1 seed because it
is curriculum-relevant but was not confirmed as a student-drawn graph response
task in the 2023-2025 public AP Central materials reviewed.

## Files

- `ap_statistics_graph_response_seed_2026_07_02.jsonl`: complete item metadata.
- `ap_statistics_graph_response_seed_2026_07_02.csv`: spreadsheet-friendly export.
- `reference_images/`: clean generated answer-key images, one per item, plus
  `contact_sheet.png` for quick review.
- `scripts/generate_ap_statistics_graph_response_seed.py`: deterministic generator.

## Workflow

1. Give drawers the `stem` / `student_prompt` and ask them to write the
   `item_id` on the page.
2. Keep `criterion_definitions` hidden from drawers.
3. Use `reference_images/` only as reviewer/calibration answer references,
   not as student-facing exemplars.
4. Collect blind human scores before making any grader-agreement claims.
""",
        encoding="utf-8",
    )


def render_images() -> None:
    paths = [
        IMG_DIR / "APSTATS-HDG-2026-GRAPH-001__reference.png",
        IMG_DIR / "APSTATS-HDG-2026-GRAPH-002__reference.png",
        IMG_DIR / "APSTATS-HDG-2026-GRAPH-003__reference.png",
        IMG_DIR / "APSTATS-HDG-2026-GRAPH-004__reference.png",
        IMG_DIR / "APSTATS-HDG-2026-GRAPH-005__reference.png",
        IMG_DIR / "APSTATS-HDG-2026-GRAPH-006__reference.png",
        IMG_DIR / "APSTATS-HDG-2026-GRAPH-007__reference.png",
        IMG_DIR / "APSTATS-HDG-2026-GRAPH-008__reference.png",
        IMG_DIR / "APSTATS-HDG-2026-GRAPH-009__reference.png",
        IMG_DIR / "APSTATS-HDG-2026-GRAPH-010__reference.png",
        IMG_DIR / "APSTATS-HDG-2026-GRAPH-011__reference.png",
        IMG_DIR / "APSTATS-HDG-2026-GRAPH-012__reference.png",
    ]
    boxplot_image(paths[0])
    segmented_bar_image(paths[1])
    mosaic_image(paths[2])
    dotplot_image(paths[3])
    scatterplot_image(paths[4])
    annotation_image(paths[5])
    boxplot_image_2(paths[6])
    segmented_bar_image_2(paths[7])
    mosaic_image_2(paths[8])
    dotplot_image_2(paths[9])
    scatterplot_image_2(paths[10])
    annotation_image_2(paths[11])

    thumbs = [Image.open(path).resize((360, 240)) for path in paths]
    sheet = Image.new("RGB", (1080, 960), "white")
    for index, thumb in enumerate(thumbs):
        sheet.paste(thumb, ((index % 3) * 360, (index // 3) * 240))
    sheet.save(IMG_DIR / "contact_sheet.png")


def main() -> None:
    records = build_records()
    write_outputs(records)
    render_images()
    print(f"Wrote {len(records)} AP Statistics graph-response items to {OUT_DIR}")


if __name__ == "__main__":
    main()
