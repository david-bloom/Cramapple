#!/usr/bin/env python3
"""Generate printable trace packets for the hand-drawn graph corpus."""

from __future__ import annotations

import json
import math
import re
import textwrap
from pathlib import Path
from typing import Any

from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parents[1]
CORPUS_DIR = ROOT / "docs" / "research" / "hand_drawn_graph_corpus_2026_06_29"
SOURCE_PATH = CORPUS_DIR / "hand_drawn_graph_questions_2026_06_29.jsonl"
OUT_DIR = CORPUS_DIR / "trace_sets"

PAGE_W = 1700
PAGE_H = 2200
MARGIN = 100
TRACE_COLOR = (172, 172, 172)
AXIS_COLOR = (118, 118, 118)
GRID_COLOR = (224, 224, 224)
TEXT_COLOR = (24, 24, 24)


def load_font(size: int, bold: bool = False) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    candidates = [
        "/System/Library/Fonts/Supplemental/Arial Bold.ttf" if bold else "/System/Library/Fonts/Supplemental/Arial.ttf",
        "/Library/Fonts/Arial Bold.ttf" if bold else "/Library/Fonts/Arial.ttf",
    ]
    for path in candidates:
        try:
            return ImageFont.truetype(path, size)
        except OSError:
            pass
    return ImageFont.load_default()


FONT_TITLE = load_font(42, bold=True)
FONT_H2 = load_font(30, bold=True)
FONT_BODY = load_font(25)
FONT_SMALL = load_font(20)
FONT_AXIS = load_font(22)
FONT_TINY = load_font(17)


def read_rows() -> list[dict[str, Any]]:
    return [json.loads(line) for line in SOURCE_PATH.read_text(encoding="utf-8").splitlines()]


def clean_prompt(stem: str) -> str:
    return stem.split("\n\n|", 1)[0]


def wrap(draw: ImageDraw.ImageDraw, text: str, font: ImageFont.ImageFont, width_px: int) -> list[str]:
    avg = max(8, draw.textlength("abcdefghijklmnopqrstuvwxyz", font=font) / 26)
    chars = max(20, int(width_px / avg))
    lines: list[str] = []
    for para in text.splitlines():
        if not para.strip():
            lines.append("")
            continue
        lines.extend(textwrap.wrap(para.strip(), width=chars))
    return lines


def draw_wrapped(draw: ImageDraw.ImageDraw, xy: tuple[int, int], text: str, font: ImageFont.ImageFont, width_px: int, fill=TEXT_COLOR, line_gap=8) -> int:
    x, y = xy
    for line in wrap(draw, text, font, width_px):
        draw.text((x, y), line, font=font, fill=fill)
        y += font.size + line_gap if hasattr(font, "size") else 32
    return y


def table_columns(row: dict[str, Any]) -> tuple[str, str | None, str | None]:
    keys = list(row["display_table"][0].keys())
    category_or_x = next(k for k in keys if not k.startswith("Mean ") and not k.startswith("SEM "))
    mean = next((k for k in keys if k.startswith("Mean ")), None)
    sem = next((k for k in keys if k.startswith("SEM ")), None)
    if mean is None:
        y_key = next(k for k in keys if k != category_or_x)
        return category_or_x, y_key, None
    return category_or_x, mean, sem


def short_label(value: Any, max_len: int = 18) -> str:
    text = str(value)
    return text if len(text) <= max_len else text[: max_len - 1] + "."


def draw_table(draw: ImageDraw.ImageDraw, row: dict[str, Any], x: int, y: int, w: int) -> int:
    data = row["display_table"]
    x_key, y_key, sem_key = table_columns(row)
    keys = [x_key, y_key] + ([sem_key] if sem_key else [])
    col_w = w // len(keys)
    row_h = 42
    draw.text((x, y), "Data table", font=FONT_H2, fill=TEXT_COLOR)
    y += 45
    for c, key in enumerate(keys):
        draw.rectangle((x + c * col_w, y, x + (c + 1) * col_w, y + row_h), outline=(180, 180, 180), fill=(244, 244, 244))
        draw.text((x + c * col_w + 8, y + 10), short_label(key, 26), font=FONT_TINY, fill=TEXT_COLOR)
    y += row_h
    for entry in data:
        for c, key in enumerate(keys):
            draw.rectangle((x + c * col_w, y, x + (c + 1) * col_w, y + row_h), outline=(210, 210, 210), fill=(255, 255, 255))
            draw.text((x + c * col_w + 8, y + 11), short_label(entry[key], 24), font=FONT_TINY, fill=TEXT_COLOR)
        y += row_h
    return y


def nice_max(value: float) -> float:
    if value <= 0:
        return 1
    magnitude = 10 ** math.floor(math.log10(value))
    scaled = value / magnitude
    if scaled <= 1.5:
        return 1.5 * magnitude
    if scaled <= 2:
        return 2 * magnitude
    if scaled <= 5:
        return 5 * magnitude
    return 10 * magnitude


def graph_box() -> tuple[int, int, int, int]:
    return (MARGIN + 120, 1080, PAGE_W - MARGIN - 80, PAGE_H - 230)


def draw_axes(draw: ImageDraw.ImageDraw, box: tuple[int, int, int, int], y_min: float, y_max: float, x_label: str, y_label: str) -> tuple[Any, Any]:
    left, top, right, bottom = box
    draw.line((left, bottom, right, bottom), fill=AXIS_COLOR, width=4)
    draw.line((left, top, left, bottom), fill=AXIS_COLOR, width=4)
    for i in range(6):
        t = i / 5
        y = bottom - t * (bottom - top)
        value = y_min + t * (y_max - y_min)
        draw.line((left - 10, y, right, y), fill=GRID_COLOR, width=1)
        draw.text((left - 88, y - 12), f"{value:g}"[:8], font=FONT_TINY, fill=AXIS_COLOR)
    draw.text(((left + right) // 2 - 150, bottom + 65), x_label[:52], font=FONT_AXIS, fill=AXIS_COLOR)
    draw.text((35, (top + bottom) // 2), y_label[:52], font=FONT_AXIS, fill=AXIS_COLOR)

    def y_map(v: float) -> float:
        return bottom - ((v - y_min) / (y_max - y_min)) * (bottom - top)

    def x_map(v: float, x_min: float, x_max: float) -> float:
        if x_max == x_min:
            return (left + right) / 2
        return left + ((v - x_min) / (x_max - x_min)) * (right - left)

    return x_map, y_map


def draw_error_bar(draw: ImageDraw.ImageDraw, x: float, y1: float, y2: float) -> None:
    draw.line((x, y1, x, y2), fill=TRACE_COLOR, width=6)
    draw.line((x - 18, y1, x + 18, y1), fill=TRACE_COLOR, width=5)
    draw.line((x - 18, y2, x + 18, y2), fill=TRACE_COLOR, width=5)


def draw_categorical_graph(draw: ImageDraw.ImageDraw, row: dict[str, Any]) -> None:
    data = row["display_table"]
    x_key, mean_key, sem_key = table_columns(row)
    assert mean_key and sem_key
    means = [float(d[mean_key]) for d in data]
    sems = [float(d[sem_key]) for d in data]
    y_max = nice_max(max(m + s for m, s in zip(means, sems)) * 1.1)
    box = graph_box()
    _, y_map = draw_axes(draw, box, 0, y_max, "Treatment", row["expected_graph_spec"]["y_axis"])
    left, _, right, bottom = box
    step = (right - left) / len(data)
    for idx, d in enumerate(data):
        x = left + step * (idx + 0.5)
        y = y_map(means[idx])
        draw.ellipse((x - 11, y - 11, x + 11, y + 11), outline=TRACE_COLOR, width=5)
        draw_error_bar(draw, x, y_map(means[idx] - sems[idx]), y_map(means[idx] + sems[idx]))
        label = short_label(d[x_key], 14)
        draw.text((x - 70, bottom + 20), label, font=FONT_TINY, fill=AXIS_COLOR)


def draw_series_graph(draw: ImageDraw.ImageDraw, row: dict[str, Any]) -> None:
    data = row["display_table"]
    x_key, mean_key, sem_key = table_columns(row)
    assert mean_key and sem_key
    xs = [float(d[x_key]) for d in data]
    ys = [float(d[mean_key]) for d in data]
    sems = [float(d[sem_key]) for d in data]
    y_min = 0 if min(ys) >= 0 else math.floor(min(y - s for y, s in zip(ys, sems)) / 5) * 5
    y_max = nice_max(max(y + s for y, s in zip(ys, sems)) * 1.1)
    box = graph_box()
    x_map, y_map = draw_axes(draw, box, y_min, y_max, row["expected_graph_spec"]["x_axis"], row["expected_graph_spec"]["y_axis"])
    points = [(x_map(x, min(xs), max(xs)), y_map(y)) for x, y in zip(xs, ys)]
    draw.line(points, fill=TRACE_COLOR, width=5)
    for (px, py), y, sem in zip(points, ys, sems):
        draw.ellipse((px - 9, py - 9, px + 9, py + 9), outline=TRACE_COLOR, width=5)
        draw_error_bar(draw, px, y_map(y - sem), y_map(y + sem))
    left, _, right, bottom = box
    for x in xs:
        px = x_map(x, min(xs), max(xs))
        draw.line((px, bottom - 8, px, bottom + 8), fill=AXIS_COLOR, width=2)
        draw.text((px - 22, bottom + 18), f"{x:g}", font=FONT_TINY, fill=AXIS_COLOR)


def draw_estimate_graph(draw: ImageDraw.ImageDraw, row: dict[str, Any]) -> None:
    data = row["display_table"]
    x_key, y_key, _ = table_columns(row)
    assert y_key
    xs = [float(d[x_key]) for d in data]
    ys = [float(d[y_key]) for d in data]
    padding = (max(ys) - min(ys)) * 0.16 or 1
    y_min = min(0, min(ys) - padding)
    y_max = max(0, max(ys) + padding)
    if y_min >= 0:
        y_min = 0
    box = graph_box()
    x_map, y_map = draw_axes(draw, box, y_min, y_max, row["expected_graph_spec"]["x_axis"], row["expected_graph_spec"]["y_axis"])
    points = [(x_map(x, min(xs), max(xs)), y_map(y)) for x, y in zip(xs, ys)]
    for px, py in points:
        draw.ellipse((px - 9, py - 9, px + 9, py + 9), outline=TRACE_COLOR, width=5)
    if row.get("relation_subtype") == "zero_intercept_estimate":
        draw.line((points[0][0], points[0][1], points[-1][0], points[-1][1]), fill=TRACE_COLOR, width=5)
        estimate = float(row["expected_graph_spec"]["expected_estimate_approx"])
        ex = x_map(estimate, min(xs), max(xs))
        ey = y_map(0)
        draw.line((ex, ey - 90, ex, ey + 90), fill=TRACE_COLOR, width=4)
        draw.text((ex + 18, ey - 60), f"estimate ~ {estimate:g}", font=FONT_TINY, fill=TRACE_COLOR)
    else:
        draw.line(points, fill=TRACE_COLOR, width=5)
        estimate = float(row["expected_graph_spec"]["expected_estimate_approx"])
        ey = y_map(estimate)
        left, _, right, _ = box
        draw.line((left + (right - left) * 0.62, ey, right - 25, ey), fill=TRACE_COLOR, width=4)
        draw.text((right - 250, ey - 36), f"level-off ~ {estimate:g}", font=FONT_TINY, fill=TRACE_COLOR)
    left, _, right, bottom = box
    for x in xs:
        px = x_map(x, min(xs), max(xs))
        draw.line((px, bottom - 8, px, bottom + 8), fill=AXIS_COLOR, width=2)
        draw.text((px - 22, bottom + 18), f"{x:g}", font=FONT_TINY, fill=AXIS_COLOR)


def draw_page(row: dict[str, Any], set_name: str, sequence: int, out_path: Path) -> None:
    image = Image.new("RGB", (PAGE_W, PAGE_H), "white")
    draw = ImageDraw.Draw(image)
    draw.text((MARGIN, 70), f"{set_name} / Page {sequence:02d}", font=FONT_SMALL, fill=(88, 88, 88))
    draw.text((MARGIN, 112), row["item_id"], font=FONT_TITLE, fill=TEXT_COLOR)
    y = 185
    y = draw_wrapped(draw, (MARGIN, y), clean_prompt(row["stem"]), FONT_BODY, PAGE_W - 2 * MARGIN)
    y += 20
    y = draw_table(draw, row, MARGIN, y, PAGE_W - 2 * MARGIN)
    y += 28
    draw_wrapped(
        draw,
        (MARGIN, y),
        "Trace or redraw the faint graph below on paper. Keep the item ID visible on the page before photographing.",
        FONT_SMALL,
        PAGE_W - 2 * MARGIN,
        fill=(90, 90, 90),
    )
    if row["archetype"] == "categorical_comparison_supplied_uncertainty":
        draw_categorical_graph(draw, row)
    elif row["archetype"] == "continuous_measured_series_supplied_uncertainty":
        draw_series_graph(draw, row)
    else:
        draw_estimate_graph(draw, row)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    image.save(out_path, quality=94)


def split_sets(rows: list[dict[str, Any]]) -> dict[str, list[dict[str, Any]]]:
    by_arch: dict[str, list[dict[str, Any]]] = {}
    for row in rows:
        by_arch.setdefault(row["archetype"], []).append(row)
    plans = {
        "set_01": {
            "categorical_comparison_supplied_uncertainty": 17,
            "continuous_measured_series_supplied_uncertainty": 17,
            "continuous_relationship_graph_derived_estimate": 16,
        },
        "set_02": {
            "categorical_comparison_supplied_uncertainty": 17,
            "continuous_measured_series_supplied_uncertainty": 16,
            "continuous_relationship_graph_derived_estimate": 17,
        },
        "set_03": {
            "categorical_comparison_supplied_uncertainty": 16,
            "continuous_measured_series_supplied_uncertainty": 17,
            "continuous_relationship_graph_derived_estimate": 17,
        },
    }
    cursors = {key: 0 for key in by_arch}
    result: dict[str, list[dict[str, Any]]] = {}
    order = [
        "categorical_comparison_supplied_uncertainty",
        "continuous_measured_series_supplied_uncertainty",
        "continuous_relationship_graph_derived_estimate",
    ]
    for set_name, plan in plans.items():
        buckets: dict[str, list[dict[str, Any]]] = {}
        for arch in order:
            count = plan[arch]
            start = cursors[arch]
            buckets[arch] = by_arch[arch][start : start + count]
            cursors[arch] += count
        mixed: list[dict[str, Any]] = []
        while any(buckets.values()):
            for arch in order:
                if buckets[arch]:
                    mixed.append(buckets[arch].pop(0))
        result[set_name] = mixed
    return result


def write_index(set_rows: dict[str, list[dict[str, Any]]]) -> None:
    lines = [
        "# Hand-Drawn Graph Trace Sets",
        "",
        "Each set contains 50 traceable pages mixing the three graph archetypes.",
        "Give one complete set to each drawer. Ask the drawer to trace or redraw the faint graph, keep the item ID visible, and photograph the finished page.",
        "",
    ]
    for set_name, rows in set_rows.items():
        counts: dict[str, int] = {}
        for row in rows:
            counts[row["archetype"]] = counts.get(row["archetype"], 0) + 1
        lines.extend([
            f"## {set_name}",
            "",
            f"- PDF: `{set_name}/{set_name}_trace_packet.pdf`",
            f"- PNG pages: `{set_name}/pages/`",
            f"- Counts: {', '.join(f'{k}={v}' for k, v in sorted(counts.items()))}",
            "",
        ])
    (OUT_DIR / "README.md").write_text("\n".join(lines), encoding="utf-8")


def main() -> None:
    rows = read_rows()
    set_rows = split_sets(rows)
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    for set_name, records in set_rows.items():
        pages: list[Image.Image] = []
        for idx, row in enumerate(records, start=1):
            out_path = OUT_DIR / set_name / "pages" / f"{idx:02d}_{row['item_id']}.png"
            draw_page(row, set_name, idx, out_path)
            pages.append(Image.open(out_path).convert("RGB"))
        pdf_path = OUT_DIR / set_name / f"{set_name}_trace_packet.pdf"
        pages[0].save(pdf_path, save_all=True, append_images=pages[1:], resolution=200)
        manifest_path = OUT_DIR / set_name / f"{set_name}_manifest.json"
        manifest_path.write_text(json.dumps(records, indent=2, sort_keys=True) + "\n", encoding="utf-8")
        print(set_name, len(records), pdf_path)
    write_index(set_rows)


if __name__ == "__main__":
    main()
