#!/usr/bin/env python3
"""Prototype: write a metadata-stripped COPY of a JPEG or PNG image.

This is a prototype for the privacy/security review required by
`docs/research/HAND_DRAWN_CORPUS_READINESS_AUDIT_2026_08_03.md` item 3
("Decide, with privacy/security review, whether original ancillary metadata
remains preserved in the private evidence object and which approved
derivative strips it."). It is NOT an approved derivative and must not be
run over the full corpus or used to produce any record referenced by
`prepare_capture_corpus.py build` until that review has happened.

Behavior:
- Never reads, modifies, deletes, or renames the input file's contents on
  disk. The input is opened read-only. The output is a brand-new file at a
  separate path supplied by the caller.
- Refuses to overwrite an existing output path unless --force is given.
- JPEG: copies every segment byte-for-byte except APP1 (0xFFE1) segments,
  which are the segment type that carries Exif metadata (and can carry XMP
  as a second APP1 segment). All other segments, including other APPn
  markers, are preserved unchanged. Compressed scan data after the Start of
  Scan (0xFFDA) marker is copied verbatim.
- PNG: copies the signature and every chunk byte-for-byte except chunks of
  type eXIf, iTXt, tEXt, or zTXt, which are the ancillary-metadata chunk
  types `prepare_capture_corpus.py` flags. All other chunks (IHDR, IDAT,
  PLTE, IEND, etc.) are preserved unchanged, including their original CRCs,
  since their bytes are not touched.

Uses only the Python standard library, matching the no-third-party-
dependency constraint in `prepare_capture_corpus.py`.

This script only decides which segments/chunks to drop. It does not decode
pixel data, and it does not classify or read the *value* of any stripped
metadata -- consistent with the audit's privacy-preserving method of not
reading or classifying embedded metadata content.
"""

from __future__ import annotations

import argparse
import struct
import sys
from pathlib import Path

PNG_SIGNATURE = b"\x89PNG\r\n\x1a\n"
JPEG_START = b"\xff\xd8"
PNG_METADATA_CHUNK_TYPES = {b"eXIf", b"iTXt", b"tEXt", b"zTXt"}
JPEG_METADATA_MARKERS = {0xE1}  # APP1: Exif / XMP


class StripError(Exception):
    pass


def strip_png(data: bytes) -> tuple[bytes, list[str]]:
    if data[:8] != PNG_SIGNATURE:
        raise StripError("extension says PNG but signature does not match")
    out = bytearray(PNG_SIGNATURE)
    removed: list[str] = []
    offset = 8
    length_total = len(data)
    while offset < length_total:
        if offset + 8 > length_total:
            raise StripError("truncated PNG chunk header")
        length = struct.unpack(">I", data[offset:offset + 4])[0]
        chunk_type = data[offset + 4:offset + 8]
        chunk_end = offset + 8 + length + 4  # length + type + payload + crc
        if chunk_end > length_total:
            raise StripError("truncated PNG chunk body")
        if chunk_type in PNG_METADATA_CHUNK_TYPES:
            removed.append(chunk_type.decode("ascii", errors="replace"))
        else:
            out += data[offset:chunk_end]
        if chunk_type == b"IEND":
            offset = chunk_end
            break
        offset = chunk_end
    # Preserve any trailing bytes verbatim (should normally be none after IEND).
    out += data[offset:]
    return bytes(out), removed


def strip_jpeg(data: bytes) -> tuple[bytes, list[str]]:
    if data[:2] != JPEG_START:
        raise StripError("extension says JPEG but signature does not match")
    out = bytearray(data[:2])
    removed: list[str] = []
    offset = 2
    length_total = len(data)
    in_scan = False
    while offset < length_total:
        if in_scan:
            out += data[offset:]
            break
        if data[offset] != 0xFF:
            raise StripError(f"expected marker prefix at offset {offset}")
        marker_offset = offset
        offset += 1
        while offset < length_total and data[offset] == 0xFF:
            offset += 1
        if offset >= length_total:
            raise StripError("truncated JPEG marker")
        marker = data[offset]
        offset += 1
        if marker in (0xD8, 0xD9) or 0xD0 <= marker <= 0xD7:
            # No length field on these markers.
            out += data[marker_offset:offset]
            continue
        if offset + 2 > length_total:
            raise StripError("truncated JPEG segment length")
        seg_length = struct.unpack(">H", data[offset:offset + 2])[0]
        if seg_length < 2:
            raise StripError("invalid JPEG segment length")
        seg_end = offset + seg_length
        if seg_end > length_total:
            raise StripError("truncated JPEG segment body")
        if marker in JPEG_METADATA_MARKERS:
            removed.append(f"APP{marker - 0xE0}")
        else:
            out += data[marker_offset:seg_end]
        offset = seg_end
        if marker == 0xDA:  # Start of Scan
            in_scan = True
    return bytes(out), removed


def strip_file(input_path: Path, output_path: Path, force: bool) -> list[str]:
    if not input_path.is_file():
        raise StripError(f"not a file: {input_path}")
    if output_path.exists() and not force:
        raise StripError(f"refusing to overwrite existing output: {output_path}")
    if input_path.resolve() == output_path.resolve():
        raise StripError("output path must differ from input path")

    suffix = input_path.suffix.lower()
    data = input_path.read_bytes()  # read-only; input is never written to
    if suffix == ".png":
        stripped, removed = strip_png(data)
    elif suffix in {".jpg", ".jpeg"}:
        stripped, removed = strip_jpeg(data)
    else:
        raise StripError(f"unsupported extension {suffix}")

    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_bytes(stripped)
    return removed


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("input", type=Path, help="Source image (read-only; never modified)")
    parser.add_argument("output", type=Path, help="Path for the stripped COPY (must not equal input)")
    parser.add_argument("--force", action="store_true", help="Overwrite an existing output path")
    args = parser.parse_args()

    try:
        removed = strip_file(args.input, args.output, args.force)
    except (StripError, OSError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1

    if removed:
        print(f"PASS: wrote {args.output} (removed segments/chunks: {', '.join(removed)})")
    else:
        print(f"PASS: wrote {args.output} (no flagged metadata segments/chunks found)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
