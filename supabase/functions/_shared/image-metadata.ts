// Metadata stripping for DERIVED capture images
// (TASK-0016 Phase D, Stage D2 security requirement: "EXIF/metadata
// stripping on derived/downstream images while retaining controlled audit
// provenance").
//
// WHY A HAND-WRITTEN STRIPPER
// ---------------------------
// A phone photo of a sheet of paper carries GPS coordinates, a device
// serial, a capture timestamp, and often a thumbnail of the same frame --
// none of which any downstream consumer of a hand-drawn graph needs, and
// all of which is exactly the kind of incidental identifier Stage D2 says
// must not travel downstream. Supabase Edge Functions have no image library
// available, and re-encoding pixels would be both expensive and lossy, so
// this module strips metadata at the CONTAINER level: it rewrites the file
// without the metadata-bearing segments/chunks and copies the compressed
// image data through byte-for-byte. The pixels are untouched; only the
// metadata is gone.
//
// WHAT THIS MODULE IS AND IS NOT
// ------------------------------
// * It NEVER modifies the original. It returns new bytes. Stage D2 requires
//   the immutable original be preserved and that "derived images never
//   overwrite them", so the caller binds the original first and stores the
//   stripped copy as a separate `kind = 'derived'` attachment at a separate
//   storage path.
// * It is not a sanitiser against malicious images. Container-level segment
//   removal does not make a malformed image safe; that job belongs to
//   `capture-attachment.ts`'s `validateCaptureObject` (signature + header
//   parse + size/dimension bounds), which runs first and rejects anything it
//   cannot positively identify.
// * "Controlled audit provenance" is retained OUTSIDE the image: what was
//   removed is reported back so the caller can record it in the audit trail
//   (`stripImageMetadata().removed`), and the untouched original -- metadata
//   and all -- remains bound and private. Nothing is silently destroyed.
//
// Pure functions only: no client, no fetch, no Deno APIs beyond typed
// arrays, so every branch is unit-testable against synthetic fixtures.

export interface RemovedMetadataSegment {
  /** JPEG marker name (`APP1`, `COM`), PNG/WEBP chunk type (`eXIf`, `EXIF`). */
  label: string;
  /** Bytes removed, including the segment/chunk framing. */
  byteLength: number;
}

export interface StripImageMetadataResult {
  /** New byte sequence. Identical to the input when nothing was removed. */
  bytes: Uint8Array;
  /** Metadata segments removed, in file order. Empty when none were found. */
  removed: RemovedMetadataSegment[];
  /** True when `bytes` differs from the input. */
  changed: boolean;
  /**
   * True when the container was parsed end to end. False means the parser
   * bailed out (truncated/unexpected structure) and returned the input
   * unchanged -- the caller must treat that as "not stripped", never as
   * "nothing to strip".
   */
  complete: boolean;
}

function unchanged(bytes: Uint8Array, complete: boolean): StripImageMetadataResult {
  return { bytes, removed: [], changed: false, complete };
}

function concat(parts: Uint8Array[], totalLength: number) {
  const out = new Uint8Array(totalLength);
  let offset = 0;
  for (const part of parts) {
    out.set(part, offset);
    offset += part.length;
  }
  return out;
}

/* -------------------------------------------------------------------------- */
/* JPEG                                                                        */
/* -------------------------------------------------------------------------- */

/**
 * APP0-APP15 (0xE0-0xEF) and COM (0xFE) are the metadata carriers: APP1
 * holds EXIF and XMP, APP2 holds ICC/MPF, APP13 holds Photoshop/IPTC, COM
 * holds free-text comments. Everything else in a JPEG is structural or
 * compressed image data and is copied through.
 *
 * APP0/JFIF is dropped along with the rest. It only declares density and
 * thumbnail info; every decoder handles its absence, and keeping it would
 * mean keeping a JFIF thumbnail (a second, un-stripped copy of the frame).
 */
function jpegSegmentLabel(marker: number): string | null {
  if (marker >= 0xe0 && marker <= 0xef) return `APP${marker - 0xe0}`;
  if (marker === 0xfe) return "COM";
  return null;
}

const JPEG_STANDALONE_MARKERS = new Set([0x01, 0xd8, 0xd9]);

function stripJpegMetadata(bytes: Uint8Array): StripImageMetadataResult {
  const kept: Uint8Array[] = [];
  const removed: RemovedMetadataSegment[] = [];
  let keptLength = 0;
  // SOI is always the first two bytes and is always kept.
  kept.push(bytes.subarray(0, 2));
  keptLength += 2;

  let offset = 2;
  while (offset + 1 < bytes.length) {
    if (bytes[offset] !== 0xff) {
      // Not at a marker boundary: the file is not shaped the way this
      // parser understands. Fail closed rather than guess.
      return unchanged(bytes, false);
    }
    // Skip 0xFF fill bytes between markers.
    let markerAt = offset + 1;
    while (markerAt < bytes.length && bytes[markerAt] === 0xff) markerAt += 1;
    if (markerAt >= bytes.length) return unchanged(bytes, false);
    const marker = bytes[markerAt];

    if (marker === 0xda) {
      // SOS: compressed scan data (and any trailing EOI) follows with no
      // further parseable segment headers. Copy the remainder verbatim.
      const rest = bytes.subarray(offset);
      kept.push(rest);
      keptLength += rest.length;
      offset = bytes.length;
      break;
    }
    if (marker === 0xd9) {
      const rest = bytes.subarray(offset);
      kept.push(rest);
      keptLength += rest.length;
      offset = bytes.length;
      break;
    }
    if (
      JPEG_STANDALONE_MARKERS.has(marker) ||
      (marker >= 0xd0 && marker <= 0xd7)
    ) {
      const segment = bytes.subarray(offset, markerAt + 1);
      kept.push(segment);
      keptLength += segment.length;
      offset = markerAt + 1;
      continue;
    }

    if (markerAt + 2 >= bytes.length) return unchanged(bytes, false);
    const segmentLength = (bytes[markerAt + 1] << 8) | bytes[markerAt + 2];
    // The length field counts itself (2 bytes) and must not run past EOF.
    if (segmentLength < 2) return unchanged(bytes, false);
    const segmentEnd = markerAt + 1 + segmentLength;
    if (segmentEnd > bytes.length) return unchanged(bytes, false);

    const label = jpegSegmentLabel(marker);
    if (label) {
      removed.push({ label, byteLength: segmentEnd - offset });
    } else {
      const segment = bytes.subarray(offset, segmentEnd);
      kept.push(segment);
      keptLength += segment.length;
    }
    offset = segmentEnd;
  }

  if (removed.length === 0) return unchanged(bytes, true);
  return {
    bytes: concat(kept, keptLength),
    removed,
    changed: true,
    complete: true,
  };
}

/* -------------------------------------------------------------------------- */
/* PNG                                                                         */
/* -------------------------------------------------------------------------- */

/**
 * Ancillary chunks that carry metadata rather than pixels. `eXIf` is
 * literal EXIF; `tEXt`/`zTXt`/`iTXt` are text (XMP lives in `iTXt`);
 * `tIME` is a modification timestamp. IHDR/PLTE/IDAT/IEND and colour
 * chunks (gAMA, cHRM, sRGB, iCCP, tRNS, bKGD, pHYs) are kept -- dropping
 * those would change how the image renders.
 */
const PNG_METADATA_CHUNKS = new Set(["eXIf", "tEXt", "zTXt", "iTXt", "tIME"]);

function readUint32BE(bytes: Uint8Array, offset: number) {
  return (
    (bytes[offset] << 24) |
    (bytes[offset + 1] << 16) |
    (bytes[offset + 2] << 8) |
    bytes[offset + 3]
  ) >>> 0;
}

function fourCC(bytes: Uint8Array, offset: number) {
  return String.fromCharCode(
    bytes[offset],
    bytes[offset + 1],
    bytes[offset + 2],
    bytes[offset + 3],
  );
}

function stripPngMetadata(bytes: Uint8Array): StripImageMetadataResult {
  const kept: Uint8Array[] = [bytes.subarray(0, 8)];
  const removed: RemovedMetadataSegment[] = [];
  let keptLength = 8;
  let offset = 8;
  let sawEnd = false;

  while (offset + 8 <= bytes.length) {
    const dataLength = readUint32BE(bytes, offset);
    const type = fourCC(bytes, offset + 4);
    const chunkTotal = 12 + dataLength;
    if (dataLength > bytes.length || offset + chunkTotal > bytes.length) {
      return unchanged(bytes, false);
    }
    if (PNG_METADATA_CHUNKS.has(type)) {
      removed.push({ label: type, byteLength: chunkTotal });
    } else {
      const chunk = bytes.subarray(offset, offset + chunkTotal);
      kept.push(chunk);
      keptLength += chunk.length;
    }
    offset += chunkTotal;
    if (type === "IEND") {
      sawEnd = true;
      break;
    }
  }

  // No IEND means truncated; a chunk stream that does not consume the file
  // cleanly is equally unparsed. Either way, do not claim a strip happened.
  if (!sawEnd) return unchanged(bytes, false);
  if (removed.length === 0) return unchanged(bytes, true);
  return {
    bytes: concat(kept, keptLength),
    removed,
    changed: true,
    complete: true,
  };
}

/* -------------------------------------------------------------------------- */
/* WEBP                                                                        */
/* -------------------------------------------------------------------------- */

/** RIFF chunks carrying metadata rather than image/animation payload. */
const WEBP_METADATA_CHUNKS = new Set(["EXIF", "XMP "]);

function writeUint32LE(target: Uint8Array, offset: number, value: number) {
  target[offset] = value & 0xff;
  target[offset + 1] = (value >>> 8) & 0xff;
  target[offset + 2] = (value >>> 16) & 0xff;
  target[offset + 3] = (value >>> 24) & 0xff;
}

function readUint32LE(bytes: Uint8Array, offset: number) {
  return (
    bytes[offset] |
    (bytes[offset + 1] << 8) |
    (bytes[offset + 2] << 16) |
    (bytes[offset + 3] << 24)
  ) >>> 0;
}

function stripWebpMetadata(bytes: Uint8Array): StripImageMetadataResult {
  if (bytes.length < 12) return unchanged(bytes, false);
  const kept: Uint8Array[] = [];
  const removed: RemovedMetadataSegment[] = [];
  let payloadLength = 0;
  let offset = 12;

  while (offset + 8 <= bytes.length) {
    const type = fourCC(bytes, offset);
    const size = readUint32LE(bytes, offset + 4);
    // RIFF chunks are padded to an even length.
    const padded = size + (size % 2);
    if (offset + 8 + padded > bytes.length) return unchanged(bytes, false);
    const chunkTotal = 8 + padded;
    if (WEBP_METADATA_CHUNKS.has(type)) {
      removed.push({ label: type, byteLength: chunkTotal });
    } else {
      const chunk = bytes.subarray(offset, offset + chunkTotal);
      kept.push(chunk);
      payloadLength += chunk.length;
    }
    offset += chunkTotal;
  }
  if (offset !== bytes.length) return unchanged(bytes, false);
  if (removed.length === 0) return unchanged(bytes, true);

  // Rebuild the RIFF header: its size field counts everything after the
  // first 8 bytes, i.e. "WEBP" plus the surviving chunks. Leaving the old
  // size in place would produce a file every decoder reads as truncated.
  const header = new Uint8Array(12);
  header.set(bytes.subarray(0, 12));
  writeUint32LE(header, 4, 4 + payloadLength);
  return {
    bytes: concat([header, ...kept], 12 + payloadLength),
    removed,
    changed: true,
    complete: true,
  };
}

/* -------------------------------------------------------------------------- */
/* Entry point                                                                 */
/* -------------------------------------------------------------------------- */

/**
 * Strips metadata for a media type already positively identified by
 * `identifyImage` (capture-attachment.ts). The caller must validate first:
 * this function trusts the declared type and will return the input
 * unchanged with `complete: false` if the bytes do not actually parse as
 * that container.
 */
export function stripImageMetadata(
  bytes: Uint8Array,
  mediaType: "image/png" | "image/jpeg" | "image/webp",
): StripImageMetadataResult {
  switch (mediaType) {
    case "image/jpeg":
      return bytes.length >= 4 && bytes[0] === 0xff && bytes[1] === 0xd8
        ? stripJpegMetadata(bytes)
        : unchanged(bytes, false);
    case "image/png":
      return bytes.length >= 8 && bytes[0] === 0x89 && bytes[1] === 0x50
        ? stripPngMetadata(bytes)
        : unchanged(bytes, false);
    case "image/webp":
      return fourCC(bytes, 0) === "RIFF" && fourCC(bytes, 8) === "WEBP"
        ? stripWebpMetadata(bytes)
        : unchanged(bytes, false);
  }
}

/**
 * Compact audit summary of a strip, for the `metadata_status` /
 * provenance-event side of the "retain controlled audit provenance"
 * requirement. Records WHAT was removed and how much, never the removed
 * content itself -- writing the stripped EXIF into an audit row would
 * simply relocate the data we just removed.
 */
export function summarizeMetadataStrip(result: StripImageMetadataResult) {
  return {
    metadata_status: result.changed
      ? "STRIPPED_IN_DERIVATIVE"
      : result.complete
      ? "NOT_PRESENT"
      : "UNKNOWN",
    segments_removed: result.removed.map((segment) => segment.label),
    bytes_removed: result.removed.reduce(
      (total, segment) => total + segment.byteLength,
      0,
    ),
  };
}
