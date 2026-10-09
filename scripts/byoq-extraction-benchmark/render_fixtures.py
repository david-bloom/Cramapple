#!/usr/bin/env python3
"""TASK-0068 benchmark: render published Cramapple items to page images.

Ground truth is the database row (type, stem, choices, subject, unit, topic), so
no labelling step is needed and there is no rights question. Each item renders as:

  clean      typeset page, straight, good contrast
  degraded   rotated a few degrees, slight blur, uneven lighting, a margin cut off
  control    (a subset) planted answer marks: a circled option, an "Answer:" line,
             a fake printed answer key, or a fake student name

Writes PNGs to fixtures/pages/<cohort>/<id>.png and a manifest.json describing
every page with its ground truth and what was planted. Run from the repo root:

  python3 scripts/byoq-extraction-benchmark/render_fixtures.py
"""
import json
import math
import os
import random
import textwrap
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont

HERE = Path(__file__).resolve().parent
FIX = HERE / "fixtures"
OUT = FIX / "pages"
FONT_PATH = "/System/Library/Fonts/Supplemental/Arial Unicode.ttf"
FONT_BOLD = "/System/Library/Fonts/Supplemental/Arial Bold.ttf"
W, H = 1240, 1754  # A4 at 150 dpi
MARGIN = 110
rng = random.Random(42)


def font(size, bold=False):
    path = FONT_BOLD if bold and os.path.exists(FONT_BOLD) else FONT_PATH
    return ImageFont.truetype(path, size)


def wrap(text, width_chars):
    out = []
    for para in text.split("\n"):
        out.extend(textwrap.wrap(para, width_chars) or [""])
    return out


def frq_text(item):
    parts = item.get("parts") or []
    lines = [item["stem"]]
    for i, p in enumerate(parts):
        label = p.get("label") or p.get("part") or chr(97 + i)
        prompt = p.get("prompt") or p.get("text") or p.get("question") or ""
        if prompt:
            lines.append(f"({label}) {prompt}")
    return "\n\n".join(lines)


def draw_item(item, planted=None):
    img = Image.new("RGB", (W, H), "white")
    d = ImageDraw.Draw(img)
    body = font(30)
    y = MARGIN
    header = font(24)
    d.text((MARGIN, y), f"{item['subject'].replace('-', ' ').upper()}  ·  Practice set", fill=(90, 90, 90), font=header)
    y += 60
    qnum = rng.randint(1, 30)
    text = item["stem"] if item["type"] == "mcq" else frq_text(item)
    lines = wrap(text, 62)
    d.text((MARGIN, y), f"{qnum}.", fill="black", font=font(30, bold=True))
    for ln in lines:
        d.text((MARGIN + 50, y), ln, fill="black", font=body)
        y += 42
    y += 20
    choice_boxes = {}
    if item["type"] == "mcq":
        for c in item["choices"] or []:
            label = f"({c['k']})"
            d.text((MARGIN + 50, y), label, fill="black", font=body)
            clines = wrap(c["t"], 56)
            top = y
            for cl in clines:
                d.text((MARGIN + 130, y), cl, fill="black", font=body)
                y += 42
            choice_boxes[c["k"]] = (MARGIN + 40, top - 6, MARGIN + 120, top + 40)
            y += 8
    if planted == "circled" and choice_boxes:
        k = rng.choice(list(choice_boxes))
        d.ellipse(choice_boxes[k], outline=(40, 40, 160), width=4)
        planted = f"circled:{k}"
    elif planted == "answer_line" and choice_boxes:
        k = rng.choice(list(choice_boxes))
        d.text((MARGIN + 50, y + 20), f"Answer: {k}", fill=(30, 30, 30), font=font(30, bold=True))
        planted = f"answer_line:{k}"
    elif planted == "answer_key":
        k = rng.choice(list(choice_boxes)) if choice_boxes else "see solution"
        y2 = y + 60
        d.line((MARGIN, y2, W - MARGIN, y2), fill="black", width=2)
        d.text((MARGIN, y2 + 20), "ANSWER KEY", fill="black", font=font(28, bold=True))
        d.text((MARGIN, y2 + 62), f"{qnum}. {k}  —  the other options fail the stated condition.", fill="black", font=font(26))
        planted = f"answer_key:{k}"
    elif planted == "name":
        d.text((W - MARGIN - 420, MARGIN - 50), "Name: Jordan Alvarez   Period 3", fill=(40, 40, 40), font=font(26))
        planted = "name"
    elif planted == "handwritten_work":
        hw = font(34)
        d.text((MARGIN + 60, y + 30), "x = 2.5 → 3(2.5)² = 18.75", fill=(20, 20, 120), font=hw)
        planted = "handwritten_work"
    return img, planted


def degrade(img):
    angle = rng.uniform(-5, 5)
    out = img.rotate(angle, resample=Image.BICUBIC, expand=False, fillcolor=(235, 232, 225))
    # uneven lighting: a diagonal gradient
    grad = Image.new("L", (W, H))
    gd = ImageDraw.Draw(grad)
    for i in range(0, W, 4):
        v = int(255 - 70 * (i / W))
        gd.rectangle((i, 0, i + 4, H), fill=v)
    out = Image.composite(out, Image.new("RGB", (W, H), (120, 115, 105)), grad)
    out = out.filter(ImageFilter.GaussianBlur(rng.uniform(0.6, 1.3)))
    # cut a margin off
    crop = rng.randint(0, 40)
    out = out.crop((crop, 0, W, H - crop)).resize((W, H))
    return out


def main():
    items = json.load(open(FIX / "items.json"))
    OUT.mkdir(parents=True, exist_ok=True)
    manifest = []
    plant_cycle = ["circled", "answer_line", "answer_key", "name", "handwritten_work"]
    for idx, item in enumerate(items):
        for cohort in ("clean", "degraded"):
            img, _ = draw_item(item)
            if cohort == "degraded":
                img = degrade(img)
            (OUT / cohort).mkdir(exist_ok=True)
            path = OUT / cohort / f"{item['id']}.png"
            img.save(path, optimize=True)
            manifest.append({"page": str(path.relative_to(FIX)), "cohort": cohort, "item_id": item["id"], "planted": None,
                             "truth": {k: item[k] for k in ("subject", "type", "unit", "topic", "stem", "choices")}})
        if idx % 3 == 0:  # roughly a third of items get a planted control
            plant = plant_cycle[(idx // 3) % len(plant_cycle)]
            img, planted = draw_item(item, planted=plant)
            (OUT / "control").mkdir(exist_ok=True)
            path = OUT / "control" / f"{item['id']}.png"
            img.save(path, optimize=True)
            manifest.append({"page": str(path.relative_to(FIX)), "cohort": "control", "item_id": item["id"], "planted": planted,
                             "truth": {k: item[k] for k in ("subject", "type", "unit", "topic", "stem", "choices")}})
    # non-question pages: blank and a notes page
    (OUT / "control").mkdir(exist_ok=True)
    blank = Image.new("RGB", (W, H), "white")
    blank.save(OUT / "control" / "blank.png")
    manifest.append({"page": "pages/control/blank.png", "cohort": "control", "item_id": None, "planted": "blank", "truth": None})
    notes = Image.new("RGB", (W, H), "white")
    nd = ImageDraw.Draw(notes)
    yy = MARGIN
    for ln in ["Chapter 4 notes", "- mitochondria: ATP via oxidative phosphorylation", "- chloroplast: light reactions in thylakoid", "- remember to review for Friday"]:
        nd.text((MARGIN, yy), ln, fill="black", font=font(30)); yy += 48
    notes.save(OUT / "control" / "notes.png")
    manifest.append({"page": "pages/control/notes.png", "cohort": "control", "item_id": None, "planted": "notes", "truth": None})
    json.dump(manifest, open(FIX / "manifest.json", "w"), ensure_ascii=False, indent=1)
    from collections import Counter
    print(len(manifest), "pages", dict(Counter(m["cohort"] for m in manifest)))


if __name__ == "__main__":
    main()
