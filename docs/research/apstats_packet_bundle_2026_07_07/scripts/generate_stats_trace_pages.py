#!/usr/bin/env python3
"""Generate printable trace pages for the 28 new AP Statistics HDR items."""
import json
import math
import os
import sys
import textwrap

from PIL import Image, ImageDraw, ImageFont

sys.path.insert(0, os.path.dirname(__file__))
from hdr_new_data import NEW_HDR_ITEMS

REPO_ROOT = "/Users/davidbloom/Documents/Cramapple"
OUT_DIR = os.path.join(REPO_ROOT, "docs/research/apstats_packet_bundle_2026_07_07/trace_pages")

PAGE_W = 1700
PAGE_H = 2200
MARGIN = 100
TRACE_COLOR = (172, 172, 172)
AXIS_COLOR = (118, 118, 118)
GRID_COLOR = (224, 224, 224)
TEXT_COLOR = (24, 24, 24)


def load_font(size, bold=False):
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


FONT_TITLE = load_font(40, bold=True)
FONT_H2 = load_font(28, bold=True)
FONT_BODY = load_font(23)
FONT_SMALL = load_font(19)
FONT_AXIS = load_font(20)
FONT_TINY = load_font(16)


def wrap(draw, text, font, width_px):
    avg = max(8, draw.textlength("abcdefghijklmnopqrstuvwxyz", font=font) / 26)
    chars = max(20, int(width_px / avg))
    lines = []
    for para in text.split("\n\n")[0].splitlines():
        if not para.strip():
            continue
        lines.extend(textwrap.wrap(para.strip(), width=chars))
    return lines


def draw_wrapped(draw, xy, text, font, width_px, fill=TEXT_COLOR, line_gap=6):
    x, y = xy
    for line in wrap(draw, text, font, width_px):
        draw.text((x, y), line, font=font, fill=fill)
        y += font.size + line_gap
    return y


def short_label(value, max_len=16):
    text = str(value)
    return text if len(text) <= max_len else text[: max_len - 1] + "."


def draw_generic_table(draw, data, x, y, w, max_rows=12):
    keys = list(data[0].keys())
    col_w = w // len(keys)
    row_h = 36
    draw.text((x, y), "Data table", font=FONT_H2, fill=TEXT_COLOR)
    y += 38
    for c, key in enumerate(keys):
        draw.rectangle((x + c * col_w, y, x + (c + 1) * col_w, y + row_h), outline=(180, 180, 180), fill=(244, 244, 244))
        draw.text((x + c * col_w + 6, y + 8), short_label(key, 22), font=FONT_TINY, fill=TEXT_COLOR)
    y += row_h
    rows_to_show = data[:max_rows]
    for entry in rows_to_show:
        for c, key in enumerate(keys):
            draw.rectangle((x + c * col_w, y, x + (c + 1) * col_w, y + row_h), outline=(210, 210, 210), fill=(255, 255, 255))
            draw.text((x + c * col_w + 6, y + 9), short_label(entry[key], 20), font=FONT_TINY, fill=TEXT_COLOR)
        y += row_h
    if len(data) > max_rows:
        draw.text((x, y + 4), f"... ({len(data)} rows total, see stem)", font=FONT_TINY, fill=(140, 140, 140))
        y += 24
    return y


def graph_box(top=1150):
    return (MARGIN + 130, top, PAGE_W - MARGIN - 60, PAGE_H - 220)


def draw_axes(draw, box, y_min, y_max, x_label, y_label):
    left, top, right, bottom = box
    draw.line((left, bottom, right, bottom), fill=AXIS_COLOR, width=4)
    draw.line((left, top, left, bottom), fill=AXIS_COLOR, width=4)
    for i in range(6):
        t = i / 5
        y = bottom - t * (bottom - top)
        value = y_min + t * (y_max - y_min)
        draw.line((left - 10, y, right, y), fill=GRID_COLOR, width=1)
        draw.text((left - 85, y - 10), f"{value:g}"[:8], font=FONT_TINY, fill=AXIS_COLOR)
    draw.text(((left + right) // 2 - 140, bottom + 55), x_label[:52], font=FONT_AXIS, fill=AXIS_COLOR)
    draw.text((30, (top + bottom) // 2 - 60), y_label[:24], font=FONT_AXIS, fill=AXIS_COLOR)

    def y_map(v):
        return bottom - ((v - y_min) / (y_max - y_min)) * (bottom - top)

    return y_map


def nice_pad(lo, hi):
    span = hi - lo
    pad = span * 0.12 or max(abs(hi), 1) * 0.1
    return lo - pad, hi + pad


# ---------------- boxplot ----------------
def draw_boxplot(draw, item):
    data = item["display_table"]
    group_key = [k for k in data[0].keys() if k not in ("Min", "Q1", "Median", "Q3", "Max")][0]
    all_vals = [row[k] for row in data for k in ("Min", "Max")]
    y_min, y_max = nice_pad(min(all_vals), max(all_vals))
    box = graph_box()
    y_map = draw_axes(draw, box, y_min, y_max, item["expected_graph_spec"]["y_axis"], item["expected_graph_spec"]["y_axis"])
    left, top, right, bottom = box
    n = len(data)
    step = (right - left) / n
    box_w = step * 0.4
    for idx, row in enumerate(data):
        cx = left + step * (idx + 0.5)
        y_min_v, y_q1, y_med, y_q3, y_max_v = (y_map(row["Min"]), y_map(row["Q1"]), y_map(row["Median"]), y_map(row["Q3"]), y_map(row["Max"]))
        draw.line((cx, y_max_v, cx, y_q3), fill=TRACE_COLOR, width=4)
        draw.line((cx, y_min_v, cx, y_q1), fill=TRACE_COLOR, width=4)
        draw.line((cx - 22, y_max_v, cx + 22, y_max_v), fill=TRACE_COLOR, width=4)
        draw.line((cx - 22, y_min_v, cx + 22, y_min_v), fill=TRACE_COLOR, width=4)
        draw.rectangle((cx - box_w / 2, y_q3, cx + box_w / 2, y_q1), outline=TRACE_COLOR, width=4)
        draw.line((cx - box_w / 2, y_med, cx + box_w / 2, y_med), fill=TRACE_COLOR, width=4)
        draw.text((cx - 55, bottom + 18), short_label(row[group_key], 16), font=FONT_TINY, fill=AXIS_COLOR)


# ---------------- segmented bar ----------------
def draw_segmented_bar(draw, item):
    data = item["display_table"]
    group_key = list(data[0].keys())[0]
    cat_keys = list(data[0].keys())[1:]
    left = MARGIN + 200
    right = PAGE_W - MARGIN - 60
    top = 1150
    bar_h = 130
    gap = 220
    draw.line((left, top - 30, right, top - 30), fill=GRID_COLOR, width=1)
    for i in range(5):
        x = left + (right - left) * i / 4
        draw.line((x, top - 30, x, top - 20), fill=AXIS_COLOR, width=2)
        draw.text((x - 15, top - 18), f"{i/4:.2f}", font=FONT_TINY, fill=AXIS_COLOR)
    y = top
    for row in data:
        total = sum(row[k] for k in cat_keys)
        x = left
        for key in cat_keys:
            frac = row[key] / total
            seg_w = (right - left) * frac
            draw.rectangle((x, y, x + seg_w, y + bar_h), outline=TRACE_COLOR, width=3)
            draw.text((x + 6, y + bar_h / 2 - 8), short_label(key, 14), font=FONT_TINY, fill=AXIS_COLOR)
            x += seg_w
        draw.text((MARGIN, y + bar_h / 2 - 10), short_label(row[group_key], 20), font=FONT_AXIS, fill=AXIS_COLOR)
        y += gap
    draw.text((left + (right - left) // 2 - 100, y + 10), "Relative frequency", font=FONT_AXIS, fill=AXIS_COLOR)


# ---------------- mosaic ----------------
def draw_mosaic(draw, item):
    data = item["display_table"]
    group_key = list(data[0].keys())[0]
    cat_keys = list(data[0].keys())[1:]
    left = MARGIN + 160
    right = PAGE_W - MARGIN - 60
    top = 1150
    bottom = PAGE_H - 220
    totals = [sum(row[k] for k in cat_keys) for row in data]
    grand_total = sum(totals)
    x = left
    for row, total in zip(data, totals):
        w = (right - left) * (total / grand_total)
        y = top
        for key in cat_keys:
            frac = row[key] / total
            h = (bottom - top) * frac
            draw.rectangle((x, y, x + w, y + h), outline=TRACE_COLOR, width=3)
            if h > 30:
                draw.text((x + 6, y + h / 2 - 8), short_label(key, int(w // 10)), font=FONT_TINY, fill=AXIS_COLOR)
            y += h
        draw.text((x + w / 2 - 40, bottom + 15), short_label(row[group_key], 14), font=FONT_TINY, fill=AXIS_COLOR)
        x += w
    draw.line((left, top, left, bottom), fill=AXIS_COLOR, width=3)
    for i in range(5):
        yy = bottom - (bottom - top) * i / 4
        draw.text((left - 55, yy - 10), f"{i/4:.2f}", font=FONT_TINY, fill=AXIS_COLOR)


# ---------------- dotplot ----------------
def draw_dotplot(draw, item):
    data = item["display_table"]
    key = list(data[0].keys())[0]
    values = sorted(row[key] for row in data)
    lo, hi = min(values), max(values)
    left = MARGIN + 60
    right = PAGE_W - MARGIN - 60
    bottom = PAGE_H - 300
    span = hi - lo or 1

    def x_map(v):
        return left + (v - lo) / span * (right - left)

    draw.line((left, bottom, right, bottom), fill=AXIS_COLOR, width=4)
    counts = {}
    for v in values:
        counts[v] = counts.get(v, 0) + 1
    for v in sorted(set(values)):
        px = x_map(v)
        draw.line((px, bottom - 6, px, bottom + 6), fill=AXIS_COLOR, width=2)
        draw.text((px - 12, bottom + 14), f"{v:g}", font=FONT_TINY, fill=AXIS_COLOR)
        for i in range(counts[v]):
            cy = bottom - 20 - i * 26
            draw.ellipse((px - 10, cy - 10, px + 10, cy + 10), outline=TRACE_COLOR, width=4)
    draw.text((left + (right - left) // 2 - 120, bottom + 45), item["expected_graph_spec"]["x_axis"][:52], font=FONT_AXIS, fill=AXIS_COLOR)


# ---------------- scatterplot + trend ----------------
def draw_scatter(draw, item):
    data = item["display_table"]
    x_key, y_key = list(data[0].keys())[0], list(data[0].keys())[1]
    xs = [row[x_key] for row in data]
    ys = [row[y_key] for row in data]
    y_min, y_max = nice_pad(min(ys), max(ys))
    box = graph_box()
    left, top, right, bottom = box
    x_min, x_max = min(xs), max(xs)
    y_map = draw_axes(draw, box, y_min, y_max, item["expected_graph_spec"]["x_axis"], item["expected_graph_spec"]["y_axis"])

    def x_map(v):
        return left + (v - x_min) / (x_max - x_min) * (right - left)

    points = [(x_map(x), y_map(y)) for x, y in zip(xs, ys)]
    for px, py in points:
        draw.ellipse((px - 9, py - 9, px + 9, py + 9), outline=TRACE_COLOR, width=4)
    # least-squares trend line
    n = len(xs)
    mean_x = sum(xs) / n
    mean_y = sum(ys) / n
    num = sum((x - mean_x) * (y - mean_y) for x, y in zip(xs, ys))
    den = sum((x - mean_x) ** 2 for x in xs)
    slope = num / den if den else 0
    intercept = mean_y - slope * mean_x
    y1 = slope * x_min + intercept
    y2 = slope * x_max + intercept
    draw.line((x_map(x_min), y_map(y1), x_map(x_max), y_map(y2)), fill=TRACE_COLOR, width=4)
    for x in xs:
        px = x_map(x)
        draw.line((px, bottom - 8, px, bottom + 8), fill=AXIS_COLOR, width=2)
        draw.text((px - 20, bottom + 16), f"{x:g}", font=FONT_TINY, fill=AXIS_COLOR)


# ---------------- curve + marked point ----------------
def draw_curve_annotation(draw, item):
    data = item["display_table"]
    x_key, y_key = list(data[0].keys())[0], list(data[0].keys())[1]
    xs = [row[x_key] for row in data]
    ys = [row[y_key] for row in data]
    y_min, y_max = nice_pad(min(ys), max(ys))
    box = graph_box()
    left, top, right, bottom = box
    x_min, x_max = min(xs), max(xs)
    y_map = draw_axes(draw, box, y_min, y_max, item["expected_graph_spec"]["x_axis"], item["expected_graph_spec"]["y_axis"])

    def x_map(v):
        return left + (v - x_min) / (x_max - x_min) * (right - left)

    points = [(x_map(x), y_map(y)) for x, y in zip(xs, ys)]
    draw.line(points, fill=TRACE_COLOR, width=4)
    for x in xs:
        px = x_map(x)
        draw.line((px, bottom - 8, px, bottom + 8), fill=AXIS_COLOR, width=2)
        draw.text((px - 20, bottom + 16), f"{x:g}", font=FONT_TINY, fill=AXIS_COLOR)
    # mark point: extract from canonical_answer's stated x location (item-specific, computed from stem)
    mark_x = item["_mark_x"]
    mark_y = item["_mark_y"]
    mx, my = x_map(mark_x), y_map(mark_y)
    draw.line((mx - 14, my - 14, mx + 14, my + 14), fill=TRACE_COLOR, width=5)
    draw.line((mx - 14, my + 14, mx + 14, my - 14), fill=TRACE_COLOR, width=5)
    draw.text((mx + 18, my - 30), f"~{mark_y:g}", font=FONT_TINY, fill=TRACE_COLOR)


DRAWERS = {
    "boxplot_construction_interpretation": draw_boxplot,
    "segmented_bar_graph_construction": draw_segmented_bar,
    "mosaic_plot_interpretation": draw_mosaic,
    "dotplot_distribution_shape": draw_dotplot,
    "scatterplot_regression_context": draw_scatter,
    "graph_annotation_marking_value": draw_curve_annotation,
}

# Manually extracted mark (x, y) for the 4 curve-annotation items, taken
# directly from each item's own stem/canonical_answer.
MARK_POINTS = {
    "APSTATS-HDG-2026-GRAPH-037": (300, 0.68),
    "APSTATS-HDG-2026-GRAPH-038": (6, 0.63),
    "APSTATS-HDG-2026-GRAPH-039": (60, 0.77),
    "APSTATS-HDG-2026-GRAPH-040": (8, 0.44),
}


def draw_page(item, sequence, out_path):
    image = Image.new("RGB", (PAGE_W, PAGE_H), "white")
    draw = ImageDraw.Draw(image)
    draw.text((MARGIN, 60), f"apstats_bundle / Page {sequence:02d}", font=FONT_SMALL, fill=(88, 88, 88))
    draw.text((MARGIN, 100), item["item_id"], font=FONT_TITLE, fill=TEXT_COLOR)
    y = 165
    y = draw_wrapped(draw, (MARGIN, y), item["stem"], FONT_BODY, PAGE_W - 2 * MARGIN)
    y += 15
    if item["archetype"] not in ("segmented_bar_graph_construction", "mosaic_plot_interpretation"):
        y = draw_generic_table(draw, item["display_table"], MARGIN, y, PAGE_W - 2 * MARGIN)
    else:
        y = draw_generic_table(draw, item["display_table"], MARGIN, y, PAGE_W - 2 * MARGIN)
    y += 20
    draw_wrapped(
        draw,
        (MARGIN, y),
        "Trace or redraw the faint graph below on paper. Keep the item ID visible on the page before photographing.",
        FONT_SMALL,
        PAGE_W - 2 * MARGIN,
        fill=(90, 90, 90),
    )
    if item["item_id"] in MARK_POINTS:
        item["_mark_x"], item["_mark_y"] = MARK_POINTS[item["item_id"]]
    DRAWERS[item["archetype"]](draw, item)
    out_path_dir = os.path.dirname(out_path)
    os.makedirs(out_path_dir, exist_ok=True)
    image.save(out_path, quality=94)


def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    pages = []
    manifest = []
    for idx, item in enumerate(NEW_HDR_ITEMS, start=1):
        out_path = os.path.join(OUT_DIR, "pages", f"{idx:02d}_{item['item_id']}.png")
        draw_page(item, idx, out_path)
        pages.append(Image.open(out_path).convert("RGB"))
        manifest.append({k: v for k, v in item.items() if not k.startswith("_")})
        print(idx, item["item_id"], item["archetype"], "->", out_path)
    pdf_path = os.path.join(OUT_DIR, "apstats_hdr_trace_pages_2026_07_07.pdf")
    pages[0].save(pdf_path, save_all=True, append_images=pages[1:], resolution=200)
    with open(os.path.join(OUT_DIR, "manifest.json"), "w") as f:
        json.dump(manifest, f, indent=2)
    print("PDF:", pdf_path)


if __name__ == "__main__":
    main()
