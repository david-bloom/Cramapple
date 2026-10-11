"""Build the gate-4b contact sheet: every named figure at the three real widths.

Gate 4b is "look at it", and the protocol records that an eye pass does not
repeat itself -- the overprinting defects it found were still in the renderer
months later. The sheet was built ad hoc each time, so this makes it a command:

    python3 -I build_eye_sheet.py --prefix "phys1-,chem-" --out out/eye.html
    python3 -I serve.py        # then open http://localhost:5191/eye.html

Widths are the containers the figure actually lands in, not round numbers:
272px is the narrow edge of the reference pane, 680px the question centre,
980px the enlarge control.
"""
from __future__ import annotations

import argparse, json, os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import render as R  # noqa: E402

WIDTHS = (("compact", 272), ("compact", 460), ("full", 680), ("expanded", 980))

CSS = """body{font:13px -apple-system,BlinkMacSystemFont,sans-serif;margin:16px;background:#fff;color:#111}
h2{font:600 14px -apple-system;margin:28px 0 8px;padding-top:12px;border-top:2px solid #111}
.row{display:flex;gap:18px;align-items:flex-start;flex-wrap:wrap;margin-bottom:8px}
figure{margin:0}
figcaption{font:10px/1.4 ui-monospace,monospace;color:#666;margin-bottom:3px}
svg{border:1px solid #ddd;display:block;background:#fff}
.meta{font:11px/1.5 -apple-system;color:#444;max-width:62em;margin:2px 0 10px}
.meta b{color:#111}"""


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--prefix", default="",
                    help="comma-separated figure_id prefixes; empty means all")
    ap.add_argument("--out", default=os.path.join(HERE, "out", "eye_sheet.html"))
    args = ap.parse_args()

    specs = {k: v for k, v in json.load(
        open(os.path.join(HERE, "specs.json"), encoding="utf-8")).items()
        if not k.startswith("_")}
    pres = [p.strip() for p in args.prefix.split(",") if p.strip()]
    ids = [k for k in specs if not pres or any(k.startswith(p) for p in pres)]
    if not ids:
        print(f"no figure matches prefix {args.prefix!r}", file=sys.stderr)
        return 1

    parts = ["<!doctype html><meta charset=utf-8><title>gate 4b contact sheet</title>",
             f"<style>{CSS}</style>",
             f"<p class=meta>{len(ids)} figure(s), four containers each. "
             "Gate 4b: the suite cannot see. Read every label at 272px.</p>"]
    for sid in sorted(ids):
        s = specs[sid]
        used = ", ".join(u.get("title", "?") for u in s.get("used_by", [])) or "—"
        parts.append(f"<h2>{sid} · {s['family']}</h2>")
        parts.append(
            f"<p class=meta><b>{s['title']}</b><br>used by: {used}<br>"
            f"labels: {' · '.join(s.get('labels', []))}</p><div class=row>")
        for lay, px in WIDTHS:
            svg = R.render(s, lay)
            svg = svg.replace("<svg ", f'<svg style="width:{px}px;height:auto" ', 1)
            parts.append(f"<figure><figcaption>{lay} @ {px}px</figcaption>{svg}</figure>")
        parts.append("</div>")

    os.makedirs(os.path.dirname(args.out), exist_ok=True)
    open(args.out, "w", encoding="utf-8").write("\n".join(parts))
    print(f"{len(ids)} figures -> {args.out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
