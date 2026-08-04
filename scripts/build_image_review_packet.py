#!/usr/bin/env python3
"""Build a static, exact-version item-context review page for a question image."""

from __future__ import annotations

import argparse
import hashlib
import html
import json
import os
import struct
import sys
from pathlib import Path
from typing import Any


PNG_SIGNATURE = b"\x89PNG\r\n\x1a\n"
GATE_NAMES = ("scientific", "grading", "accessibility", "visual_layout", "rights")
REVIEW_STATES = {"pending", "approved", "rejected"}
MATRIX_STATES = {"pending", "technical_pass", "approved", "rejected", "not_applicable"}


class ReviewPacketError(Exception):
    pass


def read_json(path: Path) -> Any:
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise ReviewPacketError(f"{path}: {exc}") from exc


def digest(path: Path) -> str:
    value = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            value.update(block)
    return value.hexdigest()


def png_dimensions(path: Path) -> tuple[int, int]:
    with path.open("rb") as handle:
        if handle.read(8) != PNG_SIGNATURE:
            raise ReviewPacketError(f"{path}: asset is not a PNG")
        length = struct.unpack(">I", handle.read(4))[0]
        chunk_type = handle.read(4)
        if chunk_type != b"IHDR" or length < 8:
            raise ReviewPacketError(f"{path}: PNG has no valid IHDR")
        return struct.unpack(">II", handle.read(8))


def one(rows: list[dict[str, Any]], predicate: Any, label: str) -> dict[str, Any]:
    matches = [row for row in rows if predicate(row)]
    if len(matches) != 1:
        raise ReviewPacketError(f"expected exactly one {label}; found {len(matches)}")
    return matches[0]


def esc(value: Any) -> str:
    return html.escape("" if value is None else str(value), quote=True)


def render_criteria(criteria: list[dict[str, Any]], reviewer: bool) -> str:
    rendered: list[str] = []
    for criterion in criteria:
        key = esc(criterion.get("criterion_key", "?"))
        prompt = esc(criterion.get("learner_facing_text", ""))
        if reviewer:
            evidence = esc(criterion.get("evidence_requirements", ""))
            rendered.append(
                f'<article class="criterion"><h4>Criterion {key}</h4>'
                f'<p>{prompt}</p><p><strong>Evidence requirements:</strong> {evidence}</p></article>'
            )
        else:
            rendered.append(
                f'<label class="prompt"><span><strong>({key})</strong> {prompt}</span>'
                f'<textarea data-response-input rows="5" aria-label="Response for part {key}"></textarea></label>'
            )
    return "\n".join(rendered)


def render_gate_rows(gates: dict[str, Any]) -> str:
    rows: list[str] = []
    for name in GATE_NAMES:
        gate = gates[name]
        rows.append(
            f"<tr><th scope=\"row\">{esc(name.replace('_', ' ').title())}</th>"
            f"<td><span class=\"status pending\">{esc(gate['status'])}</span></td>"
            f"<td>{esc(gate.get('reviewer') or 'Unassigned')}</td>"
            f"<td>{esc(gate.get('notes') or '—')}</td></tr>"
        )
    return "\n".join(rows)


def render_matrix_rows(matrix: dict[str, Any]) -> str:
    def status_class(status: str) -> str:
        return {
            "approved": "approved",
            "technical_pass": "technical",
            "rejected": "rejected",
        }.get(status, "pending")

    return "\n".join(
        f"<tr><th scope=\"row\">{esc(name.replace('_', ' '))}</th>"
        f"<td><span class=\"status {status_class(status)}\">{esc(status)}</span></td></tr>"
        for name, status in matrix.items()
    )


def validate_and_render(
    manifest_path: Path,
    content_path: Path,
    review_path: Path,
    output_path: Path,
) -> str:
    manifest = read_json(manifest_path)
    content_rows = read_json(content_path)
    review = read_json(review_path)
    if not isinstance(content_rows, list):
        raise ReviewPacketError("content packet must be a JSON array")

    asset = one(
        manifest.get("assets", []),
        lambda row: row.get("asset_id") == review.get("asset_id"),
        "manifest asset matching review asset_id",
    )
    item = one(
        content_rows,
        lambda row: (
            row.get("content_key") == review.get("content_key")
            and row.get("content_item_version_id") == review.get("content_version_id")
        ),
        "content item matching review key and version",
    )

    exact_fields = {
        "asset_sha256": asset.get("sha256"),
        "content_key": asset.get("content_key"),
        "content_version_id": asset.get("content_version_id"),
        "content_version_num": asset.get("content_version_num"),
    }
    for field, expected in exact_fields.items():
        if review.get(field) != expected:
            raise ReviewPacketError(
                f"review {field}={review.get(field)!r} does not match manifest {expected!r}"
            )
    if item.get("version_num") != review.get("content_version_num"):
        raise ReviewPacketError("content packet version_num does not match review packet")

    package_dir = manifest_path.resolve().parent
    image_path = (package_dir / asset["file"]).resolve()
    if package_dir not in image_path.parents:
        raise ReviewPacketError("asset path escapes package directory")
    if digest(image_path) != review["asset_sha256"]:
        raise ReviewPacketError("asset bytes do not match review checksum")
    width, height = png_dimensions(image_path)
    if (width, height) != (asset.get("pixel_width"), asset.get("pixel_height")):
        raise ReviewPacketError("asset dimensions do not match manifest")

    accessibility = review.get("accessibility", {})
    manifest_accessibility = asset.get("accessibility", {})
    for field in ("short_alt", "long_description"):
        if not str(accessibility.get(field, "")).strip():
            raise ReviewPacketError(f"review accessibility.{field} is required")
        if accessibility.get(field) != manifest_accessibility.get(field):
            raise ReviewPacketError(f"review accessibility.{field} differs from manifest")
    for field in ("construct_equivalence_status", "answer_leakage_status"):
        if accessibility.get(field) != manifest_accessibility.get(field):
            raise ReviewPacketError(f"review accessibility.{field} differs from manifest")

    gates = review.get("review_gates", {})
    missing_gates = [name for name in GATE_NAMES if name not in gates]
    if missing_gates:
        raise ReviewPacketError(f"review packet missing gates: {missing_gates}")
    invalid_gates = {
        name: gates[name].get("status")
        for name in GATE_NAMES
        if gates[name].get("status") not in REVIEW_STATES
    }
    if invalid_gates:
        raise ReviewPacketError(f"review packet has invalid gate states: {invalid_gates}")
    for name in ("scientific", "grading", "accessibility", "visual_layout"):
        if gates[name].get("status") != asset.get("review", {}).get(name):
            raise ReviewPacketError(f"review gate {name} differs from manifest asset")
    if gates["rights"].get("status") != asset.get("rights", {}).get("status"):
        raise ReviewPacketError("review rights gate differs from manifest asset")
    all_approved = all(gates[name].get("status") == "approved" for name in GATE_NAMES)
    matrix = review.get("render_matrix", {})
    invalid_matrix = {name: state for name, state in matrix.items() if state not in MATRIX_STATES}
    if invalid_matrix:
        raise ReviewPacketError(f"review packet has invalid render states: {invalid_matrix}")
    matrix_approved = bool(matrix) and all(value == "approved" for value in matrix.values())
    accessibility_approved = all(
        accessibility.get(field) == "approved"
        for field in ("construct_equivalence_status", "answer_leakage_status")
    )
    if review.get("release_eligible") is True and not (
        all_approved and matrix_approved and accessibility_approved
    ):
        raise ReviewPacketError("release_eligible=true while review gates or render matrix remain open")

    image_url = Path(os.path.relpath(image_path, output_path.resolve().parent)).as_posix()
    criteria = item.get("criteria_json", [])
    if not isinstance(criteria, list) or not criteria:
        raise ReviewPacketError("content item has no criteria_json prompts")
    canonical_answers = item.get("canonical_answers", [])
    answers_html = "".join(f"<li>{esc(answer)}</li>" for answer in canonical_answers)

    return f"""<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{esc(review['review_packet_id'])}</title>
  <style>
    :root {{ color-scheme: light; --ink:#172033; --muted:#5e6879; --line:#cad2df; --paper:#fff; --wash:#f2f5f9; --accent:#3159c6; --danger:#a52525; }}
    * {{ box-sizing:border-box; }}
    body {{ margin:0; font:16px/1.55 system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif; color:var(--ink); background:var(--wash); }}
    button,textarea {{ font:inherit; }}
    button {{ border:1px solid var(--accent); border-radius:.45rem; padding:.55rem .8rem; color:var(--accent); background:#fff; cursor:pointer; }}
    button:focus-visible,textarea:focus-visible,summary:focus-visible {{ outline:3px solid #ffbf47; outline-offset:2px; }}
    .page {{ width:min(1040px,calc(100% - 2rem)); margin:2rem auto 5rem; }}
    .eyebrow {{ color:var(--accent); font-size:.78rem; font-weight:750; letter-spacing:.08em; text-transform:uppercase; }}
    h1,h2,h3,h4 {{ line-height:1.2; }}
    h1 {{ margin:.25rem 0 .6rem; }}
    .lede,.muted {{ color:var(--muted); }}
    .lede {{ overflow-wrap:anywhere; }}
    .controls {{ display:flex; flex-wrap:wrap; gap:.6rem; margin:1.25rem 0; }}
    .card {{ background:var(--paper); border:1px solid var(--line); border-radius:.8rem; padding:clamp(1rem,3vw,2rem); margin:1rem 0; box-shadow:0 2px 8px rgb(23 32 51 / .06); }}
    .preview {{ max-width:780px; margin-inline:auto; }}
    .asset {{ margin:1.5rem 0; }}
    .asset img {{ display:block; width:100%; height:auto; border:1px solid var(--line); background:#fff; }}
    figcaption {{ margin-top:.5rem; color:var(--muted); font-size:.9rem; overflow-wrap:anywhere; }}
    .prompt {{ display:grid; gap:.5rem; margin:1.25rem 0; }}
    textarea {{ width:100%; resize:vertical; border:1px solid #7d899b; border-radius:.4rem; padding:.65rem; }}
    .blocking {{ border:2px solid var(--danger); border-radius:.55rem; padding:1rem; color:var(--danger); background:#fff7f7; }}
    .zoomed .preview {{ font-size:2rem; max-width:none; }}
    .zoomed .asset {{ overflow:auto; }}
    .zoomed .asset img {{ width:200%; max-width:none; }}
    dl.meta {{ display:grid; grid-template-columns:max-content 1fr; gap:.35rem 1rem; }}
    dt {{ font-weight:700; }} dd {{ margin:0; overflow-wrap:anywhere; }}
    table {{ width:100%; border-collapse:collapse; margin:1rem 0; }}
    .table-scroll {{ max-width:100%; overflow-x:auto; }}
    th,td {{ border:1px solid var(--line); padding:.55rem; text-align:left; vertical-align:top; }}
    thead th {{ background:var(--wash); }}
    .status {{ display:inline-block; border-radius:999px; padding:.12rem .55rem; font-size:.8rem; font-weight:700; }}
    .pending {{ color:#6a4700; background:#fff1bf; }}
    .technical {{ color:#174c70; background:#dbeeff; }}
    .approved {{ color:#155b31; background:#dff5e7; }}
    .rejected {{ color:#8a2020; background:#ffe1e1; }}
    .criterion {{ border-left:4px solid var(--line); padding-left:1rem; margin:1rem 0; }}
    .sr-only {{ position:absolute; width:1px; height:1px; padding:0; margin:-1px; overflow:hidden; clip:rect(0,0,0,0); white-space:nowrap; border:0; }}
    [hidden] {{ display:none !important; }}
    @media (max-width:520px) {{ .page {{ width:min(100% - 1rem,1040px); margin-top:.5rem; }} .card {{ border-radius:.5rem; padding:1rem; }} dl.meta {{ grid-template-columns:1fr; }} dd {{ margin-bottom:.5rem; }} th,td {{ padding:.4rem; }} }}
    @media print {{ body {{ background:#fff; }} .page {{ width:100%; margin:0; }} .card {{ box-shadow:none; break-inside:avoid; }} .controls,textarea,.submit-response {{ display:none; }} details {{ display:block; }} details > * {{ display:block; }} }}
  </style>
</head>
<body>
<main class="page" id="review-shell">
  <p class="eyebrow">Draft item-context review · not release eligible</p>
  <h1>{esc(item.get('title') or item['content_key'])}</h1>
  <p class="lede">Exact published version {esc(review['content_version_id'])}; candidate checksum {esc(review['asset_sha256'])}.</p>
  <div class="controls" aria-label="Review simulations">
    <button type="button" id="toggle-missing" aria-pressed="false">Simulate required image unavailable</button>
    <button type="button" id="toggle-zoom" aria-pressed="false">Toggle 200% review</button>
  </div>

  <section class="card preview" aria-labelledby="learner-heading">
    <p class="eyebrow">Learner context</p>
    <h2 id="learner-heading">Question</h2>
    <p>{esc(item.get('stem'))}</p>
    <p>{esc(item.get('stimulus'))}</p>
    <div id="image-missing" class="blocking" role="alert" tabindex="-1" hidden>
      <strong>Required diagram unavailable.</strong> This response is blocked because the visual evidence and its approved equivalent could not be delivered. Retry or use an approved equivalent item.
    </div>
    <figure class="asset" id="asset-figure">
      <img src="{esc(image_url)}" width="{width}" height="{height}" alt="{esc(accessibility['short_alt'])}">
      <figcaption>Candidate asset {esc(asset['asset_id'])}</figcaption>
    </figure>
    <details>
      <summary>Text description of the diagram</summary>
      <p>{esc(accessibility['long_description'])}</p>
    </details>
    {render_criteria(criteria, reviewer=False)}
    <button class="submit-response" type="button">Submit response (review simulation only)</button>
  </section>

  <section class="card" aria-labelledby="binding-heading">
    <p class="eyebrow">Immutable binding</p>
    <h2 id="binding-heading">Asset and item identity</h2>
    <dl class="meta">
      <dt>Content key</dt><dd>{esc(review['content_key'])}</dd>
      <dt>Content version</dt><dd>{esc(review['content_version_id'])} · version {esc(review['content_version_num'])}</dd>
      <dt>Asset ID</dt><dd>{esc(review['asset_id'])}</dd>
      <dt>SHA-256</dt><dd>{esc(review['asset_sha256'])}</dd>
      <dt>Dimensions</dt><dd>{width} × {height} px</dd>
      <dt>Production changed</dt><dd>No</dd>
    </dl>
  </section>

  <section class="card" aria-labelledby="access-heading">
    <p class="eyebrow">Accessibility draft</p>
    <h2 id="access-heading">Equivalent description and leakage review</h2>
    <h3>Short alternative</h3><p>{esc(accessibility['short_alt'])}</p>
    <h3>Long description</h3><p>{esc(accessibility['long_description'])}</p>
    <h3>Answer-leakage note</h3><p>{esc(accessibility['answer_leakage_note'])}</p>
  </section>

  <section class="card" aria-labelledby="rubric-heading">
    <p class="eyebrow">Reviewer-only context</p>
    <h2 id="rubric-heading">Rubric alignment</h2>
    {render_criteria(criteria, reviewer=True)}
    <details><summary>Canonical answers</summary><ol>{answers_html}</ol></details>
  </section>

  <section class="card" aria-labelledby="gates-heading">
    <p class="eyebrow">Hard gates</p>
    <h2 id="gates-heading">Independent review state</h2>
    <div class="table-scroll" tabindex="0" aria-label="Independent review gates"><table><thead><tr><th>Gate</th><th>Status</th><th>Reviewer</th><th>Notes</th></tr></thead><tbody>{render_gate_rows(gates)}</tbody></table></div>
    <h3>Render and delivery matrix</h3>
    <div class="table-scroll" tabindex="0" aria-label="Render and delivery matrix"><table><thead><tr><th>Scenario</th><th>Status</th></tr></thead><tbody>{render_matrix_rows(matrix)}</tbody></table></div>
  </section>
</main>
<script>
  const shell = document.getElementById('review-shell');
  const missingButton = document.getElementById('toggle-missing');
  const zoomButton = document.getElementById('toggle-zoom');
  const figure = document.getElementById('asset-figure');
  const missing = document.getElementById('image-missing');
  const responseControls = [...document.querySelectorAll('[data-response-input], .submit-response')];
  missingButton.addEventListener('click', () => {{
    const active = missingButton.getAttribute('aria-pressed') !== 'true';
    missingButton.setAttribute('aria-pressed', String(active));
    figure.hidden = active;
    missing.hidden = !active;
    responseControls.forEach(control => control.disabled = active);
    if (active) missing.focus();
  }});
  zoomButton.addEventListener('click', () => {{
    const active = zoomButton.getAttribute('aria-pressed') !== 'true';
    zoomButton.setAttribute('aria-pressed', String(active));
    shell.classList.toggle('zoomed', active);
  }});
</script>
</body>
</html>
"""


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("manifest", type=Path)
    parser.add_argument("content_packet", type=Path)
    parser.add_argument("review_packet", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    try:
        rendered = validate_and_render(
            args.manifest.resolve(),
            args.content_packet.resolve(),
            args.review_packet.resolve(),
            args.output.resolve(),
        )
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(rendered, encoding="utf-8")
    except (ReviewPacketError, OSError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1
    print(f"PASS: wrote {args.output.resolve()}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
