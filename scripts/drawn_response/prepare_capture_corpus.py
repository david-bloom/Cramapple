#!/usr/bin/env python3
"""Audit loose response images or build a fail-closed capture-image manifest."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import struct
import sys
import tempfile
from collections import Counter, defaultdict
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Optional

import validate_records


IMAGE_EXTENSIONS = {".jpg", ".jpeg", ".png"}
PNG_SIGNATURE = b"\x89PNG\r\n\x1a\n"
JPEG_START = b"\xff\xd8"
JPEG_SOF_MARKERS = {
    0xC0, 0xC1, 0xC2, 0xC3, 0xC5, 0xC6, 0xC7,
    0xC9, 0xCA, 0xCB, 0xCD, 0xCE, 0xCF,
}
METADATA_REQUIRED = {
    "file_name",
    "image_id",
    "image_role",
    "source_image_id",
    "response_id",
    "item_id",
    "content_item_version_id",
    "transformation",
    "metadata_status",
    "provenance_status",
    "consent_status",
    "storage_scope",
    "captured_at",
    "ingested_at",
}


@dataclass(frozen=True)
class ImageInfo:
    file_name: str
    media_type: str
    byte_length: int
    pixel_width: int
    pixel_height: int
    sha256: str
    embedded_metadata: bool


class CorpusError(Exception):
    pass


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def png_info(path: Path) -> tuple[int, int, bool]:
    embedded_metadata = False
    with path.open("rb") as handle:
        if handle.read(8) != PNG_SIGNATURE:
            raise CorpusError("extension says PNG but signature does not")
        width = height = None
        while True:
            length_bytes = handle.read(4)
            if len(length_bytes) != 4:
                break
            length = struct.unpack(">I", length_bytes)[0]
            chunk_type = handle.read(4)
            if len(chunk_type) != 4:
                break
            if chunk_type == b"IHDR":
                payload = handle.read(length)
                if len(payload) < 8:
                    raise CorpusError("truncated PNG IHDR")
                width, height = struct.unpack(">II", payload[:8])
            else:
                handle.seek(length, os.SEEK_CUR)
            if chunk_type in {b"eXIf", b"iTXt", b"tEXt", b"zTXt"}:
                embedded_metadata = True
            crc = handle.read(4)
            if len(crc) != 4:
                raise CorpusError("truncated PNG chunk")
            if chunk_type == b"IEND":
                break
        if width is None or height is None:
            raise CorpusError("PNG has no readable IHDR")
        return width, height, embedded_metadata


def jpeg_info(path: Path) -> tuple[int, int, bool]:
    embedded_metadata = False
    width = height = None
    with path.open("rb") as handle:
        if handle.read(2) != JPEG_START:
            raise CorpusError("extension says JPEG but signature does not")
        while True:
            prefix = handle.read(1)
            if not prefix:
                break
            if prefix != b"\xff":
                continue
            marker_byte = handle.read(1)
            while marker_byte == b"\xff":
                marker_byte = handle.read(1)
            if not marker_byte:
                break
            marker = marker_byte[0]
            if marker == 0xDA:  # Start of Scan: compressed image data follows.
                break
            if marker in {0xD8, 0xD9} or 0xD0 <= marker <= 0xD7:
                continue
            length_bytes = handle.read(2)
            if len(length_bytes) != 2:
                raise CorpusError("truncated JPEG segment length")
            length = struct.unpack(">H", length_bytes)[0]
            if length < 2:
                raise CorpusError("invalid JPEG segment length")
            payload_length = length - 2
            if marker == 0xE1:
                embedded_metadata = True
            if marker in JPEG_SOF_MARKERS:
                payload = handle.read(payload_length)
                if len(payload) < 5:
                    raise CorpusError("truncated JPEG size segment")
                height, width = struct.unpack(">HH", payload[1:5])
            else:
                handle.seek(payload_length, os.SEEK_CUR)
    if width is None or height is None:
        raise CorpusError("JPEG has no readable start-of-frame segment")
    return width, height, embedded_metadata


def inspect_image(root: Path, path: Path) -> ImageInfo:
    if path.is_symlink():
        raise CorpusError("symbolic links are not accepted as corpus images")
    suffix = path.suffix.lower()
    if suffix == ".png":
        width, height, embedded_metadata = png_info(path)
        media_type = "image/png"
    elif suffix in {".jpg", ".jpeg"}:
        width, height, embedded_metadata = jpeg_info(path)
        media_type = "image/jpeg"
    else:
        raise CorpusError(f"unsupported extension {suffix}")
    return ImageInfo(
        file_name=path.relative_to(root).as_posix(),
        media_type=media_type,
        byte_length=path.stat().st_size,
        pixel_width=width,
        pixel_height=height,
        sha256=sha256(path),
        embedded_metadata=embedded_metadata,
    )


def image_paths(root: Path) -> list[Path]:
    return sorted(
        path for path in root.rglob("*")
        if path.is_file() and path.suffix.lower() in IMAGE_EXTENSIONS
    )


def safe_file_name(value: str) -> str:
    path = Path(value)
    if path.is_absolute() or ".." in path.parts or "://" in value:
        raise CorpusError(f"unsafe metadata file_name {value!r}")
    return path.as_posix()


def load_metadata(path: Optional[Path]) -> tuple[dict[str, dict[str, Any]], list[str]]:
    if path is None:
        return {}, []
    rows: dict[str, dict[str, Any]] = {}
    errors: list[str] = []
    for line_number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), start=1):
        if not line.strip():
            continue
        try:
            row = json.loads(line)
        except json.JSONDecodeError as exc:
            errors.append(f"metadata line {line_number}: invalid JSON: {exc}")
            continue
        if not isinstance(row, dict):
            errors.append(f"metadata line {line_number}: row must be an object")
            continue
        missing = sorted(METADATA_REQUIRED - set(row))
        if missing:
            errors.append(f"metadata line {line_number}: missing {missing}")
            continue
        try:
            file_name = safe_file_name(str(row["file_name"]))
        except CorpusError as exc:
            errors.append(f"metadata line {line_number}: {exc}")
            continue
        if file_name in rows:
            errors.append(f"metadata line {line_number}: duplicate declaration {file_name}")
            continue
        rows[file_name] = row
    return rows, errors


def audit(root: Path, metadata_path: Optional[Path], show_paths: bool) -> tuple[dict[str, Any], list[ImageInfo]]:
    root = root.resolve()
    if not root.is_dir():
        raise CorpusError(f"not a directory: {root}")
    metadata, metadata_errors = load_metadata(metadata_path)
    infos: list[ImageInfo] = []
    file_errors: list[dict[str, str]] = []
    for path in image_paths(root):
        try:
            infos.append(inspect_image(root, path))
        except (CorpusError, OSError) as exc:
            issue = {"error": str(exc)}
            if show_paths:
                issue["file_name"] = path.relative_to(root).as_posix()
            file_errors.append(issue)

    by_digest: dict[str, list[ImageInfo]] = defaultdict(list)
    for info in infos:
        by_digest[info.sha256].append(info)
    duplicate_groups = [group for group in by_digest.values() if len(group) > 1]
    duplicate_summary: list[dict[str, Any]] = []
    for group in sorted(duplicate_groups, key=lambda value: value[0].sha256):
        entry: dict[str, Any] = {"copies": len(group)}
        if show_paths:
            entry["sha256"] = group[0].sha256
            entry["file_names"] = [info.file_name for info in group]
        duplicate_summary.append(entry)

    files = {info.file_name for info in infos}
    declared = set(metadata)
    missing_metadata = sorted(files - declared)
    unknown_metadata = sorted(declared - files)
    widths = [info.pixel_width for info in infos]
    heights = [info.pixel_height for info in infos]
    report: dict[str, Any] = {
        "corpus_name": root.name,
        "image_count": len(infos),
        "total_bytes": sum(info.byte_length for info in infos),
        "media_types": dict(sorted(Counter(info.media_type for info in infos).items())),
        "embedded_metadata_count": sum(info.embedded_metadata for info in infos),
        "dimensions": {
            "min_width": min(widths) if widths else None,
            "max_width": max(widths) if widths else None,
            "min_height": min(heights) if heights else None,
            "max_height": max(heights) if heights else None,
        },
        "file_error_count": len(file_errors),
        "unique_byte_sequence_count": len(by_digest),
        "exact_duplicate_group_count": len(duplicate_groups),
        "exact_duplicate_file_count": sum(len(group) for group in duplicate_groups),
        "exact_duplicate_excess_count": sum(len(group) - 1 for group in duplicate_groups),
        "metadata": {
            "provided": metadata_path is not None,
            "declared_count": len(metadata),
            "matched_count": len(files & declared),
            "missing_count": len(missing_metadata),
            "unknown_count": len(unknown_metadata),
            "error_count": len(metadata_errors),
        },
        "ingestion_ready": not (
            file_errors
            or duplicate_groups
            or metadata_errors
            or missing_metadata
            or unknown_metadata
            or not infos
        ),
    }
    if show_paths:
        report["duplicate_groups"] = duplicate_summary
        report["file_errors"] = file_errors
        report["missing_metadata"] = missing_metadata
        report["unknown_metadata"] = unknown_metadata
        report["metadata_errors"] = metadata_errors
    return report, infos


def build(root: Path, metadata_path: Path, output: Path) -> None:
    report, infos = audit(root, metadata_path, show_paths=True)
    if not report["ingestion_ready"]:
        raise CorpusError(
            "corpus is not ingestion-ready; run the audit command with --show-paths"
        )
    metadata, metadata_errors = load_metadata(metadata_path)
    if metadata_errors:
        raise CorpusError("metadata changed between audit and build")
    records: list[dict[str, Any]] = []
    for info in infos:
        row = metadata[info.file_name]
        records.append({
            "image_id": row["image_id"],
            "image_role": row["image_role"],
            "source_image_id": row["source_image_id"],
            "response_id": row["response_id"],
            "item_id": row["item_id"],
            "content_item_version_id": row["content_item_version_id"],
            "file_name": info.file_name,
            "media_type": info.media_type,
            "sha256": info.sha256,
            "byte_length": info.byte_length,
            "pixel_width": info.pixel_width,
            "pixel_height": info.pixel_height,
            "transformation": row["transformation"],
            "metadata_status": row["metadata_status"],
            "provenance_status": row["provenance_status"],
            "consent_status": row["consent_status"],
            "storage_scope": row["storage_scope"],
            "captured_at": row["captured_at"],
            "ingested_at": row["ingested_at"],
        })

    output = output.resolve()
    output.parent.mkdir(parents=True, exist_ok=True)
    temp_path: Optional[Path] = None
    try:
        with tempfile.NamedTemporaryFile(
            "w", encoding="utf-8", dir=output.parent, delete=False,
            prefix=f".{output.name}.", suffix=".tmp",
        ) as handle:
            temp_path = Path(handle.name)
            for record in records:
                handle.write(json.dumps(record, sort_keys=True, separators=(",", ":")) + "\n")
        schema = validate_records.load_schema("capture_image")
        if validate_records.validate_file(temp_path, schema):
            raise CorpusError("generated capture-image records failed validation")
        os.replace(temp_path, output)
        temp_path = None
    finally:
        if temp_path is not None and temp_path.exists():
            temp_path.unlink()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)

    audit_parser = subparsers.add_parser("audit", help="Read-only corpus audit")
    audit_parser.add_argument("root", type=Path)
    audit_parser.add_argument("--metadata", type=Path)
    audit_parser.add_argument("--json-output", type=Path)
    audit_parser.add_argument("--show-paths", action="store_true")
    audit_parser.add_argument(
        "--strict", action="store_true",
        help="Return nonzero unless the corpus is ingestion-ready.",
    )

    build_parser = subparsers.add_parser("build", help="Build validated JSONL records")
    build_parser.add_argument("root", type=Path)
    build_parser.add_argument("metadata", type=Path)
    build_parser.add_argument("output", type=Path)

    args = parser.parse_args()
    try:
        if args.command == "audit":
            report, _ = audit(args.root, args.metadata, args.show_paths)
            rendered = json.dumps(report, indent=2, sort_keys=True) + "\n"
            if args.json_output:
                args.json_output.parent.mkdir(parents=True, exist_ok=True)
                args.json_output.write_text(rendered, encoding="utf-8")
            print(rendered, end="")
            return 1 if args.strict and not report["ingestion_ready"] else 0
        build(args.root, args.metadata, args.output)
        print(f"PASS: wrote validated capture-image records to {args.output.resolve()}")
        return 0
    except (CorpusError, OSError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
